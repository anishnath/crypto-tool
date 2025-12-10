<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Rust Tutorial - Landing Page
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rust Tutorial for Beginners - Learn Rust Programming | 8gwifi.org</title>
    <meta name="description" content="Learn Rust programming from scratch with interactive examples. Free Rust tutorial for beginners to advanced. Master memory safety, ownership, and systems programming. 30+ lessons with live code editor.">
    <meta name="keywords" content="rust tutorial, rust tutorial for beginners, learn rust, rust programming, rust programming language, rust course, rust online tutorial, rust examples, rust beginner, rust memory safety">
    
    <meta property="og:type" content="website">
    <meta property="og:title" content="Rust Tutorial for Beginners - Learn Rust Programming">
    <meta property="og:description" content="Free Rust tutorial with 30+ interactive lessons. Learn memory safety, ownership, and systems programming from scratch.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">
    <meta property="og:url" content="https://8gwifi.org/tutorials/rust/">
    
    <link rel="canonical" href="https://8gwifi.org/tutorials/rust/">

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
        "name": "Rust Tutorial for Beginners - Learn Rust Programming",
        "description": "Learn Rust programming from scratch with interactive examples. Free Rust tutorial for beginners to advanced. Master memory safety, ownership, and systems programming. 30+ lessons with live code editor.",
        "url": "https://8gwifi.org/tutorials/rust/",
        "keywords": "rust tutorial, rust tutorial for beginners, learn rust, rust programming, rust programming language, rust course, rust online tutorial, rust examples, rust beginner, rust memory safety",
        "educationalLevel": "Beginner",
        "programmingLanguage": "Rust",
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
            "courseWorkload": "PT15H"
        },
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD",
            "availability": "https://schema.org/InStock"
        },
        "teaches": [
            "Rust programming",
            "Memory safety",
            "Ownership and borrowing",
            "Systems programming",
            "Rust syntax",
            "Error handling",
            "Traits and generics",
            "Collections",
            "Smart pointers",
            "Concurrency"
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
                "name": "Rust Tutorial"
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
            <%@ include file="../tutorial-sidebar-rust.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content" style="margin-right: 0;">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Rust</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Rust Tutorial</h1>
                    <p style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                        Learn Rust programming from scratch with interactive examples. Master the language that provides memory safety without garbage collection, making it ideal for systems programming, web services, and embedded systems.
                    </p>
                </header>

                <div class="lesson-body">
                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                        <%-- Start Learning Card --%>
                        <a href="<%=request.getContextPath()%>/tutorials/rust/intro.jsp" class="card" style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                            <div style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                            </div>
                            <div>
                                <h3 style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">Start Learning</h3>
                                <p style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">Begin with What is Rust?</p>
                            </div>
                            <svg style="margin-left: auto;" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"/>
                            </svg>
                        </a>

                        <%-- What You'll Learn --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                            <ul style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                <li>Variables, data types, and mutability</li>
                                <li>Control flow: if expressions, loops, pattern matching</li>
                                <li>Ownership, borrowing, and lifetimes</li>
                                <li>Structs and enums for custom types</li>
                                <li>Collections: vectors, strings, HashMaps</li>
                                <li>Error handling: panic, Result, custom errors</li>
                                <li>Traits and generics for code reuse</li>
                                <li>Iterators and closures for functional programming</li>
                                <li>Advanced: Smart pointers, concurrency, modules</li>
                            </ul>
                        </div>

                        <%-- Course Info --%>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">30+</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Lessons</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">8</div>
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
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Introduction, installation, Hello World, Cargo</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">2. Variables & Data Types</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Variables, types, strings, functions</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">3. Control Flow</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">If expressions, loops, pattern matching</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">4. Ownership</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Ownership rules, borrowing, slices</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">5. Structs & Enums</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Custom types, methods, pattern matching</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">6. Collections</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Vectors, HashMaps, dynamic data</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">7. Error Handling</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Panic, Result, error propagation</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">8. Advanced Topics</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Traits, generics, iterators, closures</p>
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

