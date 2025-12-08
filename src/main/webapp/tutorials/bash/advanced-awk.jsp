<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-awk"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>awk - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Process structured text with awk: fields, filters, built-in variables, and BEGIN/END blocks.">
  <meta name="keywords" content="awk tutorial, awk fields, awk NR NF, awk BEGIN END, awk arrays">
  <meta property="og:type" content="article">
  <meta property="og:title" content="awk - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Learn awk basics and advanced patterns for text processing.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-awk.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: awk","description":"Use awk for field-based processing, filters, and reports.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["fields","filters","NR/NF","BEGIN/END"],"timeRequired":"PT35M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-awk">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>awk</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">awk</h1><div class="lesson-meta"><span>Advanced</span><span>~35 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">awk is a small language for scanning and processing text with fields and patterns. It shines at CSV/TSV and report generation.</p>
        <h2>Basics: Fields and Filters</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-awk.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-awk" /><jsp:param name="filename" value="advanced-awk.sh" /></jsp:include>
        <h2>Advanced: BEGIN/END and Arrays</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-awk-advanced.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-awk-advanced" /><jsp:param name="filename" value="advanced-awk-advanced.sh" /></jsp:include>
        <div class="info-box"><strong>Note:</strong> Set the field separator with <code>-F</code> or inside a BEGIN block.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use printf for aligned columns and reports.</div>
        <div class="warning-box"><strong>Caution:</strong> Beware of CSV corner cases (quoted commas). Consider dedicated CSV tools when needed.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Forgetting NR>1 to skip headers</h4><p>When processing CSV with headers, include a condition to skip the first line.</p></div>
        <div class="mistake-box"><h4>2) Mixing separators</h4><p>Ensure the field separator matches your data (e.g., comma vs tab).</p></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Average by City</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> From <code>name,age,city</code> CSV on stdin, print the average age per city.</p>
          <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/exercises/ex-advanced-awk.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="exercise-advanced-awk" /><jsp:param name="filename" value="ex-advanced-awk.sh" /></jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">awk -F, 'NR>1 { sum[$3]+=$2; count[$3]++ } END{ for(c in sum) printf "%s %.2f\n", c, sum[c]/count[c] }'</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Split with <code>-F</code> and access fields via <code>$1..$n</code>.</li><li>Use conditions and actions per line.</li><li>Aggregate in <code>END</code> with arrays.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Handle OS signals and graceful cleanup with <a href="advanced-signals.jsp">Signal Handling</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="advanced-sed.jsp" /><jsp:param name="prevTitle" value="sed (Stream Editor)" /><jsp:param name="nextLink" value="advanced-signals.jsp" /><jsp:param name="nextTitle" value="Signal Handling" /><jsp:param name="currentLessonId" value="advanced-awk" /></jsp:include>
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

