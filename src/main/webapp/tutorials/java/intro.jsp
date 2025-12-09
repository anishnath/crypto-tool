<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Introduction" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Introduction to Java - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn what Java is, understand JDK vs JRE vs JVM, Java history, platform independence, and installation. Start your Java programming journey.">
            <meta name="keywords"
                content="java introduction, what is java, jdk jre jvm, java platform, java tutorial, learn java, java programming, java installation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to Java - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn about Java programming language, its platform independence, and core concepts.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/intro.jsp">
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
        "name": "Introduction to Java",
        "description": "Learn what Java is, understand JDK vs JRE vs JVM, Java history, and platform independence.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Java programming language", "JDK vs JRE vs JVM", "Platform independence", "Java history"],
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

        <body class="tutorial-body no-preview" data-lesson="intro">
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
                                    <span>Introduction</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to Java</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Java is one of the most popular programming languages in the world,
                                        powering millions of applications from enterprise software to Android apps. In
                                        this lesson, you'll learn what Java is, why it's so widely used, and understand
                                        the key components that make Java work: JDK, JRE, and JVM.</p>

                                    <!-- Section 1: What is Java? -->
                                    <h2>What is Java?</h2>
                                    <p>Java is a high-level, object-oriented, class-based programming language designed
                                        to have as few implementation dependencies as possible. Developed by Sun
                                        Microsystems (now owned by Oracle) and released in 1995, Java was designed with
                                        the principle of <strong>"Write Once, Run Anywhere"</strong> (WORA).</p>

                                    <div class="info-box">
                                        <strong>Key Features of Java:</strong>
                                        <ul>
                                            <li><strong>Platform Independent:</strong> Java code compiles to bytecode
                                                that runs on any device with a Java Virtual Machine (JVM)</li>
                                            <li><strong>Object-Oriented:</strong> Everything in Java is an object,
                                                making code modular and reusable</li>
                                            <li><strong>Secure:</strong> Built-in security features and sandbox
                                                execution</li>
                                            <li><strong>Robust:</strong> Strong memory management and exception handling
                                            </li>
                                            <li><strong>Multithreaded:</strong> Built-in support for concurrent
                                                programming</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: JDK vs JRE vs JVM -->
                                    <h2>JDK, JRE, and JVM</h2>
                                    <p>Understanding the difference between JDK, JRE, and JVM is crucial for Java
                                        development. These three components work together to enable Java's platform
                                        independence.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-jdk-jre-jvm.svg"
                                        alt="JDK, JRE, and JVM Architecture" class="diagram-image"
                                        style="max-width: 600px; margin: 2rem auto; display: block;">

                                    <h3>JVM (Java Virtual Machine)</h3>
                                    <p>The JVM is a virtual machine that executes Java bytecode. It's platform-specific
                                        (different JVM for Windows, Linux, macOS) but provides a consistent runtime
                                        environment. The JVM:</p>
                                    <ul>
                                        <li>Loads bytecode (.class files)</li>
                                        <li>Verifies bytecode for security</li>
                                        <li>Executes bytecode by converting it to native machine code</li>
                                        <li>Manages memory (garbage collection)</li>
                                    </ul>

                                    <h3>JRE (Java Runtime Environment)</h3>
                                    <p>The JRE is a software package that provides everything needed to run Java
                                        applications. It includes:</p>
                                    <ul>
                                        <li>JVM (Java Virtual Machine)</li>
                                        <li>Java class libraries (rt.jar, charsets.jar, etc.)</li>
                                        <li>Supporting files and properties</li>
                                    </ul>
                                    <p><strong>Note:</strong> JRE is sufficient if you only want to <em>run</em> Java
                                        programs. You don't need JRE if you have JDK installed.</p>

                                    <h3>JDK (Java Development Kit)</h3>
                                    <p>The JDK is a complete development environment for Java. It includes:</p>
                                    <ul>
                                        <li>Everything in JRE</li>
                                        <li>Development tools (javac compiler, javadoc, jdb debugger, etc.)</li>
                                        <li>Source code and documentation</li>
                                    </ul>
                                    <p><strong>For development:</strong> You need JDK installed. It contains all tools
                                        necessary to write, compile, and debug Java programs.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Component</th>
                                                <th>Contains</th>
                                                <th>Used For</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>JVM</strong></td>
                                                <td>Virtual machine that executes bytecode</td>
                                                <td>Running Java programs</td>
                                            </tr>
                                            <tr>
                                                <td><strong>JRE</strong></td>
                                                <td>JVM + Java libraries</td>
                                                <td>Running Java programs</td>
                                            </tr>
                                            <tr>
                                                <td><strong>JDK</strong></td>
                                                <td>JRE + Development tools</td>
                                                <td>Developing Java programs</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Memory Tip:</strong> Think of it like building a house:
                                        <ul>
                                            <li><strong>JVM</strong> = The foundation (runs code)</li>
                                            <li><strong>JRE</strong> = Foundation + walls (can run programs)</li>
                                            <li><strong>JDK</strong> = Complete house with tools (can build and run
                                                programs)</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Platform Independence -->
                                    <h2>Platform Independence</h2>
                                    <p>Java's most powerful feature is platform independence, enabled by the JVM. Here's
                                        how it works:</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-compilation-process.svg"
                                        alt="Java Compilation Process" class="diagram-image"
                                        style="max-width: 700px; margin: 2rem auto; display: block;">

                                    <ol>
                                        <li><strong>Write:</strong> You write Java source code (.java files) on any
                                            platform</li>
                                        <li><strong>Compile:</strong> The JDK compiler (javac) converts .java to .class
                                            bytecode files</li>
                                        <li><strong>Distribute:</strong> Bytecode is platform-independent - the same
                                            .class files work everywhere</li>
                                        <li><strong>Run:</strong> JVM (platform-specific) interprets bytecode for the
                                            specific operating system</li>
                                    </ol>

                                    <div class="info-box">
                                        <strong>Example:</strong> You can write Java code on a Windows machine, compile
                                        it, and the resulting .class files will run on Linux, macOS, or any other
                                        platform with JVM installed - without any modifications!
                                    </div>

                                    <!-- Section 4: Java Versions -->
                                    <h2>Java Versions</h2>
                                    <p>Java has evolved significantly since its release. Here are some major milestones:
                                    </p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Version</th>
                                                <th>Year</th>
                                                <th>Key Features</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Java 1.0</td>
                                                <td>1996</td>
                                                <td>Initial release</td>
                                            </tr>
                                            <tr>
                                                <td>Java 5</td>
                                                <td>2004</td>
                                                <td>Generics, autoboxing, annotations</td>
                                            </tr>
                                            <tr>
                                                <td>Java 8</td>
                                                <td>2014</td>
                                                <td>Lambda expressions, Streams API, default methods</td>
                                            </tr>
                                            <tr>
                                                <td>Java 11</td>
                                                <td>2018</td>
                                                <td>LTS version, HTTP client, local variable syntax</td>
                                            </tr>
                                            <tr>
                                                <td>Java 17</td>
                                                <td>2021</td>
                                                <td>Current LTS, sealed classes, pattern matching</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>LTS Versions:</strong> Long Term Support (LTS) versions receive extended
                                        support and updates. Java 8, 11, and 17 are LTS versions and are widely used in
                                        production environments.
                                    </div>

                                    <!-- Section 5: Installation -->
                                    <h2>Installation</h2>
                                    <p>To start developing Java applications, you need to install the JDK. Here's how:
                                    </p>

                                    <h3>1. Download JDK</h3>
                                    <ul>
                                        <li>Visit <a href="https://www.oracle.com/java/technologies/downloads/"
                                                target="_blank" rel="noopener">Oracle's JDK download page</a> or</li>
                                        <li>Use <a href="https://adoptium.net/" target="_blank" rel="noopener">Eclipse
                                                Temurin (Adoptium)</a> for open-source JDK</li>
                                    </ul>

                                    <h3>2. Install JDK</h3>
                                    <ul>
                                        <li><strong>Windows:</strong> Run the installer and follow the wizard</li>
                                        <li><strong>macOS:</strong> Use Homebrew: <code>brew install openjdk@17</code>
                                        </li>
                                        <li><strong>Linux:</strong> Use package manager:
                                            <code>sudo apt install openjdk-17-jdk</code>
                                        </li>
                                    </ul>

                                    <h3>3. Verify Installation</h3>
                                    <p>Open terminal/command prompt and run:</p>
                                    <pre><code class="language-bash">java -version
