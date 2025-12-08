<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 8gwifi.org Tutorials - Main Hub --%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>8gwifi.org Tutorials - Learn Programming</title>
    <meta name="description"
        content="Free interactive tutorials for programming. Learn HTML, CSS, JavaScript, Python, Java, Go, and more with live code editor.">

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

    <style>
        .hero {
            text-align: center;
            padding: var(--space-16) var(--space-4);
            max-width: 800px;
            margin: 0 auto;
        }

        .hero-title {
            font-size: var(--text-4xl);
            font-weight: 700;
            margin-bottom: var(--space-4);
            background: linear-gradient(135deg, var(--accent-primary), var(--success));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: var(--text-xl);
            color: var(--text-secondary);
            margin-bottom: var(--space-8);
        }

        .section-title {
            font-size: var(--text-2xl);
            font-weight: 600;
            text-align: center;
            margin-bottom: var(--space-6);
            color: var(--text-primary);
        }

        .section-subtitle {
            text-align: center;
            color: var(--text-secondary);
            margin-bottom: var(--space-8);
            font-size: var(--text-base);
        }

        .tutorials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: var(--space-5);
            padding: 0 var(--space-4);
            max-width: 1200px;
            margin: 0 auto var(--space-12);
        }

        .tutorial-card {
            text-decoration: none;
            padding: var(--space-5);
            border: 2px solid var(--border);
            border-radius: var(--radius-lg);
            transition: all var(--transition-normal);
            background: var(--bg-primary);
        }

        .tutorial-card:hover:not(.disabled) {
            border-color: var(--accent-primary);
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .tutorial-card.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .tutorial-card-header {
            display: flex;
            align-items: center;
            gap: var(--space-3);
            margin-bottom: var(--space-3);
        }

        .tutorial-card-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .tutorial-card-icon img {
            width: 32px;
            height: 32px;
            object-fit: contain;
        }

        .tutorial-card h3 {
            margin: 0;
            color: var(--text-primary);
            font-size: var(--text-lg);
        }

        .tutorial-card p {
            margin: 0 0 var(--space-3) 0;
            color: var(--text-secondary);
            font-size: var(--text-sm);
            line-height: 1.5;
        }

        .tutorial-card-badge {
            display: inline-block;
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: 500;
        }

        .badge-available {
            background: var(--success-light);
            color: var(--success);
        }

        .badge-coming {
            background: var(--bg-tertiary);
            color: var(--text-muted);
        }

        .hub-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: var(--header-height);
            background: var(--bg-primary);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 var(--space-4);
            z-index: 50;
        }

        .hub-content {
            padding-top: var(--header-height);
        }

        .divider {
            max-width: 1200px;
            margin: var(--space-8) auto;
            padding: 0 var(--space-4);
        }

        .divider hr {
            border: none;
            border-top: 1px solid var(--border);
        }
    </style>
</head>

