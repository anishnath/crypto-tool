<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentFunction", "hash_hkdf"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP hash_hkdf() - HKDF Key Derivation Online | Example</title>
    <meta name="description" content="PHP hash_hkdf() generates HKDF key derivation of a supplied key input. RFC 5869 compliant. Key expansion. Try online.">
    <meta name="keywords" content="php hash_hkdf, hkdf php, php key derivation, hkdf key expansion, rfc 5869">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/hash_hkdf.jsp">
    <meta property="og:title" content="PHP hash_hkdf() - HKDF Key Derivation"><meta property="og:type" content="article">
    <meta name="twitter:card" content="summary">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.setAttribute('data-theme','dark');})();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"TechArticle","headline":"PHP hash_hkdf() Function","datePublished":"2025-01-01","dateModified":"2025-01-28"}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Tutorials","item":"https://8gwifi.org/tutorials/"},{"@type":"ListItem","position":2,"name":"PHP Functions","item":"https://8gwifi.org/tutorials/php-functions/"},{"@type":"ListItem","position":3,"name":"hash_hkdf()"}]}</script>
    <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="hash_hkdf">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/php-functions/">PHP Functions</a><span class="breadcrumb-separator">/</span><span>hash_hkdf()</span></nav>
                <header class="lesson-header"><h1 class="lesson-title">PHP hash_hkdf() Function</h1><div class="lesson-meta"><span>Hash Function</span><span>PHP 7.1.2+</span></div></header>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
                <div class="lesson-body">
                    <p class="lead">The <code>hash_hkdf()</code> function generates a HKDF key derivation of a supplied key input (RFC 5869).</p>
                    <h2>Syntax</h2>
                    <pre><code class="language-php">hash_hkdf(string $algo, string $key, int $length = 0, string $info = "", string $salt = ""): string</code></pre>
                    <h2>Try It Online</h2>
                    <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="php-functions/hash_hkdf.php" /><jsp:param name="language" value="php" /><jsp:param name="editorId" value="hash-hkdf-demo" /></jsp:include>
                    <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /></jsp:include>
                    <h2>Examples</h2>
                    <pre><code class="language-php">&lt;?php
$inputKey = random_bytes(32);
$derivedKey = hash_hkdf('sha256', $inputKey, 32, 'encryption');
echo bin2hex($derivedKey);
?&gt;</code></pre>
                    <div class="tip-box"><strong>Use Case:</strong> HKDF is used to derive multiple keys from a single master key, e.g., separate encryption and authentication keys.</div>
                    <h2>Related Functions</h2>
                    <ul><li><a href="hash_pbkdf2.jsp">hash_pbkdf2()</a> - Password-based key derivation</li><li><a href="random_bytes.jsp">random_bytes()</a> - Generate random key</li></ul>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
                <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="hash_equals.jsp" /><jsp:param name="prevTitle" value="hash_equals()" /><jsp:param name="nextLink" value="hash_hmac.jsp" /><jsp:param name="nextTitle" value="hash_hmac()" /><jsp:param name="currentLessonId" value="hash_hkdf" /></jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script><script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>
