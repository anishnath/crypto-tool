<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-constructor" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Constructors & Destructors - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP constructors and destructors. Learn object initialization, __construct, __destruct, and object lifecycle.">
            <meta name="keywords"
                content="php constructor, php destructor, php __construct, php __destruct, php object initialization">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-constructor.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Constructors and Destructors","description":"Learn PHP constructors and destructors","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP constructor","PHP destructor","Object initialization","Object lifecycle"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-constructor">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Constructors & Destructors</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Constructors & Destructors</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Constructors initialize objects when they're created, and
                                        destructors clean up when they're destroyed. These special methods automate
                                        setup and teardown tasks!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-constructor.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-constructor" />
                                    </jsp:include>

                                    <h2>Constructor (__construct)</h2>
                                    <pre><code class="language-php">&lt;?php
class User {
    public $name;
    
    public function __construct($name) {
        $this->name = $name;
        echo "User created: $name\n";
    }
}

$user = new User("Alice");  // Constructor called automatically
?&gt;</code></pre>

                                    <h2>Destructor (__destruct)</h2>
                                    <pre><code class="language-php">&lt;?php
class User {
    public function __destruct() {
        echo "User destroyed\n";
    }
}
// Destructor called when script ends or object is unset
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>__construct:</strong> Called when object created</li>
                                            <li><strong>__destruct:</strong> Called when object destroyed</li>
                                            <li><strong>Automatic:</strong> No manual calling needed</li>
                                            <li><strong>Use case:</strong> Initialize properties, cleanup resources</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Access Modifiers</strong> - controlling visibility with
                                        public, protected, and private!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-classes.jsp" />
                                    <jsp:param name="prevTitle" value="Classes & Objects" />
                                    <jsp:param name="nextLink" value="oop-access-modifiers.jsp" />
                                    <jsp:param name="nextTitle" value="Access Modifiers" />
                                    <jsp:param name="currentLessonId" value="oop-constructor" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>