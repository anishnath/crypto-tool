<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-magic-methods" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Magic Methods - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP magic methods: __get, __set, __toString, __call, __isset, __unset. Learn dynamic object behavior.">
            <meta name="keywords"
                content="php magic methods, php __get, php __set, php __toString, php __call, php dynamic methods">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-magic-methods.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Magic Methods","description":"Learn PHP magic methods for dynamic behavior","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["Magic methods","__get","__set","__toString","__call"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-magic-methods">
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
                                    <span>Magic Methods</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Magic Methods</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Magic methods are special methods that PHP calls automatically in
                                        specific situations. They start with __ (double underscore) and enable powerful
                                        dynamic behavior!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-magic-methods.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-magic" />
                                    </jsp:include>

                                    <h2>Common Magic Methods</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Called When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>__get($name)</code></td>
                                                <td>Accessing inaccessible property</td>
                                            </tr>
                                            <tr>
                                                <td><code>__set($name, $value)</code></td>
                                                <td>Setting inaccessible property</td>
                                            </tr>
                                            <tr>
                                                <td><code>__toString()</code></td>
                                                <td>Object used as string</td>
                                            </tr>
                                            <tr>
                                                <td><code>__call($name, $args)</code></td>
                                                <td>Calling inaccessible method</td>
                                            </tr>
                                            <tr>
                                                <td><code>__isset($name)</code></td>
                                                <td>isset() on inaccessible property</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>__get and __set</h2>
                                    <pre><code class="language-php">&lt;?php
class Magic {
    private $data = [];
    
    public function __get($name) {
        return $this->data[$name] ?? null;
    }
    
    public function __set($name, $value) {
        $this->data[$name] = $value;
    }
}

$obj = new Magic();
$obj->name = "John";  // Calls __set
echo $obj->name;      // Calls __get
?&gt;</code></pre>

                                    <h2>__toString</h2>
                                    <pre><code class="language-php">&lt;?php
class User {
    public function __toString() {
        return "User object";
    }
}

$user = new User();
echo $user;  // "User object"
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Magic methods:</strong> Start with __</li>
                                            <li><strong>Automatic:</strong> PHP calls them</li>
                                            <li><strong>__get/__set:</strong> Dynamic properties</li>
                                            <li><strong>__toString:</strong> String conversion</li>
                                            <li><strong>__call:</strong> Dynamic methods</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 7 (OOP). Next, dive into
                                        <strong>Superglobals & Forms</strong> - handling user input!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-static.jsp" />
                                    <jsp:param name="prevTitle" value="Static Members" />
                                    <jsp:param name="nextLink" value="superglobals-overview.jsp" />
                                    <jsp:param name="nextTitle" value="Superglobals Overview" />
                                    <jsp:param name="currentLessonId" value="oop-magic-methods" />
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