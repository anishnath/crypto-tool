<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- 8gwifi.org Tutorials - Main Hub --%>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Free Coding Tutorials 2025 - Learn HTML, CSS, JavaScript, Python, Go, Lua, Rust | 8gwifi.org</title>
            <meta name="description"
                content="[Free] Learn to code with interactive tutorials. Master HTML, CSS, JavaScript, TypeScript, Python, Go, Lua, Bash, Java, Rust with live editor. No signup. Practice instantly in browser. 100+ lessons.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/">

            <%-- Open Graph Tags --%>
                <meta property="og:title" content="Free Programming Tutorials - Learn to Code Online | 8gwifi.org">
                <meta property="og:description"
                    content="Interactive coding tutorials with live editor. Learn HTML, CSS, JavaScript, Python, Go, Lua, Bash, Java, Rust by doing - not just reading.">
                <meta property="og:type" content="website">
                <meta property="og:url" content="https://8gwifi.org/tutorials/">
                <meta property="og:site_name" content="8gwifi.org">

                <%-- Twitter Card --%>
                    <meta name="twitter:card" content="summary_large_image">
                    <meta name="twitter:title" content="Free Programming Tutorials - Learn to Code">
                    <meta name="twitter:description"
                        content="Learn HTML, CSS, JavaScript, Python, Go, Lua with interactive code editor. Practice instantly in your browser.">

                    <link rel="icon" type="image/svg+xml"
                        href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">

                    <%-- Structured Data: CollectionPage + ItemList --%>
                        <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "CollectionPage",
        "name": "Free Programming Tutorials - Learn to Code Online",
        "description": "Free interactive coding tutorials with live editor. Learn HTML, CSS, JavaScript, Python, Go, Lua, Bash, Java, Rust from scratch.",
        "url": "https://8gwifi.org/tutorials/",
        "mainEntity": {
            "@type": "ItemList",
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "HTML Tutorial",
                    "description": "Learn the foundation of web development. Structure content for the web.",
                    "url": "https://8gwifi.org/tutorials/html/"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "CSS Tutorial",
                    "description": "Style your webpages. Colors, layouts, animations, and responsive design.",
                    "url": "https://8gwifi.org/tutorials/css/"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "JavaScript Tutorial",
                    "description": "Add interactivity to websites. Learn programming fundamentals.",
                    "url": "https://8gwifi.org/tutorials/javascript/"
                },
                {
                    "@type": "ListItem",
                    "position": 4,
                    "name": "Python Tutorial",
                    "description": "Versatile language for web, data science, AI, and automation.",
                    "url": "https://8gwifi.org/tutorials/python/"
                },
                {
                    "@type": "ListItem",
                    "position": 5,
                    "name": "Bash Tutorial",
                    "description": "Shell scripting for automation, DevOps, and system administration.",
                    "url": "https://8gwifi.org/tutorials/bash/"
                },
                {
                    "@type": "ListItem",
                    "position": 6,
                    "name": "Java Tutorial",
                    "description": "Enterprise-grade programming. Build robust applications.",
                    "url": "https://8gwifi.org/tutorials/java/"
                },
                {
                    "@type": "ListItem",
                    "position": 7,
                    "name": "TypeScript Tutorial",
                    "description": "JavaScript with types. Build large-scale, type-safe applications.",
                    "url": "https://8gwifi.org/tutorials/typescript/"
                },
                {
                    "@type": "ListItem",
                    "position": 8,
                    "name": "Lua Tutorial",
                    "description": "Lightweight scripting for games, embedded systems, and more.",
                    "url": "https://8gwifi.org/tutorials/lua/"
                },
                {
                    "@type": "ListItem",
                    "position": 9,
                    "name": "Go Tutorial",
                    "description": "Concurrent programming and web services. Simple, fast, and efficient.",
                    "url": "https://8gwifi.org/tutorials/go/"
                },
                {
                    "@type": "ListItem",
                    "position": 10,
                    "name": "Rust Tutorial",
                    "description": "Memory-safe systems programming. Performance without compromise.",
                    "url": "https://8gwifi.org/tutorials/rust/"
                }
            ]
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    }
    </script>

                        <%-- FAQ Schema for Rich Snippets --%>
                            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "Are these programming tutorials free?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, all tutorials are 100% free. No signup, no credit card, no hidden fees. Just open and start coding immediately in your browser."
                }
            },
            {
                "@type": "Question",
                "name": "Do I need to install any software to learn coding?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "No installation required. Our tutorials include a live code editor that runs directly in your browser. Write code, see results instantly."
                }
            },
            {
                "@type": "Question",
                "name": "Which programming language should I learn first?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "For web development, start with HTML, then CSS, then JavaScript. For data science or automation, start with Python. For DevOps, learn Bash scripting."
                }
            },
            {
                "@type": "Question",
                "name": "How long does it take to complete a tutorial?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Each tutorial has 10-15 lessons. Most learners complete a full tutorial in 2-4 hours of focused practice. Learn at your own pace."
                }
            }
        ]
    }
    </script>

                            <%-- Course Schema for Enhanced SERP --%>
                                <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "ItemList",
        "itemListElement": [
            {
                "@type": "Course",
                "position": 1,
                "name": "HTML Tutorial for Beginners",
                "description": "Learn HTML from scratch. Build web page structure with hands-on exercises.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/html/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 2,
                "name": "CSS Tutorial for Beginners",
                "description": "Master CSS styling. Colors, layouts, animations, responsive design.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/css/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 3,
                "name": "JavaScript Tutorial for Beginners",
                "description": "Learn JavaScript programming. Add interactivity to websites.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/javascript/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 4,
                "name": "Python Tutorial for Beginners",
                "description": "Learn Python for web development, data science, AI, and automation.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/python/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 5,
                "name": "Bash Scripting Tutorial",
                "description": "Shell scripting for automation, DevOps, and system administration.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/bash/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 6,
                "name": "Java Tutorial for Beginners",
                "description": "Enterprise Java programming. Build robust applications.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/java/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 7,
                "name": "TypeScript Tutorial for Beginners",
                "description": "Learn TypeScript for type-safe JavaScript. Build large-scale applications.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/typescript/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 8,
                "name": "Lua Tutorial for Beginners",
                "description": "Learn Lua for game development, embedded systems, and scripting.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/lua/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 9,
                "name": "Go Tutorial for Beginners",
                "description": "Learn Go for concurrent programming and web services. Simple, fast, and efficient.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/go/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            },
            {
                "@type": "Course",
                "position": 10,
                "name": "Rust Tutorial for Beginners",
                "description": "Learn Rust for memory-safe systems programming. Performance without compromise.",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "url": "https://8gwifi.org/tutorials/rust/",
                "educationalLevel": "Beginner",
                "isAccessibleForFree": true,
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        ]
    }
    </script>

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

                                    /* Breadcrumb Styles */
                                    .breadcrumb {
                                        max-width: 1200px;
                                        margin: var(--space-4) auto 0;
                                        padding: 0 var(--space-4);
                                    }

                                    .breadcrumb-list {
                                        display: flex;
                                        align-items: center;
                                        gap: var(--space-2);
                                        list-style: none;
                                        margin: 0;
                                        padding: 0;
                                        font-size: var(--text-sm);
                                    }

                                    .breadcrumb-list li {
                                        display: flex;
                                        align-items: center;
                                        gap: var(--space-2);
                                    }

                                    .breadcrumb-list li:not(:last-child)::after {
                                        content: "/";
                                        color: var(--text-muted);
                                    }

                                    .breadcrumb-list a {
                                        color: var(--accent-primary);
                                        text-decoration: none;
                                    }

                                    .breadcrumb-list a:hover {
                                        text-decoration: underline;
                                    }

                                    .breadcrumb-list .current {
                                        color: var(--text-secondary);
                                    }

                                    /* Learning Paths Styles */
                                    .learning-paths {
                                        display: grid;
                                        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                                        gap: var(--space-5);
                                        padding: 0 var(--space-4);
                                        max-width: 1200px;
                                        margin: 0 auto var(--space-8);
                                    }

                                    .path-card {
                                        padding: var(--space-5);
                                        border: 2px solid var(--border);
                                        border-radius: var(--radius-lg);
                                        background: var(--bg-primary);
                                        transition: all var(--transition-normal);
                                    }

                                    .path-card:hover {
                                        border-color: var(--accent-primary);
                                        box-shadow: var(--shadow-lg);
                                    }

                                    .path-header {
                                        display: flex;
                                        align-items: center;
                                        gap: var(--space-3);
                                        margin-bottom: var(--space-2);
                                    }

                                    .path-icon {
                                        font-size: var(--text-2xl);
                                    }

                                    .path-card h3 {
                                        margin: 0;
                                        color: var(--text-primary);
                                        font-size: var(--text-lg);
                                    }

                                    .path-card>p {
                                        margin: 0 0 var(--space-3) 0;
                                        color: var(--text-secondary);
                                        font-size: var(--text-sm);
                                    }

                                    .path-steps {
                                        display: flex;
                                        align-items: center;
                                        gap: var(--space-2);
                                        flex-wrap: wrap;
                                        margin-bottom: var(--space-3);
                                    }

                                    .path-steps a {
                                        padding: var(--space-1) var(--space-3);
                                        background: var(--bg-tertiary);
                                        border-radius: var(--radius-md);
                                        color: var(--accent-primary);
                                        text-decoration: none;
                                        font-size: var(--text-sm);
                                        font-weight: 500;
                                        transition: background var(--transition-fast);
                                    }

                                    .path-steps a:hover {
                                        background: var(--accent-primary);
                                        color: white;
                                    }

                                    .path-arrow {
                                        color: var(--text-muted);
                                        font-size: var(--text-sm);
                                    }

                                    .path-badge {
                                        display: inline-block;
                                        padding: var(--space-1) var(--space-2);
                                        background: linear-gradient(135deg, var(--accent-primary), var(--success));
                                        color: white;
                                        border-radius: var(--radius-full);
                                        font-size: var(--text-xs);
                                        font-weight: 600;
                                    }

                                    /* FAQ Styles */
                                    .faq-section {
                                        max-width: 800px;
                                        margin: 0 auto var(--space-12);
                                        padding: 0 var(--space-4);
                                    }

                                    .faq-item {
                                        border: 1px solid var(--border);
                                        border-radius: var(--radius-md);
                                        margin-bottom: var(--space-3);
                                        background: var(--bg-primary);
                                        overflow: hidden;
                                    }

                                    .faq-item summary {
                                        padding: var(--space-4);
                                        cursor: pointer;
                                        font-weight: 500;
                                        color: var(--text-primary);
                                        list-style: none;
                                        display: flex;
                                        justify-content: space-between;
                                        align-items: center;
                                    }

                                    .faq-item summary::-webkit-details-marker {
                                        display: none;
                                    }

                                    .faq-item summary::after {
                                        content: "+";
                                        font-size: var(--text-xl);
                                        color: var(--accent-primary);
                                        transition: transform var(--transition-fast);
                                    }

                                    .faq-item[open] summary::after {
                                        content: "−";
                                    }

                                    .faq-item p {
                                        padding: 0 var(--space-4) var(--space-4);
                                        margin: 0;
                                        color: var(--text-secondary);
                                        line-height: 1.6;
                                    }

                                    .faq-item[open] {
                                        border-color: var(--accent-primary);
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
                <%-- Breadcrumb Navigation with Schema.org markup --%>
                    <nav class="breadcrumb" aria-label="Breadcrumb">
                        <ol class="breadcrumb-list" itemscope itemtype="https://schema.org/BreadcrumbList">
                            <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                <a itemprop="item" href="/"><span itemprop="name">Home</span></a>
                                <meta itemprop="position" content="1">
                            </li>
                            <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                                <span class="current" itemprop="name">Tutorials</span>
                                <meta itemprop="position" content="2">
                            </li>
                        </ol>
                    </nav>

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
                                            <img src="<%=request.getContextPath()%>/tutorials/assets/images/html-logo.svg"
                                                alt="HTML5">
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
                                                <img src="<%=request.getContextPath()%>/tutorials/assets/images/css-logo.svg"
                                                    alt="CSS3">
                                            </div>
                                            <h3>CSS</h3>
                                        </div>
                                        <p>Style your webpages. Colors, layouts, animations, and responsive design.</p>
                                        <span class="tutorial-card-badge badge-available">Available</span>
                                    </a>

                                    <%-- JavaScript Tutorial --%>
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/"
                                            class="tutorial-card">
                                            <div class="tutorial-card-header">
                                                <div class="tutorial-card-icon" style="background: #f7df1e15;">
                                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/javascript-logo.svg"
                                                        alt="JavaScript">
                                                </div>
                                                <h3>JavaScript</h3>
                                            </div>
                                            <p>Add interactivity to websites. Learn programming fundamentals.</p>
                                            <span class="tutorial-card-badge badge-available">Available</span>
                                        </a>

                                        <%-- Python Tutorial --%>
                                            <a href="<%=request.getContextPath()%>/tutorials/python/"
                                                class="tutorial-card">
                                                <div class="tutorial-card-header">
                                                    <div class="tutorial-card-icon" style="background: #3776ab15;">
                                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/python-logo.svg"
                                                            alt="Python">
                                                    </div>
                                                    <h3>Python</h3>
                                                </div>
                                                <p>Versatile language for web, data science, AI, and automation.</p>
                                                <span class="tutorial-card-badge badge-available">Available</span>
                                            </a>

                                            <%-- Bash Tutorial --%>
                                                <a href="<%=request.getContextPath()%>/tutorials/bash/"
                                                    class="tutorial-card">
                                                    <div class="tutorial-card-header">
                                                        <div class="tutorial-card-icon" style="background: #4eaa2515;">
                                                            <img src="<%=request.getContextPath()%>/tutorials/assets/images/bash-logo.svg"
                                                                alt="Bash">
                                                        </div>
                                                        <h3>Bash</h3>
                                                    </div>
                                                    <p>Shell scripting for automation, DevOps, and system
                                                        administration.</p>
                                                    <span class="tutorial-card-badge badge-available">Available</span>
                                                </a>

                                                <%-- Java Tutorial --%>
                                                    <a href="<%=request.getContextPath()%>/tutorials/java/"
                                                        class="tutorial-card">
                                                        <div class="tutorial-card-header">
                                                            <div class="tutorial-card-icon"
                                                                style="background: #ed8b0015;">
                                                                <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-logo.svg"
                                                                    alt="Java">
                                                            </div>
                                                            <h3>Java</h3>
                                                        </div>
                                                        <p>Enterprise-grade programming. Build robust applications.</p>
                                                        <span
                                                            class="tutorial-card-badge badge-available">Available</span>
                                                    </a>

                                                    <%-- TypeScript Tutorial --%>
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/"
                                                            class="tutorial-card">
                                                            <div class="tutorial-card-header">
                                                                <div class="tutorial-card-icon"
                                                                    style="background: #3178c615;">
                                                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/typescript-logo.svg"
                                                                        alt="TypeScript">
                                                                </div>
                                                                <h3>TypeScript</h3>
                                                            </div>
                                                            <p>JavaScript with types. Build large-scale, type-safe
                                                                applications.</p>
                                                            <span
                                                                class="tutorial-card-badge badge-available">Available</span>
                                                        </a>

                                                        <%-- Rust Tutorial --%>
                                                            <a href="<%=request.getContextPath()%>/tutorials/lua/"
                                                                class="tutorial-card">
                                                                <div class="tutorial-card-header">
                                                                    <div class="tutorial-card-icon"
                                                                        style="background: #00008015;">
                                                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/lua-logo.svg"
                                                                            alt="Lua">
                                                                    </div>
                                                                    <h3>Lua</h3>
                                                                </div>
                                                                <p>Lightweight scripting for games, embedded systems,
                                                                    and more.</p>
                                                                <span
                                                                    class="tutorial-card-badge badge-available">Available</span>
                                                            </a>

                                                            <a href="<%=request.getContextPath()%>/tutorials/go/"
                                                                class="tutorial-card">
                                                                <div class="tutorial-card-header">
                                                                    <div class="tutorial-card-icon"
                                                                        style="background: #00add815;">
                                                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-logo.svg"
                                                                            alt="Go">
                                                                    </div>
                                                                    <h3>Go</h3>
                                                                </div>
                                                                <p>Fast, simple, and efficient. Build scalable systems
                                                                    and web services.</p>
                                                                <span
                                                                    class="tutorial-card-badge badge-available">Available</span>
                                                            </a>

                                                            <a href="<%=request.getContextPath()%>/tutorials/rust/"
                                                                class="tutorial-card">
                                                                <div class="tutorial-card-header">
                                                                    <div class="tutorial-card-icon"
                                                                        style="background: #dea58415;">
                                                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-logo.svg"
                                                                            alt="Rust">
                                                                    </div>
                                                                    <h3>Rust</h3>
                                                                </div>
                                                                <p>Memory-safe systems programming. Performance without
                                                                    compromise.</p>
                                                                <span
                                                                    class="tutorial-card-badge badge-available">Available</span>
                                                            </a>
                        </section>

                        <div class="divider">
                            <hr>
                        </div>

                        <%-- Coming Soon Section --%>
                            <h2 class="section-title">Coming Soon</h2>
                            <p class="section-subtitle">More tutorials are on the way</p>

                            <section class="tutorials-grid">


                                <%-- C++ Tutorial --%>
                                    <div class="tutorial-card disabled">
                                        <div class="tutorial-card-header">
                                            <div class="tutorial-card-icon" style="background: #00599c15;">
                                                <img src="<%=request.getContextPath()%>/tutorials/assets/images/cpp-logo.svg"
                                                    alt="C++">
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
                                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/sql-logo.svg"
                                                        alt="SQL">
                                                </div>
                                                <h3>SQL</h3>
                                            </div>
                                            <p>Query and manage databases. Essential data skill.</p>
                                            <span class="tutorial-card-badge badge-coming">Coming
                                                Soon</span>
                                        </div>

                                        <%-- PHP Tutorial --%>
                                            <div class="tutorial-card disabled">
                                                <div class="tutorial-card-header">
                                                    <div class="tutorial-card-icon" style="background: #777bb315;">
                                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-logo.svg"
                                                            alt="PHP">
                                                    </div>
                                                    <h3>PHP</h3>
                                                </div>
                                                <p>Server-side web development. Powers most of the web.</p>
                                                <span class="tutorial-card-badge badge-coming">Coming
                                                    Soon</span>
                                            </div>

                                            <%-- Ruby Tutorial --%>
                                                <div class="tutorial-card disabled">
                                                    <div class="tutorial-card-header">
                                                        <div class="tutorial-card-icon" style="background: #cc342d15;">
                                                            <img src="<%=request.getContextPath()%>/tutorials/assets/images/ruby-logo.svg"
                                                                alt="Ruby">
                                                        </div>
                                                        <h3>Ruby</h3>
                                                    </div>
                                                    <p>Elegant and productive. Build web apps with Rails.
                                                    </p>
                                                    <span class="tutorial-card-badge badge-coming">Coming
                                                        Soon</span>
                                                </div>
                            </section>

                            <div class="divider">
                                <hr>
                            </div>

                            <%-- Learning Paths Section --%>
                                <h2 class="section-title">Learning Paths</h2>
                                <p class="section-subtitle">Not sure where to start? Follow a structured path</p>

                                <section class="learning-paths">
                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">🌐</span>
                                            <h3>Web Developer</h3>
                                        </div>
                                        <p>Build websites from scratch</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/html/">HTML</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/css/">CSS</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/">JavaScript</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a>
                                        </div>
                                        <span class="path-badge">Beginner Friendly</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">⚡</span>
                                            <h3>Full-Stack Developer</h3>
                                        </div>
                                        <p>Build complete web applications</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/html/">HTML</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/css/">CSS</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                        </div>
                                        <span class="path-badge">Professional</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">🤖</span>
                                            <h3>Data & Automation</h3>
                                        </div>
                                        <p>Automate tasks, analyze data</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                                        </div>
                                        <span class="path-badge">High Demand</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">☁️</span>
                                            <h3>DevOps Engineer</h3>
                                        </div>
                                        <p>CI/CD, servers, infrastructure</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                        </div>
                                        <span class="path-badge">Career Growth</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">⚙️</span>
                                            <h3>Systems Programmer</h3>
                                        </div>
                                        <p>Build fast, safe systems software</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/rust/">Rust</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                                        </div>
                                        <span class="path-badge">High Performance</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">🚀</span>
                                            <h3>Backend Developer</h3>
                                        </div>
                                        <p>Build scalable backend services</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/go/">Go</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                                        </div>
                                        <span class="path-badge">Cloud Native</span>
                                    </div>

                                    <div class="path-card">
                                        <div class="path-header">
                                            <span class="path-icon">🎮</span>
                                            <h3>Game Developer</h3>
                                        </div>
                                        <p>Script game logic and mechanics</p>
                                        <div class="path-steps">
                                            <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                            <span class="path-arrow">→</span>
                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/">JavaScript</a>
                                        </div>
                                        <span class="path-badge">Game Development</span>
                                    </div>
                                </section>

                                <div class="divider">
                                    <hr>
                                </div>

                                <%-- FAQ Section --%>
                                    <h2 class="section-title">Frequently Asked Questions</h2>
                                    <p class="section-subtitle">Quick answers to common questions</p>

                                    <section class="faq-section">
                                        <details class="faq-item">
                                            <summary>Are these programming tutorials free?</summary>
                                            <p>Yes, all tutorials are 100% free. No signup, no credit card, no hidden
                                                fees. Just open and start coding immediately in your browser.</p>
                                        </details>

                                        <details class="faq-item">
                                            <summary>Do I need to install any software to learn coding?</summary>
                                            <p>No installation required. Our tutorials include a live code editor that
                                                runs directly in your browser. Write code, see results instantly.</p>
                                        </details>

                                        <details class="faq-item">
                                            <summary>Which programming language should I learn first?</summary>
                                            <p>For web development, start with HTML, then CSS, then JavaScript. For data
                                                science or automation, start with Python. For DevOps, learn Bash
                                                scripting.</p>
                                        </details>

                                        <details class="faq-item">
                                            <summary>How long does it take to complete a tutorial?</summary>
                                            <p>Each tutorial has 10-15 lessons. Most learners complete a full tutorial
                                                in 2-4 hours of focused practice. Learn at your own pace.</p>
                                        </details>
                                    </section>
            </div>

            <footer class="tutorial-footer" style="margin: 0;">
                <div class="footer-content">
                    <p>&copy; 2025 8gwifi.org Tutorials. Learn to code with interactive examples.</p>
                    <div class="footer-links">
                        <a href="/">Main Site</a>
                    </div>
                </div>
            </footer>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js"></script>
        </body>

        </html>