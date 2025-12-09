<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-classes"); request.setAttribute("currentModule", "Object-Oriented Programming Basics"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Classes & Objects in Java - Java Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn about Java classes and objects: class keyword, object creation with 'new', instance variables, object references, and the null keyword. Essential OOP concepts.">
    <meta name="keywords"
        content="java classes, java objects, oop java, java class keyword, java new keyword, java instance variables, java object references, java null">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Classes & Objects in Java - Java Tutorial | 8gwifi.org">
    <meta property="og:description" content="Learn the fundamentals of classes and objects in Java programming.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/oop-classes.jsp">
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
        "name": "Classes & Objects in Java",
        "description": "Learn about Java classes and objects: class keyword, object creation with 'new', instance variables, object references, and the null keyword.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Java classes", "Java objects", "Object creation", "Instance variables", "Object references", "null keyword"],
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

<body class="tutorial-body no-preview" data-lesson="oop-classes">
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
                    <span>Classes & Objects</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Classes & Objects</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Object-Oriented Programming (OOP) is at the heart of Java. Understanding classes and objects is essential for writing Java programs. A class is a blueprint for creating objects, while an object is an instance of a class. In this lesson, you'll learn how to define classes, create objects, work with instance variables, and understand object references.</p>

                    <!-- Section 1: What is a Class? -->
                    <h2>What is a Class?</h2>
                    <p>A <strong>class</strong> is a template or blueprint that defines the properties (attributes) and behaviors (methods) that objects of that class will have. Think of a class as a cookie cutter and objects as the cookies made from it.</p>

                    <div class="info-box">
                        <h4>Class vs Object Analogy</h4>
                        <ul>
                            <li><strong>Class:</strong> A blueprint (like a house plan)</li>
                            <li><strong>Object:</strong> An instance created from the blueprint (like an actual house built from the plan)</li>
                            <li>One class can create many objects</li>
                        </ul>
                    </div>

                    <h3>Defining a Class</h3>
                    <p>To define a class in Java, use the <code>class</code> keyword followed by the class name. Class names should be in PascalCase.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/oop-classes.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-classes" />
                    </jsp:include>

                    <p>In this example:</p>
                    <ul>
                        <li><code>class Student</code> - Defines a class named <code>Student</code></li>
                        <li><code>String name;</code> and <code>int age;</code> - Instance variables (attributes)</li>
                        <li>Each object created from this class will have its own <code>name</code> and <code>age</code></li>
                    </ul>

                    <!-- Section 2: Creating Objects -->
                    <h2>Creating Objects</h2>
                    <p>To create an object (instance) from a class, use the <code>new</code> keyword followed by the class constructor. This process is called <strong>instantiation</strong>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/oop-objects.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-objects" />
                    </jsp:include>

                    <p>Key points about object creation:</p>
                    <ul>
                        <li><code>new Student()</code> - Creates a new object instance</li>
                        <li><code>student1</code> and <code>student2</code> - Object references (variables that hold references to objects)</li>
                        <li>Each object has its own copy of instance variables</li>
                        <li>You can create multiple objects from the same class</li>
                    </ul>

                    <div class="tip-box">
                        <h4>Object Reference vs Object</h4>
                        <p>In Java, object variables are actually <strong>references</strong> (not the objects themselves). The variable holds the memory address where the object is stored. This is similar to how a house address points to an actual house.</p>
                    </div>

                    <!-- Section 3: Instance Variables -->
                    <h2>Instance Variables</h2>
                    <p><strong>Instance variables</strong> are variables declared inside a class but outside any method. Each object has its own copy of these variables.</p>

                    <pre><code class="language-java">public class Car {
    // Instance variables
    String brand;      // Each Car object has its own brand
    String color;      // Each Car object has its own color
    int speed;         // Each Car object has its own speed
    
    // Methods can access instance variables
    void displayInfo() {
        System.out.println(brand + " " + color + " - Speed: " + speed);
    }
}</code></pre>

                    <p>Characteristics of instance variables:</p>
                    <ul>
                        <li>Each object has its own copy</li>
                        <li>Initialized to default values (0, null, false) if not explicitly set</li>
                        <li>Accessible from any method in the class</li>
                        <li>Exist as long as the object exists</li>
                    </ul>

                    <!-- Section 4: Object References -->
                    <h2>Object References</h2>
                    <p>In Java, object variables store references (memory addresses), not the objects themselves. This means multiple variables can reference the same object.</p>

                    <pre><code class="language-java">Student student1 = new Student();
student1.name = "Alice";
student1.age = 20;

Student student2 = student1;  // student2 now references the same object

System.out.println(student2.name);  // Prints "Alice"
student2.name = "Bob";
System.out.println(student1.name);  // Prints "Bob" (same object!)
</code></pre>

                    <div class="warning-box">
                        <h4>Reference Assignment</h4>
                        <p>When you assign one object reference to another, both variables point to the same object. Changes made through one reference affect the object, and those changes are visible through all references.</p>
                    </div>

                    <!-- Section 5: The null Keyword -->
                    <h2>The null Keyword</h2>
                    <p>The <code>null</code> keyword represents an absence of an object reference. A reference variable that is <code>null</code> doesn't point to any object.</p>

                    <pre><code class="language-java">Student student = null;  // Reference variable doesn't point to any object

