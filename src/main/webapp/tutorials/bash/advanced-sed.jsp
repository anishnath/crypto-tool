<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-sed"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>sed (Stream Editor) - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Perform substitutions, deletions, insertions, and address-ranged edits with sed.">
  <meta name="keywords" content="sed tutorial, sed -E, address ranges, substitution, deletion, insertion">
  <meta property="og:type" content="article">
  <meta property="og:title" content="sed (Stream Editor) - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Learn practical sed editing patterns.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-sed.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: sed","description":"Use sed for substitution, deletion, insertion, and range selection.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["s///","d","i","address ranges"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-sed">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>sed (Stream Editor)</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">sed (Stream Editor)</h1><div class="lesson-meta"><span>Advanced</span><span>~30 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">The stream editor <code>sed</code> excels at quick, scriptable edits across streams and files.</p>
        <h2>Core Edits</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/advanced-sed.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-advanced-sed" />
          <jsp:param name="filename" value="advanced-sed.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> Use single quotes around sed scripts to avoid shell interpolation.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Combine multiple commands with <code>-e</code> or use a script file for complex edits.</div>
        <div class="warning-box"><strong>Caution:</strong> On macOS, <code>sed -i</code> requires a backup suffix: <code>-i ''</code>.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box">
          <h4>1) Forgetting -n with p</h4>
          <pre><code class="language-bash"># Wrong
sed '2,4p' file
# Correct (suppress default print)
sed -n '2,4p' file</code></pre>
        </div>
        <div class="mistake-box">
          <h4>2) Greedy dot</h4>
          <pre><code class="language-bash"># Over-matching
sed -E 's/<.*>/X/'
# Safer
sed -E 's/<[^>]*>/X/g'</code></pre>
        </div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Delete Comments</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> From stdin, remove lines that are blank or start with <code>#</code>.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-advanced-sed.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-advanced-sed" />
            <jsp:param name="filename" value="ex-advanced-sed.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary>
            <pre><code class="language-bash">sed -E '/^\s*($|#)/d'</code></pre>
          </details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Substitute with <code>s///</code>.</li><li>Delete with <code>d</code>, insert with <code>i</code>.</li><li>Use ranges and regex addresses for precision.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Process structured text with <a href="advanced-awk.jsp">awk</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp">
        <jsp:param name="prevLink" value="advanced-regex.jsp" />
        <jsp:param name="prevTitle" value="Regular Expressions" />
        <jsp:param name="nextLink" value="advanced-awk.jsp" />
        <jsp:param name="nextTitle" value="awk" />
        <jsp:param name="currentLessonId" value="advanced-sed" />
      </jsp:include>
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
