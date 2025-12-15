<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "composer-packages" ); request.setAttribute("currentModule", "Professional"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Composer & Packages - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP Composer. Learn dependency management, autoloading, PSR-4, and package installation.">
            <meta name="keywords"
                content="php composer, php packages, php autoloading, php psr-4, php dependency management">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/composer-packages.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Composer and Packages","description":"Learn PHP Composer and package management","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["Composer","Package management","Autoloading","PSR-4"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="composer-packages">
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
                                    <span>Composer & Packages</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Composer & Packages</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Composer is PHP's dependency manager - the modern way to manage
                                        packages and autoload classes. Essential for professional PHP development!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/composer-packages.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-composer" />
                                    </jsp:include>

                                    <h2>Install Composer</h2>
                                    <pre><code class="language-bash">curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer</code></pre>

                                    <h2>composer.json</h2>
                                    <pre><code class="language-json">{
    "require": {
        "monolog/monolog": "^2.0",
        "guzzlehttp/guzzle": "^7.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}</code></pre>

                                    <h2>Install Packages</h2>
                                    <pre><code class="language-bash">composer install
composer update</code></pre>

                                    <h2>Use Autoloader</h2>
                                    <pre><code class="language-php">&lt;?php
require 'vendor/autoload.php';

use Monolog\Logger;
use App\User;

$log = new Logger('app');
$user = new User('John');
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Composer:</strong> Dependency manager</li>
                                            <li><strong>composer.json:</strong> Define dependencies</li>
                                            <li><strong>PSR-4:</strong> Autoloading standard</li>
                                            <li><strong>vendor/autoload.php:</strong> Auto-include classes</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, learn about <strong>Testing & Deployment</strong> - professional
                                        development practices!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="security-practices.jsp" />
                                    <jsp:param name="prevTitle" value="Security Best Practices" />
                                    <jsp:param name="nextLink" value="testing-deployment.jsp" />
                                    <jsp:param name="nextTitle" value="Testing & Deployment" />
                                    <jsp:param name="currentLessonId" value="composer-packages" />
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