// Trying to use a null reference causes NullPointerException
// student.name = "Alice";  // ERROR: NullPointerException

// Always check for null before using
if (student != null) {
    student.name = "Alice";
} else {
    System.out.println("Student object is null");
}
</code></pre>

                    <div class="tip-box">
                        <h4>Default Values</h4>
                        <p>When you create an object with <code>new</code>, instance variables get default values:
                        <ul>
                            <li><code>int</code>, <code>byte</code>, <code>short</code>, <code>long</code>: <code>0</code></li>
                            <li><code>float</code>, <code>double</code>: <code>0.0</code></li>
                            <li><code>boolean</code>: <code>false</code></li>
                            <li><code>char</code>: <code>'\u0000'</code></li>
                            <li>Object references: <code>null</code></li>
                        </ul>
                        </p>
                    </div>

                    <!-- Visual: Class vs Object -->
                    <h2>Class vs Object Visualization</h2>
                    <p>Understanding the relationship between classes and objects is crucial. Below is a visual representation:</p>

                    <div style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-class-object.svg" 
                             alt="Class vs Object Diagram" 
                             style="max-width: 100%; height: auto;">
                    </div>

                    <p>The diagram shows how one class (the blueprint) can create multiple objects (instances), each with its own set of instance variables.</p>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing class and object</h4>
                        <pre><code class="language-java">// Wrong - trying to access instance variables from class
Student.name = "Alice";  // Error! name is not static

// Correct - create an object first
Student student = new Student();
student.name = "Alice";</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using null references without checking</h4>
                        <pre><code class="language-java">// Wrong - can cause NullPointerException
Student student = null;
System.out.println(student.name);  // Runtime error!

// Correct - check for null first
Student student = null;
if (student != null) {
    System.out.println(student.name);
}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to use 'new' keyword</h4>
                        <pre><code class="language-java">// Wrong - doesn't create an object
Student student;
student.name = "Alice";  // Error! student is null

// Correct - use 'new' to create object
Student student = new Student();
student.name = "Alice";</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not understanding reference assignment</h4>
                        <pre><code class="language-java">// Wrong assumption - thinking this creates a copy
Student student1 = new Student();
student1.name = "Alice";
Student student2 = student1;  // Both reference the same object!
student2.name = "Bob";
System.out.println(student1.name);  // Prints "Bob", not "Alice"!

// Correct - create separate objects if you need copies
Student student1 = new Student();
student1.name = "Alice";
Student student2 = new Student();  // New object
student2.name = "Bob";</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a Book Class</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a <code>Book</code> class with instance variables for title, author, and pages. Then create two <code>Book</code> objects and display their information.</p>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="java/exercises/ex-oop-classes.java" />
                            <jsp:param name="language" value="java" />
                            <jsp:param name="editorId" value="compiler-exercise" />
                        </jsp:include>

                        <details class="solution-box">
                            <summary>Show Solution</summary>
                            <pre><code class="language-java">public class Book {
    String title;
    String author;
    int pages;
    
    void displayInfo() {
        System.out.println("Title: " + title);
        System.out.println("Author: " + author);
        System.out.println("Pages: " + pages);
    }
}

public class Exercise {
    public static void main(String[] args) {
        Book book1 = new Book();
        book1.title = "The Java Handbook";
        book1.author = "John Doe";
        book1.pages = 350;
        
        Book book2 = new Book();
        book2.title = "Learning Java";
        book2.author = "Jane Smith";
        book2.pages = 280;
        
        System.out.println("Book 1:");
        book1.displayInfo();
        
        System.out.println("\nBook 2:");
        book2.displayInfo();
    }
}</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h2>Summary</h2>
                        <ul>
                            <li>A <strong>class</strong> is a blueprint for creating objects</li>
                            <li>An <strong>object</strong> is an instance of a class, created with the <code>new</code> keyword</li>
                            <li><strong>Instance variables</strong> are properties that belong to each object</li>
                            <li>Object variables are <strong>references</strong> that point to objects in memory</li>
                            <li>The <code>null</code> keyword represents an absence of an object reference</li>
                            <li>Multiple references can point to the same object</li>
                            <li>Instance variables get default values when an object is created</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <h2>What's Next?</h2>
                    <p>Now that you understand classes and objects, the next lesson covers <strong>Constructors</strong>, which are special methods used to initialize objects when they're created. Constructors allow you to set initial values for your objects efficiently.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <%
                    String prevLinkUrl = request.getContextPath() + "/tutorials/java/methods-scope.jsp";
                    String nextLinkUrl = request.getContextPath() + "/tutorials/java/oop-constructors.jsp";
                %>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                    <jsp:param name="prevTitle" value="← Method Scope" />
                    <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                    <jsp:param name="nextTitle" value="Constructors →"/>
                    <jsp:param name="currentLessonId" value="oop-classes" />
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

