<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "inheritance-object-class");
   request.setAttribute("currentModule", "Inheritance & Polymorphism"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Java Object Class - toString, equals, hashCode Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn about Java's Object class - the root of all classes. Master toString(), equals(), hashCode(), getClass(), and clone() methods.">
    <meta name="keywords"
        content="java Object class, java toString method, java equals method, java hashCode method, java getClass, java clone method">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Java Object Class Tutorial | 8gwifi.org">
    <meta property="og:description"
        content="Master the Object class in Java - the parent of all classes. Learn to override toString(), equals(), and hashCode().">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/java/inheritance-object-class.jsp">
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
    "name": "Java Object Class",
    "description": "Learn about the Object class - the root of all Java classes and its important methods.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Object class", "toString()", "equals()", "hashCode()", "getClass()", "clone()"],
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

<body class="tutorial-body no-preview" data-lesson="inheritance-object-class">
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
                    <span>Object Class</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">The Object Class</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>Object</code> class in <code>java.lang</code> is the root of the class hierarchy. Every class in Java implicitly extends Object, making its methods available to all objects.</p>

                    <!-- Section 1: The Root Class -->
                    <h2>The Root of All Classes</h2>
                    <p>Every class in Java, whether you explicitly extend it or not, is a descendant of <code>Object</code>:</p>

                    <div class="code-box">
                        <pre><code class="language-java">// These two declarations are equivalent:
class MyClass { }
class MyClass extends Object { }

// Even classes that extend other classes ultimately extend Object
class Animal { }           // Implicitly extends Object
class Dog extends Animal { } // Dog -> Animal -> Object</code></pre>
                    </div>

                    <div class="info-box">
                        <strong>Key Methods of Object Class:</strong>
                        <ul>
                            <li><code>toString()</code> - String representation of the object</li>
                            <li><code>equals(Object obj)</code> - Check if two objects are equal</li>
                            <li><code>hashCode()</code> - Return a hash code value</li>
                            <li><code>getClass()</code> - Return the runtime class</li>
                            <li><code>clone()</code> - Create a copy of the object</li>
                            <li><code>finalize()</code> - Called before garbage collection (deprecated)</li>
                        </ul>
                    </div>

                    <!-- Section 2: toString() -->
                    <h2>The <code>toString()</code> Method</h2>
                    <p>Returns a string representation of the object. The default implementation returns the class name followed by <code>@</code> and the hash code in hexadecimal.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

Person p = new Person("Alice", 25);
System.out.println(p);  // Output: Person@1a2b3c4d (unhelpful!)

// Override toString() for meaningful output
class Person {
    String name;
    int age;

    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
}

System.out.println(p);  // Output: Person{name='Alice', age=25}</code></pre>
                    </div>

                    <div class="tip-box">
                        <strong>Best Practice:</strong> Always override <code>toString()</code> in your classes for easier debugging and logging.
                    </div>

                    <!-- Section 3: equals() -->
                    <h2>The <code>equals()</code> Method</h2>
                    <p>The default <code>equals()</code> compares object references (same as <code>==</code>). Override it to compare object content instead.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Person {
    String name;
    int age;

    // Default equals() compares references
    Person p1 = new Person("Alice", 25);
    Person p2 = new Person("Alice", 25);

    System.out.println(p1 == p2);       // false (different objects)
    System.out.println(p1.equals(p2));  // false (default equals = ==)

    // Override equals() to compare content
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;  // Same reference
        if (obj == null || getClass() != obj.getClass()) return false;

        Person person = (Person) obj;
        return age == person.age && name.equals(person.name);
    }
}</code></pre>
                    </div>

                    <!-- Section 4: hashCode() -->
                    <h2>The <code>hashCode()</code> Method</h2>
                    <p>Returns an integer hash code value for the object. If you override <code>equals()</code>, you <strong>must</strong> override <code>hashCode()</code> too.</p>

                    <div class="warning-box">
                        <strong>The Contract:</strong>
                        <ul>
                            <li>If <code>a.equals(b)</code> is true, then <code>a.hashCode() == b.hashCode()</code> must be true</li>
                            <li>If <code>hashCode()</code> values are different, <code>equals()</code> must return false</li>
                            <li>Two unequal objects may have the same hash code (collision)</li>
                        </ul>
                    </div>

                    <div class="code-box">
                        <pre><code class="language-java">class Person {
    String name;
    int age;

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + age;
        return result;
    }

    // Or use Objects.hash() (Java 7+)
    @Override
    public int hashCode() {
        return java.util.Objects.hash(name, age);
    }
}</code></pre>
                    </div>

                    <!-- Section 5: getClass() -->
                    <h2>The <code>getClass()</code> Method</h2>
                    <p>Returns the runtime class of the object. This method is <code>final</code> and cannot be overridden.</p>

                    <div class="code-box">
                        <pre><code class="language-java">Animal animal = new Dog();

