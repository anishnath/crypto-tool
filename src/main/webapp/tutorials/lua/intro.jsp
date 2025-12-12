<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Getting Started" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Introduction to Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn what Lua is, its use cases in game development and embedded systems, and why you should learn this powerful scripting language. Free Lua tutorial for beginners.">
            <meta name="keywords"
                content="lua introduction, what is lua, lua programming, lua scripting, learn lua, lua tutorial, lua for beginners">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to Lua - Lua Tutorial">
            <meta property="og:description"
                content="Discover Lua: the powerful, lightweight scripting language used in games, embedded systems, and more.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/intro.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

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
        "@type": "LearningResource",
        "name": "Introduction to Lua Programming",
        "description": "Learn what Lua is, its use cases in game development and embedded systems, and why you should learn this powerful scripting language.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/intro.jsp",
        "keywords": "lua introduction, what is lua, lua programming, lua scripting, learn lua",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Lua basics", "Lua use cases", "Lua history", "Why learn Lua"],
        "timeRequired": "PT15M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "description": "Complete Lua programming course from beginner to advanced with interactive examples",
            "url": "https://8gwifi.org/tutorials/lua/",
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            }
        },
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
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
                "name": "Lua",
                "item": "https://8gwifi.org/tutorials/lua/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Introduction to Lua"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="intro">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-lua.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Introduction to Lua</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Lua is a powerful, efficient, lightweight, embeddable scripting
                                        language.
                                        Created in 1993 at the Pontifical Catholic University of Rio de Janeiro, Lua has
                                        become
                                        one of the most popular scripting languages in game development, embedded
                                        systems, and
                                        application scripting. Let's discover what makes Lua special and why millions of
                                        developers
                                        choose it for their projects.</p>

                                    <!-- What is Lua? -->
                                    <h2>What is Lua?</h2>
                                    <p>Lua (pronounced "LOO-ah", Portuguese for "moon") is a lightweight, high-level,
                                        multi-paradigm programming language designed primarily for embedded use in
                                        applications.
                                        It supports procedural, object-oriented, functional, and data-driven programming
                                        styles.</p>

                                    <div class="info-box">
                                        <strong>Key Characteristics:</strong>
                                        <ul>
                                            <li><strong>Lightweight:</strong> The entire Lua interpreter is less than
                                                300KB</li>
                                            <li><strong>Fast:</strong> One of the fastest scripting languages available
                                            </li>
                                            <li><strong>Embeddable:</strong> Easy to integrate into C/C++ applications
                                            </li>
                                            <li><strong>Simple:</strong> Clean, readable syntax with minimal keywords
                                            </li>
                                            <li><strong>Portable:</strong> Runs on virtually any platform with a C
                                                compiler</li>
                                        </ul>
                                    </div>

                                    <h3>A Simple Lua Example</h3>
                                    <p>Here's your first look at Lua code. Don't worry if you don't understand
                                        everything yet—we'll
                                        cover all the details in upcoming lessons!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/intro-simple.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-intro" />
                                    </jsp:include>

                                    <p>Notice how clean and readable the code is? That's one of Lua's greatest
                                        strengths!</p>

                                    <!-- Why Learn Lua? -->
                                    <h2>Why Learn Lua?</h2>

                                    <h3>1. Game Development 🎮</h3>
                                    <p>Lua is the scripting language of choice for many game engines and games:</p>
                                    <ul>
                                        <li><strong>Roblox:</strong> All Roblox games are scripted in Lua (Luau variant)
                                        </li>
                                        <li><strong>World of Warcraft:</strong> UI and addon system powered by Lua</li>
                                        <li><strong>Angry Birds:</strong> Game logic written in Lua</li>
                                        <li><strong>Love2D:</strong> Popular 2D game framework using Lua</li>
                                        <li><strong>Corona SDK:</strong> Mobile game development with Lua</li>
                                    </ul>

                                    <h3>2. Embedded Systems 🔧</h3>
                                    <p>Lua's small footprint makes it perfect for embedded applications:</p>
                                    <ul>
                                        <li><strong>IoT Devices:</strong> NodeMCU firmware for ESP8266/ESP32</li>
                                        <li><strong>Network Equipment:</strong> Cisco uses Lua for configuration</li>
                                        <li><strong>Adobe Lightroom:</strong> Uses Lua for plugin development</li>
                                    </ul>

                                    <h3>3. Application Scripting 📝</h3>
                                    <p>Many applications use Lua for user scripting and customization:</p>
                                    <ul>
                                        <li><strong>Neovim/Vim:</strong> Configuration and plugin system</li>
                                        <li><strong>Redis:</strong> Server-side scripting</li>
                                        <li><strong>Wireshark:</strong> Packet analysis scripts</li>
                                    </ul>

                                    <div class="tip-box">
                                        <strong>Career Tip:</strong> Learning Lua opens doors to game development,
                                        embedded systems,
                                        and DevOps roles. Many companies specifically look for Lua developers for their
                                        game engines
                                        and scripting needs!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Lua's Design Philosophy -->
                                    <h2>Lua's Design Philosophy</h2>
                                    <p>Lua was designed with three main goals in mind:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Goal</th>
                                                <th>Description</th>
                                                <th>Benefit</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Simplicity</strong></td>
                                                <td>Minimal, clean syntax</td>
                                                <td>Easy to learn and read</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Efficiency</strong></td>
                                                <td>Fast execution, small memory footprint</td>
                                                <td>Perfect for resource-constrained environments</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Portability</strong></td>
                                                <td>Written in ANSI C</td>
                                                <td>Runs anywhere C runs</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Lua vs Other Languages -->
                                    <h2>Lua vs Other Languages</h2>
                                    <p>How does Lua compare to other popular scripting languages?</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Lua</th>
                                                <th>Python</th>
                                                <th>JavaScript</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Size</td>
                                                <td>~300 KB</td>
                                                <td>~30 MB</td>
                                                <td>~15 MB (Node.js)</td>
                                            </tr>
                                            <tr>
                                                <td>Speed</td>
                                                <td>Very Fast</td>
                                                <td>Moderate</td>
                                                <td>Fast</td>
                                            </tr>
                                            <tr>
                                                <td>Learning Curve</td>
                                                <td>Easy</td>
                                                <td>Easy</td>
                                                <td>Moderate</td>
                                            </tr>
                                            <tr>
                                                <td>Main Use</td>
                                                <td>Embedding, Games</td>
                                                <td>General Purpose</td>
                                                <td>Web Development</td>
                                            </tr>
                                            <tr>
                                                <td>Array Indexing</td>
                                                <td>1-based</td>
                                                <td>0-based</td>
                                                <td>0-based</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Lua uses 1-based array indexing (arrays start at
                                        index 1, not 0).
                                        This is different from most other programming languages and is one of the most
                                        common sources
                                        of confusion for beginners!
                                    </div>

                                    <!-- What You'll Learn -->
                                    <h2>What You'll Learn in This Tutorial</h2>
                                    <p>This comprehensive Lua tutorial will take you from complete beginner to confident
                                        Lua programmer.
                                        Here's what we'll cover:</p>

                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Fundamentals:</strong> Variables, types, operators, control flow
                                            </li>
                                            <li><strong>Functions:</strong> Basic functions, closures, higher-order
                                                functions</li>
                                            <li><strong>Tables:</strong> Lua's powerful data structure (arrays,
                                                dictionaries, objects)</li>
                                            <li><strong>Metatables:</strong> Metaprogramming and operator overloading
                                            </li>
                                            <li><strong>OOP:</strong> Object-oriented programming patterns in Lua</li>
                                            <li><strong>Modules:</strong> Code organization and reusability</li>
                                            <li><strong>Advanced Topics:</strong> Coroutines, pattern matching, garbage
                                                collection</li>
                                        </ul>
                                    </div>

                                    <!-- Prerequisites -->
                                    <h2>Prerequisites</h2>
                                    <p>This tutorial is designed for complete beginners. You don't need any prior
                                        programming experience!
                                        However, if you have programmed before in any language, you'll find Lua
                                        refreshingly simple.</p>

                                    <div class="best-practice-box">
                                        <strong>Best Way to Learn:</strong>
                                        <ul>
                                            <li>Read each lesson carefully</li>
                                            <li>Run and modify all code examples</li>
                                            <li>Complete the exercises at the end of each lesson</li>
                                            <li>Build small projects to practice what you've learned</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Misconceptions</h2>

                                    <div class="mistake-box">
                                        <h4>1. "Lua is only for games"</h4>
                                        <p><strong>Wrong:</strong> While Lua is popular in game development, it's also
                                            widely used in
                                            embedded systems, network applications, and as a configuration language.</p>
                                        <p><strong>Correct:</strong> Lua is a general-purpose scripting language with
                                            applications
                                            across many domains.</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. "Lua is slow because it's interpreted"</h4>
                                        <p><strong>Wrong:</strong> Lua is one of the fastest interpreted languages. With
                                            LuaJIT
                                            (Just-In-Time compiler), it can approach C-like performance.</p>
                                        <p><strong>Correct:</strong> Lua is highly optimized and extremely fast for a
                                            scripting language.</p>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what Lua is and why it's worth learning, it's time to get
                                        started!
                                        In the next lesson, we'll walk through <strong>installing Lua</strong> on your
                                        computer and
                                        setting up your development environment. You'll write and run your first Lua
                                        program!</p>

                                    <p>Ready to begin your Lua journey? Let's go! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="index.jsp" />
                                    <jsp:param name="prevTitle" value="Tutorial Home" />
                                    <jsp:param name="nextLink" value="installation.jsp" />
                                    <jsp:param name="nextTitle" value="Installation & Setup" />
                                    <jsp:param name="currentLessonId" value="intro" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/lua.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>