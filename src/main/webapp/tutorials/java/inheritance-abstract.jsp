<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-abstract");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Abstract Classes - abstract Keyword Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Java abstract classes and abstract methods. Understand when to use abstract classes vs interfaces and how to design class hierarchies.">
    <meta name="keywords"
        content="java abstract class, java abstract method, java abstract keyword, java abstract vs interface, java abstract inheritance">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Abstract Classes Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master abstract classes in Java. Learn when and how to use abstract classes and methods effectively.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-abstract.jsp">
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
    "name": "Java Abstract Classes",
    "description": "Learn how to use abstract classes and methods in Java to define class hierarchies.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["abstract keyword", "Abstract Classes", "Abstract Methods", "Concrete Methods"],
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

<body class="tutorial-body no-preview" data-lesson="inheritance-abstract">
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
                    <span>Abstract Classes</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Abstract Classes</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">An abstract class is a class that cannot be instantiated directly. It's designed to be a base class that other classes extend. Abstract classes can contain both abstract methods (without implementation) and concrete methods (with implementation).</p>

                    <!-- Section 1: What is an Abstract Class? -->
                    <h2>What is an Abstract Class?</h2>
                    <p>An <strong>abstract class</strong> is declared with the <code>abstract</code> keyword. It represents an incomplete class that serves as a blueprint for subclasses.</p>

                    <div class="code-box">
                        <pre><code class="language-java">abstract class Shape {
    String color;

    // Abstract method - no body, must be implemented by subclasses
    abstract double calculateArea();

    // Concrete method - has implementation
    void setColor(String color) {
        this.color = color;
    }
}</code></pre>
                    </div>

                    <div class="info-box">
                        <strong>Key Characteristics:</strong>
                        <ul>
                            <li>Declared with <code>abstract</code> keyword</li>
                            <li>Cannot be instantiated (<code>new Shape()</code> is invalid)</li>
                            <li>Can have constructors (called by subclasses)</li>
                            <li>Can have both abstract and concrete methods</li>
                            <li>Can have instance variables</li>
                        </ul>
                    </div>

                    <!-- Section 2: Abstract Methods -->
                    <h2>Abstract Methods</h2>
                    <p>An abstract method has no body - just a declaration. Subclasses <strong>must</strong> provide an implementation.</p>

                    <div class="code-box">
                        <pre><code class="language-java">abstract class Animal {
    // Abstract method - each animal sounds different
    abstract void makeSound();

    // Concrete method - all animals breathe the same way
    void breathe() {
        System.out.println("Breathing...");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {  // MUST implement abstract method
        System.out.println("Woof!");
    }
}

class Cat extends Animal {
    @Override
    void makeSound() {  // MUST implement abstract method
        System.out.println("Meow!");
    }
}</code></pre>
                    </div>

                    <div class="warning-box">
                        <strong>Rules for Abstract Methods:</strong>
                        <ul>
                            <li>No method body - ends with semicolon</li>
                            <li>Can only exist in abstract classes or interfaces</li>
                            <li>Cannot be <code>final</code>, <code>static</code>, or <code>private</code></li>
                            <li>Subclasses must implement all abstract methods (or be abstract themselves)</li>
                        </ul>
                    </div>

                    <!-- Section 3: Constructors in Abstract Classes -->
                    <h2>Constructors in Abstract Classes</h2>
                    <p>Abstract classes can have constructors. They are called when a subclass object is created.</p>

                    <div class="code-box">
                        <pre><code class="language-java">abstract class Vehicle {
    String brand;
    int year;

    // Constructor in abstract class
    Vehicle(String brand, int year) {
        this.brand = brand;
        this.year = year;
        System.out.println("Vehicle constructor called");
    }

    abstract void start();
}

class Car extends Vehicle {
    int numDoors;

    Car(String brand, int year, int numDoors) {
        super(brand, year);  // Call abstract class constructor
        this.numDoors = numDoors;
        System.out.println("Car constructor called");
    }

    @Override
    void start() {
        System.out.println(brand + " car is starting");
    }
}</code></pre>
                    </div>

                    <!-- Section 4: Concrete Methods -->
                    <h2>Concrete Methods in Abstract Classes</h2>
                    <p>Abstract classes can provide default implementations that subclasses inherit or override:</p>

                    <div class="code-box">
                        <pre><code class="language-java">abstract class Employee {
    String name;
    double baseSalary;

    Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }

    // Abstract - different for each type
    abstract double calculateBonus();

    // Concrete - same for all employees
    double getTotalPay() {
        return baseSalary + calculateBonus();
    }

    // Concrete - can be overridden if needed
    void displayInfo() {
        System.out.println("Name: " + name);
        System.out.println("Total Pay: $" + getTotalPay());
    }
}</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/AbstractClasses.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-abstract" />
                    </jsp:include>

                    <!-- Section 5: When to Use Abstract Classes -->
                    <h2>When to Use Abstract Classes</h2>
                    <ul>
                        <li><strong>Shared code among related classes:</strong> When subclasses share common code</li>
                        <li><strong>Partial implementation:</strong> When you want to provide some default behavior but force subclasses to implement specific parts</li>
                        <li><strong>Template method pattern:</strong> Define the skeleton of an algorithm, letting subclasses fill in the details</li>
                        <li><strong>Access modifiers needed:</strong> When you need non-public methods (interfaces are implicitly public)</li>
                        <li><strong>Instance variables:</strong> When you need to share state among subclasses</li>
                    </ul>

                    <!-- Section 6: Abstract Class vs Interface -->
                    <h2>Abstract Class vs Interface</h2>
                    <table class="comparison-table">
                        <thead>
                            <tr>
                                <th>Abstract Class</th>
                                <th>Interface</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Can have instance variables</td>
                                <td>Only constants (public static final)</td>
                            </tr>
                            <tr>
                                <td>Can have constructors</td>
                                <td>Cannot have constructors</td>
                            </tr>
                            <tr>
                                <td>Single inheritance only</td>
                                <td>Multiple implementation allowed</td>
                            </tr>
                            <tr>
                                <td>Any access modifier for methods</td>
                                <td>Methods are public by default</td>
                            </tr>
                            <tr>
                                <td>Use for IS-A relationship with shared code</td>
                                <td>Use for CAN-DO capability/behavior</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Rule of Thumb:</strong> Use abstract classes when classes share code and state. Use interfaces when classes share behavior but not implementation.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Trying to instantiate an abstract class:</strong> <code>new Animal()</code> is a compile error</li>
                            <li><strong>Forgetting to implement all abstract methods:</strong> Subclass must implement ALL abstract methods or be declared abstract itself</li>
                            <li><strong>Making abstract methods private:</strong> Abstract methods must be accessible to subclasses</li>
                            <li><strong>Overusing abstract classes:</strong> Consider interfaces for defining capabilities</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li>Abstract classes cannot be instantiated directly</li>
                            <li>Abstract methods have no body and must be implemented by subclasses</li>
                            <li>Abstract classes can have constructors, instance variables, and concrete methods</li>
                            <li>Use abstract classes when you have shared code among related classes</li>
                            <li>A class that doesn't implement all abstract methods must itself be abstract</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-object-class.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/interfaces-basics.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="Object Class" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Interfaces" />
                            <jsp:param name="currentLessonId" value="inheritance-abstract" />
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
