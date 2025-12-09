<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-debugging" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Debugging Java Applications - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn tips and tricks for debugging Java applications.">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="practices-debugging">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Debugging</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Debugging Techniques</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Effective debugging saves hours of development time. Master IDE debuggers,
                                        stack trace analysis, and remote debugging to quickly find and fix issues.</p>

                                    <h2>IDE Debugger Basics</h2>
                                    <p>IDEs like IntelliJ IDEA and Eclipse provide powerful debugging tools.</p>

                                    <h3>Debugger Controls</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Action</th>
                                                <th>Shortcut (IntelliJ)</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Toggle Breakpoint</td>
                                                <td><code>Ctrl+F8</code></td>
                                                <td>Set/remove breakpoint on current line</td>
                                            </tr>
                                            <tr>
                                                <td>Debug</td>
                                                <td><code>Shift+F9</code></td>
                                                <td>Start debugging</td>
                                            </tr>
                                            <tr>
                                                <td>Step Over</td>
                                                <td><code>F8</code></td>
                                                <td>Execute line, don't enter methods</td>
                                            </tr>
                                            <tr>
                                                <td>Step Into</td>
                                                <td><code>F7</code></td>
                                                <td>Enter the method being called</td>
                                            </tr>
                                            <tr>
                                                <td>Step Out</td>
                                                <td><code>Shift+F8</code></td>
                                                <td>Exit current method</td>
                                            </tr>
                                            <tr>
                                                <td>Resume</td>
                                                <td><code>F9</code></td>
                                                <td>Continue until next breakpoint</td>
                                            </tr>
                                            <tr>
                                                <td>Evaluate Expression</td>
                                                <td><code>Alt+F8</code></td>
                                                <td>Run code in current context</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Types of Breakpoints</h3>
                                    <ul>
                                        <li><strong>Line Breakpoint:</strong> Pause at a specific line</li>
                                        <li><strong>Conditional Breakpoint:</strong> Pause only when condition is true</li>
                                        <li><strong>Exception Breakpoint:</strong> Pause when exception is thrown</li>
                                        <li><strong>Method Breakpoint:</strong> Pause when method is entered/exited</li>
                                        <li><strong>Field Watchpoint:</strong> Pause when field is accessed/modified</li>
                                    </ul>

                                    <div class="info-box">
                                        <strong>Pro Tip:</strong> Right-click a breakpoint to add conditions like
                                        <code>userId == 42</code> or <code>list.size() > 100</code>. This avoids
                                        stopping on every iteration of a loop.
                                    </div>

                                    <h2>Reading Stack Traces</h2>
                                    <p>Stack traces show the sequence of method calls that led to an error.</p>
                                    <pre><code class="language-java">Exception in thread "main" java.lang.NullPointerException: Cannot invoke "String.length()"
    at com.example.UserService.validateEmail(UserService.java:45)
    at com.example.UserService.createUser(UserService.java:28)
    at com.example.UserController.register(UserController.java:15)
    at com.example.Main.main(Main.java:10)</code></pre>

                                    <h3>How to Read It</h3>
                                    <ul>
                                        <li><strong>Line 1:</strong> Exception type and message</li>
                                        <li><strong>Line 2:</strong> Where the exception occurred (start here!)</li>
                                        <li><strong>Lines 3+:</strong> Call chain that led to the exception</li>
                                        <li>Read from <strong>top to bottom</strong> = most recent to oldest</li>
                                    </ul>

                                    <h3>Common Exceptions</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Exception</th>
                                                <th>Likely Cause</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>NullPointerException</code></td>
                                                <td>Called method on null object</td>
                                            </tr>
                                            <tr>
                                                <td><code>ArrayIndexOutOfBoundsException</code></td>
                                                <td>Invalid array index</td>
                                            </tr>
                                            <tr>
                                                <td><code>ClassCastException</code></td>
                                                <td>Invalid type cast</td>
                                            </tr>
                                            <tr>
                                                <td><code>NumberFormatException</code></td>
                                                <td>String can't be parsed as number</td>
                                            </tr>
                                            <tr>
                                                <td><code>ConcurrentModificationException</code></td>
                                                <td>Modified collection while iterating</td>
                                            </tr>
                                            <tr>
                                                <td><code>StackOverflowError</code></td>
                                                <td>Infinite recursion</td>
                                            </tr>
                                            <tr>
                                                <td><code>OutOfMemoryError</code></td>
                                                <td>Memory leak or large data</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Remote Debugging</h2>
                                    <p>Debug applications running on remote servers.</p>

                                    <h3>1. Start JVM with Debug Options</h3>
                                    <pre><code class="language-bash"># Java 9+
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar app.jar

