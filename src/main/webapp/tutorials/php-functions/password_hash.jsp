<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "password_hash"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP password_hash() - Secure Password Hashing Online | Bcrypt Argon2</title>
    <meta name="description" content="PHP password_hash() creates secure password hash using bcrypt or Argon2. Best practice for storing passwords. Try online.">
    <meta name="keywords" content="php password_hash, password_hash php, php bcrypt, php argon2, secure password hashing">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/password_hash.jsp">
    <meta property="og:title" content="PHP password_hash() - Secure Password Hashing"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP password_hash() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"Which algorithm should I use for password_hash?","acceptedAnswer":{"@type":"Answer","text":"Use PASSWORD_DEFAULT (currently bcrypt) for most cases, or PASSWORD_ARGON2ID for maximum security if your PHP version supports it."}}]}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"password_hash()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="password_hash">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>password_hash()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP password_hash() Function</h1><div class="lesson-meta"><span>Password Function</span><span>PHP 5.5.0+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>password_hash()</code> function creates a secure password hash using bcrypt or Argon2.</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">password_hash(string $password, string|int|null $algo, array $options = []): string</code></pre>
                    <h2>Algorithms</h2>
                    <p><code>PASSWORD_DEFAULT</code> (bcrypt), <code>PASSWORD_BCRYPT</code>, <code>PASSWORD_ARGON2I</code>, <code>PASSWORD_ARGON2ID</code></p>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/password_hash.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="password-hash-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
$password = "user_password";
$hash = password_hash($password, PASSWORD_DEFAULT);
// Store $hash in database
?&gt;</code></pre>
                    <div class="tip-box"><strong>Best Practice:</strong> Always use password_hash() for storing passwords. Never use MD5 or SHA-1 for passwords.</div>
                    <h2>Related Functions</h2>
                    <ul><li><a href="password_verify.jsp">password_verify()</a> - Verify password</li><li><a href="password_needs_rehash.jsp">password_needs_rehash()</a> - Check if rehash needed</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="random_int.jsp" /><jsp:param name="prevTitle" value="random_int()" /><jsp:param name="nextLink" value="password_verify.jsp" /><jsp:param name="nextTitle" value="password_verify()" /><jsp:param name="currentLessonId" value="password_hash" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
