<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "interfaces-basics");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Interfaces - implements Keyword Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Java interfaces with implements keyword. Understand multiple inheritance, default methods, static methods, and functional interfaces.">
    <meta name="keywords"
        content="java interface, java implements keyword, java default methods, java multiple inheritance, java functional interface">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Interfaces Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master Java interfaces. Learn how to define contracts, implement multiple interfaces, and use default methods.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/interfaces-basics.jsp">
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
    "name": "Java Interfaces",
    "description": "Learn how to use interfaces in Java to define contracts and achieve multiple inheritance.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["interface keyword", "implements keyword", "Multiple Inheritance", "Default Methods", "Functional Interfaces"],
    "timeRequired": "PT40M",
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

<body class="tutorial-body no-preview" data-lesson="interfaces-basics">
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
                    <span>Interfaces</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Interfaces in Java</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~40 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">An interface in Java is a reference type that defines a contract - a set of methods that implementing classes must provide. Interfaces enable multiple inheritance of behavior and are fundamental to Java's polymorphism.</p>

                    <!-- Section 1: What is an Interface? -->
                    <h2>What is an Interface?</h2>
                    <p>An interface is like a completely abstract class. It defines <strong>what</strong> a class can do, not <strong>how</strong> it does it.</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Define an interface
interface Drawable {
    void draw();  // Abstract by default
}

// Implement the interface
class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing a circle");
    }
}</code></pre>
                    </div>

                    <div class="info-box">
                        <strong>Key Characteristics:</strong>
                        <ul>
                            <li>Declared with <code>interface</code> keyword</li>
                            <li>Methods are <code>public abstract</code> by default</li>
                            <li>Variables are <code>public static final</code> by default (constants)</li>
                            <li>Cannot be instantiated</li>
                            <li>Classes use <code>implements</code> keyword</li>
                        </ul>
                    </div>

                    <!-- Section 2: Implementing Interfaces -->
                    <h2>Implementing Interfaces</h2>
                    <p>A class implements an interface using the <code>implements</code> keyword and must provide implementations for ALL abstract methods.</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Animal {
    void makeSound();
    void move();
}

class Dog implements Animal {
    @Override
    public void makeSound() {
        System.out.println("Woof!");
    }

    @Override
    public void move() {
        System.out.println("Dog runs");
    }
}</code></pre>
                    </div>

                    <!-- Section 3: Multiple Interfaces -->
                    <h2>Multiple Inheritance via Interfaces</h2>
                    <p>Unlike classes, a class can implement <strong>multiple interfaces</strong>. This is Java's way of achieving multiple inheritance.</p>

                    <!-- Visual: Interface Implementation Diagram -->
                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-interface-implementation.svg"
                             alt="Java Interface Implementation Diagram showing a class implementing multiple interfaces"
                             style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">interface Flyable {
    void fly();
}

interface Swimmable {
    void swim();
}

interface Walkable {
    void walk();
}

// Duck can do all three!
class Duck implements Flyable, Swimmable, Walkable {
    @Override
    public void fly() {
        System.out.println("Duck is flying");
    }

    @Override
    public void swim() {
        System.out.println("Duck is swimming");
    }

    @Override
    public void walk() {
        System.out.println("Duck is walking");
    }
}</code></pre>
                    </div>

                    <!-- Section 4: Default Methods (Java 8+) -->
                    <h2>Default Methods (Java 8+)</h2>
                    <p>Since Java 8, interfaces can have methods with default implementations. This allows adding new methods to interfaces without breaking existing implementations.</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Vehicle {
    void start();
    void stop();

    // Default method - provides implementation
    default void honk() {
        System.out.println("Beep beep!");
    }
}

class Car implements Vehicle {
    @Override
    public void start() {
        System.out.println("Car starting");
    }

    @Override
    public void stop() {
        System.out.println("Car stopping");
    }

