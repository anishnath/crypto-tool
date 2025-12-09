<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-overriding");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Method Overriding - @Override Annotation Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn method overriding in Java with @Override annotation. Understand runtime polymorphism, dynamic method dispatch, and overriding rules.">
    <meta name="keywords"
        content="java method overriding, java @Override annotation, java runtime polymorphism, java dynamic method dispatch, java override rules">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Method Overriding Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master method overriding in Java. Learn the rules, best practices, and how it enables polymorphism.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-overriding.jsp">
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
    "name": "Java Method Overriding",
    "description": "Learn how to override methods in Java subclasses and understand runtime polymorphism.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Method Overriding", "@Override Annotation", "Runtime Polymorphism", "Dynamic Method Dispatch"],
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

<body class="tutorial-body no-preview" data-lesson="inheritance-overriding">
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
                    <span>Method Overriding</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Method Overriding</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~35 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Method overriding allows a subclass to provide a specific implementation of a method that is already defined in its parent class. This is a key feature that enables runtime polymorphism in Java.</p>

                    <!-- Section 1: What is Method Overriding? -->
                    <h2>What is Method Overriding?</h2>
                    <p>When a subclass defines a method with the <strong>same name, return type, and parameters</strong> as a method in its parent class, it <strong>overrides</strong> the parent's method. The subclass version is called instead of the parent version when invoked on a subclass object.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal {
    void makeSound() {
        System.out.println("Some generic sound");
    }
}

class Dog extends Animal {
    @Override  // Annotation indicating override
    void makeSound() {
        System.out.println("Woof! Woof!");
    }
}

class Cat extends Animal {
    @Override
    void makeSound() {
        System.out.println("Meow!");
    }
}</code></pre>
                    </div>

                    <!-- Section 2: The @Override Annotation -->
                    <h2>The <code>@Override</code> Annotation</h2>
                    <p>The <code>@Override</code> annotation tells the compiler that you intend to override a method from the parent class. While optional, it's highly recommended because:</p>
                    <ul>
                        <li>The compiler will catch errors if the method doesn't actually override anything</li>
                        <li>It makes your code more readable and documents your intent</li>
                        <li>It catches typos in method names or incorrect parameter types</li>
                    </ul>

                    <div class="code-box">
                        <pre><code class="language-java">class Parent {
    void display() {
        System.out.println("Parent display");
    }
}

class Child extends Parent {
    @Override
    void display() {  // Correctly overrides
        System.out.println("Child display");
    }

    // @Override
    // void disply() { }  // Compiler error! "disply" doesn't exist in parent
}</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Always use <code>@Override</code> when overriding methods. It's a free compile-time check that prevents bugs.
                    </div>

                    <!-- Section 3: Rules for Method Overriding -->
                    <h2>Rules for Method Overriding</h2>
                    <p>For a method to correctly override a parent method:</p>

                    <div class="info-box">
                        <ol>
                            <li><strong>Same method name</strong></li>
                            <li><strong>Same parameter list</strong> (number, type, and order)</li>
                            <li><strong>Same or covariant return type</strong> (subtype of parent's return type)</li>
                            <li><strong>Access modifier</strong> must be same or less restrictive</li>
                            <li><strong>Cannot override</strong> <code>final</code>, <code>static</code>, or <code>private</code> methods</li>
                        </ol>
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">class Parent {
    protected Number getValue() {
        return 10;
    }
}

class Child extends Parent {
    @Override
    public Integer getValue() {  // Valid: Integer is subtype of Number
        return 20;               // public is less restrictive than protected
    }
}</code></pre>
                    </div>

                    <!-- Section 4: Dynamic Method Dispatch -->
                    <h2>Dynamic Method Dispatch (Runtime Polymorphism)</h2>
                    <p>When you call an overridden method using a parent type reference pointing to a child object, Java determines which version to call <strong>at runtime</strong> based on the actual object type. This is called <strong>dynamic method dispatch</strong>.</p>

                    <!-- Visual: Method Overriding Diagram -->
                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-method-overriding.svg"
                             alt="Java Method Overriding Diagram showing parent and child class method implementations"
                             style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">Animal animal1 = new Dog();   // Parent reference, Child object
Animal animal2 = new Cat();   // Parent reference, Child object

animal1.makeSound();  // Output: "Woof! Woof!" - Dog's method
animal2.makeSound();  // Output: "Meow!" - Cat's method

// The actual method called depends on the OBJECT type, not reference type</code></pre>
                    </div>

                    <!-- Section 5: Overriding vs Overloading -->
                    <h2>Overriding vs Overloading</h2>
                    <table class="comparison-table">
                        <thead>
                            <tr>
                                <th>Method Overriding</th>
                                <th>Method Overloading</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Same method signature in subclass</td>
                                <td>Different parameters in same class</td>
                            </tr>
                            <tr>
                                <td>Requires inheritance (parent-child)</td>
                                <td>Can be in same class</td>
                            </tr>
                            <tr>
                                <td>Resolved at <strong>runtime</strong></td>
                                <td>Resolved at <strong>compile time</strong></td>
                            </tr>
                            <tr>
                                <td>Return type must be same or covariant</td>
                                <td>Return type can be different</td>
                            </tr>
                            <tr>
                                <td>Used for runtime polymorphism</td>
                                <td>Used for compile-time polymorphism</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/MethodOverriding.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-override" />
                    </jsp:include>

                    <!-- Section 6: What Cannot Be Overridden -->
                    <h2>What Cannot Be Overridden</h2>
                    <ul>
                        <li><strong><code>final</code> methods:</strong> Declared to prevent overriding</li>
                        <li><strong><code>static</code> methods:</strong> Belong to class, not instance (can be hidden, not overridden)</li>
                        <li><strong><code>private</code> methods:</strong> Not visible to subclass</li>
                        <li><strong>Constructors:</strong> Not inherited, so cannot be overridden</li>
                    </ul>

                    <div class="code-box">
                        <pre><code class="language-java">class Parent {
    final void finalMethod() { }     // Cannot override
    static void staticMethod() { }   // Cannot override (can hide)
    private void privateMethod() { } // Cannot override (not visible)
}</code></pre>
                    </div>

                    <!-- Section 7: Calling Parent's Overridden Method -->
                    <h2>Calling the Parent's Version</h2>
                    <p>Use <code>super.methodName()</code> to call the parent's version of an overridden method.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Employee {
    void work() {
        System.out.println("Working on general tasks");
    }
}

class Developer extends Employee {
    @Override
    void work() {
        super.work();  // Call parent's work() first
        System.out.println("Writing code");
    }
}</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Changing parameter types:</strong> This creates overloading, not overriding</li>
                            <li><strong>Using more restrictive access:</strong> Cannot make public method private in subclass</li>
                            <li><strong>Forgetting @Override:</strong> Typos in method names go undetected</li>
                            <li><strong>Trying to override static methods:</strong> Static methods are hidden, not overridden</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li>Method overriding provides a new implementation of an inherited method</li>
                            <li>Use <code>@Override</code> annotation for compile-time safety</li>
                            <li>Same name, parameters, and compatible return type required</li>
                            <li>Access modifier must be same or less restrictive</li>
                            <li>Dynamic method dispatch determines which version to call at runtime</li>
                            <li><code>final</code>, <code>static</code>, and <code>private</code> methods cannot be overridden</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-super.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-instanceof.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="super Keyword" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="instanceof Operator" />
                            <jsp:param name="currentLessonId" value="inheritance-overriding" />
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