javac -version</code></pre>

                                    <div class="tip-box">
                                        <strong>Environment Variables:</strong> Make sure <code>JAVA_HOME</code> is set
                                        to your JDK installation directory, and that the <code>bin</code> directory is
                                        in your <code>PATH</code> environment variable.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Confusing JDK with JRE</h4>
                                        <p><strong>Problem:</strong> Trying to compile Java code with only JRE installed
                                        </p>
                                        <pre><code class="language-bash"># Error: javac command not found
javac HelloWorld.java</code></pre>
                                        <p><strong>Solution:</strong> Install JDK (which includes JRE) to get the
                                            compiler</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Multiple Java Versions</h4>
                                        <p><strong>Problem:</strong> Having multiple Java versions installed without
                                            proper configuration</p>
                                        <p><strong>Solution:</strong> Use <code>JAVA_HOME</code> environment variable to
                                            specify which version to use, or use tools like <code>jenv</code>
                                            (macOS/Linux) to manage versions</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Java is a platform-independent, object-oriented programming language
                                            </li>
                                            <li><strong>JVM</strong> executes Java bytecode and is platform-specific
                                            </li>
                                            <li><strong>JRE</strong> = JVM + Java libraries (for running programs)</li>
                                            <li><strong>JDK</strong> = JRE + Development tools (for developing programs)
                                            </li>
                                            <li>Java's "Write Once, Run Anywhere" is enabled by bytecode and JVM</li>
                                            <li>Install JDK to develop Java applications</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what Java is and how it works, you're ready to write your
                                        first Java program! In the next lesson, you'll learn how to create a Java class,
                                        write the main method, and see your code come to life.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/first-program.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="" />
                                                <jsp:param name="prevTitle" value="" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="First Program →" />
                                                <jsp:param name="currentLessonId" value="intro" />
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