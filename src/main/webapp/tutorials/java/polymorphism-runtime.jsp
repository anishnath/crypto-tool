<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "polymorphism-runtime");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Polymorphism - Runtime & Compile-time Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Java polymorphism - both runtime (dynamic) and compile-time (static). Learn method overriding, method overloading, and polymorphic arrays.">
    <meta name="keywords"
        content="java polymorphism, java runtime polymorphism, java compile time polymorphism, java dynamic dispatch, java method overriding">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Polymorphism Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master polymorphism in Java. Understand how one interface can have multiple implementations.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/polymorphism-runtime.jsp">
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
    "name": "Java Polymorphism",
    "description": "Learn runtime and compile-time polymorphism in Java through method overriding and overloading.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Runtime Polymorphism", "Compile-time Polymorphism", "Method Overriding", "Polymorphic Arrays"],
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

<body class="tutorial-body no-preview" data-lesson="polymorphism-runtime">
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
                    <span>Polymorphism</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Polymorphism in Java</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~35 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Polymorphism means "many forms." In Java, it allows objects to be treated as instances of their parent class or interface, while the actual behavior is determined by their real type. It's one of the four pillars of OOP.</p>

                    <!-- Section 1: What is Polymorphism? -->
                    <h2>What is Polymorphism?</h2>
                    <p>Polymorphism allows you to write code that works with objects of different types through a common interface. The same method call can behave differently depending on the actual object type.</p>

                    <div class="code-box">
                        <pre><code class="language-java">Animal myAnimal = new Dog();  // Polymorphism in action!
myAnimal.makeSound();         // Calls Dog's makeSound(), not Animal's

myAnimal = new Cat();         // Same variable, different object
myAnimal.makeSound();         // Now calls Cat's makeSound()</code></pre>
                    </div>

                    <div class="info-box">
                        <strong>Two Types of Polymorphism:</strong>
                        <ul>
                            <li><strong>Compile-time (Static):</strong> Method overloading - decided at compile time</li>
                            <li><strong>Runtime (Dynamic):</strong> Method overriding - decided at runtime</li>
                        </ul>
                    </div>

                    <!-- Section 2: Runtime Polymorphism -->
                    <h2>Runtime Polymorphism (Dynamic Method Dispatch)</h2>
                    <p>When you call an overridden method through a parent class reference, Java determines which version to call <strong>at runtime</strong> based on the actual object type.</p>

                    <!-- Visual: Polymorphism Concept Diagram -->
                    <div class="diagram-container" style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-polymorphism.svg"
                             alt="Java Polymorphism Diagram showing one interface with multiple implementations"
                             style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">class Animal {
    void makeSound() {
        System.out.println("Some animal sound");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Woof!");
    }
}

class Cat extends Animal {
    @Override
    void makeSound() {
        System.out.println("Meow!");
    }
}

// Runtime polymorphism
Animal animal1 = new Dog();  // Reference: Animal, Object: Dog
Animal animal2 = new Cat();  // Reference: Animal, Object: Cat

animal1.makeSound();  // Output: "Woof!" (Dog's method)
animal2.makeSound();  // Output: "Meow!" (Cat's method)</code></pre>
                    </div>

                    <!-- Section 3: Compile-time Polymorphism -->
                    <h2>Compile-time Polymorphism (Method Overloading)</h2>
                    <p>Method overloading allows multiple methods with the same name but different parameters. The compiler decides which method to call based on the arguments.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Calculator {
    // Same method name, different parameters
    int add(int a, int b) {
        return a + b;
    }

    double add(double a, double b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }
}

Calculator calc = new Calculator();
calc.add(5, 3);        // Calls add(int, int)
calc.add(5.0, 3.0);    // Calls add(double, double)
calc.add(1, 2, 3);     // Calls add(int, int, int)</code></pre>
                    </div>

                    <!-- Section 4: Upcasting and Downcasting -->
                    <h2>Upcasting and Downcasting</h2>
                    <p><strong>Upcasting</strong> is casting to a parent type (implicit, always safe). <strong>Downcasting</strong> is casting to a child type (explicit, can fail).</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Upcasting (implicit, safe)
Dog dog = new Dog();
Animal animal = dog;  // Dog -> Animal (automatic)

