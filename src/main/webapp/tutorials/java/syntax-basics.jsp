<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "syntax-basics" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Syntax Basics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Java syntax basics: statements, blocks, semicolons, whitespace, comments (//, /* */, /** */), and naming conventions. Essential Java syntax rules.">
            <meta name="keywords"
                content="java syntax, java statements, java blocks, java comments, java naming conventions, java semicolons, java code style">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Syntax Basics - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Learn the fundamental syntax rules of Java programming.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/syntax-basics.jsp">
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
        "name": "Java Syntax Basics",
        "description": "Learn Java syntax basics: statements, blocks, semicolons, whitespace, comments, and naming conventions.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Java statements", "Code blocks", "Comments", "Semicolons", "Naming conventions"],
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

        <body class="tutorial-body no-preview" data-lesson="syntax-basics">
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
                                    <span>Syntax Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Syntax Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Understanding Java syntax is essential for writing correct, readable
                                        code. In this lesson, you'll learn about statements, code blocks, semicolons,
                                        whitespace handling, comments, and Java naming conventions. These fundamental
                                        rules form the foundation of all Java programming.</p>

                                    <!-- Section 1: Statements -->
                                    <h2>Statements</h2>
                                    <p>A <strong>statement</strong> is a complete instruction that performs an action.
                                        In Java, statements must end with a semicolon (<code>;</code>).</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-statements.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-statements" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Statement Types:</strong>
                                        <ul>
                                            <li><strong>Declaration statements:</strong> Declare variables (e.g.,
                                                <code>int x;</code>)
                                            </li>
                                            <li><strong>Expression statements:</strong> Assignments or method calls
                                                (e.g., <code>x = 5;</code>)</li>
                                            <li><strong>Control statements:</strong> Control flow (if, for, while, etc.)
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: Semicolons -->
                                    <h2>Semicolons</h2>
                                    <p>In Java, almost every statement must end with a semicolon. The semicolon tells
                                        the compiler where one statement ends and the next begins.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-semicolons.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-semicolons" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Missing semicolons cause compilation errors. The
                                        compiler will report an error like <code>';' expected</code>. However, class and
                                        method declarations don't need semicolons after their closing braces.
                                    </div>

                                    <!-- Section 3: Code Blocks -->
                                    <h2>Code Blocks</h2>
                                    <p>A <strong>block</strong> is a group of statements enclosed in curly braces
                                        <code>{}</code>. Blocks define scope and group related statements together.
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-blocks.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-blocks" />
                                    </jsp:include>

                                    <h3>Block Rules</h3>
                                    <ul>
                                        <li>Blocks start with <code>{</code> and end with <code>}</code></li>
                                        <li>Variables declared inside a block are only accessible within that block
                                            (scope)</li>
                                        <li>Blocks can be nested (a block inside another block)</li>
                                        <li>Opening brace can be on the same line or next line (style preference)</li>
                                    </ul>

                                    <div class="tip-box">
                                        <strong>Brace Style:</strong> Two common styles:
                                        <ul>
                                            <li><strong>Same-line:</strong> <code>if (condition) {</code> (K&R style)
                                            </li>
                                            <li><strong>Next-line:</strong> <code>if (condition)\n{</code> (Allman
                                                style)</li>
                                        </ul>
                                        Choose one style and be consistent throughout your code.
                                    </div>

                                    <!-- Section 4: Whitespace -->
                                    <h2>Whitespace</h2>
                                    <p>Java is generally <strong>whitespace-insensitive</strong> - extra spaces, tabs,
                                        and blank lines are mostly ignored by the compiler. However, whitespace is
                                        important for code readability.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-whitespace.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-whitespace" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Whitespace Type</th>
                                                <th>Usage</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Spaces</td>
                                                <td>Separate tokens, improve readability</td>
                                                <td><code>int x = 5;</code> vs <code>int x=5;</code> (both valid, first
                                                    is clearer)</td>
                                            </tr>
                                            <tr>
                                                <td>Tabs</td>
                                                <td>Indentation (typically converted to spaces)</td>
                                                <td>Used for code indentation</td>
                                            </tr>
                                            <tr>
                                                <td>Newlines</td>
                                                <td>Separate statements, improve readability</td>
                                                <td>One statement per line is standard practice</td>
                                            </tr>
                                            <tr>
                                                <td>Blank lines</td>
                                                <td>Separate logical sections</td>
                                                <td>Improve code organization</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use consistent indentation (typically 4 spaces
                                        or 1 tab). Most IDEs can automatically format your code according to your
                                        preferences.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 5: Comments -->
                                    <h2>Comments</h2>
                                    <p>Comments are notes in your code that the compiler ignores. They help document
                                        your code for yourself and other programmers. Java supports three types of
                                        comments:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-comments.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-comments" />
                                    </jsp:include>

                                    <h3>Comment Types</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Use Case</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Single-line</td>
                                                <td><code>//</code></td>
                                                <td>Short notes, inline explanations</td>
                                                <td><code>// This is a comment</code></td>
                                            </tr>
                                            <tr>
                                                <td>Multi-line</td>
                                                <td><code>/* */</code></td>
                                                <td>Block of comments, longer explanations</td>
                                                <td><code>/* This is a\nmulti-line comment */</code></td>
                                            </tr>
                                            <tr>
                                                <td>JavaDoc</td>
                                                <td><code>/** */</code></td>
                                                <td>Documentation comments (generates API docs)</td>
                                                <td><code>/** This is JavaDoc */</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>JavaDoc Comments</h3>
                                    <p>JavaDoc comments start with <code>/**</code> and are used to generate HTML
                                        documentation. They can include special tags like <code>@param</code>,
                                        <code>@return</code>, <code>@author</code>, etc.
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-javadoc.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-javadoc" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>When to Comment:</strong>
                                        <ul>
                                            <li>Explain <em>why</em> you're doing something (not <em>what</em> - code
                                                should be self-explanatory)</li>
                                            <li>Document complex algorithms or business logic</li>
                                            <li>Provide usage examples for methods</li>
                                            <li>Note temporary workarounds or known issues</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Don't Over-Comment:</strong> Avoid comments that just repeat what the
                                        code does. <code>int x = 5; // Set x to 5</code> is a bad comment - it's obvious
                                        from the code.
                                    </div>

                                    <!-- Section 6: Naming Conventions -->
                                    <h2>Naming Conventions</h2>
                                    <p>Java has established naming conventions that make code more readable and
                                        maintainable. While not enforced by the compiler, following these conventions is
                                        essential for professional Java development.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-naming.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-naming" />
                                    </jsp:include>

                                    <h3>Java Naming Rules</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Element</th>
                                                <th>Convention</th>
                                                <th>Example</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Class names</td>
                                                <td>PascalCase</td>
                                                <td><code>HelloWorld</code>, <code>BankAccount</code></td>
                                                <td>Each word capitalized, no underscores</td>
                                            </tr>
                                            <tr>
                                                <td>Method names</td>
                                                <td>camelCase</td>
                                                <td><code>calculateTotal()</code>, <code>getUserName()</code></td>
                                                <td>First word lowercase, subsequent words capitalized</td>
                                            </tr>
                                            <tr>
                                                <td>Variable names</td>
                                                <td>camelCase</td>
                                                <td><code>userName</code>, <code>totalAmount</code></td>
                                                <td>Same as method names</td>
                                            </tr>
                                            <tr>
                                                <td>Constants</td>
                                                <td>UPPER_SNAKE_CASE</td>
                                                <td><code>MAX_SIZE</code>, <code>DEFAULT_VALUE</code></td>
                                                <td>All uppercase, words separated by underscores</td>
                                            </tr>
                                            <tr>
                                                <td>Package names</td>
                                                <td>lowercase</td>
                                                <td><code>com.example.util</code></td>
                                                <td>All lowercase, dots separate words</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Identifier Rules</h3>
                                    <p>Identifiers (names for classes, methods, variables) must follow these rules:</p>
                                    <ul>
                                        <li>Must start with a letter (a-z, A-Z), underscore (_), or dollar sign ($)</li>
                                        <li>Can contain letters, digits (0-9), underscores, and dollar signs</li>
                                        <li>Cannot be Java keywords (like <code>class</code>, <code>int</code>,
                                            <code>void</code>)
                                        </li>
                                        <li>Case-sensitive (<code>myVar</code> and <code>MyVar</code> are different)
                                        </li>
                                        <li>No length limit, but keep them reasonable and meaningful</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/syntax-identifiers.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-identifiers" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Good Naming:</strong>
                                        <ul>
                                            <li>Use descriptive names: <code>calculateTotal()</code> instead of
                                                <code>calc()</code>
                                            </li>
                                            <li>Use verbs for methods: <code>getUser()</code>, <code>setName()</code>,
                                                <code>calculatePrice()</code>
                                            </li>
                                            <li>Use nouns for variables: <code>userName</code>, <code>totalPrice</code>,
                                                <code>isValid</code>
                                            </li>
                                            <li>Avoid abbreviations unless well-known: <code>calculateTotal()</code> not
                                                <code>calcTot()</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Missing semicolons</h4>
                                        <pre><code class="language-java">// Wrong
int x = 5
System.out.println(x)

// Correct
int x = 5;
System.out.println(x);</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mismatched braces</h4>
                                        <pre><code class="language-java">// Wrong - missing closing brace
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello");
    // Missing }

// Correct
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello");
    }
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using keywords as identifiers</h4>
                                        <pre><code class="language-java">// Wrong - 'class' is a keyword
int class = 5;  // Error!

// Wrong - 'void' is a keyword
String void = "test";  // Error!

// Correct - use descriptive names
int studentClass = 5;
String returnValue = "test";</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Starting identifiers with numbers</h4>
                                        <pre><code class="language-java">// Wrong
int 2value = 5;  // Error!

// Correct
int value2 = 5;
int secondValue = 5;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>5. Inconsistent naming</h4>
                                        <pre><code class="language-java">// Wrong - mixing conventions
int UserName = "John";  // Should be camelCase
int user_name = "John";  // Should be camelCase, not snake_case

// Correct
int userName = "John";</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Fix the Code</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix all syntax errors and follow Java naming
                                            conventions!</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fix missing semicolons</li>
                                            <li>Fix mismatched braces</li>
                                            <li>Use proper naming conventions</li>
                                            <li>Add appropriate comments</li>
                                            <li>Make the code compile and run</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="java/exercises/ex-syntax-basics.java" />
                                            <jsp:param name="language" value="java" />
                                            <jsp:param name="editorId" value="exercise-syntax" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>💡 Hint</summary>
                                            <p>Check for: missing semicolons, proper class name matching filename,
                                                correct brace placement, and camelCase for variables.</p>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Statements must end with a semicolon (<code>;</code>)</li>
                                            <li>Code blocks are enclosed in curly braces <code>{}</code></li>
                                            <li>Java is whitespace-insensitive but use whitespace for readability</li>
                                            <li>Three comment types: <code>//</code> (single-line), <code>/* */</code>
                                                (multi-line), <code>/** */</code> (JavaDoc)</li>
                                            <li>Class names: PascalCase (e.g., <code>HelloWorld</code>)</li>
                                            <li>Methods and variables: camelCase (e.g., <code>userName</code>)</li>
                                            <li>Constants: UPPER_SNAKE_CASE (e.g., <code>MAX_SIZE</code>)</li>
                                            <li>Identifiers must start with a letter, underscore, or dollar sign</li>
                                            <li>Cannot use Java keywords as identifiers</li>
                                            <li>Java is case-sensitive</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Great! You now understand the fundamental syntax rules of Java. In the next
                                        module, you'll learn about variables and data types - the building blocks for
                                        storing and manipulating data in your Java programs.</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/first-program.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/types-primitives.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← First Program" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Module 2: Primitive Types →" />
                                                <jsp:param name="currentLessonId" value="syntax-basics" />
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