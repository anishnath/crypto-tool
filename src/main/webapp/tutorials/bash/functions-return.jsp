<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-return");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Return Values - Bash Tutorial | 8gwifi.org</title>
    <meta name="description" content="Understand Bash function return values. Use exit status for success/failure and echo to return computed data.">
    <meta name="keywords" content="bash function return, bash exit code, bash echo return value, shell function status">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Return Values - Bash Tutorial | 8gwifi.org">
    <meta property="og:description" content="Use exit codes and command substitution to get results from Bash functions.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/functions-return.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <script>
        (function () {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "LearningResource",
      "name": "Bash Functions: Return Values",
      "description": "Use exit status for success/failure and echo for computed results.",
      "learningResourceType": "tutorial",
      "educationalLevel": "Intermediate",
      "teaches": ["exit codes", "command substitution", "error handling"],
      "timeRequired": "PT20M",
      "isPartOf": {"@type": "Course", "name": "Bash Tutorial", "url": "https://8gwifi.org/tutorials/bash/"}
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="functions-return">
  <div class="tutorial-layout">
    <%@ include file="../tutorial-header.jsp" %>
    <main class="tutorial-main">
      <%@ include file="../tutorial-sidebar-bash.jsp" %>
      <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

      <article class="tutorial-content">
        <nav class="breadcrumb">
          <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
          <span class="breadcrumb-separator">/</span>
          <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a>
          <span class="breadcrumb-separator">/</span>
          <span>Return Values</span>
        </nav>

        <header class="lesson-header">
          <h1 class="lesson-title">Return Values</h1>
          <div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div>
        </header>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

        <div class="lesson-body">
          <p class="lead">Bash functions signal success or failure using the <em>exit status</em> (0 = success, non-zero = failure). To get computed data, print it and capture via command substitution.</p>

          <h2>Exit Status (Success/Failure)</h2>
          <p>Any command or function leaves a status code in <code>$?</code>. In conditions, a status of 0 is treated as true.</p>

          <h2>Returning Data</h2>
          <p>Use <code>echo</code> inside the function and capture the output with <code>var=$(func args)</code>.</p>

          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/functions-return.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="compiler-functions-return" />
            <jsp:param name="filename" value="functions-return.sh" />
          </jsp:include>

          <div class="tip-box">
            <strong>Pro Tip:</strong> For complex outputs, print in a stable, parseable format (e.g., TSV or JSON) so callers can reliably consume results.
          </div>

          <div class="warning-box">
            <strong>Caution:</strong> Don’t mix diagnostic output with data output. Send logs to <code>stderr</code> using <code>echo "msg" 1>&2</code> if needed.
          </div>

          <h2>Common Mistakes</h2>
          <div class="mistake-box">
            <h4>1) Using <code>return</code> for arbitrary data</h4>
            <pre><code class="language-bash"># Wrong
sum() { return $(( $1 + $2 )); }

# Correct
sum() { echo $(( $1 + $2 )); }</code></pre>
          </div>
          <div class="mistake-box">
            <h4>2) Ignoring function exit status</h4>
            <pre><code class="language-bash"># Wrong
maybe_fail() { false; echo 42; }
result=$(maybe_fail)
echo "$result"  # Misleading if command failed

# Correct
if result=$(maybe_fail); then
  echo "$result"
else
  echo "error" 1>&2
fi</code></pre>
          </div>

          <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>

          <h2>Exercise: Max of Two</h2>
          <div class="exercise-section">
            <p><strong>Task:</strong> Implement <code>max</code> that echoes the larger of two integers. Return non-zero if arguments are invalid.</p>
            <ul>
              <li>Accept exactly two arguments.</li>
              <li>Handle negative numbers correctly.</li>
            </ul>
            <jsp:include page="../tutorial-compiler.jsp">
              <jsp:param name="codeFile" value="bash/exercises/ex-functions-return.sh" />
              <jsp:param name="language" value="bash" />
              <jsp:param name="editorId" value="exercise-functions-return" />
              <jsp:param name="filename" value="ex-functions-return.sh" />
            </jsp:include>
            <details class="exercise-hint">
              <summary>Show Solution</summary>
              <pre><code class="language-bash">max() {
  [[ $# -eq 2 && $1 =~ ^-?[0-9]+$ && $2 =~ ^-?[0-9]+$ ]] || return 1
  (( $1 >= $2 )) && echo "$1" || echo "$2"
}

max 5 9</code></pre>
            </details>
          </div>

          <h2>Summary</h2>
          <div class="summary-box">
            <ul>
              <li>Use exit status for control flow (0 = success).</li>
              <li>Use <code>echo</code> and <code>$(...)</code> to return data.</li>
              <li>Check <code>$?</code> or use <code>if func; then ...</code> patterns.</li>
            </ul>
          </div>

          <h2>What's Next?</h2>
          <p>Next, manage variable visibility and side effects in <a href="functions-scope.jsp">Function Scope</a>.</p>
        </div>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

        <jsp:include page="../tutorial-nav.jsp">
          <jsp:param name="prevLink" value="functions-parameters.jsp" />
          <jsp:param name="prevTitle" value="Function Parameters" />
          <jsp:param name="nextLink" value="functions-scope.jsp" />
          <jsp:param name="nextTitle" value="Function Scope" />
          <jsp:param name="currentLessonId" value="functions-return" />
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
