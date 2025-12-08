<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "io-read"); request.setAttribute("currentModule", "Input & Output" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Reading Input - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Read input in Bash with read, prompts, arrays, hidden input, and line-by-line file reading with IFS and -r.">
  <meta name="keywords" content="bash read, bash input, read -r, IFS, read -a, bash read file lines">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Reading Input - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Interactive input in Bash with read, prompts, arrays, and file reading.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/io-read.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"LearningResource","name":"Bash I/O: Reading Input","description":"Use read, prompts, IFS, -r, arrays, and mapfile to read input in Bash.","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["read","IFS","-r","-a","mapfile"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}
  </script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="io-read">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Reading Input</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Reading Input</h1><div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Read interactive input and files using <code>read</code>, handle spaces safely with <code>-r</code> and <code>IFS</code>, and collect words into arrays.</p>
        <h2>read Basics</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-read.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-read" />
          <jsp:param name="filename" value="io-read.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> Use <code>-r</code> to prevent backslash escapes, and always quote variables when echoing user input.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Set <code>IFS=,</code> (or another delimiter) temporarily for CSV-style parsing.</div>
        <div class="warning-box"><strong>Caution:</strong> <code>read</code> without <code>-r</code> may treat backslashes specially and surprise you.</div>
        <h2>Advanced Reads</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-read-advanced.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-read-advanced" />
          <jsp:param name="filename" value="io-read-advanced.sh" />
        </jsp:include>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Unquoted variables</h4><pre><code class="language-bash"># Wrong
echo $name
# Correct
echo "$name"</code></pre></div>
        <div class="mistake-box"><h4>2) Forgetting -r</h4><pre><code class="language-bash"># Wrong
read line   # backslashes get consumed
# Correct
read -r line</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Parse CSV</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Read a <code>name,age,city</code> line and echo fields on separate lines.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-io-read.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-io-read" />
            <jsp:param name="filename" value="ex-io-read.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">IFS=, read -r name age city
printf '%s\n' "$name" "$age" "$city"</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use <code>read -r</code> to read lines safely.</li><li>Temporarily set <code>IFS</code> to split on custom delimiters.</li><li>Loop with <code>while IFS= read -r</code> for files.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Redirect outputs and manage file descriptors in <a href="io-redirection.jsp">Output Redirection</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="functions-recursive.jsp" /><jsp:param name="prevTitle" value="Recursive Functions" /><jsp:param name="nextLink" value="io-redirection.jsp" /><jsp:param name="nextTitle" value="Output Redirection" /><jsp:param name="currentLessonId" value="io-read" /></jsp:include>
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

