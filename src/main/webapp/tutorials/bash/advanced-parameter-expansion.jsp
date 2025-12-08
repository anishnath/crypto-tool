<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-parameter-expansion"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Parameter Expansion (Advanced) - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Slice strings, trim patterns, and perform advanced substitutions with Bash parameter expansion.">
  <meta name="keywords" content="bash parameter expansion, slicing, trimming, pattern removal, substitution">
  <meta property="og:type" content="article"><meta property="og:title" content="Parameter Expansion (Advanced) - Bash Tutorial | 8gwifi.org"><meta property="og:description" content="Advanced string operations using parameter expansion."><meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-parameter-expansion.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: Parameter Expansion","description":"Slice, trim, and substitute strings using advanced parameter expansion.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["\\${var:offset}","\\${var#pat}","\\${var%%pat}","\\${var//old/new}"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-parameter-expansion">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator"></span><span>Parameter Expansion (Advanced)</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Parameter Expansion (Advanced)</h1><div class="lesson-meta"><span>Advanced</span><span>~30 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Perform powerful string manipulations using slicing, pattern trimming, and substitutions all within the shell.</p>
        <h2>Slicing and Trimming</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-parameter-expansion.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-paramexp" /><jsp:param name="filename" value="advanced-parameter-expansion.sh" /></jsp:include>
        <div class="info-box"><strong>Note:</strong> These expansions are POSIX/Bash features; exact behavior can vary by shell.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use braces around variables (e.g., <code>\${name}</code>) when concatenating to avoid ambiguity.</div>
        <div class="warning-box"><strong>Caution:</strong> Pattern matching uses globs, not full regex. Use character classes and <code>*</code>, <code>?</code> patterns.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Expecting regex</h4><p>Parameter expansion patterns are glob-like, not regular expressions.</p></div>
        <div class="mistake-box"><h4>2) Off-by-one slices</h4><p>Remember slicing is zero-based: <code>\${s:0:1}</code> is the first character.</p></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Filename Parts</h2>
        <div class="exercise-section"><p><strong>Task:</strong> Given <code>path=/var/log/nginx/access.log</code>, echo the directory and the basename without extension using parameter expansion only.</p>
          <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/exercises/ex-advanced-parameter-expansion.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="exercise-advanced-paramexp" /><jsp:param name="filename" value="ex-advanced-parameter-expansion.sh" /></jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">echo "\${path%/*}"; base="\${path##*/}"; echo "\${base%.*}"</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Slice with <code>\${var:off:len}</code>.</li><li>Trim with <code>#</code>/<code>##</code>, <code>%</code>/<code>%%</code>.</li><li>Substitute with <code>\${var/old/new}</code> and <code>\${var//old/new}</code>.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Wrap up with best practices in <a href="practices-best-practices.jsp">Professional Practices</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="advanced-brace-expansion.jsp" /><jsp:param name="prevTitle" value="Brace Expansion" /><jsp:param name="nextLink" value="practices-best-practices.jsp" /><jsp:param name="nextTitle" value="Best Practices" /><jsp:param name="currentLessonId" value="advanced-parameter-expansion" /></jsp:include>
    </article>
  </main>
  <%@ include file="../tutorial-footer.jsp" %>
</div>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>
</html>

