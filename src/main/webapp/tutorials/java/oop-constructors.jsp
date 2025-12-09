<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-constructors"); request.setAttribute("currentModule", "Object-Oriented Programming Basics"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Constructors in Java - Java Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn about Java constructors: default constructor, parameterized constructor, constructor overloading, and the 'this' keyword. Initialize objects properly in Java.">
    <meta name="keywords"
        content="java constructors, default constructor, parameterized constructor, constructor overloading, java this keyword, object initialization">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Constructors in Java - Java Tutorial | 8gwifi.org">
    <meta property="og:description" content="Learn how to use constructors to initialize objects in Java.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/oop-constructors.jsp">
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
        "name": "Constructors in Java",
        "description": "Learn about Java constructors: default constructor, parameterized constructor, constructor overloading, and the 'this' keyword.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Java constructors", "Default constructor", "Parameterized constructor", "Constructor overloading", "this keyword"],
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

<body class="tutorial-body no-preview" data-lesson="oop-constructors">
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
                    <span>Constructors</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Constructors</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Constructors are special methods used to initialize objects when they are created. They are called automatically when you use the <code>new</code> keyword. Constructors ensure that objects start with valid initial values, making your code more robust and easier to use. In this lesson, you'll learn about different types of constructors and how to use them effectively.</p>

                    <!-- Section 1: What is a Constructor? -->
                    <h2>What is a Constructor?</h2>
                    <p>A <strong>constructor</strong> is a special method that has the same name as the class and no return type (not even <code>void</code>). It is automatically called when an object is created using the <code>new</code> keyword.</p>

                    <div class="info-box">
                        <h4>Constructor Characteristics</h4>
                        <ul>
                            <li>Has the same name as the class</li>
                            <li>No return type (not even <code>void</code>)</li>
                            <li>Automatically called when object is created</li>
                            <li>Cannot be called explicitly like regular methods</li>
                            <li>Used to initialize instance variables</li>
                        </ul>
                    </div>

                    <!-- Section 2: Default Constructor -->
                    <h2>Default Constructor</h2>
                    <p>If you don't define any constructor in your class, Java automatically provides a <strong>default constructor</strong> (a constructor with no parameters) that does nothing except initialize instance variables to their default values.</p>

                    <pre><code class="language-java">public class Student {
    String name;
    int age;
    
    // No constructor defined - Java provides default constructor
    // Default constructor: public Student() { }
}

// Using the default constructor
Student student = new Student();  // Default constructor called automatically
</code></pre>

                    <p>However, if you define any constructor (even a parameterized one), Java will <strong>not</strong> provide the default constructor. You must explicitly define it if you need it.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/oop-constructors.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-constructors" />
                    </jsp:include>

                    <!-- Section 3: Parameterized Constructor -->
                    <h2>Parameterized Constructor</h2>
                    <p>A <strong>parameterized constructor</strong> accepts parameters to initialize instance variables with specific values. This is much more convenient than setting values after object creation.</p>

                    <pre><code class="language-java">public class Student {
    String name;
    int age;
    
    // Parameterized constructor
    public Student(String studentName, int studentAge) {
        name = studentName;
        age = studentAge;
    }
}

// Create object with initial values
Student student = new Student("Alice", 20);
</code></pre>

                    <div class="tip-box">
                        <h4>Benefits of Parameterized Constructors</h4>
                        <ul>
                            <li>Initialize objects with values in one step</li>
                            <li>Ensure required fields are set</li>
                            <li>Make code more readable and concise</li>
                            <li>Prevent objects from being created in invalid states</li>
                        </ul>
                    </div>

                    <!-- Section 4: Constructor Overloading -->
                    <h2>Constructor Overloading</h2>
                    <p>Like methods, constructors can be <strong>overloaded</strong>. This means you can have multiple constructors with different parameter lists. The compiler determines which constructor to call based on the arguments you provide.</p>

                    <pre><code class="language-java">public class Rectangle {
    double width;
    double height;
    
    // Default constructor
    public Rectangle() {
        width = 1.0;
        height = 1.0;
    }
    
    // Constructor with one parameter (square)
    public Rectangle(double side) {
        width = side;
        height = side;
    }
    
    // Constructor with two parameters
    public Rectangle(double w, double h) {
        width = w;
        height = h;
    }
}

