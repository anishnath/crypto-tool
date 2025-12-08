<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    HTML Tutorial - Introduction
    Lesson 1: What is HTML?
--%>
<%
    // Set current lesson for sidebar highlighting
    request.setAttribute("currentLesson", "introduction");
    request.setAttribute("currentModule", "Getting Started");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <%-- SEO --%>
    <title>HTML Introduction - Learn What HTML Is | 8gwifi.org Tutorials</title>
    <meta name="description" content="Learn what HTML is and why it's the foundation of every website. Start your web development journey with this beginner-friendly HTML tutorial.">
    <meta name="keywords" content="HTML tutorial, what is HTML, learn HTML, HTML for beginners, web development">

    <%-- Open Graph --%>
    <meta property="og:type" content="article">
    <meta property="og:title" content="HTML Introduction - Learn What HTML Is">
    <meta property="og:description" content="Learn what HTML is and why it's the foundation of every website.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <%-- Favicon --%>
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">

    <%-- Fonts & CSS --%>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <%-- Prevent FOUC --%>
    <script>
        (function() {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <%-- JSON-LD --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "HTML Introduction",
        "description": "Learn what HTML is and why it's the foundation of every website",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "isPartOf": {
            "@type": "Course",
            "name": "HTML Tutorial",
            "url": "https://8gwifi.org/tutorials/html/"
        }
    }
    </script>

    <%-- Analytics & Ads --%>
    <%@ include file="../tutorial-analytics.jsp" %>
    <%@ include file="../tutorial-ads.jsp" %>
</head>
<body class="tutorial-body" data-lesson="introduction">
    <div class="tutorial-layout">
        <%-- Header --%>
        <%@ include file="../tutorial-header.jsp" %>

        <%-- Main Content Area --%>
        <main class="tutorial-main">
            <%-- Sidebar --%>
            <%@ include file="../tutorial-sidebar.jsp" %>

            <%-- Overlay for mobile sidebar --%>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <%-- Lesson Content --%>
            <article class="tutorial-content">
                <%-- Breadcrumb --%>
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="/tutorials/html/">HTML</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Introduction</span>
                </nav>

                <%-- Lesson Header --%>
                <header class="lesson-header">
                    <h1 class="lesson-title">Introduction to HTML</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~5 min read</span>
                    </div>
                </header>

                <%-- Lesson Body --%>
                <div class="lesson-body">
                    <h2>What is HTML?</h2>
                    <p>
                        <strong>HTML</strong> stands for <strong>HyperText Markup Language</strong>. It is the standard
                        language used to create and structure content on the web. Every website you visit is built using HTML.
                    </p>
                    <p>
                        HTML is not a programming language - it's a <em>markup language</em>. This means it uses special
                        tags to define the structure and content of a webpage.
                    </p>

                    <h2>What You'll Learn</h2>
                    <ul>
                        <li>How to structure a webpage with HTML</li>
                        <li>Common HTML elements and tags</li>
                        <li>How to add text, images, links, and more</li>
                        <li>Best practices for writing clean HTML</li>
                    </ul>

                    <h2>Your First HTML Code</h2>
                    <p>
                        Let's start with a simple example. The code below creates a basic webpage with a heading
                        and a paragraph. Try editing the code and see the result update in real-time!
                    </p>

                    <%-- Code Editor --%>
                    <div class="editor-container">
                        <div class="editor-header">
                            <div class="editor-tabs">
                                <button class="editor-tab active">index.html</button>
                            </div>
                            <div class="editor-actions">
                                <button class="btn btn-sm btn-ghost" onclick="resetCode('editor1', originalCode1)" title="Reset">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M23 4v6h-6M1 20v-6h6"/>
                                        <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15"/>
                                    </svg>
                                </button>
                                <button class="btn btn-sm btn-ghost" onclick="copyCode('editor1')" title="Copy">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
                                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                                    </svg>
                                </button>
                                <button class="btn btn-sm btn-success" onclick="runCodePreview('editor1')">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                                        <polygon points="5 3 19 12 5 21 5 3"/>
                                    </svg>
                                    Run
                                </button>
                            </div>
                        </div>
                        <div class="editor-body">
                            <textarea id="editor1"><!DOCTYPE html>
<html>
<head>
    <title>My First Page</title>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>Welcome to my first webpage.</p>
    <p>HTML is fun and easy to learn!</p>
</body>
</html></textarea>
                        </div>
                    </div>

                    <%-- Mobile Run Button --%>
                    <div class="hidden" style="margin-top: var(--space-4);">
                        <button class="btn btn-success btn-lg" onclick="openMobilePreview()" style="width: 100%;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                <polygon points="5 3 19 12 5 21 5 3"/>
                            </svg>
                            View Result
                        </button>
                    </div>

                    <%-- Callout --%>
                    <div class="callout callout-tip">
                        <svg class="callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 16v-4M12 8h.01"/>
                        </svg>
                        <div class="callout-content">
                            <strong>Pro Tip:</strong> Try changing "Hello, World!" to your own message and click Run to see the result!
                        </div>
                    </div>

                    <h2>Understanding the Code</h2>
                    <p>Let's break down what each part does:</p>

                    <ul>
                        <li><code>&lt;!DOCTYPE html&gt;</code> - Tells the browser this is an HTML5 document</li>
                        <li><code>&lt;html&gt;</code> - The root element that contains all HTML content</li>
                        <li><code>&lt;head&gt;</code> - Contains metadata like the page title</li>
                        <li><code>&lt;title&gt;</code> - Sets the browser tab title</li>
                        <li><code>&lt;body&gt;</code> - Contains all visible content</li>
                        <li><code>&lt;h1&gt;</code> - A main heading (largest)</li>
                        <li><code>&lt;p&gt;</code> - A paragraph of text</li>
                    </ul>

                    <h2>Key Takeaways</h2>
                    <div class="card" style="margin: var(--space-6) 0;">
                        <ul style="margin: 0; padding-left: var(--space-6);">
                            <li>HTML is the standard language for creating webpages</li>
                            <li>HTML uses <strong>tags</strong> to structure content</li>
                            <li>Tags usually come in pairs: opening <code>&lt;tag&gt;</code> and closing <code>&lt;/tag&gt;</code></li>
                            <li>Every HTML page needs a <code>&lt;!DOCTYPE html&gt;</code> declaration</li>
                        </ul>
                    </div>

                    <%-- Quiz --%>
                    <div class="quiz-container">
                        <h3 class="quiz-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
                                <line x1="12" y1="17" x2="12.01" y2="17"/>
                            </svg>
                            Quick Quiz
                        </h3>
                        <p class="quiz-question">What does HTML stand for?</p>
                        <div class="quiz-options">
                            <div class="quiz-option" data-question="q1" onclick="checkQuizAnswer('q1', 0, 1)">
                                <span>Hyper Transfer Markup Language</span>
                            </div>
                            <div class="quiz-option" data-question="q1" onclick="checkQuizAnswer('q1', 1, 1)">
                                <span>HyperText Markup Language</span>
                            </div>
                            <div class="quiz-option" data-question="q1" onclick="checkQuizAnswer('q1', 2, 1)">
                                <span>Home Tool Markup Language</span>
                            </div>
                            <div class="quiz-option" data-question="q1" onclick="checkQuizAnswer('q1', 3, 1)">
                                <span>Hyperlink Text Management Language</span>
                            </div>
                        </div>
                    </div>

                    <%-- Navigation --%>
                    <nav class="lesson-nav">
                        <div class="nav-prev">
                            <%-- No previous lesson --%>
                        </div>
                        <div class="nav-next">
                            <a href="<%=request.getContextPath()%>/tutorials/html/editors.jsp" class="nav-btn">
                                <span class="nav-label">Next Lesson</span>
                                <span class="nav-title">HTML Editors &rarr;</span>
                            </a>
                        </div>
                    </nav>
                </div>
            </article>

            <%-- Live Preview Panel --%>
            <aside class="tutorial-preview" id="previewPanel">
                <div class="preview-header">
                    <span>Live Preview</span>
                    <button class="btn btn-ghost btn-icon" onclick="refreshPreview()" title="Refresh">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M23 4v6h-6M1 20v-6h6"/>
                            <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15"/>
                        </svg>
                    </button>
                </div>
                <iframe id="previewFrame" class="preview-frame" sandbox="allow-scripts allow-same-origin" title="Live Preview"></iframe>
            </aside>
        </main>

        <%-- Footer --%>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <%-- Mobile Preview Bottom Sheet --%>
    <div class="mobile-preview" id="mobilePreview">
        <div class="mobile-preview-header">
            <span style="font-weight: 500;">Preview</span>
            <button class="btn btn-ghost btn-icon" onclick="closeMobilePreview()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>
        <div class="mobile-preview-body">
            <iframe id="mobilePreviewFrame" class="preview-frame" style="width:100%;height:100%;" sandbox="allow-scripts allow-same-origin" title="Mobile Preview"></iframe>
        </div>
    </div>

    <%-- JavaScript --%>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>

    <script>
        // Store original code for reset
        var originalCode1 = document.getElementById('editor1').value;

        // Initialize editor
        document.addEventListener('DOMContentLoaded', function() {
            initCodeEditor('editor1', {
                mode: 'htmlmixed',
                height: 280
            });
        });
    </script>
</body>
</html>
