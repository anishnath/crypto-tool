<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Go Tutorial - Landing Page --%>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Go Tutorial for Beginners - Learn Go Programming | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go programming from scratch with interactive examples. Free Go tutorial for beginners to advanced. Master concurrency, goroutines, and web development. 30 lessons with live code editor.">
            <meta name="keywords"
                content="go tutorial, go tutorial for beginners, learn go, golang tutorial, go programming, golang programming, go course, go online tutorial, go examples, go beginner, go concurrency">

            <meta property="og:type" content="website">
            <meta property="og:title" content="Go Tutorial for Beginners - Learn Go Programming">
            <meta property="og:description"
                content="Free Go tutorial with 30 interactive lessons. Learn concurrency, goroutines, and web development from scratch.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">
            <meta property="og:url" content="https://8gwifi.org/tutorials/go/">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/">

            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">

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
        "@type": "Course",
        "name": "Go Tutorial for Beginners - Learn Go Programming",
        "description": "Learn Go programming from scratch with interactive examples. Free Go tutorial for beginners to advanced. Master concurrency, goroutines, and web development. 30 lessons with live code editor.",
        "url": "https://8gwifi.org/tutorials/go/",
        "keywords": "go tutorial, go tutorial for beginners, learn go, golang tutorial, go programming, golang programming, go course, go online tutorial, go examples, go beginner, go concurrency",
        "educationalLevel": "Beginner",
        "programmingLanguage": "Go",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org",
            "sameAs": "https://8gwifi.org"
        },
        "hasCourseInstance": {
            "@type": "CourseInstance",
            "courseMode": "online",
            "courseWorkload": "PT12H"
        },
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD",
            "availability": "https://schema.org/InStock"
        },
        "teaches": [
            "Go programming",
            "Concurrency with goroutines",
            "Channels and select",
            "Web development",
            "Go syntax",
            "Error handling",
            "Interfaces",
            "Testing and benchmarking",
            "JSON and HTTP",
            "Package organization"
        ],
        "numberOfCredits": "0",
        "coursePrerequisites": "Basic programming knowledge recommended but not required"
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
                "name": "Go Tutorial"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-go.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" style="margin-right: 0;">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Go</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Go Tutorial</h1>
                                    <p
                                        style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                                        Learn Go programming from scratch with interactive examples. Master the language
                                        built for simplicity, concurrency, and high performance—perfect for web
                                        services, cloud applications, and distributed systems.
                                    </p>
                                </header>

                                <div class="lesson-body">
                                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                                        <%-- Start Learning Card --%>
                                            <a href="<%=request.getContextPath()%>/tutorials/go/intro.jsp"
                                                class="card"
                                                style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                                                <div
                                                    style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                        stroke="var(--success)" stroke-width="2">
                                                        <polygon points="5 3 19 12 5 21 5 3" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <h3
                                                        style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">
                                                        Start Learning</h3>
                                                    <p
                                                        style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">
                                                        Begin with Introduction to Go</p>
                                                </div>
                                                <svg style="margin-left: auto;" width="20" height="20"
                                                    viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)"
                                                    stroke-width="2">
                                                    <polyline points="9 18 15 12 9 6" />
                                                </svg>
                                            </a>

                                            <%-- What You'll Learn --%>
                                                <div class="card">
                                                    <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                                                    <ul
                                                        style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                                        <li>Variables, data types, and constants</li>
                                                        <li>Control flow: if-else, switch, loops</li>
                                                        <li>Functions, defer, panic, and recover</li>
                                                        <li>Data structures: arrays, slices, maps, structs</li>
                                                        <li>Pointers and interfaces</li>
                                                        <li>Error handling patterns</li>
                                                        <li>Concurrency: goroutines, channels, select</li>
                                                        <li>Packages, modules, and file I/O</li>
                                                        <li>JSON, HTTP, and web development</li>
                                                        <li>Testing, benchmarking, and best practices</li>
                                                    </ul>
                                                </div>

                                                <%-- Course Info --%>
                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                30</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Lessons</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                10</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Modules</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">
                                                                Free</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Forever</div>
                                                        </div>
                                                    </div>

                                                    <%-- Course Modules Overview --%>
                                                        <div class="card">
                                                            <h3 style="margin: 0 0 var(--space-4) 0;">Course Modules
                                                            </h3>
                                                            <div
                                                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--space-3);">
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">1.
                                                                        Getting Started</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Introduction, setup, Hello World</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">2.
                                                                        Basics</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Variables, types, operators, constants</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">3.
                                                                        Control Flow</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        If-else, switch, loops</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">4.
                                                                        Functions</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Functions, variadic, defer, panic</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">5. Data
                                                                        Structures</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Arrays, slices, maps, structs</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">6.
                                                                        Pointers & Interfaces</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Pointers, interfaces, type switches</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">7. Error
                                                                        Handling</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Errors, wrapping, best practices</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">8.
                                                                        Concurrency</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Goroutines, channels, select</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">9.
                                                                        Packages & Std Library</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Packages, file I/O, JSON, HTTP</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">10.
                                                                        Advanced & Professional</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Testing, benchmarking, best practices</p>
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