<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-inheritance" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Inheritance - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP inheritance with extends keyword. Learn parent classes, child classes, method overriding, and parent:: keyword.">
            <meta name="keywords"
                content="php inheritance, php extends, php parent, php method overriding, php oop inheritance">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-inheritance.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Inheritance","description":"Learn PHP class inheritance","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP inheritance","extends keyword","Method overriding","parent keyword"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-inheritance">
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
                                    <span>Inheritance</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Inheritance</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Inheritance lets child classes reuse code from parent classes. It's
                                        perfect for creating specialized versions of existing classes without
                                        duplicating code!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-inheritance.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-inheritance" />
                                    </jsp:include>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-oop-inheritance.svg"
                                        alt="PHP Inheritance - Parent to Child Class Relationship" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Basic Inheritance</h2>
                                    <pre><code class="language-php">&lt;?php
class Animal {
    public function makeSound() {
        echo "Some sound";
    }
}

class Dog extends Animal {
    // Inherits makeSound()
}

$dog = new Dog();
$dog->makeSound();  // Works!
?&gt;</code></pre>

                                    <h2>Method Overriding</h2>
                                    <pre><code class="language-php">&lt;?php
class Dog extends Animal {
    public function makeSound() {
        echo "Woof!";  // Override parent method
    }
}
?&gt;</code></pre>

                                    <h2>Calling Parent Methods</h2>
                                    <pre><code class="language-php">&lt;?php
class Dog extends Animal {
    public function makeSound() {
        parent::makeSound();  // Call parent version
        echo " and Woof!";
    }
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>extends:</strong> Create child class</li>
                                            <li><strong>Inherit:</strong> Get parent's properties/methods</li>
                                            <li><strong>Override:</strong> Replace parent method</li>
                                            <li><strong>parent::</strong> Call parent method</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Abstract Classes</strong> - blueprints that can't be
                                        instantiated!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-access-modifiers.jsp" />
                                    <jsp:param name="prevTitle" value="Access Modifiers" />
                                    <jsp:param name="nextLink" value="oop-abstract.jsp" />
                                    <jsp:param name="nextTitle" value="Abstract Classes" />
                                    <jsp:param name="currentLessonId" value="oop-inheritance" />
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