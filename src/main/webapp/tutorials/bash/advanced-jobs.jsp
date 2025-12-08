<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "advanced-jobs"); request.setAttribute("currentModule", "Advanced Topics" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Background Jobs - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Run tasks in the background with &, check jobs, wait for completion, and manage long-running processes.">
  <meta name="keywords" content="bash background jobs, &, jobs, wait, nohup, disown">
  <meta property="og:type" content="article"><meta property="og:title" content="Background Jobs - Bash Tutorial | 8gwifi.org"><meta property="og:description" content="Use job control primitives in Bash for concurrency."><meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/advanced-jobs.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Bash Advanced: Background Jobs","description":"Run tasks in the background and wait for completion.","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["&","jobs","wait","pid"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}</script>
  <%@ include file="../tutorial-ads.jsp" %><%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="advanced-jobs">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Background Jobs</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Background Jobs</h1><div class="lesson-meta"><span>Advanced</span><span>~25 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Run tasks concurrently with <code>&amp;</code>, track PIDs, and wait for completion. In non-interactive shells, prefer <code>wait</code> over interactive <code>fg/bg</code>.</p>
        <h2>Starting and Waiting</h2>
        <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/advanced-jobs.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="compiler-advanced-jobs" /><jsp:param name="filename" value="advanced-jobs.sh" /></jsp:include>
        <div class="info-box"><strong>Note:</strong> <code>$!</code> expands to the PID of the most recent background command.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use descriptive logging including job IDs and timestamps.</div>
        <div class="warning-box"><strong>Caution:</strong> <code>fg/bg</code> require interactive job control; they are not available in many non-interactive environments.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Losing track of PIDs</h4><p>Store PIDs immediately after launching background tasks.</p></div>
        <div class="mistake-box"><h4>2) Not handling failures</h4><p>Check <code>$?</code> after <code>wait</code> to detect job errors.</p></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Parallel Sleeps</h2>
        <div class="exercise-section"><p><strong>Task:</strong> Start two <code>sleep</code> commands in the background and wait for both to complete.</p>
          <jsp:include page="../tutorial-compiler.jsp"><jsp:param name="codeFile" value="bash/exercises/ex-advanced-jobs.sh" /><jsp:param name="language" value="bash" /><jsp:param name="editorId" value="exercise-advanced-jobs" /><jsp:param name="filename" value="ex-advanced-jobs.sh" /></jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">sleep 1 & pid1=$!; sleep 2 & pid2=$!; wait "$pid1" "$pid2"</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Launch with <code>&amp;</code>, capture <code>$!</code>.</li><li>Use <code>wait</code> to synchronize.</li><li>Be cautious with interactive job control in scripts.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Diagnose issues and trace execution in <a href="advanced-debugging.jsp">Debugging</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="processes-basics.jsp" /><jsp:param name="prevTitle" value="Process Basics" /><jsp:param name="nextLink" value="advanced-debugging.jsp" /><jsp:param name="nextTitle" value="Debugging" /><jsp:param name="currentLessonId" value="advanced-jobs" /></jsp:include>
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

