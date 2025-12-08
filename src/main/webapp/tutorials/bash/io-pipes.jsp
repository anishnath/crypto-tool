<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "io-pipes"); request.setAttribute("currentModule", "Input & Output" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Pipes - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Chain commands with pipes in Bash. Filter, transform, and save with grep, awk, sort, uniq, and tee.">
  <meta name="keywords" content="bash pipes, pipeline, tee, grep, awk, sort, uniq">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Pipes - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Use pipelines to process text streams with grep, awk, sort, uniq, and tee.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/io-pipes.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"LearningResource","name":"Bash I/O: Pipes","description":"Chain commands with pipes to filter and transform streams.","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["pipes","grep","awk","sort","uniq","tee"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}
  </script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="io-pipes">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Pipes</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Pipes</h1><div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Pipes connect commands by sending stdout of one as stdin to the next, enabling powerful one-liners for text processing.</p>
        <h2>Common Pipelines</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-pipes.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-pipes" />
          <jsp:param name="filename" value="io-pipes.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> Use <code>tr</code>, <code>sort</code>, <code>uniq -c</code>, and <code>awk</code> to build readable pipelines.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use <code>tee</code> to save intermediate results while continuing the pipeline.</div>
        <div class="warning-box"><strong>Caution:</strong> By default, a pipeline succeeds if the last command succeeds. Consider <code>set -o pipefail</code> for stricter error handling.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Unnecessary Use of cat</h4><pre><code class="language-bash"># Wrong
cat file | grep pattern
# Correct
grep pattern file</code></pre></div>
        <div class="mistake-box"><h4>2) Losing errors in the middle</h4><pre><code class="language-bash"># Without pipefail, early failures may be ignored
set -o pipefail  # enable stricter pipeline status</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Top Words</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Read a line from stdin and output the top 3 most frequent words (case-insensitive) with counts.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-io-pipes.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-io-pipes" />
            <jsp:param name="filename" value="ex-io-pipes.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' |
sort | uniq -c | sort -nr | head -n 3</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use pipes to chain commands.</li><li><code>tee</code> saves output while piping.</li><li>Consider <code>set -o pipefail</code> for reliability.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Create multi-line input blocks with <a href="io-heredoc.jsp">Here Documents</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="io-redirection.jsp" /><jsp:param name="prevTitle" value="Output Redirection" /><jsp:param name="nextLink" value="io-heredoc.jsp" /><jsp:param name="nextTitle" value="Here Documents & Here Strings" /><jsp:param name="currentLessonId" value="io-pipes" /></jsp:include>
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

