<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "first-program" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>First Java Program - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Write your first Java program! Learn the main method, System.out.println, class structure, compilation (javac), and execution (java). Start coding in Java.">
            <meta name="keywords"
                content="java hello world, java first program, java main method, System.out.println, javac compile, java tutorial, learn java">

            <meta property="og:type" content="article">
            <meta property="og:title" content="First Java Program - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Write your first Java program with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/first-program.jsp">
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

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "First Java Program",
        "description": "Write your first Java program. Learn the main method, System.out.println, class structure, compilation, and execution.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["main method", "System.out.println", "Java class structure", "Compilation", "Execution"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Java Tutorial",
            "url": "https://8gwifi.org/tutorials/java/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="first-program">
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
                                    <span>First Program</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">First Java Program</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Welcome to your first Java program! In this lesson, you'll write the
                                        classic "Hello, World!" program and learn the fundamental structure of a Java
                                        application. You'll understand how to compile and execute Java code, and get
                                        familiar with the <code>main</code> method - the entry point of every Java
                                        application.</p>

                                    <!-- Section 1: Hello World Program -->
                                    <h2>Hello, World!</h2>
                                    <p>The traditional first program in any programming language is "Hello, World!" - a
                                        simple program that displays text. In Java, even this simple program requires
                                        understanding a few key concepts.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/first-hello-world.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-hello" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Components:</strong> Every Java program must have:
                                        <ul>
                                            <li>A <code>class</code> declaration (Java is object-oriented)</li>
                                            <li>A <code>main</code> method (entry point for execution)</li>
                                            <li>Code statements inside the method</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Understanding the Structure -->
                                    <h2>Understanding the Structure</h2>
                                    <p>Let's break down the Hello World program line by line:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/first-program.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-structure" />
                                    </jsp:include>

                                    <h3>Line-by-Line Explanation</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Line</th>
                                                <th>Explanation</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>public class HelloWorld</code></td>
                                                <td>Declares a public class named <code>HelloWorld</code>. The class
                                                    name must match the filename (HelloWorld.java)</td>
                                            </tr>
                                            <tr>
                                                <td><code>{</code></td>
                                                <td>Opening brace starts the class body</td>
                                            </tr>
                                            <tr>
                                                <td><code>public static void main(String[] args)</code></td>
                                                <td>The <code>main</code> method - entry point. <code>public</code>
                                                    makes it accessible, <code>static</code> allows calling without
                                                    creating an object, <code>void</code> means it returns nothing</td>
                                            </tr>
                                            <tr>
                                                <td><code>System.out.println("Hello, World!");</code></td>
                                                <td>Prints "Hello, World!" to the console and moves to a new line</td>
                                            </tr>
                                            <tr>
                                                <td><code>}</code></td>
                                                <td>Closing braces end the method and class</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Naming Convention:</strong> Class names in Java use PascalCase (each
                                        word starts with a capital letter). The class name must exactly match the
                                        filename (case-sensitive).
                                    </div>

                                    <!-- Section 3: The main Method -->
                                    <h2>The <code>main</code> Method</h2>
                                    <p>The <code>main</code> method is special in Java - it's the entry point where
                                        program execution begins. The JVM looks for this exact method signature to start
                                        running your program.</p>

                                    <div class="info-box">
                                        <strong>main Method Signature:</strong>
                                        <pre><code class="language-java">public static void main(String[] args)</code></pre>
                                        <ul>
                                            <li><code>public</code> - Accessible from anywhere (required by JVM)</li>
                                            <li><code>static</code> - Can be called without creating a class instance
                                            </li>
                                            <li><code>void</code> - Doesn't return any value</li>
                                            <li><code>main</code> - Method name (must be exactly "main")</li>
                                            <li><code>String[] args</code> - Command-line arguments (array of strings)
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Important:</strong> The <code>main</code> method signature is fixed.
                                        Changing any part of it (like removing <code>static</code> or changing the
                                        parameter type) will prevent your program from running!
                                    </div>

                                    <!-- Section 4: System.out.println -->
                                    <h2>System.out.println</h2>
                                    <p><code>System.out.println</code> is used to display output on the console. Let's
                                        understand each part:</p>

                                    <ul>
                                        <li><code>System</code> - A built-in class in Java</li>
                                        <li><code>out</code> - A static member of System class (represents standard
                                            output stream)</li>
                                        <li><code>println</code> - Method that prints the argument and adds a newline
                                        </li>
                                    </ul>

                                    <h3>println vs print</h3>
                                    <p>Java provides two methods for output:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/first-print-vs-println.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-print" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Behavior</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>System.out.print()</code></td>
                                                <td>Prints without newline</td>
                                                <td><code>System.out.print("Hello"); System.out.print("World");</code> →
                                                    "HelloWorld"</td>
                                            </tr>
                                            <tr>
                                                <td><code>System.out.println()</code></td>
                                                <td>Prints with newline</td>
                                                <td><code>System.out.println("Hello"); System.out.println("World");</code>
                                                    → "Hello\nWorld"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 5: Compilation and Execution -->
                                    <h2>Compilation and Execution</h2>
                                    <p>Java programs require a two-step process: compilation and execution.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-compilation-process.svg"
                                        alt="Java Compilation Process" class="diagram-image"
                                        style="max-width: 700px; margin: 2rem auto; display: block;">

                                    <h3>Step 1: Compile</h3>
                                    <p>Use the <code>javac</code> command to compile your Java source file:</p>
                                    <pre><code class="language-bash">javac HelloWorld.java</code></pre>
                                    <p>This creates a <code>HelloWorld.class</code> file containing bytecode.</p>

                                    <h3>Step 2: Execute</h3>
                                    <p>Use the <code>java</code> command to run the compiled program:</p>
                                    <pre><code class="language-bash">java HelloWorld</code></pre>
                                    <p><strong>Note:</strong> Don't include the <code>.class</code> extension when
                                        running!</p>

                                    <div class="tip-box">
                                        <strong>Quick Test:</strong> The interactive compiler above handles compilation
                                        and execution automatically. Try modifying the code and clicking "Run" to see
                                        the output instantly!
                                    </div>

                                    <!-- Section 6: Class Name and Filename -->
                                    <h2>Class Name Must Match Filename</h2>
                                    <p>In Java, the public class name must exactly match the filename (without the
                                        <code>.java</code> extension). This is a Java requirement.
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Filename</th>
                                                <th>Class Name</th>
                                                <th>Valid?</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>HelloWorld.java</code></td>
                                                <td><code>public class HelloWorld</code></td>
                                                <td>✓ Yes</td>
                                            </tr>
                                            <tr>
                                                <td><code>HelloWorld.java</code></td>
                                                <td><code>public class Hello</code></td>
                                                <td>✗ No - Compile error</td>
                                            </tr>
                                            <tr>
                                                <td><code>hello.java</code></td>
                                                <td><code>public class HelloWorld</code></td>
                                                <td>✗ No - Compile error</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Case Sensitivity:</strong> Java is case-sensitive!
                                        <code>HelloWorld</code>, <code>helloworld</code>, and <code>HELLOWORLD</code>
                                        are all different. The class name and filename must match exactly, including
                                        case.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Missing main method</h4>
                                        <pre><code class="language-java">public class HelloWorld {
    // Missing main method!
    System.out.println("Hello");
}</code></pre>
                                        <p><strong>Error:</strong>
                                            <code>Error: Main method not found in class HelloWorld</code>
                                        </p>
                                        <p><strong>Solution:</strong> Every program needs a <code>main</code> method</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Wrong main method signature</h4>
                                        <pre><code class="language-java">// Wrong - missing static