// Different ways to create Rectangle objects
Rectangle rect1 = new Rectangle();           // Uses default constructor
Rectangle rect2 = new Rectangle(5.0);        // Creates a square
Rectangle rect3 = new Rectangle(4.0, 6.0);   // Creates a rectangle</code></pre>

                    <!-- Section 5: The 'this' Keyword -->
                    <h2>The 'this' Keyword</h2>
                    <p>The <code>this</code> keyword refers to the current object. It's commonly used in constructors and methods to distinguish between instance variables and parameters with the same name.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/oop-this-keyword.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-this" />
                    </jsp:include>

                    <p>Key uses of <code>this</code>:</p>
                    <ul>
                        <li><strong>Refer to instance variables:</strong> <code>this.name</code> refers to the instance variable</li>
                        <li><strong>Call other constructors:</strong> <code>this()</code> calls another constructor (must be first line)</li>
                        <li><strong>Return the current object:</strong> Useful for method chaining</li>
                        <li><strong>Pass current object:</strong> Pass <code>this</code> as a parameter to methods</li>
                    </ul>

                    <div class="info-box">
                        <h4>Constructor Chaining</h4>
                        <p>You can call one constructor from another using <code>this()</code>. This is called constructor chaining and must be the first statement in the constructor.</p>
                        <pre><code class="language-java">public class Student {
    String name;
    int age;
    String email;
    
    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public Student(String name, int age, String email) {
        this(name, age);  // Call the other constructor
        this.email = email;
    }
}</code></pre>
                    </div>

                    <!-- Visual: Constructor Flow -->
                    <h2>Constructor Execution Flow</h2>
                    <p>Understanding how constructors are executed is important. Below is a visual representation:</p>

                    <div style="text-align: center; margin: 2rem 0;">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-constructor-flow.svg" 
                             alt="Constructor Flow Diagram" 
                             style="max-width: 100%; height: auto;">
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Adding return type to constructor</h4>
                        <pre><code class="language-java">// Wrong - this is a method, not a constructor
public void Student(String name) {
    this.name = name;
}

// Correct - no return type
public Student(String name) {
    this.name = name;
}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Assuming default constructor always exists</h4>
                        <pre><code class="language-java">public class Student {
    String name;
    
    public Student(String name) {
        this.name = name;
    }
}

// Wrong - default constructor not available
Student student = new Student();  // Error! No default constructor

// Correct - use parameterized constructor
Student student = new Student("Alice");</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not using 'this' when parameter names match instance variables</h4>
                        <pre><code class="language-java">public class Student {
    String name;
    
    // Wrong - assigns parameter to itself, instance variable unchanged
    public Student(String name) {
        name = name;  // Does nothing!
    }
    
    // Correct - use 'this' to refer to instance variable
    public Student(String name) {
        this.name = name;
    }
}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Calling constructor not as first statement</h4>
                        <pre><code class="language-java">public class Student {
    String name;
    int age;
    
    // Wrong - this() must be first statement
    public Student(String name, int age) {
        this.name = name;  // Error! Can't have code before this()
        this(age);
    }
    
    // Correct - this() is first statement
    public Student(String name, int age) {
        this(age);
        this.name = name;
    }
}</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a Bank Account Class</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a <code>BankAccount</code> class with:</p>
                        <ul>
                            <li>A default constructor that initializes balance to 0</li>
                            <li>A parameterized constructor that sets initial balance</li>
                            <li>Instance variables: accountNumber (String) and balance (double)</li>
                            <li>Use the <code>this</code> keyword appropriately</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="java/exercises/ex-oop-constructors.java" />
                            <jsp:param name="language" value="java" />
                            <jsp:param name="editorId" value="compiler-exercise" />
                        </jsp:include>

                        <details class="solution-box">
                            <summary>Show Solution</summary>
                            <pre><code class="language-java">public class BankAccount {
    String accountNumber;
    double balance;
    
    // Default constructor
    public BankAccount() {
        this.accountNumber = "";
        this.balance = 0.0;
    }
    
    // Parameterized constructor
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }
    
    void displayInfo() {
        System.out.println("Account: " + accountNumber);
        System.out.println("Balance: $" + balance);
    }
}

public class Exercise {
    public static void main(String[] args) {
        BankAccount account1 = new BankAccount();
        account1.accountNumber = "ACC001";
        account1.displayInfo();
        
        BankAccount account2 = new BankAccount("ACC002", 1000.0);
        account2.displayInfo();
    }
}</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h2>Summary</h2>
                        <ul>
                            <li>Constructors initialize objects when they are created</li>
                            <li>Constructor name must match the class name and have no return type</li>
                            <li>Java provides a default constructor only if you don't define any constructor</li>
                            <li>Parameterized constructors allow initialization with specific values</li>
                            <li>Constructors can be overloaded (multiple constructors with different parameters)</li>
                            <li>The <code>this</code> keyword refers to the current object</li>
                            <li>Use <code>this</code> to distinguish instance variables from parameters</li>
                            <li><code>this()</code> can call another constructor (must be first statement)</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <h2>What's Next?</h2>
                    <p>Now that you understand constructors, the next lesson covers <strong>Methods in Classes</strong>, which shows you how to define and use methods that operate on your objects' data.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <%
                    String prevLinkUrl = request.getContextPath() + "/tutorials/java/oop-classes.jsp";
                    String nextLinkUrl = request.getContextPath() + "/tutorials/java/oop-methods.jsp";
                %>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                    <jsp:param name="prevTitle" value="← Classes & Objects" />
                    <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                    <jsp:param name="nextTitle" value="Methods in Classes →" />
                    <jsp:param name="currentLessonId" value="oop-constructors" />
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