// Downcasting (explicit, needs instanceof check)
Animal animal2 = new Dog();
if (animal2 instanceof Dog) {
    Dog dog2 = (Dog) animal2;  // Animal -> Dog (explicit cast)
    dog2.fetch();  // Can now call Dog-specific methods
}</code></pre>
                    </div>

                    <div class="warning-box">
                        <strong>ClassCastException:</strong> Downcasting without checking can throw an exception:
                        <pre><code class="language-java">Animal animal = new Cat();
Dog dog = (Dog) animal;  // ClassCastException! Cat is not a Dog</code></pre>
                    </div>

                    <!-- Section 5: Polymorphic Arrays -->
                    <h2>Polymorphic Arrays and Collections</h2>
                    <p>Arrays and collections of parent type can hold objects of any subclass:</p>

                    <div class="code-box">
                        <pre><code class="language-java">// Array of parent type
Animal[] zoo = new Animal[3];
zoo[0] = new Dog();
zoo[1] = new Cat();
zoo[2] = new Bird();

// Process all animals uniformly
for (Animal animal : zoo) {
    animal.makeSound();  // Each calls its own version
}</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/PolymorphismDemo.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-polymorphism" />
                    </jsp:include>

                    <!-- Section 6: Interface Polymorphism -->
                    <h2>Interface Polymorphism</h2>
                    <p>Polymorphism works with interfaces too - different classes can implement the same interface differently:</p>

                    <div class="code-box">
                        <pre><code class="language-java">interface Drawable {
    void draw();
}

class Circle implements Drawable {
    public void draw() { System.out.println("Drawing Circle"); }
}

class Rectangle implements Drawable {
    public void draw() { System.out.println("Drawing Rectangle"); }
}

// Interface polymorphism
Drawable[] shapes = {new Circle(), new Rectangle()};
for (Drawable shape : shapes) {
    shape.draw();  // Polymorphic call
}</code></pre>
                    </div>

                    <!-- Section 7: Benefits of Polymorphism -->
                    <h2>Benefits of Polymorphism</h2>
                    <ul>
                        <li><strong>Code Reusability:</strong> Write code that works with parent class/interface, reuse with all subclasses</li>
                        <li><strong>Flexibility:</strong> Add new classes without changing existing code</li>
                        <li><strong>Maintainability:</strong> Changes in one class don't affect others</li>
                        <li><strong>Extensibility:</strong> System is open for extension, closed for modification (Open/Closed Principle)</li>
                    </ul>

                    <!-- Section 8: Real-World Example -->
                    <h2>Real-World Example: Payment Processing</h2>
                    <div class="code-box">
                        <pre><code class="language-java">abstract class Payment {
    abstract void processPayment(double amount);
}

class CreditCardPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via Credit Card");
    }
}

class PayPalPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via PayPal");
    }
}

class BitcoinPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via Bitcoin");
    }
}

// Polymorphic processing - works with ANY payment type
void checkout(Payment payment, double amount) {
    payment.processPayment(amount);
}

// Usage
checkout(new CreditCardPayment(), 100.00);
checkout(new PayPalPayment(), 50.00);
checkout(new BitcoinPayment(), 200.00);</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Confusing overriding with overloading:</strong> Overriding is runtime polymorphism; overloading is compile-time</li>
                            <li><strong>Downcasting without instanceof:</strong> Always check type before downcasting</li>
                            <li><strong>Trying to call child-specific methods on parent reference:</strong> The reference type determines available methods (at compile time)</li>
                            <li><strong>Forgetting @Override annotation:</strong> Use it to catch errors in method signatures</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li>Polymorphism means "many forms" - same interface, different behaviors</li>
                            <li><strong>Runtime polymorphism:</strong> Method overriding - determined at runtime</li>
                            <li><strong>Compile-time polymorphism:</strong> Method overloading - determined at compile time</li>
                            <li>Upcasting is implicit and safe; downcasting requires explicit cast and type check</li>
                            <li>Use polymorphic arrays/collections to process different object types uniformly</li>
                            <li>Polymorphism enables flexible, extensible, and maintainable code</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/interfaces-basics.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/collections-overview.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="Interfaces" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Collections Overview (Next Module)" />
                            <jsp:param name="currentLessonId" value="polymorphism-runtime" />
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