# Java 8
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar app.jar</code></pre>

                                    <h3>2. Connect from IDE</h3>
                                    <p>In IntelliJ: Run → Edit Configurations → Add New → Remote JVM Debug</p>
                                    <ul>
                                        <li>Host: <code>localhost</code> (or server IP)</li>
                                        <li>Port: <code>5005</code></li>
                                    </ul>

                                    <div class="info-box">
                                        <strong>Security Warning:</strong> Never expose debug ports in production!
                                        Use <code>address=127.0.0.1:5005</code> for localhost-only access, or use
                                        SSH tunneling for remote debugging.
                                    </div>

                                    <h2>Debugging Techniques</h2>

                                    <h3>Binary Search Debugging</h3>
                                    <p>When you don't know where the bug is:</p>
                                    <ol>
                                        <li>Set breakpoint halfway through the code path</li>
                                        <li>Check if data is correct at that point</li>
                                        <li>If correct, bug is after; if wrong, bug is before</li>
                                        <li>Repeat until you find the exact location</li>
                                    </ol>

                                    <h3>Rubber Duck Debugging</h3>
                                    <p>Explain the code line by line (to a duck, colleague, or yourself).
                                       Often, you'll spot the bug while explaining.</p>

                                    <h3>Print Debugging (When All Else Fails)</h3>
                                    <pre><code class="language-java">public void processOrder(Order order) {
    System.out.println("DEBUG: order = " + order);
    System.out.println("DEBUG: order.items = " + order.getItems());
    System.out.println("DEBUG: order.items.size = " + order.getItems().size());

    // Better: Use logging with DEBUG level
    logger.debug("Processing order: {}", order);
}</code></pre>

                                    <h2>JVM Debugging Tools</h2>

                                    <h3>jps - List Java Processes</h3>
                                    <pre><code class="language-bash">$ jps -l
12345 com.example.MyApp
67890 org.gradle.launcher.daemon.bootstrap.GradleDaemon</code></pre>

                                    <h3>jstack - Thread Dump</h3>
                                    <pre><code class="language-bash"># Get thread dump (find deadlocks, blocked threads)
$ jstack 12345 > thread-dump.txt</code></pre>

                                    <h3>jmap - Memory Analysis</h3>
                                    <pre><code class="language-bash"># Create heap dump for memory analysis
$ jmap -dump:format=b,file=heap.hprof 12345

# Analyze with tools like Eclipse MAT or VisualVM</code></pre>

                                    <h3>VisualVM</h3>
                                    <p>GUI tool for monitoring and profiling Java applications:</p>
                                    <ul>
                                        <li>Monitor CPU, memory, threads in real-time</li>
                                        <li>Profile method execution times</li>
                                        <li>Analyze heap dumps</li>
                                        <li>Take thread dumps</li>
                                    </ul>

                                    <h2>Common Debugging Scenarios</h2>

                                    <h3>NullPointerException</h3>
                                    <pre><code class="language-java">// Java 14+ shows helpful NPE messages:
// Cannot invoke "String.toLowerCase()" because "user.getName()" is null

// Debugging approach:
// 1. Look at the line number in stack trace
// 2. Identify which variable is null
// 3. Trace back where it should have been set
// 4. Add null checks or fix the source

// Prevention:
Optional.ofNullable(user)
    .map(User::getName)
    .ifPresent(name -> process(name));</code></pre>

                                    <h3>Infinite Loop</h3>
                                    <pre><code class="language-java">// Symptoms: Application hangs, 100% CPU
// Debugging:
// 1. Take thread dump with jstack
// 2. Look for threads in RUNNABLE state
// 3. Check the stack trace for loop locations

// Common causes:
while (i < list.size()) {
    // Forgot to increment i!
    process(list.get(i));
    i++;  // Don't forget this!
}</code></pre>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Master IDE <strong>debugger shortcuts</strong> for efficiency</li>
                                            <li>Use <strong>conditional breakpoints</strong> to stop only when needed</li>
                                            <li>Read stack traces <strong>from top to bottom</strong></li>
                                            <li>Use <strong>remote debugging</strong> for server issues (securely!)</li>
                                            <li>Use JVM tools (<strong>jstack, jmap</strong>) for production issues</li>
                                            <li><strong>Binary search</strong> to narrow down bug location</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath() + "/tutorials/java/practices-logging.jsp"
                                    ; String nextLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-examples.jsp" ; %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Logging" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Real-World Examples →" />
                                    <jsp:param name="currentLessonId" value="practices-debugging" />
                                    </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>