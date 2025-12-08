<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-scope");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Function Scope - Bash Tutorial | 8gwifi.org</title>
    <meta name="description" content="Master variable scope in Bash functions. Learn global variables, local variables, and shadowing to avoid side effects.">
    <meta name="keywords" content="bash function scope, bash local variable, bash global variable, bash shadowing">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Function Scope - Bash Tutorial | 8gwifi.org">
    <meta property="og:description" content="Local vs global variables and shadowing in Bash functions.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/functions-scope.jsp">
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
      "name": "Bash Functions: Scope",
      "description": "Understand local vs global variables and shadowing in Bash functions.",
      "learningResourceType": "tutorial",
      "educationalLevel": "Intermediate",
      "teaches": ["local variables", "global variables", "shadowing"],
      "timeRequired": "PT15M",
      "isPartOf": {"@type": "Course", "name": "Bash Tutorial", "url": "https://8gwifi.org/tutorials/bash/"}
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="functions-scope">
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
          <span>Function Scope</span>
        </nav>

        <header class="lesson-header">
          <h1 class="lesson-title">Function Scope</h1>
          <div class="lesson-meta"><span>Intermediate</span><span>~15 min read</span></div>
        </header>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

        <div class="lesson-body">
          <p class="lead">Bash variables are global by default. Use <code>local</code> within functions to contain changes and prevent accidental side effects.</p>

          <h2>Local vs Global</h2>
          <p>Declare a variable with <code>local</code> inside a function to keep it scoped. Without <code>local</code>, assignments modify the global variable.</p>

          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/functions-scope.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="compiler-functions-scope" />
            <jsp:param name="filename" value="functions-scope.sh" />
          </jsp:include>

          <div class="info-box">
            <strong>Note:</strong> <code>export</code> makes variables available to child processes. It does not make them local.
          </div>

          <div class="tip-box">
            <strong>Pro Tip:</strong> Use a consistent prefix for globals (e.g., <code>APP_</code>) and always declare temporaries with <code>local</code> inside functions.
          </div>

          <div class="warning-box">
            <strong>Caution:</strong> Sourcing files (<code>. file.sh</code>) executes in the current shell and can override globals; keep sourced files tidy and namespaced.
          </div>

          <h2>Common Mistakes</h2>
          <div class="mistake-box">
            <h4>1) Accidental global mutation</h4>
            <pre><code class="language-bash"># Wrong
count=0
inc() { count=$((count+1)); }
inc; echo "$count"  # modified globally

# Correct
inc() { local count=0; count=$((count+1)); echo "$count"; }
echo "local: $(inc)"; echo "global: $count"</code></pre>
          </div>
          <div class="mistake-box">
            <h4>2) Assuming <code>export</code> makes a variable local</h4>
            <pre><code class="language-bash"># Wrong
foo=bar; export foo  # Still global in current shell

# Correct
local foo=bar  # scoped to function only
export APP_TOKEN  # only for children
</code></pre>
          </div>

          <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>

          <h2>Exercise: Safe Increment</h2>
          <div class="exercise-section">
            <p><strong>Task:</strong> Implement <code>safe_inc</code> that increments a number passed by value and echoes the result without changing any global <code>counter</code> variable.</p>
            <ul>
              <li>Do not modify globals.</li>
              <li>Return non-zero if the input is not an integer.</li>
            </ul>
            <jsp:include page="../tutorial-compiler.jsp">
              <jsp:param name="codeFile" value="bash/exercises/ex-functions-scope.sh" />
              <jsp:param name="language" value="bash" />
              <jsp:param name="editorId" value="exercise-functions-scope" />
              <jsp:param name="filename" value="ex-functions-scope.sh" />
            </jsp:include>
            <details class="exercise-hint">
              <summary>Show Solution</summary>
              <pre><code class="language-bash">safe_inc() {
  local n=$1
  [[ $n =~ ^-?[0-9]+$ ]] || return 1
  echo $(( n + 1 ))
}

counter=41
safe_inc "$counter"  # echoes 42
echo "$counter"      # unchanged
</code></pre>
            </details>
          </div>

          <h2>Summary</h2>
          <div class="summary-box">
            <ul>
              <li>Variables are global unless declared <code>local</code> in a function.</li>
              <li>Shadowing lets you reuse names safely with <code>local</code>.</li>
              <li>Use <code>export</code> to pass values to child processes, not for scoping.</li>
            </ul>
          </div>

          <h2>What's Next?</h2>
          <p>Finally, build recursive functions for problems like factorial and directory traversal in <a href="functions-recursive.jsp">Recursive Functions</a>.</p>
        </div>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

        <jsp:include page="../tutorial-nav.jsp">
          <jsp:param name="prevLink" value="functions-return.jsp" />
          <jsp:param name="prevTitle" value="Return Values" />
          <jsp:param name="nextLink" value="functions-recursive.jsp" />
          <jsp:param name="nextTitle" value="Recursive Functions" />
          <jsp:param name="currentLessonId" value="functions-scope" />
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
