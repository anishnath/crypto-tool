<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "functions-basics");
   request.setAttribute("currentModule", "Functions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- 1. META TAGS -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Defining Functions - Bash Tutorial | 8gwifi.org</title>
    <meta name="description" content="Learn how to define and call functions in Bash using both 'function name()' and 'name()' styles. Understand basic return codes and setup for local vs global variables.">
    <meta name="keywords" content="bash functions, bash function keyword, bash local variables, bash return code, shell scripting functions">

    <!-- Open Graph -->
    <meta property="og:type" content="article">
    <meta property="og:title" content="Defining Functions - Bash Tutorial | 8gwifi.org">
    <meta property="og:description" content="Define and call Bash functions, compare styles, and see simple return codes.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <!-- 2. RESOURCES -->
    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/functions-basics.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <!-- 3. THEME DETECTION -->
    <script>
        (function () {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <!-- 4. STRUCTURED DATA -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Bash Functions: Defining Functions",
        "description": "Learn how to define and call functions in Bash using both common declaration styles, and understand return codes.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["function keyword", "name() style", "calling functions", "return status"],
        "timeRequired": "PT25M",
        "isPartOf": {"@type": "Course", "name": "Bash Tutorial", "url": "https://8gwifi.org/tutorials/bash/"}
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>
<body class="tutorial-body no-preview" data-lesson="functions-basics">
<div class="tutorial-layout">
    <%@ include file="../tutorial-header.jsp" %>
    <main class="tutorial-main">
        <%@ include file="../tutorial-sidebar-bash.jsp" %>
        <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

        <article class="tutorial-content">
            <!-- 5. BREADCRUMB -->
            <nav class="breadcrumb">
                <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                <span class="breadcrumb-separator">/</span>
                <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp">Bash</a>
                <span class="breadcrumb-separator">/</span>
                <span>Defining Functions</span>
            </nav>

            <!-- 6. LESSON HEADER -->
            <header class="lesson-header">
                <h1 class="lesson-title">Defining Functions</h1>
                <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
            </header>

            <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="top" /></jsp:include>

            <!-- 7. LESSON BODY -->
            <div class="lesson-body">
                <p class="lead">Functions package reusable logic in Bash scripts. You can declare functions using either the <code>function name()</code> or <code>name()</code> style, then call them like commands.</p>

                <h2>Two Declaration Styles</h2>
                <p>Both styles are widely used. Pick one and be consistent:</p>
                <ul>
                    <li><strong>With keyword</strong>: <code>function foo() { ... }</code></li>
                    <li><strong>Without keyword</strong>: <code>foo() { ... }</code></li>
                </ul>

                <jsp:include page="../tutorial-compiler.jsp">
                    <jsp:param name="codeFile" value="bash/functions-basics.sh" />
                    <jsp:param name="language" value="bash" />
                    <jsp:param name="editorId" value="compiler-functions-basics" />
                    <jsp:param name="filename" value="functions-basics.sh" />
                </jsp:include>

                <div class="info-box">
                    <strong>Tip:</strong> Functions inherit the parent shell environment. To avoid accidental global changes, use <code>local</code> variables inside functions.
                </div>

                <div class="tip-box">
                    <strong>Pro Tip:</strong> Keep function names lowercase with hyphens or underscores (e.g., <code>print_summary</code>) and group related helpers together for readability.
                </div>

                <div class="warning-box">
                    <strong>Caution:</strong> A function that runs <code>set -e</code> or unguarded commands can terminate your whole script. Handle errors explicitly or return status codes.
                </div>

                <h2>Local vs Global (Preview)</h2>
                <p>By default, variables are global in Bash. Use <code>local</code> inside functions to limit scope:</p>
                <jsp:include page="../tutorial-compiler.jsp">
                    <jsp:param name="codeFile" value="bash/functions-local-vars.sh" />
                    <jsp:param name="language" value="bash" />
                    <jsp:param name="editorId" value="compiler-functions-local" />
                    <jsp:param name="filename" value="functions-local-vars.sh" />
                </jsp:include>

                <h2>Common Mistakes</h2>
                <div class="mistake-box">
                    <h4>1) Forgetting <code>local</code> in helpers</h4>
                    <pre><code class="language-bash"># Wrong: overwrites global var
name="Global"
set_name() { name="$1"; }
set_name "Bob"
echo "$name"  # Global changed unintentionally

# Correct: use local inside function
name="Global"
set_name() { local name="$1"; echo "local=$name"; }
set_name "Bob"
echo "$name"  # Still "Global"</code></pre>
                </div>
                <div class="mistake-box">
                    <h4>2) Relying on <code>return</code> for data</h4>
                    <pre><code class="language-bash"># Wrong: return is only 0..255
add() { return $(( $1 + $2 )); }
add 200 100  # Overflow risk

# Correct: echo and capture output
add() { echo $(( $1 + $2 )); }
sum=$(add 200 100)
echo "$sum"</code></pre>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="middle" />
                    <jsp:param name="responsive" value="true" />
                </jsp:include>

                <h2>Exercise: Greeting Function</h2>
                <div class="exercise-section">
                    <p><strong>Task:</strong> Write a function <code>greet</code> that prints <code>"Hello, NAME"</code>. If no argument is provided, default to <code>"World"</code>.</p>
                    <ul>
                        <li>Support zero or one argument.</li>
                        <li>Do not modify any global variables.</li>
                    </ul>
                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/exercises/ex-functions-basics.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="exercise-functions-basics" />
                        <jsp:param name="filename" value="ex-functions-basics.sh" />
                    </jsp:include>
                    <details class="exercise-hint">
                        <summary>Show Solution</summary>
                        <pre><code class="language-bash">greet() {
  local name=\${1:-World}
  echo "Hello, $name"
}

greet
greet "Alice"</code></pre>
                    </details>
                </div>

                <h2>Summary</h2>
                <div class="summary-box">
                    <ul>
                        <li>Declare functions with either <code>function name()</code> or <code>name()</code>.</li>
                        <li>Call functions like regular commands: <code>my_func arg1 arg2</code>.</li>
                        <li>Use <code>local</code> to prevent side effects on global variables.</li>
                    </ul>
                </div>

                <h2>What's Next?</h2>
                <p>Next, pass data into functions and iterate arguments in <a href="functions-parameters.jsp">Function Parameters</a>.</p>
            </div>

            <jsp:include page="../tutorial-ad-slot.jsp"><jsp:param name="slot" value="bottom" /></jsp:include>

            <!-- 8. NAVIGATION -->
            <jsp:include page="../tutorial-nav.jsp">
                <jsp:param name="prevLink" value="loops-select.jsp" />
                <jsp:param name="prevTitle" value="Select Menus" />
                <jsp:param name="nextLink" value="functions-parameters.jsp" />
                <jsp:param name="nextTitle" value="Function Parameters" />
                <jsp:param name="currentLessonId" value="functions-basics" />
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
