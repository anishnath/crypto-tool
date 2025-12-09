<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-basics");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Inheritance - extends Keyword Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Java inheritance using the extends keyword. Understand superclass, subclass, IS-A relationship, and code reuse in object-oriented programming.">
    <meta name="keywords"
        content="java inheritance, java extends keyword, java superclass subclass, java IS-A relationship, java OOP inheritance, java code reuse">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Inheritance - extends Keyword Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master inheritance in Java. Learn how to create class hierarchies and reuse code effectively.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-basics.jsp">
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
    "name": "Java Inheritance",
    "description": "Learn how to use inheritance in Java to create class hierarchies and reuse code.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["extends keyword", "Superclass and Subclass", "IS-A Relationship", "Code Reuse"],
    "timeRequired": "PT30M",
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

<body class="tutorial-body no-preview" data-lesson="inheritance-basics">
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
                    <span>Inheritance</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Inheritance in Java</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Inheritance is one of the four pillars of Object-Oriented Programming. It allows a class to inherit fields and methods from another class, promoting code reuse and establishing a natural hierarchy between classes.</p>

                    <!-- Section 1: What is Inheritance? -->
                    <h2>What is Inheritance?</h2>
                    <p>Inheritance is a mechanism where a new class (called a <strong>subclass</strong> or <strong>child class</strong>) is derived from an existing class (called a <strong>superclass</strong> or <strong>parent class</strong>). The subclass inherits all non-private fields and methods from the superclass.</p>

                    <div class="info-box">
                        <strong>Key Terms:</strong>
                        <ul>
                            <li><strong>Superclass (Parent):</strong> The class being inherited from</li>
                            <li><strong>Subclass (Child):</strong> The class that inherits</li>
                            <li><strong>extends:</strong> The keyword used to inherit from a class</li>
                        </ul>
                    </div>

                    <!-- Section 2: The extends Keyword -->
                    <h2>The <code>extends</code> Keyword</h2>
                    <p>In Java, you use the <code>extends</code> keyword to inherit from a class.</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Superclass (Parent)
class Animal {
    String name;

    void eat() {
        System.out.println(name + " is eating.");
    }

    void sleep() {
        System.out.println(name + " is sleeping.");
    }
}

// Subclass (Child) - inherits from Animal
class Dog extends Animal {
    void bark() {
        System.out.println(name + " says: Woof!");
    }
}</code></pre>
                    </div>

                    <p>In this example, <code>Dog</code> inherits all non-private members from <code>Animal</code>. A <code>Dog</code> object can use <code>eat()</code>, <code>sleep()</code>, AND its own <code>bark()</code> method.</p>

                    <!-- Section 3: IS-A Relationship -->
                    <h2>The IS-A Relationship</h2>
                    <p>Inheritance establishes an <strong>IS-A relationship</strong>. If <code>Dog extends Animal</code>, then we can say "a Dog IS-A Animal". This relationship is fundamental to polymorphism.</p>

                    <div class="code-box">
                        <pre><code class="language-java">Dog myDog = new Dog();
myDog.name = "Buddy";

// Dog IS-A Animal, so Dog can do everything Animal can do
myDog.eat();    // Inherited from Animal
myDog.sleep();  // Inherited from Animal
myDog.bark();   // Defined in Dog</code></pre>
                    </div>

                    <!-- Section 4: What Gets Inherited? -->
                    <h2>What Gets Inherited?</h2>
                    <p>A subclass inherits:</p>
                    <ul>
                        <li><code>public</code> members - accessible everywhere</li>
                        <li><code>protected</code> members - accessible in subclass and same package</li>
                        <li>Default (package-private) members - only if subclass is in same package</li>
                    </ul>

                    <div class="warning-box">
                        <strong>Not Inherited:</strong>
                        <ul>
                            <li><code>private</code> members - never accessible directly in subclass</li>
                            <li>Constructors - not inherited, but can be called using <code>super()</code></li>
                        </ul>
                    </div>

                    <!-- Section 5: Single Inheritance -->
                    <h2>Single Inheritance in Java</h2>
                    <p>Java supports <strong>single inheritance</strong> only - a class can extend only ONE other class. This avoids the complexity of the "diamond problem" found in languages with multiple inheritance.</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Valid - single inheritance
class Dog extends Animal { }

// INVALID - multiple inheritance not allowed
// class Dog extends Animal, Pet { }  // Compile error!</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Tip:</strong> While you can only extend one class, you can implement multiple interfaces. This is Java's way of achieving similar functionality to multiple inheritance.
                    </div>

                    <!-- Section 6: Inheritance Hierarchy -->
                    <h2>Inheritance Hierarchy</h2>
                    <p>Classes can form a chain of inheritance. Each subclass inherits from its direct parent AND all ancestors above it.</p>

                    <!-- Visual: Inheritance Hierarchy Diagram -->
                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-inheritance-hierarchy.svg"
                             alt="Java Inheritance Hierarchy Diagram showing Object -> Animal -> Dog/Cat/Bird"
                             style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal {
    void breathe() {
        System.out.println("Breathing...");
    }
}

class Mammal extends Animal {
    void warmBlooded() {
        System.out.println("I'm warm-blooded!");
    }
}

class Dog extends Mammal {
    void bark() {
        System.out.println("Woof!");
    }
}

// Dog inherits from Mammal AND Animal
Dog dog = new Dog();
dog.breathe();      // From Animal
dog.warmBlooded();  // From Mammal
dog.bark();         // From Dog</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/InheritanceBasics.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-inheritance" />
                    </jsp:include>

                    <!-- Section 7: Benefits of Inheritance -->
                    <h2>Benefits of Inheritance</h2>
                    <ul>
                        <li><strong>Code Reuse:</strong> Write common code once in the parent class</li>
                        <li><strong>Extensibility:</strong> Add new features without modifying existing code</li>
                        <li><strong>Maintainability:</strong> Fix bugs in one place (parent class)</li>
                        <li><strong>Polymorphism:</strong> Treat objects of different classes uniformly</li>
                    </ul>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Trying to access private members:</strong> Private fields/methods are not accessible in subclasses. Use getters/setters or <code>protected</code> access.</li>
                            <li><strong>Forgetting that constructors aren't inherited:</strong> You must call the parent constructor explicitly using <code>super()</code> if needed.</li>
                            <li><strong>Overusing inheritance:</strong> Use inheritance for IS-A relationships. For HAS-A relationships, use composition instead.</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li>Inheritance allows a class to inherit fields and methods from another class using <code>extends</code>.</li>
                            <li>The child class (subclass) inherits from the parent class (superclass).</li>
                            <li>Inheritance establishes an IS-A relationship.</li>
                            <li>Java supports single inheritance - one class can only extend one other class.</li>
                            <li>Private members are not inherited; constructors are not inherited but can be called with <code>super()</code>.</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/oop-final.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-super.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="final Keyword" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="super Keyword" />
                            <jsp:param name="currentLessonId" value="inheritance-basics" />
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
