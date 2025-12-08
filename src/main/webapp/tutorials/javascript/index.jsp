<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">

        <title>Learn JavaScript | 8gwifi.org Tutorials</title>
        <meta name="description"
            content="Comprehensive JavaScript tutorial for beginners and advanced developers. Learn modern JavaScript (ES6+), DOM manipulation, async programming, and more.">
        <meta name="keywords" content="JavaScript tutorial, learn JavaScript, JS course, web development, ES6, DOM">

        <meta property="og:type" content="article">
        <meta property="og:title" content="Learn JavaScript - Free Interactive Tutorial">
        <meta property="og:description"
            content="Master JavaScript with our comprehensive, interactive tutorial series.">
        <meta property="og:site_name" content="8gwifi.org Tutorials">

        <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

        <script>
            (function () {
                var theme = localStorage.getItem('tutorial-theme');
                if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                    document.documentElement.setAttribute('data-theme', 'dark');
                }
            })();
        </script>

        <style>
            .hero-section {
                padding: var(--space-12) 0;
                text-align: center;
                background: linear-gradient(to bottom, var(--bg-secondary), var(--bg-primary));
                border-bottom: 1px solid var(--border-color);
                margin-bottom: var(--space-8);
            }

            .hero-title {
                font-size: 3rem;
                font-weight: 800;
                margin-bottom: var(--space-4);
                background: linear-gradient(135deg, #F7DF1E 0%, #F0DB4F 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                display: inline-block;
            }

            .hero-subtitle {
                font-size: 1.25rem;
                color: var(--text-secondary);
                max-width: 600px;
                margin: 0 auto var(--space-8);
                line-height: 1.6;
            }

            .module-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: var(--space-6);
                padding: 0 var(--space-6);
                max-width: 1200px;
                margin: 0 auto var(--space-12);
            }

            .module-card {
                background: var(--bg-surface);
                border: 1px solid var(--border-color);
                border-radius: var(--radius-lg);
                padding: var(--space-6);
                transition: transform 0.2s, box-shadow 0.2s;
                display: flex;
                flex-direction: column;
            }

            .module-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow-lg);
                border-color: var(--primary-color);
            }

            .module-header {
                display: flex;
                align-items: center;
                gap: var(--space-3);
                margin-bottom: var(--space-4);
            }

            .module-icon {
                width: 40px;
                height: 40px;
                background: var(--bg-secondary);
                border-radius: var(--radius-md);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--primary-color);
            }

            .module-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-primary);
            }

            .module-desc {
                color: var(--text-secondary);
                font-size: 0.95rem;
                margin-bottom: var(--space-6);
                flex-grow: 1;
                line-height: 1.5;
            }

            .module-link {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: var(--space-2) var(--space-4);
                background: var(--bg-secondary);
                color: var(--text-primary);
                text-decoration: none;
                border-radius: var(--radius-md);
                font-weight: 500;
                transition: all 0.2s;
            }

            .module-link:hover {
                background: var(--primary-color);
                color: white;
            }

            .start-btn {
                display: inline-flex;
                align-items: center;
                gap: var(--space-2);
                padding: var(--space-3) var(--space-8);
                background: var(--primary-color);
                color: white;
                text-decoration: none;
                border-radius: var(--radius-full);
                font-weight: 600;
                font-size: 1.1rem;
                transition: all 0.2s;
                box-shadow: var(--shadow-md);
            }

            .start-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                filter: brightness(1.1);
            }
        </style>
    <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

    <body class="tutorial-body">
        <div class="tutorial-layout">
            <%@ include file="../tutorial-header.jsp" %>

                <main class="tutorial-main" style="display: block;">
                    <div class="hero-section">
                        <h1 class="hero-title">Master JavaScript</h1>
                        <p class="hero-subtitle">
                            From basic syntax to advanced modern concepts. Learn JavaScript through interactive
                            examples, live coding, and comprehensive guides.
                        </p>
                        <a href="<%=request.getContextPath()%>/tutorials/javascript/introduction.jsp" class="start-btn">
                            Start Learning
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M5 12h14M12 5l7 7-7 7" />
                            </svg>
                        </a>
                    </div>

                    <div class="module-grid">
                        <!-- Module 1 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z" />
                                        <polyline points="13 2 13 9 20 9" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Getting Started</h3>
                            </div>
                            <p class="module-desc">Learn the basics of JavaScript, how to add it to your pages, and how
                                to use the console for debugging.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/introduction.jsp"
                                class="module-link">Start Module 1</a>
                        </div>

                        <!-- Module 2 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Fundamentals</h3>
                            </div>
                            <p class="module-desc">Master variables, data types, operators, and basic string/number
                                manipulation.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/variables.jsp"
                                class="module-link">Start Module 2</a>
                        </div>

                        <!-- Module 3 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <polyline points="16 18 22 12 16 6" />
                                        <polyline points="8 6 2 12 8 18" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Control Flow</h3>
                            </div>
                            <p class="module-desc">Understand conditionals, loops, functions, and scope to control your
                                program's logic.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/conditionals.jsp"
                                class="module-link">Start Module 3</a>
                        </div>

                        <!-- Module 4 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                        <line x1="3" y1="9" x2="21" y2="9" />
                                        <line x1="9" y1="21" x2="9" y2="9" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Data Structures</h3>
                            </div>
                            <p class="module-desc">Deep dive into Arrays and Objects, the core data structures of
                                JavaScript.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/arrays.jsp"
                                class="module-link">Start Module 4</a>
                        </div>

                        <!-- Module 5 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                                    </svg>
                                </div>
                                <h3 class="module-title">DOM Manipulation</h3>
                            </div>
                            <p class="module-desc">Learn to interact with the web page: selecting, modifying, and
                                creating elements dynamically.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/dom-selectors.jsp"
                                class="module-link">Start Module 5</a>
                        </div>

                        <!-- Module 6 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                                        <polyline points="15 3 21 3 21 9" />
                                        <line x1="10" y1="14" x2="21" y2="3" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Advanced Concepts</h3>
                            </div>
                            <p class="module-desc">Master the 'this' keyword, Prototypes, Classes, and Asynchronous
                                programming basics.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/this-keyword.jsp"
                                class="module-link">Start Module 6</a>
                        </div>

                        <!-- Module 7 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <polygon points="12 2 2 7 12 12 22 7 12 2" />
                                        <polyline points="2 17 12 22 22 17" />
                                        <polyline points="2 12 12 17 22 12" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Modern JavaScript</h3>
                            </div>
                            <p class="module-desc">Get up to speed with ES6+ features: Async/Await, Modules,
                                Destructuring, and more.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/async-await.jsp"
                                class="module-link">Start Module 7</a>
                        </div>

                        <!-- Module 8 -->
                        <div class="module-card">
                            <div class="module-header">
                                <div class="module-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path
                                            d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z" />
                                    </svg>
                                </div>
                                <h3 class="module-title">Practical Topics</h3>
                            </div>
                            <p class="module-desc">Essential skills for real-world development: Error Handling, JSON,
                                Storage, and Best Practices.</p>
                            <a href="<%=request.getContextPath()%>/tutorials/javascript/error-handling.jsp"
                                class="module-link">Start Module 8</a>
                        </div>
                    </div>
                </main>

                <%@ include file="../tutorial-footer.jsp" %>
        </div>
    </body>

    </html>