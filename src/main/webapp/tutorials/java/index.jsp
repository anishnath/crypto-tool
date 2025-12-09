<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Java Tutorial - Landing Page
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Tutorial - Learn Java Programming | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn Java programming from scratch with interactive examples. Free Java tutorial for beginners to advanced with live code editor.">

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
        "name": "Java Programming Tutorial",
        "description": "A comprehensive interactive course to learn Java programming from scratch to advanced topics.",
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
            <%@ include file="../tutorial-sidebar-java.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content" style="margin-right: 0;">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Java</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Java Tutorial</h1>
                    <p style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                        Learn Java programming from scratch with interactive examples. Master the language used in enterprise applications, Android development, and backend systems.
                    </p>
                </header>

                <div class="lesson-body">
                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                        <%-- Start Learning Card --%>
                        <a href="<%=request.getContextPath()%>/tutorials/java/intro.jsp" class="card" style="text-decoration: none; display: flex; align-items: center; gap: var(--space-4);">
                            <div style="width: 48px; height: 48px; background: var(--success-light); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2">
                                    <polygon points="5 3 19 12 5 21 5 3"/>
                                </svg>
                            </div>
                            <div>
                                <h3 style="margin: 0; font-size: var(--text-lg); color: var(--text-primary);">Start Learning</h3>
                                <p style="margin: 0; color: var(--text-secondary); font-size: var(--text-sm);">Begin with What is Java?</p>
                            </div>
                            <svg style="margin-left: auto;" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"/>
                            </svg>
                        </a>

                        <%-- What You'll Learn --%>
                        <div class="card">
                            <h3 style="margin: 0 0 var(--space-4) 0;">What You'll Learn</h3>
                            <ul style="margin: 0; padding-left: var(--space-6); color: var(--text-secondary);">
                                <li>Variables, data types, and operators</li>
                                <li>Control flow: conditionals and loops</li>
                                <li>Methods, parameters, and return values</li>
                                <li>Object-Oriented Programming: classes, inheritance, polymorphism</li>
                                <li>Collections Framework: List, Set, Map</li>
                                <li>Exception handling and error management</li>
                                <li>File I/O and serialization</li>
                                <li>Advanced: Generics, Streams, Lambda expressions</li>
                                <li>Professional: JUnit testing, logging, design patterns</li>
                            </ul>
                        </div>

                        <%-- Course Info --%>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">80+</div>
                                <div style="color: var(--text-muted); font-size: var(--text-sm);">Lessons</div>
                            </div>
                            <div class="card" style="text-align: center;">
                                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">13</div>
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
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Introduction, setup, first program</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">2. Variables & Types</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Primitives, Strings, Arrays</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">3. Operators</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Arithmetic, logical, bitwise</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">4. Control Flow</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">If, switch, for, while loops</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">5. Methods</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Parameters, return, overloading</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">6. OOP Basics</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Classes, objects, constructors</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">7. Inheritance</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Extends, interfaces, polymorphism</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">8. Collections</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">List, Set, Map, Iterators</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">9. Exceptions</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Try/catch, custom exceptions</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">10. File I/O</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Reading, writing, NIO</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">11. Advanced Topics</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">Streams, Lambdas, Regex</p>
                                </div>
                                <div style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                    <strong style="color: var(--text-primary);">12. Professional</strong>
                                    <p style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">JUnit, logging, patterns</p>
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
