<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "io-heredoc"); request.setAttribute("currentModule", "Input & Output" ); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Here Documents & Here Strings - Bash Tutorial | 8gwifi.org</title>
  <meta name="description" content="Create multi-line input with here documents and pass short strings via here strings in Bash.">
  <meta name="keywords" content="bash heredoc, here document, here string, <<, <<<, quoted delimiter">
  <meta property="og:type" content="article">
  <meta property="og:title" content="Here Documents & Here Strings - Bash Tutorial | 8gwifi.org">
  <meta property="og:description" content="Use <<, <<- and <<< to pass multi-line and inline data to commands.">
  <meta property="og:site_name" content="8gwifi.org Tutorials">
  <link rel="canonical" href="https://8gwifi.org/tutorials/bash/io-heredoc.jsp">
  <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
  <script>(function(){var t=localStorage.getItem('tutorial-theme');if(t==='dark'||(!t&&window.matchMedia('(prefers-color-scheme: dark)').matches)){document.documentElement.setAttribute('data-theme','dark');}})();</script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"LearningResource","name":"Bash I/O: Here Documents & Here Strings","description":"Create multi-line input blocks and inline strings for commands using heredocs and here strings.","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["heredoc","here string","quoted delimiter","<<-"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"Bash Tutorial","url":"https://8gwifi.org/tutorials/bash/"}}
  </script>
  <%@ include file="../tutorial-ads.jsp" %>
  <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="io-heredoc">
<div class="tutorial-layout">
  <%@ include file="../tutorial-header.jsp" %>
  <main class="tutorial-main">
    <%@ include file="../tutorial-sidebar-bash.jsp" %>
    <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
    <article class="tutorial-content">
      <nav class="breadcrumb"><a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span class="breadcrumb-separator">/</span><a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a><span class="breadcrumb-separator">/</span><span>Here Documents & Here Strings</span></nav>
      <header class="lesson-header"><h1 class="lesson-title">Here Documents & Here Strings</h1><div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div></header>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>
      <div class="lesson-body">
        <p class="lead">Use heredocs for multi-line input blocks and here strings for quick one-liners.</p>
        <h2>Heredoc Variants</h2>
        <jsp:include page="../tutorial-compiler.jsp">
          <jsp:param name="codeFile" value="bash/io-heredoc.sh" />
          <jsp:param name="language" value="bash" />
          <jsp:param name="editorId" value="compiler-io-heredoc" />
          <jsp:param name="filename" value="io-heredoc.sh" />
        </jsp:include>
        <div class="info-box"><strong>Note:</strong> Quote the delimiter (<code><<'EOF'</code>) to disable variable and command expansion.</div>
        <div class="tip-box"><strong>Pro Tip:</strong> Use <code><<-</code> to strip leading tabs for nicely indented scripts.</div>
        <div class="warning-box"><strong>Caution:</strong> The delimiter must appear alone on its line—no leading/trailing spaces.</div>
        <h2>Common Mistakes</h2>
        <div class="mistake-box"><h4>1) Indentation with spaces</h4><pre><code class="language-bash"># Wrong (spaces won't be stripped)
cat <<-EOF
  indented with spaces
EOF</code></pre></div>
        <div class="mistake-box"><h4>2) Unintended expansion</h4><pre><code class="language-bash"># Wrong (variables expand)
cat <<EOF
$HOME
EOF
# Correct
cat <<'EOF'
$HOME
EOF</code></pre></div>
        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>
        <h2>Exercise: Template</h2>
        <div class="exercise-section">
          <p><strong>Task:</strong> Print a multi-line message that includes <code>$USER</code> and the current date using a heredoc.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/exercises/ex-io-heredoc.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="exercise-io-heredoc" />
            <jsp:param name="filename" value="ex-io-heredoc.sh" />
          </jsp:include>
          <details class="exercise-hint"><summary>Show Solution</summary><pre><code class="language-bash">cat <<EOF
Hello $USER
Today is $(date +%F)
EOF</code></pre></details>
        </div>
        <h2>Summary</h2>
        <div class="summary-box"><ul><li>Use heredocs for multi-line input.</li><li>Quote delimiter to disable expansion.</li><li>Use here strings (<code>&lt;&lt;&lt;</code>) for short inputs.</li></ul></div>
        <h2>What's Next?</h2>
        <p>Connect commands without temp files using <a href="io-process-substitution.jsp">Process Substitution</a>.</p>
      </div>
      <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>
      <jsp:include page="../tutorial-nav.jsp"><jsp:param name="prevLink" value="io-pipes.jsp" /><jsp:param name="prevTitle" value="Pipes" /><jsp:param name="nextLink" value="io-process-substitution.jsp" /><jsp:param name="nextTitle" value="Process Substitution" /><jsp:param name="currentLessonId" value="io-heredoc" /></jsp:include>
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

