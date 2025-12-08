<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-regex"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Regular Expressions - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Use regular expressions with grep and sed for searching, extraction, and redaction.">
  <meta name="keywords" content="bash regex, grep -E, sed -E, regex extraction, regex substitution">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Regular Expressions - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Regex in Bash with grep -E and sed -E patterns.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-regex.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: Regular Expressions","description":"Search, extract, and substitute text using grep and sed with EREs.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["grep -E","sed -E","capture groups","address ranges"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-regex">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Regular Expressions</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Regular Expressions</h1><div class="lesson-meta"><span>Advanced</span><span>~30 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Master regex with <code>grep -E</code> and <code>sed -E</code> to search, extract, and transform text streams efficiently.</p>
        <h2>grep -E and sed -E</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-regex.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-regex" /><jsp:param name="filename" value="advanced-regex.sh" /></jsp:include>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-grep.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-grep" /><jsp:param name="filename" value="advanced-grep.sh" /></jsp:include>
        <div class="info-box"><strong>Note:</strong> <code>grep -E</code> enables EREs; <code>grep -P</code> (PCRE) may not be available everywhere.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use <code>-o</code> to extract only matches and <code>-n</code> to show line numbers.</div>
        <div class="warning-box"><strong>Caution:</strong> Some shells alias <code>grep</code>; prefer explicit flags (<code>-E</code>, <code>-F</code>) for clarity.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Forgetting to escape backslashes</h4><pre><code class="language-bash"># Wrong (\d is not ERE)
grep -E '\\d+' file
# Correct (use [0-9] or -P if available)
grep -E '[0-9]+' file</code></pre></div>
        <div class="mistake-box"><h4>2) Greedy patterns in sed</h4><pre><code class="language-bash"># Over-matching
echo 'a[b]c[d]e' | sed -E 's/\[[^]]*\]/X/g'</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Mask Emails</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Read lines from stdin and replace the username of emails with <code>***</code>, keeping the domain.</p>
          <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/exercises/ex-advanced-regex.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="exercise-advanced-regex" /><jsp:param name="filename" value="ex-advanced-regex.sh" /></jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">sed -E 's/[A-Za-z0-9._%+-]+@/***@/g'</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use <code>-E</code> for ERE patterns.</li><li>Extract with <code>-o</code> and transform with <code>sed -E</code>.</li><li>Escape carefully; prefer character classes.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Edit streams powerfully with <a href="advanced-sed.jsp">sed</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="files-directories.jsp" /><jsp:param name="prevTitle" value="Working with Directories" /><jsp:param name="nextLink" value="advanced-sed.jsp" /><jsp:param name="nextTitle" value="sed (Stream Editor)" /><jsp:param name="currentLessonId" value="advanced-regex" /></jsp:include>
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