public void main(String[] args) { ... }

// Wrong - wrong return type
public static int main(String[] args) { ... }

// Correct
public static void main(String[] args) { ... }</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Class name doesn't match filename</h4>
                                        <pre><code class="language-java">// File: HelloWorld.java
public class Hello {  // Error! Class name must be HelloWorld
    ...
}</code></pre>
                                        <p><strong>Error:</strong>
                                            <code>class Hello is public, should be declared in a file named Hello.java</code>
                                        </p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Missing semicolon</h4>
                                        <pre><code class="language-java">// Wrong
System.out.println("Hello")

// Correct
System.out.println("Hello");</code></pre>
                                        <p><strong>Error:</strong> <code>';' expected</code></p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>5. Missing quotes around strings</h4>
                                        <pre><code class="language-java">// Wrong
System.out.println(Hello World);

// Correct
System.out.println("Hello World");</code></pre>
                                        <p><strong>Error:</strong> <code>cannot find symbol: variable Hello</code></p>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Personalize Your Program</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Modify the Hello World program to introduce yourself!
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Print your name</li>
                                            <li>Print your favorite programming language</li>
                                            <li>Print a greeting message</li>
                                            <li>Use both <code>print</code> and <code>println</code> methods</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="java/exercises/ex-first-program.java" />
                                            <jsp:param name="language" value="java" />
                                            <jsp:param name="editorId" value="exercise-first" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>💡 Hint</summary>
                                            <p>Try using multiple <code>System.out.println()</code> statements, or use
                                                <code>System.out.print()</code> for the name and
                                                <code>System.out.println()</code> for the language.
                                            </p>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Every Java program must have a <code>public class</code> with a matching
                                                filename</li>
                                            <li>The <code>main</code> method is the entry point:
                                                <code>public static void main(String[] args)</code>
                                            </li>
                                            <li><code>System.out.println()</code> prints output with a newline;
                                                <code>System.out.print()</code> prints without a newline
                                            </li>
                                            <li>Compile with <code>javac filename.java</code> to create a
                                                <code>.class</code> file
                                            </li>
                                            <li>Execute with <code>java ClassName</code> (no <code>.class</code>
                                                extension)</li>
                                            <li>Java is case-sensitive - class names and filenames must match exactly
                                            </li>
                                            <li>Statements must end with a semicolon (<code>;</code>)</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've written your first Java program. Now that you understand
                                        the basic structure, let's learn about Java syntax - statements, blocks,
                                        comments, and naming conventions. These fundamentals will help you write clean,
                                        readable Java code.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath() + "/tutorials/java/intro.jsp" ;
                                            String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/syntax-basics.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Introduction" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Syntax Basics →" />
                                                <jsp:param name="currentLessonId" value="first-program" />
                                            </jsp:include>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
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