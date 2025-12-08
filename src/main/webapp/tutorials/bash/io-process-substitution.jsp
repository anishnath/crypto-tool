<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "io-process-substitution"); request.setAttribute("currentModule", "Input & Output" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Process Substitution - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Use process substitution to treat command output as files with <() and feed data into processes with >().">
  <meta name="keywords" content="bash process substitution, <(), >(), diff process substitution, paste">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Process Substitution - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Avoid temp files by using <() and >() to connect commands.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/io-process-substitution.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"LearningResource","name":"Bash I/O: Process Substitution","description":"Treat command output as files with <() and write into processes with >().","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["<()",">()","diff","paste"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}
  </script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="io-process-substitution">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Process Substitution</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Process Substitution</h1><div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Process substitution lets you pass the output of a command where a filename is expected, and send data into a process without temp files.</p>
        <h2>Reading with <code>&lt;()</code></h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-process-substitution.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-procsub" />
          <jsp:param name="filename" value="io-process-substitution.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> This feature requires Bash (and /proc or named pipes). It may not work in strictly POSIX shells.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use with <code>diff</code>, <code>comm</code>, <code>paste</code>, and any tool expecting file paths.</div>
        <div class="warning-box"><strong>Caution:</strong> Some tools might fully read inputs before processing, which can affect memory usage.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Using in POSIX sh</h4><pre><code class="language-bash"># Wrong
/bin/sh -c 'diff <(echo a) <(echo b)'
# Correct
bash -c 'diff <(echo a) <(echo b)'</code></pre></div>
        <div class="mistake-box"><h4>2) Forgetting quotes around paths</h4><pre><code class="language-bash"># Always quote variables holding paths
diff "$(some_cmd_generating_path)" file</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Compare Sorted Lists</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Create two lists in variables and show a <code>diff</code> of their sorted forms using process substitution.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-io-process-substitution.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-io-procsub" />
            <jsp:param name="filename" value="ex-io-process-substitution.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">a=$'c\na\nb'
b=$'b\nc\nd'
diff <(printf '%s\n' "$a" | sort) <(printf '%s\n' "$b" | sort)</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use <code>&lt;()</code> to pass command output where a file is needed.</li><li>Use <code>&gt;()</code> to feed a process like it was a file.</li><li>Avoid temp files and simplify complex chains.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Move on to file handling in <a href="files-reading.jsp">File Reading</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="io-heredoc.jsp" /><jsp:param name="prevTitle" value="Here Documents & Here Strings" /><jsp:param name="nextLink" value="files-reading.jsp" /><jsp:param name="nextTitle" value="File Reading" /><jsp:param name="currentLessonId" value="io-process-substitution" /></jsp:include>
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

