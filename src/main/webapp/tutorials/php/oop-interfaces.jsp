<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-interfaces" ); request.setAttribute("currentModule", "OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Interfaces - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP interfaces with implements keyword. Learn contracts, multiple interfaces, and interface-based programming.">
            <meta name="keywords"
                content="php interface, php implements, php multiple interfaces, php interface programming">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/oop-interfaces.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Interfaces","description":"Learn PHP interfaces and implements keyword","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP interfaces","implements keyword","Multiple interfaces","Interface contracts"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="oop-interfaces">
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
                                    <span>Interfaces</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Interfaces</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Interfaces define contracts that classes must follow. Unlike
                                        abstract classes, a class can implement multiple interfaces - perfect for
                                        defining capabilities!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/oop-interfaces.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-interfaces" />
                                    </jsp:include>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-oop-interfaces.svg"
                                        alt="PHP Interfaces - Contract and Implementation" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Defining an Interface</h2>
                                    <pre><code class="language-php">&lt;?php
interface PaymentInterface {
    public function processPayment($amount);
    public function refund($transactionId);
}
?&gt;</code></pre>

                                    <h2>Implementing an Interface</h2>
                                    <pre><code class="language-php">&lt;?php
class CreditCardPayment implements PaymentInterface {
    public function processPayment($amount) {
        echo "Processing $$amount";
    }
    
    public function refund($transactionId) {
        echo "Refunding $transactionId";
    }
}
?&gt;</code></pre>

                                    <h2>Multiple Interfaces</h2>
                                    <pre><code class="language-php">&lt;?php
class Payment implements PaymentInterface, Loggable {
    // Must implement all methods from both interfaces
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-oop-access-modifiers.svg"
                                        alt="PHP Access Modifiers - public, protected, private" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Three Access Levels</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>interface:</strong> Contract definition</li>
                                            <li><strong>implements:</strong> Follow the contract</li>
                                            <li><strong>Multiple:</strong> Can implement many interfaces</li>
                                            <li><strong>All public:</strong> Interface methods are always public</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Traits</strong> - horizontal code reuse without
                                        inheritance!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-abstract.jsp" />
                                    <jsp:param name="prevTitle" value="Abstract Classes" />
                                    <jsp:param name="nextLink" value="oop-traits.jsp" />
                                    <jsp:param name="nextTitle" value="Traits" />
                                    <jsp:param name="currentLessonId" value="oop-interfaces" />
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