<body class="tutorial-body">
    <header class="hub-header">
        <a href="/tutorials/" class="logo">
            <div class="logo-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="16 18 22 12 16 6" />
                    <polyline points="8 6 2 12 8 18" />
                </svg>
            </div>
            <span class="logo-text">8gwifi.org <span
                    style="font-weight: 400; color: var(--text-secondary);">Tutorials</span></span>
        </a>

        <button class="theme-toggle" id="themeToggle" onclick="toggleTheme()" aria-label="Toggle dark mode">
            <svg class="theme-icon-light" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" style="display: none;">
                <circle cx="12" cy="12" r="5" />
                <line x1="12" y1="1" x2="12" y2="3" />
                <line x1="12" y1="21" x2="12" y2="23" />
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
                <line x1="1" y1="12" x2="3" y2="12" />
                <line x1="21" y1="12" x2="23" y2="12" />
                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" />
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
            </svg>
            <svg class="theme-icon-dark" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
            </svg>
        </button>
    </header>

    <div class="hub-content">
        <section class="hero">
            <h1 class="hero-title">Learn to Code</h1>
            <p class="hero-subtitle">
                Free interactive tutorials with live code editor. Learn by doing, not just reading.
            </p>
        </section>

        <%-- Available Tutorials Section --%>
        <h2 class="section-title">Available Now</h2>
        <p class="section-subtitle">Start learning with our interactive tutorials</p>

        <section class="tutorials-grid">
            <%-- HTML Tutorial --%>
            <a href="<%=request.getContextPath()%>/tutorials/html/" class="tutorial-card">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #e34c2615;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/html-logo.svg" alt="HTML5">
                    </div>
                    <h3>HTML</h3>
                </div>
                <p>Learn the foundation of web development. Structure content for the web.</p>
                <span class="tutorial-card-badge badge-available">Available</span>
            </a>

            <%-- CSS Tutorial --%>
            <a href="<%=request.getContextPath()%>/tutorials/css/" class="tutorial-card">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #264de415;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/css-logo.svg" alt="CSS3">
                    </div>
                    <h3>CSS</h3>
                </div>
                <p>Style your webpages. Colors, layouts, animations, and responsive design.</p>
                <span class="tutorial-card-badge badge-available">Available</span>
            </a>

            <%-- JavaScript Tutorial --%>
            <a href="<%=request.getContextPath()%>/tutorials/javascript/" class="tutorial-card">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #f7df1e15;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/javascript-logo.svg" alt="JavaScript">
                    </div>
                    <h3>JavaScript</h3>
                </div>
                <p>Add interactivity to websites. Learn programming fundamentals.</p>
                <span class="tutorial-card-badge badge-available">Available</span>
            </a>

            <%-- Python Tutorial --%>
            <a href="<%=request.getContextPath()%>/tutorials/python/" class="tutorial-card">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #3776ab15;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/python-logo.svg" alt="Python">
                    </div>
                    <h3>Python</h3>
                </div>
                <p>Versatile language for web, data science, AI, and automation.</p>
                <span class="tutorial-card-badge badge-available">Available</span>
            </a>
        </section>

        <div class="divider"><hr></div>

        <%-- Coming Soon Section --%>
        <h2 class="section-title">Coming Soon</h2>
        <p class="section-subtitle">More tutorials are on the way</p>

        <section class="tutorials-grid">
            <%-- Java Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #ed8b0015;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-logo.svg" alt="Java">
                    </div>
                    <h3>Java</h3>
                </div>
                <p>Enterprise-grade programming. Build robust applications.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- Go Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #00add815;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-logo.svg" alt="Go">
                    </div>
                    <h3>Go</h3>
                </div>
                <p>Fast, simple, and efficient. Build scalable systems.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- TypeScript Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #3178c615;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/typescript-logo.svg" alt="TypeScript">
                    </div>
                    <h3>TypeScript</h3>
                </div>
                <p>JavaScript with types. Build large-scale applications.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- Rust Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #dea58415;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-logo.svg" alt="Rust">
                    </div>
                    <h3>Rust</h3>
                </div>
                <p>Memory-safe systems programming. Performance without compromise.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- C++ Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #00599c15;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/cpp-logo.svg" alt="C++">
                    </div>
                    <h3>C++</h3>
                </div>
                <p>High-performance programming for games and systems.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- SQL Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #33679115;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/sql-logo.svg" alt="SQL">
                    </div>
                    <h3>SQL</h3>
                </div>
                <p>Query and manage databases. Essential data skill.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- PHP Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #777bb315;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-logo.svg" alt="PHP">
                    </div>
                    <h3>PHP</h3>
                </div>
                <p>Server-side web development. Powers most of the web.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>

            <%-- Ruby Tutorial --%>
            <div class="tutorial-card disabled">
                <div class="tutorial-card-header">
                    <div class="tutorial-card-icon" style="background: #cc342d15;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/ruby-logo.svg" alt="Ruby">
                    </div>
                    <h3>Ruby</h3>
                </div>
                <p>Elegant and productive. Build web apps with Rails.</p>
                <span class="tutorial-card-badge badge-coming">Coming Soon</span>
            </div>
        </section>
    </div>

    <footer class="tutorial-footer" style="margin: 0;">
        <div class="footer-content">
            <p>&copy; 2024 8gwifi.org Tutorials. Learn to code with interactive examples.</p>
            <div class="footer-links">
                <a href="/">Main Site</a>
            </div>
        </div>
    </footer>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js"></script>
</body>

</html>
