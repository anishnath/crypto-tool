<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- TypeScript Tutorial - Landing Page --%>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Tutorial - Learn TypeScript Programming | 8gwifi.org Tutorials</title>
            <meta name="description"
                content="Learn TypeScript programming from scratch with interactive examples. Free TypeScript tutorial for beginners to advanced with live code editor and strict typing.">

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
        "name": "TypeScript Programming Tutorial",
        "description": "A comprehensive interactive course to learn TypeScript programming from scratch to advanced topics.",
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
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" style="margin-right: 0;">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>TypeScript</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">TypeScript Tutorial</h1>
                                    <p
                                        style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                                        Learn TypeScript programming from scratch with interactive examples. Master
                                        static typing, interfaces, generics, and advanced type manipulation for modern
                                        web development.
                                    </p>
                                </header>

                                <div class="lesson-body">
                                    <div style="display: grid; gap: var(--space-4); margin-top: var(--space-8);">
                                        <%-- Start Learning Card --%>
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/intro.jsp"
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
                                                        Begin with What is TypeScript?</p>
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
                                                        <li>Type annotations, primitives, and special types</li>
                                                        <li>Interfaces, type aliases, and type composition</li>
                                                        <li>Functions: parameters, overloading, arrow functions</li>
                                                        <li>Object-Oriented Programming: classes, inheritance, access
                                                            modifiers</li>
                                                        <li>Advanced types: union, intersection, literal types</li>
                                                        <li>Generics: functions, interfaces, classes, constraints</li>
                                                        <li>Utility types: Partial, Pick, Omit, Record, Readonly</li>
                                                        <li>Type manipulation: keyof, typeof, mapped types</li>
                                                        <li>Modules, namespaces, and declaration files</li>
                                                    </ul>
                                                </div>

                                                <%-- Course Info --%>
                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                55+</div>
                                                            <div
                                                                style="color: var(--text-muted); font-size: var(--text-sm);">
                                                                Lessons</div>
                                                        </div>
                                                        <div class="card" style="text-align: center;">
                                                            <div
                                                                style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                                                12</div>
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
                                                                        Getting Started & Basic Types</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Setup, primitives, arrays, enums</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">2.
                                                                        Functions & Interfaces</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Types, parameters, shapes, aliases</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">3.
                                                                        Classes & OOP</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Classes, inheritance, modifiers</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">4.
                                                                        Advanced Types</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Union, intersection, guards</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    style="margin: var(--space-1) 0 0; font-size:
                                                                    var(--text-sm); color: var(--text-muted);">
                                                                    Partial, Pick, Omit, Record</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">9. Type
                                                                        Manipulation</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        keyof, typeof, mapped types</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">10.
                                                                        Modules</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        ES Modules, namespaces</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">11. Real
                                                                        World TS</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Declaration files, integration</p>
                                                                </div>
                                                                <div
                                                                    style="padding: var(--space-3); background: var(--bg-secondary); border-radius: var(--radius-md);">
                                                                    <strong style="color: var(--text-primary);">12.
                                                                        Professional</strong>
                                                                    <p
                                                                        style="margin: var(--space-1) 0 0; font-size: var(--text-sm); color: var(--text-muted);">
                                                                        Project structure, best practices</p>
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