<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "testing-deployment" );
        request.setAttribute("currentModule", "Professional" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Testing & Deployment - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP testing and deployment. Learn PHPUnit, unit testing, production deployment, and best practices.">
            <meta name="keywords" content="php testing, php phpunit, php deployment, php unit testing, php production">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/testing-deployment.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Testing and Deployment","description":"Learn PHP testing and deployment practices","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["PHPUnit","Unit testing","Deployment","Production practices"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="testing-deployment">
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
                                    <span>Testing & Deployment</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Testing & Deployment</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Testing ensures code quality, and proper deployment keeps your
                                        application secure and performant. Learn professional practices for
                                        production-ready PHP!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/testing-deployment.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-testing" />
                                    </jsp:include>

                                    <h2>PHPUnit Testing</h2>
                                    <pre><code class="language-bash">composer require --dev phpunit/phpunit</code></pre>

                                    <pre><code class="language-php">&lt;?php
use PHPUnit\Framework\TestCase;

class UserTest extends TestCase {
    public function testUserCreation() {
        $user = new User('John');
        $this->assertEquals('John', $user->name);
    }
}
?&gt;</code></pre>

                                    <h2>Run Tests</h2>
                                    <pre><code class="language-bash">./vendor/bin/phpunit tests</code></pre>

                                    <h2>Deployment Checklist</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>✅ Disable error display</strong> (error_reporting(0))</li>
                                            <li><strong>✅ Enable OPcache</strong> for performance</li>
                                            <li><strong>✅ Use HTTPS</strong> for secure connections</li>
                                            <li><strong>✅ Set secure session cookies</strong></li>
                                            <li><strong>✅ Enable error logging</strong></li>
                                            <li><strong>✅ Use environment variables</strong> for secrets</li>
                                            <li><strong>✅ Optimize database</strong> queries and indexes</li>
                                            <li><strong>✅ Set up automated backups</strong></li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>PHPUnit:</strong> Unit testing framework</li>
                                            <li><strong>Tests:</strong> Ensure code quality</li>
                                            <li><strong>Production:</strong> Disable errors, enable logging</li>
                                            <li><strong>Performance:</strong> OPcache, optimization</li>
                                        </ul>
                                    </div>

                                    <h2>Congratulations!</h2>
                                    <p><strong>You've completed the PHP tutorial!</strong> You now have comprehensive
                                        knowledge from basics to professional practices. You're ready to build
                                        production-ready PHP applications!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="composer-packages.jsp" />
                                    <jsp:param name="prevTitle" value="Composer & Packages" />
                                    <jsp:param name="nextLink" value="" />
                                    <jsp:param name="nextTitle" value="" />
                                    <jsp:param name="currentLessonId" value="testing-deployment" />
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