Class&lt;?&gt; cls = animal.getClass();
System.out.println(cls.getName());        // "Dog"
System.out.println(cls.getSimpleName());  // "Dog"
System.out.println(cls.getSuperclass());  // "class Animal"</code></pre>
                    </div>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="java/ObjectClassDemo.java" />
                        <jsp:param name="language" value="java" />
                        <jsp:param name="editorId" value="compiler-object" />
                    </jsp:include>

                    <!-- Section 6: clone() -->
                    <h2>The <code>clone()</code> Method</h2>
                    <p>Creates and returns a copy of the object. To use it, your class must implement <code>Cloneable</code> interface.</p>

                    <div class="code-box">
                        <pre><code class="language-java">class Person implements Cloneable {
    String name;
    int age;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();  // Shallow copy
    }
}

Person original = new Person("Alice", 25);
Person copy = (Person) original.clone();

System.out.println(original == copy);         // false (different objects)
System.out.println(original.name == copy.name); // true (shallow copy!)</code></pre>
                    </div>

                    <div class="info-box">
                        <strong>Shallow vs Deep Copy:</strong>
                        <ul>
                            <li><strong>Shallow copy:</strong> Copies references (default clone behavior)</li>
                            <li><strong>Deep copy:</strong> Creates new instances of referenced objects too</li>
                        </ul>
                    </div>

                    <!-- Section 7: Complete Example -->
                    <h2>Complete Example: Proper equals/hashCode/toString</h2>
                    <div class="code-box">
                        <pre><code class="language-java">import java.util.Objects;

class Student {
    private String name;
    private int id;

    public Student(String name, int id) {
        this.name = name;
        this.id = id;
    }

    @Override
    public String toString() {
        return "Student{name='" + name + "', id=" + id + "}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return id == student.id && Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, id);
    }
}</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>
                    <div class="mistake-box">
                        <ul>
                            <li><strong>Overriding equals() without hashCode():</strong> Breaks HashMap, HashSet functionality</li>
                            <li><strong>Using == instead of equals() for strings:</strong> Always use <code>.equals()</code> for object comparison</li>
                            <li><strong>Not checking for null in equals():</strong> Can cause NullPointerException</li>
                            <li><strong>Forgetting to override toString():</strong> Makes debugging difficult</li>
                        </ul>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><code>Object</code> is the root class - every class extends it</li>
                            <li>Override <code>toString()</code> for meaningful string representation</li>
                            <li>Override <code>equals()</code> to compare object content (not references)</li>
                            <li>If you override <code>equals()</code>, always override <code>hashCode()</code></li>
                            <li><code>getClass()</code> returns the runtime class (cannot be overridden)</li>
                            <li><code>clone()</code> creates a copy (requires Cloneable interface)</li>
                        </ul>
                    </div>

                    <div style="margin-top: 3rem;">
                        <% String prevLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-instanceof.jsp";
                           String nextLinkUrl = request.getContextPath() + "/tutorials/java/inheritance-abstract.jsp"; %>
                        <jsp:include page="../tutorial-nav.jsp">
                            <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                            <jsp:param name="prevTitle" value="instanceof Operator" />
                            <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                            <jsp:param name="nextTitle" value="Abstract Classes" />
                            <jsp:param name="currentLessonId" value="inheritance-object-class" />
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
