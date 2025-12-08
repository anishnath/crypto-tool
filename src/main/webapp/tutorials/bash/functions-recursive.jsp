<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-recursive");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Recursive Functions - Bash Tutorial | 8gwifi.org</title>
    <meta name="description" content="Implement recursion in Bash functions. Build factorial and explore simple directory traversal.">
    <meta name="keywords" content="bash recursion, bash recursive function, bash factorial, bash directory traversal">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Recursive Functions - Bash Tutorial | 8gwifi.org">
    <meta property="og:description" content="Write recursive Bash functions for factorial and directory traversal.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/functions-recursive.jsp">
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
      "name": "Bash Functions: Recursion",
      "description": "Implement recursive Bash functions with base and recursive cases.",
      "learningResourceType": "tutorial",
      "educationalLevel": "Intermediate",
      "teaches": ["base case", "recursive case", "factorial", "directory traversal"],
      "timeRequired": "PT20M",
      "isPartOf": {"@type": "Course", "name": "Bash Tutorial", "url": "https://8gwifi.org/tutorials/bash/"}
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="functions-recursive">
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
          <span>Recursive Functions</span>
        </nav>

        <header class="lesson-header">
          <h1 class="lesson-title">Recursive Functions</h1>
          <div class="lesson-meta"><span>Intermediate</span><span>~20 min read</span></div>
        </header>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

        <div class="lesson-body">
          <p class="lead">Bash supports recursion, though iteration is usually preferred for performance. Still, recursion is handy for problems like factorial or walking directory trees.</p>

          <h2>Factorial</h2>
          <p>Define a base case for <code>n &lt;= 1</code> and recurse for <code>n * factorial(n-1)</code>.</p>

          <h2>Directory Traversal</h2>
          <p>Walk a directory by listing entries and recursing into subdirectories.</p>

          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/functions-recursive.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="compiler-functions-recursive" />
            <jsp:param name="filename" value="functions-recursive.sh" />
          </jsp:include>

          <div class="mistake-box">
            <strong>Watch out:</strong> Deep recursion can hit system limits. Prefer loops for large traversals.
          </div>

          <div class="tip-box">
            <strong>Pro Tip:</strong> Memoization (caching results) can dramatically speed up recursive functions like Fibonacci.
          </div>

          <div class="warning-box">
            <strong>Caution:</strong> Beware of globbing and unquoted variables in recursive walkers; always quote paths.
          </div>

          <h2>Common Mistakes</h2>
          <div class="mistake-box">
            <h4>1) Missing base case</h4>
            <pre><code class="language-bash"># Wrong
fact() { echo $(( $1 * $(fact $1) )); }

# Correct
fact() { local n=$1; (( n <= 1 )) && echo 1 || echo $(( n * $(fact $((n-1))) )); }</code></pre>
          </div>
          <div class="mistake-box">
            <h4>2) Unquoted paths in traversal</h4>
            <pre><code class="language-bash"># Wrong
for f in $dir/*; do echo $f; done

# Correct
for f in "$dir"/*; do echo "$f"; done</code></pre>
          </div>

          <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>

          <h2>Exercise: Recursive Fibonacci</h2>
          <div class="exercise-section">
            <p><strong>Task:</strong> Implement <code>fib</code> that prints the <em>n</em>th Fibonacci number recursively.</p>
            <ul>
              <li>Define <code>fib(0)=0</code> and <code>fib(1)=1</code>.</li>
              <li>Return non-zero on invalid input.</li>
            </ul>
            <jsp:include page="../tutorial-compiler.jsp">
              <jsp:param name="codeFile" value="bash/exercises/ex-functions-recursive.sh" />
              <jsp:param name="language" value="bash" />
              <jsp:param name="editorId" value="exercise-functions-recursive" />
              <jsp:param name="filename" value="ex-functions-recursive.sh" />
            </jsp:include>
            <details class="exercise-hint">
              <summary>Show Solution</summary>
              <pre><code class="language-bash">fib() {
  local n=$1
  [[ $n =~ ^[0-9]+$ ]] || return 1
  if (( n <= 1 )); then echo "$n"; else echo $(( $(fib $((n-1))) + $(fib $((n-2))) )); fi
}

fib 8  # 21</code></pre>
            </details>
          </div>

          <h2>Summary</h2>
          <div class="summary-box">
            <ul>
              <li>Always include a clear base case.</li>
              <li>Recursion is expressive but may be slower than loops in Bash.</li>
              <li>Use recursion selectively for clarity or small problem sizes.</li>
            </ul>
          </div>

          <h2>What's Next?</h2>
          <p>Up next: working with input and output in <a href="io-read.jsp">Reading Input</a>.</p>
        </div>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

        <jsp:include page="../tutorial-nav.jsp">
          <jsp:param name="prevLink" value="functions-scope.jsp" />
          <jsp:param name="prevTitle" value="Function Scope" />
          <jsp:param name="nextLink" value="io-read.jsp" />
          <jsp:param name="nextTitle" value="Reading Input" />
          <jsp:param name="currentLessonId" value="functions-recursive" />
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
