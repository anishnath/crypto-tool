<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-packages"); request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Code Organization in Java - Java Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Java code organization: packages, package naming conventions, import statements, access modifiers with packages, and JAR files. Professional Java development practices.">
    <meta name="keywords"
        content="java packages, java code organization, package naming, import statements, java jar files, access modifiers packages">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Code Organization in Java - Java Tutorial | 8gwifi.org">
    <meta property="og:description" content="Learn how to organize Java code using packages and JAR files.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/practices-packages.jsp">
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
        "name": "Code Organization in Java",
        "description": "Learn Java code organization: packages, package naming conventions, import statements, access modifiers with packages, and JAR files.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Java packages", "Package naming", "Import statements", "Access modifiers", "JAR files"],
        "timeRequired": "PT35M",
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

<body class="tutorial-body no-preview" data-lesson="practices-packages">
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
                    <span>Code Organization</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Code Organization</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~35 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Well-organized code is essential for maintainable and scalable Java applications. Packages help organize related classes into logical groups, making code easier to navigate, understand, and reuse. In this lesson, you'll learn about packages, import statements, package naming conventions, access modifiers in the context of packages, and how to distribute code using JAR files.</p>

                    <!-- Section 1: What are Packages? -->
                    <h2>What are Packages?</h2>
                    <p>A <strong>package</strong> is a namespace that organizes related classes and interfaces. It's similar to folders on your computer—packages help organize your code and prevent naming conflicts.</p>

                    <div class="info-box">
                        <h4>Benefits of Packages</h4>
                        <ul>
                            <li><strong>Organization:</strong> Group related classes together</li>
                            <li><strong>Namespace:</strong> Prevent naming conflicts (two classes can have the same name in different packages)</li>
                            <li><strong>Access Control:</strong> Package-private access allows classes in the same package to access each other</li>
                            <li><strong>Reusability:</strong> Easier to share and reuse code across projects</li>
                        </ul>
                    </div>

                    <h3>Package Declaration</h3>
                    <p>Package declaration must be the first non-comment statement in a Java file:</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/practices-packages.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-packages" />
                    </jsp:include>

                    <!-- Section 2: Package Naming Conventions -->
                    <h2>Package Naming Conventions</h2>
                    <p>Java follows a reverse domain name convention for package naming to ensure uniqueness:</p>

                    <pre><code class="language-java">// Use reverse domain name
package com.example.util;        // com.example is the domain
package org.apache.commons.io;   // org.apache is the domain
package net.mycompany.tools;     // net.mycompany is the domain

// All lowercase
package com.mycompany.MyPackage;  // Wrong - uppercase
package com.mycompany.mypackage;  // Correct

// Use singular nouns
package com.example.utilities;    // Acceptable
package com.example.util;         // Better - shorter, clearer</code></pre>

                    <div class="tip-box">
                        <h4>Package Naming Rules</h4>
                        <ul>
                            <li>Use reverse domain name (e.g., <code>com.company.project</code>)</li>
                            <li>All lowercase letters</li>
                            <li>No underscores or hyphens (use camelCase if needed)</li>
                            <li>Use meaningful, short names</li>
                            <li>Package name should match directory structure</li>
                        </ul>
                    </div>

                    <!-- Section 3: Import Statements -->
                    <h2>Import Statements</h2>
                    <p><strong>Import statements</strong> tell Java which classes from other packages you want to use. They appear after the package declaration and before the class declaration.</p>

                    <pre><code class="language-java">package com.example.app;

// Import specific class
import java.util.ArrayList;
import java.util.List;

// Import all classes from a package (not recommended)
import java.util.*;

// Static import (for static members)
import static java.lang.Math.PI;
import static java.lang.Math.pow;

// Using fully qualified name (no import needed)
java.util.Date date = new java.util.Date();</code></pre>

                    <div class="warning-box">
                        <h4>Avoid Wildcard Imports</h4>
                        <p>Using <code>import java.util.*;</code> imports all classes from that package, which can lead to naming conflicts. It's better to import specific classes you need.</p>
                    </div>

                    <!-- Section 4: Access Modifiers with Packages -->
                    <h2>Access Modifiers with Packages</h2>
                    <p>Access modifiers control visibility of classes, methods, and variables. In the context of packages:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Modifier</th>
                                <th>Same Class</th>
                                <th>Same Package</th>
                                <th>Subclass (Different Package)</th>
                                <th>Different Package</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>private</code></td>
                                <td>✓</td>
                                <td>✗</td>
                                <td>✗</td>
                                <td>✗</td>
                            </tr>
                            <tr>
                                <td><code>default</code> (package-private)</td>
                                <td>✓</td>
                                <td>✓</td>
                                <td>✗</td>
                                <td>✗</td>
                            </tr>
                            <tr>
                                <td><code>protected</code></td>
                                <td>✓</td>
                                <td>✓</td>
                                <td>✓</td>
                                <td>✗</td>
                            </tr>
                            <tr>
                                <td><code>public</code></td>
                                <td>✓</td>
                                <td>✓</td>
                                <td>✓</td>
                                <td>✓</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-java">package com.example.util;