    // honk() is inherited, but can be overridden
}</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Why Default Methods?</strong> They allow library designers to add new methods to interfaces without breaking all existing implementations. This was crucial for adding Stream API methods to Collection interface in Java 8.
                    </div>

                    <!-- Section 5: Static Methods -->
                    <h2>Static Methods in Interfaces (Java 8+)</h2>
                    <p>Interfaces can also have static methods. These are utility methods related to the interface.</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface MathOperations {
    int calculate(int a, int b);

    // Static utility method
    static int add(int a, int b) {
        return a + b;
    }

    static int multiply(int a, int b) {
        return a * b;
    }
}

// Call static methods using interface name
int sum = MathOperations.add(5, 3);  // 8</code></pre>
                    </div>

                    <!-- Section 6: Private Methods (Java 9+) -->
                    <h2>Private Methods (Java 9+)</h2>
                    <p>Java 9 added private methods to interfaces, allowing code reuse within default methods.</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Logger {
    default void logInfo(String message) {
        log("INFO", message);
    }

    default void logError(String message) {
        log("ERROR", message);
    }

    // Private helper method (Java 9+)
    private void log(String level, String message) {
        System.out.println("[" + level + "] " + message);
    }
}</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/InterfacesBasics.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-interface" />
                    </jsp:include>

                    <!-- Section 7: Interface Constants -->
                    <h2>Constants in Interfaces</h2>
                    <p>Variables declared in interfaces are implicitly <code>public static final</code>:</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface GameConstants {
    int MAX_PLAYERS = 4;        // public static final
    int MIN_PLAYERS = 2;        // public static final
    String GAME_NAME = "Chess"; // public static final
}

// Access as constants
System.out.println(GameConstants.MAX_PLAYERS);  // 4</code></pre>
                    </div>

                    <!-- Section 8: Extending Interfaces -->
                    <h2>Extending Interfaces</h2>
                    <p>Interfaces can extend other interfaces using <code>extends</code>. An interface can extend multiple interfaces.</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Readable {
    void read();
}

interface Writable {
    void write();
}

// Interface extending multiple interfaces
interface ReadWritable extends Readable, Writable {
    void readWrite();  // Additional method
}

class File implements ReadWritable {
    @Override
    public void read() { System.out.println("Reading"); }

    @Override
    public void write() { System.out.println("Writing"); }

    @Override
    public void readWrite() { System.out.println("Read and Write"); }
}</code></pre>
                    </div>

                    <!-- Section 9: Functional Interfaces -->
                    <h2>Functional Interfaces</h2>
                    <p>A functional interface has exactly one abstract method. It can be used with lambda expressions.</p>

                    <div class="code-box">
                        <pre><code class="language-java">@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);  // Single abstract method
}

// Using lambda expression
Calculator add = (a, b) -> a + b;
Calculator multiply = (a, b) -> a * b;

System.out.println(add.calculate(5, 3));      // 8
System.out.println(multiply.calculate(5, 3)); // 15</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Forgetting public on implemented methods:</strong> Interface methods are public, so implementations must also be public</li>
                            <li><strong>Trying to instantiate an interface:</strong> <code>new Drawable()</code> is invalid (use anonymous classes or lambdas instead)</li>
                            <li><strong>Conflicting default methods:</strong> When implementing two interfaces with the same default method, you must override it</li>
                            <li><strong>Adding instance variables:</strong> Interfaces can only have constants (static final)</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li>Interfaces define contracts using <code>interface</code> keyword</li>
                            <li>Classes implement interfaces with <code>implements</code> keyword</li>
                            <li>A class can implement multiple interfaces (multiple inheritance)</li>
                            <li>Default methods (Java 8+) provide default implementations</li>
                            <li>Static methods (Java 8+) provide utility methods</li>
                            <li>Variables in interfaces are constants (<code>public static final</code>)</li>
                            <li>Functional interfaces have one abstract method (for lambdas)</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-abstract.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/polymorphism-runtime.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="Abstract Classes" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Polymorphism" />
                            <jsp:param name="currentLessonId" value="interfaces-basics" />
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
