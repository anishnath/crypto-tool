<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-brace-expansion"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Brace Expansion - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Use brace expansion to generate sequences, lists, and templated names in Bash.">
  <meta name="keywords" content="bash brace expansion, {1..10}, {a..z}, filename templating">
  <meta property="og:type" content="article"><meta property="og:title" content="Brace Expansion - Bash Tutorial | 8gwifi.org"><meta property="og:description" content="Create sequences and lists with brace expansion."><meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-brace-expansion.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: Brace Expansion","description":"Generate sequences and templated names with brace expansion.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["{1..n}","lists","zero-padding"],"timeRequired":"PT15M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-brace-expansion">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Brace Expansion</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Brace Expansion</h1><div class="lesson-meta"><span>Advanced</span><span>~15 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Brace expansion builds lists before command execution, useful for ranges, permutations, and templated names.</p>
        <h2>Examples</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-brace-expansion.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-brace" /><jsp:param name="filename" value="advanced-brace-expansion.sh" /></jsp:include>
        <div class="info-box"><strong>Note:</strong> Expansion happens in the shell, not by external commands.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use zero-padded ranges like <code>{01..12}</code> to align filenames.</div>
        <div class="warning-box"><strong>Caution:</strong> Globbing may expand further; quote paths to avoid unintended matches.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Expecting runtime evaluation</h4><p>Brace expansion is purely syntactic; it does not evaluate variables inside braces.</p></div>
        <div class="mistake-box"><h4>2) Missing braces</h4><p>Use braces, not parentheses, and separate list items with commas.</p></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Month Files</h2>
        <div class="exercise-section"><p><strong>Task:</strong> Echo the sequence <code>report_01.txt</code> to <code>report_12.txt</code> using brace expansion.</p>
          <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/exercises/ex-advanced-brace-expansion.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="exercise-advanced-brace" /><jsp:param name="filename" value="ex-advanced-brace-expansion.sh" /></jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">echo report_{01..12}.txt</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Generate ranges and lists with braces.</li><li>Use zero-padding for aligned names.</li><li>Quote to control globbing.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Unlock powerful string operations via <a href="advanced-parameter-expansion.jsp">Advanced Parameter Expansion</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="advanced-debugging.jsp" /><jsp:param name="prevTitle" value="Debugging" /><jsp:param name="nextLink" value="advanced-parameter-expansion.jsp" /><jsp:param name="nextTitle" value="Parameter Expansion Advanced" /><jsp:param name="currentLessonId" value="advanced-brace-expansion" /></jsp:include>
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

