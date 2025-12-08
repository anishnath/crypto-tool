<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "io-redirection"); request.setAttribute("currentModule", "Input & Output" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Output Redirection - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Redirect stdout and stderr in Bash using >, >>, 2>, and 2>&1. Send logs to stderr and discard noise with /dev/null.">
  <meta name="keywords" content="bash redirection, stdout, stderr, 2>&1, /dev/null, append">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Output Redirection - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Master stdout/stderr redirection, append, and file descriptor merging in Bash.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/io-redirection.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"LearningResource","name":"Bash I/O: Output Redirection","description":"Redirect stdout/stderr with >, >>, 2>, and 2>&1. Use /dev/null and send logs to stderr.","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":[">",">>","2>","2>&1","/dev/null"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}
  </script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="io-redirection">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Output Redirection</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Output Redirection</h1><div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Control where output goes using redirection operators. Separate stdout from stderr, append to files, or discard noise.</p>
        <h2>Stdout and Stderr</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-redirection.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-redirection" />
          <jsp:param name="filename" value="io-redirection.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> <code>1></code> is stdout, <code>2></code> is stderr. <code>2>&1</code> merges stderr into stdout.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Send diagnostic messages to stderr: <code>echo "error" 1>&2</code>.</div>
        <div class="warning-box"><strong>Caution:</strong> Overwriting files with <code>></code> is destructive. Use <code>>></code> to append.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Wrong order for 2>&1</h4><pre><code class="language-bash"># Wrong
cmd 2>&1 > out.txt
# Correct
cmd > out.txt 2>&1</code></pre></div>
        <div class="mistake-box"><h4>2) Accidental truncation</h4><pre><code class="language-bash"># Wrong (overwrites)
echo data > file
# Safer append
echo data >> file</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Split Outputs</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Run a command that writes to both stdout and stderr, saving each to separate files. Then produce a combined file with both.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-io-redirection.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-io-redirection" />
            <jsp:param name="filename" value="ex-io-redirection.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">{ echo out; echo err 1>&2; } 1>out.txt 2>err.txt
{ echo out; echo err 1>&2; } > both.txt 2>&1</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use <code>></code>/<code>>></code> for stdout.</li><li>Use <code>2></code> for stderr.</li><li>Merge with <code>2>&1</code>; discard via <code>/dev/null</code>.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Chain commands to transform data using <a href="io-pipes.jsp">Pipes</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="io-read.jsp" /><jsp:param name="prevTitle" value="Reading Input" /><jsp:param name="nextLink" value="io-pipes.jsp" /><jsp:param name="nextTitle" value="Pipes" /><jsp:param name="currentLessonId" value="io-redirection" /></jsp:include>
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

