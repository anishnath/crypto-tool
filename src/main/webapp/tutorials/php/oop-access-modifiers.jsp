<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-access-modifiers" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Access Modifiers - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP access modifiers: public, protected, and private. Learn encapsulation and visibility control in OOP.">
            <meta name="keywords"
                content="php access modifiers, php public, php protected, php private, php encapsulation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-access-modifiers.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Access Modifiers","description":"Learn PHP access modifiers and encapsulation","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Access modifiers","Encapsulation","Public","Protected","Private"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-access-modifiers">
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
                                    <span>Access Modifiers</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Access Modifiers</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Access modifiers control who can access properties and methods.
                                        They're essential for encapsulation - hiding internal details and exposing only
                                        what's necessary!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-access-modifiers.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-access" />
                                    </jsp:include>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-oop-access-modifiers.svg"
                                        alt="PHP Access Modifiers - public, protected, private" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Three Access Levels</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Modifier</th>
                                                <th>Class</th>
                                                <th>Subclass</th>
                                                <th>Outside</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>public</code></td>
                                                <td>✅</td>
                                                <td>✅</td>
                                                <td>✅</td>
                                            </tr>
                                            <tr>
                                                <td><code>protected</code></td>
                                                <td>✅</td>
                                                <td>✅</td>
                                                <td>❌</td>
                                            </tr>
                                            <tr>
                                                <td><code>private</code></td>
                                                <td>✅</td>
                                                <td>❌</td>
                                                <td>❌</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Public - Accessible Everywhere</h2>
                                    <pre><code class="language-php">&lt;?php
class User {
    public $name;  // Accessible anywhere
}

$user = new User();
$user->name = "Alice";  // OK
?&gt;</code></pre>

                                    <h2>Protected - Class and Subclasses</h2>
                                    <pre><code class="language-php">&lt;?php
class User {
    protected $email;  // Only in class and subclasses
}
// $user->email = "...";  // Error!
?&gt;</code></pre>

                                    <h2>Private - Class Only</h2>
                                    <pre><code class="language-php">&lt;?php
class BankAccount {
    private $pin;  // Only within this class
    
    public function validatePin($pin) {
        return $this->pin === $pin;
    }
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>public:</strong> Accessible everywhere</li>
                                            <li><strong>protected:</strong> Class + subclasses only</li>
                                            <li><strong>private:</strong> Class only</li>
                                            <li><strong>Encapsulation:</strong> Hide internal details</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Inheritance</strong> - reusing code with the extends
                                        keyword!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-constructor.jsp" />
                                    <jsp:param name="prevTitle" value="Constructors & Destructors" />
                                    <jsp:param name="nextLink" value="oop-inheritance.jsp" />
                                    <jsp:param name="nextTitle" value="Inheritance" />
                                    <jsp:param name="currentLessonId" value="oop-access-modifiers" />
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