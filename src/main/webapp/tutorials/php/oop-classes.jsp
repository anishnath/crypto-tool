<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-classes" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Classes & Objects - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn PHP classes and objects. Master OOP basics, properties, methods, and object instantiation.">
            <meta name="keywords" content="php classes, php objects, php oop, php class definition">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-classes.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Classes and Objects","description":"Learn PHP OOP fundamentals","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP classes","PHP objects","OOP basics","Properties and methods"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-classes">
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
                                    <span>Classes & Objects</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Classes & Objects</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Object-Oriented Programming (OOP) lets you organize code into
                                        reusable, maintainable structures. Classes are blueprints, and objects are
                                        instances created from those blueprints!</p>

                                    <h2>What is a Class?</h2>
                                    <p>A <strong>class</strong> is a template that defines properties (data) and methods
                                        (functions) that objects will have.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-oop-classes.svg"
                                        alt="PHP Classes and Objects - Blueprint vs Instance" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-classes.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-classes" />
                                    </jsp:include>

                                    <h2>Defining a Class</h2>
                                    <pre><code class="language-php">&lt;?php
class Car {
    // Properties
    public $brand;
    public $color;
    
    // Method
    public function drive() {
        echo "Driving!";
    }
}
?&gt;</code></pre>

                                    <h2>Creating Objects</h2>
                                    <pre><code class="language-php">&lt;?php
$myCar = new Car();
$myCar->brand = "Toyota";
$myCar->color = "red";
$myCar->drive();
?&gt;</code></pre>

                                    <h2>$this Keyword</h2>
                                    <pre><code class="language-php">&lt;?php
class Car {
    public $brand;
    
    public function showBrand() {
        echo $this->brand;  // Access own property
    }
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Class:</strong> Blueprint/template</li>
                                            <li><strong>Object:</strong> Instance of a class</li>
                                            <li><strong>Properties:</strong> Variables in a class</li>
                                            <li><strong>Methods:</strong> Functions in a class</li>
                                            <li><strong>$this:</strong> Refers to current object</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Constructors & Destructors</strong> - special methods
                                        for object initialization and cleanup!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="arrays-sorting.jsp" />
                                    <jsp:param name="prevTitle" value="Array Sorting" />
                                    <jsp:param name="nextLink" value="oop-constructor.jsp" />
                                    <jsp:param name="nextTitle" value="Constructors & Destructors" />
                                    <jsp:param name="currentLessonId" value="oop-classes" />
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