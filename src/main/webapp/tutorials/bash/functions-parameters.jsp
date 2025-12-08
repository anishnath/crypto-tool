<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-parameters");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Function Parameters - Bash Tutorial | 8gwifi.org</title>
    <meta name="description" content="Pass and handle parameters in Bash functions. Use positional parameters ($1..$9), $@, $*, and the shift command to iterate arguments safely.">
    <meta name="keywords" content="bash function parameters, bash $@, bash $*, bash shift, bash positional parameters">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Function Parameters - Bash Tutorial | 8gwifi.org">
    <meta property="og:description" content="How to pass and iterate parameters in Bash functions using $1..$9, $@, $*, and shift.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/functions-parameters.jsp">
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
      "name": "Bash Functions: Parameters",
      "description": "Handle function parameters using positional variables, $@, $*, and shift.",
      "learningResourceType": "tutorial",
      "educationalLevel": "Intermediate",
      "teaches": ["$1..$9", "$@ vs $*", "shift", "argument iteration"],
      "timeRequired": "PT25M",
      "isPartOf": {"@type": "Course", "name": "Bash Tutorial", "url": "https://8gwifi.org/tutorials/bash/"}
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="functions-parameters">
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
          <span>Function Parameters</span>
        </nav>

        <header class="lesson-header">
          <h1 class="lesson-title">Function Parameters</h1>
          <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
        </header>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

        <div class="lesson-body">
          <p class="lead">Use positional parameters to pass values into functions. Prefer <code>$@</code> for iterating arguments safely, and use <code>shift</code> to consume them.</p>

          <h2>Positional Parameters</h2>
          <p>Inside a function, <code>$1</code> is the first argument, <code>$2</code> the second, and so on. <code>$#</code> holds the argument count.</p>
          <jsp:include page="../tutorial-compiler.jsp">
            <jsp:param name="codeFile" value="bash/functions-parameters.sh" />
            <jsp:param name="language" value="bash" />
            <jsp:param name="editorId" value="compiler-functions-parameters" />
            <jsp:param name="filename" value="functions-parameters.sh" />
          </jsp:include>

          <div class="info-box">
            <strong>$@ vs $*:</strong> Within quotes, <code>"$@"</code> preserves argument boundaries (preferred), while <code>"$*"</code> joins them into a single string.
          </div>

          <div class="tip-box">
            <strong>Pro Tip:</strong> When forwarding args to another function, use <code>"$@"</code> to preserve spacing and quoting.
          </div>

          <div class="warning-box">
            <strong>Caution:</strong> Unquoted <code>$@</code> or <code>$*</code> will split on IFS and can break on spaces. Quote your expansions unless you specifically need word splitting.
          </div>

          <h2>Common Mistakes</h2>
          <div class="mistake-box">
            <h4>1) Using <code>$*</code> when you need <code>"$@"</code></h4>
            <pre><code class="language-bash"># Wrong
show() { for a in "$*"; do echo "[$a]"; done }
show "alpha beta" gamma  # Loses original boundaries

# Correct
show() { for a in "$@"; do echo "[$a]"; done }
show "alpha beta" gamma</code></pre>
          </div>
          <div class="mistake-box">
            <h4>2) Forgetting to quote when forwarding</h4>
            <pre><code class="language-bash"># Wrong
caller() { callee $@; }
callee() { printf '%s\n' "$@"; }
caller "one two" three  # Broken

# Correct
caller() { callee "$@"; }
caller "one two" three</code></pre>
          </div>

          <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="middle" /><jsp:param name="responsive" value="true" /></jsp:include>

          <h2>Exercise: Sum Arguments</h2>
          <div class="exercise-section">
            <p><strong>Task:</strong> Implement <code>sum_args</code> that prints the sum of all numeric arguments.</p>
            <ul>
              <li>Handle any number of args (including 0).</li>
              <li>Treat non-numeric args as an error and return non-zero.</li>
            </ul>
            <jsp:include page="../tutorial-compiler.jsp">
              <jsp:param name="codeFile" value="bash/exercises/ex-functions-parameters.sh" />
              <jsp:param name="language" value="bash" />
              <jsp:param name="editorId" value="exercise-functions-parameters" />
              <jsp:param name="filename" value="ex-functions-parameters.sh" />
            </jsp:include>
            <details class="exercise-hint">
              <summary>Show Solution</summary>
              <pre><code class="language-bash">sum_args() {
  local n sum=0
  for n in "$@"; do
    [[ $n =~ ^-?[0-9]+$ ]] || return 1
    sum=$((sum + n))
  done
  echo "$sum"
}

sum_args 1 2 3</code></pre>
            </details>
          </div>

          <h2>Summary</h2>
          <div class="summary-box">
            <ul>
              <li>Use <code>$1..$9</code> and <code>$#</code> to access and count parameters.</li>
              <li>Prefer <code>"$@"</code> for iteration to preserve spaces.</li>
              <li>Use <code>shift</code> to consume parameters in a loop.</li>
            </ul>
          </div>

          <h2>What's Next?</h2>
          <p>Next, learn about return codes and returning computed values in <a href="functions-return.jsp">Return Values</a>.</p>
        </div>

        <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

        <jsp:include page="../tutorial-nav.jsp">
          <jsp:param name="prevLink" value="functions-basics.jsp" />
          <jsp:param name="prevTitle" value="Defining Functions" />
          <jsp:param name="nextLink" value="functions-return.jsp" />
          <jsp:param name="nextTitle" value="Return Values" />
          <jsp:param name="currentLessonId" value="functions-parameters" />
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