public class UtilClass {
    private int privateVar;      // Only accessible within this class
    int packageVar;              // Accessible within same package
    protected int protectedVar;  // Accessible in same package and subclasses
    public int publicVar;        // Accessible everywhere
}</code></pre>

                    <!-- Section 5: JAR Files -->
                    <h2>JAR Files</h2>
                    <p>A <strong>JAR</strong> (Java Archive) file is a package format used to aggregate many Java class files and associated metadata into a single file for distribution.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/practices-jar.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-jar" />
                    </jsp:include>

                    <h3>Creating a JAR File</h3>
                    <p>To create a JAR file from compiled classes:</p>

                    <pre><code class="language-bash"># Compile Java files
javac -d . Calculator.java

# Create JAR file
jar cvf calculator.jar com/example/library/

# View contents of JAR
jar tf calculator.jar

# Extract JAR contents
jar xf calculator.jar</code></pre>

                    <div class="tip-box">
                        <h4>JAR File Commands</h4>
                        <ul>
                            <li><code>c</code> - Create archive</li>
                            <li><code>v</code> - Verbose output</li>
                            <li><code>f</code> - Specify filename</li>
                            <li><code>t</code> - List table of contents</li>
                            <li><code>x</code> - Extract files</li>
                        </ul>
                    </div>

                    <!-- Section 6: Directory Structure -->
                    <h2>Package Directory Structure</h2>
                    <p>Package names must match the directory structure. For a package <code>com.example.util</code>, the directory structure should be:</p>

                    <pre><code class="language-plaintext">project-root/
└── src/
    └── com/
        └── example/
            └── util/
                └── UtilClass.java</code></pre>

                    <p>The fully qualified name of <code>UtilClass</code> would be <code>com.example.util.UtilClass</code>.</p>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Package name doesn't match directory structure</h4>
                        <pre><code class="language-java">// File is at: src/com/example/MyClass.java
// But package declaration is:
package com.example.util;  // Wrong! Directory doesn't match

// Correct:
package com.example;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using uppercase in package names</h4>
                        <pre><code class="language-java">// Wrong
package com.example.MyPackage;
package com.example.my_package;

// Correct
package com.example.mypackage;
package com.example.util;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Missing package declaration</h4>
                        <pre><code class="language-java">// Wrong - class in default package
// No package declaration
public class MyClass {
    // ...
}

// Correct - explicit package
package com.example;
public class MyClass {
    // ...
}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Import conflicts</h4>
                        <pre><code class="language-java">// Wrong - ambiguous imports
import java.util.Date;
import java.sql.Date;  // Error! Both have Date class

// Correct - use fully qualified name
import java.util.Date;
java.sql.Date sqlDate = new java.sql.Date(...);</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a Package Structure</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a package structure for a library management system:</p>
                        <ul>
                            <li>Create package <code>com.mylibrary.model</code> with a <code>Book</code> class</li>
                            <li>Create package <code>com.mylibrary.service</code> with a <code>BookService</code> class</li>
                            <li>Import and use the <code>Book</code> class in <code>BookService</code></li>
                            <li>Use appropriate access modifiers</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="java/exercises/ex-practices-packages.java" />
                            <jsp:param name="language" value="java" />
                            <jsp:param name="editorId" value="compiler-exercise" />
                        </jsp:include>

                        <details class="solution-box">
                            <summary>Show Solution</summary>
                            <pre><code class="language-java">// Book.java in com.mylibrary.model package
package com.mylibrary.model;

public class Book {
    private String title;
    private String author;
    
    public Book(String title, String author) {
        this.title = title;
        this.author = author;
    }
    
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
}

// BookService.java in com.mylibrary.service package
package com.mylibrary.service;
import com.mylibrary.model.Book;

public class BookService {
    public void displayBook(Book book) {
        System.out.println("Title: " + book.getTitle());
        System.out.println("Author: " + book.getAuthor());
    }
}</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h2>Summary</h2>
                        <ul>
                            <li>Packages organize related classes and prevent naming conflicts</li>
                            <li>Package names use reverse domain convention (e.g., <code>com.example.util</code>)</li>
                            <li>Package names must be lowercase and match directory structure</li>
                            <li>Import statements allow using classes from other packages</li>
                            <li>Access modifiers control visibility across packages</li>
                            <li>Default (package-private) access allows same-package access</li>
                            <li>JAR files package compiled classes for distribution</li>
                            <li>Use specific imports instead of wildcard imports when possible</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <h2>What's Next?</h2>
                    <p>Now that you understand code organization, the next lesson covers <strong>Unit Testing</strong> with JUnit, which shows you how to write and run automated tests for your Java code.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <%
                    String prevLinkUrl = request.getContextPath() + "/tutorials/java/advanced-datetime.jsp";
                    String nextLinkUrl = request.getContextPath() + "/tutorials/java/practices-junit.jsp";
                %>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                    <jsp:param name="prevTitle" value="← Date & Time API" />
                    <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                    <jsp:param name="nextTitle" value="Unit Testing →" />
                                    <jsp:param name="currentLessonId" value="practices-packages" />
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

