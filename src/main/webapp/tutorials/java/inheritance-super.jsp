<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-super");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java super Keyword - Constructor Chaining Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn how to use the super keyword in Java to access parent class members and constructors. Master constructor chaining in inheritance.">
    <meta name="keywords"
        content="java super keyword, java super constructor, java constructor chaining, java parent class access, java super method call">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java super Keyword Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master the super keyword in Java. Learn how to call parent constructors and access parent class members.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-super.jsp">
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
    "name": "Java super Keyword",
    "description": "Learn how to use the super keyword to access parent class members and constructors.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["super keyword", "Constructor Chaining", "Accessing Parent Members", "super() vs this()"],
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

<body class="tutorial-body no-preview" data-lesson="inheritance-super">
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
                    <span>super Keyword</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">The super Keyword</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>super</code> keyword is a reference to the parent (superclass) of the current object. It's used to access parent class members (fields and methods) and to call parent class constructors.</p>

                    <!-- Section 1: What is super? -->
                    <h2>What is <code>super</code>?</h2>
                    <p>The <code>super</code> keyword in Java has three main uses:</p>
                    <ol>
                        <li><strong>super()</strong> - Call parent class constructor</li>
                        <li><strong>super.method()</strong> - Call parent class method</li>
                        <li><strong>super.field</strong> - Access parent class field</li>
                    </ol>

                    <!-- Section 2: Calling Parent Constructor -->
                    <h2>Calling Parent Constructor with <code>super()</code></h2>
                    <p>Constructors are not inherited in Java. To initialize parent class fields, you must explicitly call the parent constructor using <code>super()</code>.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal {
    String name;

    Animal(String name) {
        this.name = name;
        System.out.println("Animal constructor called");
    }
}

class Dog extends Animal {
    String breed;

    Dog(String name, String breed) {
        super(name);  // Call Animal's constructor FIRST
        this.breed = breed;
        System.out.println("Dog constructor called");
    }
}</code></pre>
                    </div>

                    <div class="warning-box">
                        <strong>Important Rules:</strong>
                        <ul>
                            <li><code>super()</code> must be the <strong>first statement</strong> in the subclass constructor</li>
                            <li>If you don't call <code>super()</code> explicitly, Java automatically inserts <code>super()</code> (no-arg) at the beginning</li>
                            <li>If the parent class has no no-arg constructor, you MUST call <code>super(args)</code> explicitly</li>
                        </ul>
                    </div>

                    <!-- Section 3: Constructor Chaining -->
                    <h2>Constructor Chaining</h2>
                    <p>When you create an object, constructors are called from the topmost parent class down to the child class. This is called <strong>constructor chaining</strong>.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Grandparent {
    Grandparent() {
        System.out.println("1. Grandparent constructor");
    }
}

class Parent extends Grandparent {
    Parent() {
        // super() is called automatically
        System.out.println("2. Parent constructor");
    }
}

class Child extends Parent {
    Child() {
        // super() is called automatically
        System.out.println("3. Child constructor");
    }
}

// new Child() prints:
// 1. Grandparent constructor
// 2. Parent constructor
// 3. Child constructor</code></pre>
                    </div>

                    <!-- Section 4: Accessing Parent Methods -->
                    <h2>Calling Parent Methods with <code>super.method()</code></h2>
                    <p>Use <code>super.methodName()</code> to call a method from the parent class, especially when the method is overridden in the subclass.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal {
    void makeSound() {
        System.out.println("Some generic animal sound");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        super.makeSound();  // Call parent's version first
        System.out.println("Woof! Woof!");  // Then add dog-specific behavior
    }
}</code></pre>
                    </div>

                    <!-- Section 5: Accessing Parent Fields -->
                    <h2>Accessing Parent Fields with <code>super.field</code></h2>
                    <p>When a subclass has a field with the same name as the parent class (variable shadowing), use <code>super.fieldName</code> to access the parent's field.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Vehicle {
    int maxSpeed = 100;
}

class Car extends Vehicle {
    int maxSpeed = 200;  // Shadows parent's maxSpeed

    void displaySpeeds() {
        System.out.println("Car's maxSpeed: " + maxSpeed);        // 200
        System.out.println("Vehicle's maxSpeed: " + super.maxSpeed);  // 100
    }
}</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Avoid variable shadowing as it can be confusing. If you need different values, use different names or override getters instead.
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/InheritanceSuper.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-super" />
                    </jsp:include>

                    <!-- Section 6: super vs this -->
                    <h2><code>super</code> vs <code>this</code></h2>
                    <table class="comparison-table">
                        <thead>
                            <tr>
                                <th><code>super</code></th>
                                <th><code>this</code></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Refers to parent class</td>
                                <td>Refers to current class</td>
                            </tr>
                            <tr>
                                <td><code>super()</code> calls parent constructor</td>
                                <td><code>this()</code> calls another constructor in same class</td>
                            </tr>
                            <tr>
                                <td><code>super.field</code> accesses parent's field</td>
                                <td><code>this.field</code> accesses current instance's field</td>
                            </tr>
                            <tr>
                                <td>Used when method/field is overridden</td>
                                <td>Used to distinguish instance variables from parameters</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Calling super() after other statements:</strong> <code>super()</code> must be the first statement in a constructor.</li>
                            <li><strong>Using both super() and this() in same constructor:</strong> You can only use one of them, and it must be the first statement.</li>
                            <li><strong>Forgetting super() when parent has no no-arg constructor:</strong> If the parent class only has parameterized constructors, you must explicitly call one with <code>super(args)</code>.</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><code>super()</code> calls the parent class constructor and must be the first statement</li>
                            <li><code>super.method()</code> calls the parent class version of an overridden method</li>
                            <li><code>super.field</code> accesses the parent class field when shadowed</li>
                            <li>Constructor chaining ensures parent classes are initialized first</li>
                            <li>If no <code>super()</code> is written, Java inserts <code>super()</code> automatically</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-basics.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-overriding.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="Inheritance" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Method Overriding" />
                            <jsp:param name="currentLessonId" value="inheritance-super" />
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
