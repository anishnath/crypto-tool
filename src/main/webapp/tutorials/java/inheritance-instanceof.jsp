<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-instanceof");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java instanceof Operator - Type Checking Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn the Java instanceof operator for runtime type checking. Understand how to safely check object types and use pattern matching in Java 16+.">
    <meta name="keywords"
        content="java instanceof operator, java type checking, java instanceof pattern matching, java runtime type check, java object type">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java instanceof Operator Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master the instanceof operator in Java for safe type checking and casting.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-instanceof.jsp">
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
    "name": "Java instanceof Operator",
    "description": "Learn how to use the instanceof operator for type checking in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["instanceof operator", "Type Checking", "Safe Casting", "Pattern Matching"],
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

<body class="tutorial-body no-preview" data-lesson="inheritance-instanceof">
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
                    <span>instanceof Operator</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">The instanceof Operator</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>instanceof</code> operator is used to test whether an object is an instance of a specific class, subclass, or interface. It returns <code>true</code> or <code>false</code> and is essential for safe type casting.</p>

                    <!-- Section 1: Basic Syntax -->
                    <h2>Basic Syntax</h2>
                    <p>The <code>instanceof</code> operator checks if an object is of a particular type:</p>

                    <div class="code-box">
                        <pre><code class="language-java">object instanceof ClassName</code></pre>
                    </div>

                    <p>Returns <code>true</code> if the object is an instance of the specified class (or its subclasses), otherwise <code>false</code>.</p>

                    <div class="code-box">
                        <pre><code class="language-java">String text = "Hello";
Integer num = 42;

System.out.println(text instanceof String);   // true
System.out.println(num instanceof Integer);   // true
System.out.println(text instanceof Object);   // true (String IS-A Object)</code></pre>
                    </div>

                    <!-- Section 2: With Inheritance -->
                    <h2>instanceof with Inheritance</h2>
                    <p>The <code>instanceof</code> operator checks the entire inheritance hierarchy. If a class extends another, <code>instanceof</code> returns <code>true</code> for both the class and its parent.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal { }
class Dog extends Animal { }
class Cat extends Animal { }

Dog myDog = new Dog();

System.out.println(myDog instanceof Dog);     // true
System.out.println(myDog instanceof Animal);  // true (Dog IS-A Animal)
System.out.println(myDog instanceof Object);  // true (Everything IS-A Object)
System.out.println(myDog instanceof Cat);     // false</code></pre>
                    </div>

                    <!-- Section 3: Safe Casting -->
                    <h2>Safe Type Casting with instanceof</h2>
                    <p>The primary use of <code>instanceof</code> is to ensure safe downcasting. Without it, you risk a <code>ClassCastException</code> at runtime.</p>

                    <div class="code-box">
                        <pre><code class="language-java">Animal animal = new Dog();  // Upcasting (safe)

// Unsafe downcasting without check
// Dog dog = (Dog) animal;  // Works here, but risky!

// Safe downcasting with instanceof
if (animal instanceof Dog) {
    Dog dog = (Dog) animal;  // Safe to cast
    dog.bark();
}</code></pre>
                    </div>

                    <div class="warning-box">
                        <strong>Without instanceof check:</strong>
                        <pre><code class="language-java">Animal animal = new Cat();
Dog dog = (Dog) animal;  // ClassCastException at runtime!</code></pre>
                    </div>

                    <!-- Section 4: Pattern Matching (Java 16+) -->
                    <h2>Pattern Matching for instanceof (Java 16+)</h2>
                    <p>Java 16 introduced pattern matching, which combines the type check and cast in one step:</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Traditional way (before Java 16)
if (animal instanceof Dog) {
    Dog dog = (Dog) animal;
    dog.bark();
}

// Pattern matching (Java 16+)
if (animal instanceof Dog dog) {
    // 'dog' is automatically cast and available here
    dog.bark();
}</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Tip:</strong> Pattern matching reduces boilerplate code and eliminates the need for explicit casting after the instanceof check.
                    </div>

                    <!-- Section 5: null Handling -->
                    <h2>instanceof and null</h2>
                    <p>The <code>instanceof</code> operator safely handles <code>null</code> values - it always returns <code>false</code> for null.</p>

                    <div class="code-box">
                        <pre><code class="language-java">String str = null;

System.out.println(str instanceof String);  // false (not true, not exception!)
System.out.println(str instanceof Object);  // false

// This makes instanceof perfect for null-safe checks
if (str instanceof String) {
    // This block won't execute if str is null
    System.out.println(str.length());
}</code></pre>
                    </div>

                    <!-- Section 6: With Interfaces -->
                    <h2>instanceof with Interfaces</h2>
                    <p>You can also use <code>instanceof</code> to check if an object implements a particular interface:</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Flyable {
    void fly();
}

class Bird implements Flyable {
    public void fly() {
        System.out.println("Bird is flying");
    }
}

Bird bird = new Bird();
System.out.println(bird instanceof Flyable);  // true
System.out.println(bird instanceof Bird);     // true</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/InstanceofOperator.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-instanceof" />
                    </jsp:include>

                    <!-- Section 7: Practical Use Cases -->
                    <h2>Practical Use Cases</h2>
                    <ul>
                        <li><strong>Processing heterogeneous collections:</strong> When you have a list of parent type objects that may be different subclass types</li>
                        <li><strong>equals() method implementation:</strong> Checking if the compared object is of the same type</li>
                        <li><strong>Factory patterns:</strong> Determining object types before processing</li>
                        <li><strong>Event handling:</strong> Checking event source types</li>
                    </ul>

                    <div class="code-box">
                        <pre><code class="language-java">// Example: Processing different types
for (Object obj : mixedList) {
    if (obj instanceof String s) {
        System.out.println("String length: " + s.length());
    } else if (obj instanceof Integer i) {
        System.out.println("Integer value: " + i);
    } else if (obj instanceof Double d) {
        System.out.println("Double value: " + d);
    }
}</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Casting without checking:</strong> Always use instanceof before downcasting to avoid ClassCastException</li>
                            <li><strong>Overusing instanceof:</strong> Excessive use may indicate poor design - consider polymorphism instead</li>
                            <li><strong>Forgetting null case:</strong> While instanceof handles null safely, explicit null checks may be clearer in some cases</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><code>instanceof</code> tests if an object is an instance of a class or interface</li>
                            <li>Returns <code>true</code> for the exact class AND all parent classes/interfaces</li>
                            <li>Returns <code>false</code> for null (safe, no exception)</li>
                            <li>Essential for safe downcasting to avoid ClassCastException</li>
                            <li>Java 16+ pattern matching combines check and cast: <code>if (obj instanceof Type t)</code></li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-overriding.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-object-class.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="Method Overriding" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Object Class" />
                            <jsp:param name="currentLessonId" value="inheritance-instanceof" />
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
