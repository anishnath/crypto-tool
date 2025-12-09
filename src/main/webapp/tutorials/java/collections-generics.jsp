<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "collections-generics" );
        request.setAttribute("currentModule", "Collections Framework" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Generics - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Generics. Understand how to write flexible and type-safe code using Generic classes and methods.">
            <meta name="keywords" content="java generics, generic class, generic method, type parameters, java T type">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Generics - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Write cleaner and safer code with Java Generics.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/collections-generics.jsp">
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
    "name": "Java Generics",
    "description": "Guide to using Generics in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Interaction",
    "teaches": ["Generics Basics", "Type Safety", "Generic Classes"],
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

        <body class="tutorial-body no-preview" data-lesson="collections-generics">
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
                                    <span>Generics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Java Generics</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Generics enable you to write flexible, reusable code that works with
                                        any type while maintaining compile-time type safety. They eliminate casting and
                                        catch type errors before your code runs.</p>

                                    <!-- SVG Diagram -->
                                    <div class="diagram-container" style="margin: 2rem 0;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-generics.svg"
                                            alt="Java Generics Type Safety Diagram" style="max-width: 100%; height: auto;">
                                    </div>

                                    <h2>Why Generics?</h2>
                                    <p>Before generics (Java 1.4 and earlier), collections stored <code>Object</code> types:</p>

                                    <pre><code class="language-java">// Without Generics (Pre-Java 5) - UNSAFE
List list = new ArrayList();
list.add("Hello");
list.add(42);           // Allowed - any Object!
list.add(new User());   // Also allowed!

// Runtime error - ClassCastException!
String s = (String) list.get(1);  // 42 is not a String!</code></pre>

                                    <pre><code class="language-java">// With Generics (Java 5+) - SAFE
List&lt;String&gt; list = new ArrayList&lt;&gt;();
list.add("Hello");
// list.add(42);        // Compile Error! Type safety enforced
// list.add(new User()); // Compile Error!

String s = list.get(0);  // No casting needed!</code></pre>

                                    <h3>Benefits of Generics</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Benefit</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Type Safety</strong></td>
                                                <td>Errors caught at compile time, not runtime</td>
                                            </tr>
                                            <tr>
                                                <td><strong>No Casting</strong></td>
                                                <td>No need to cast objects when retrieving from collections</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Code Reuse</strong></td>
                                                <td>Write one class/method that works with any type</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Better Readability</strong></td>
                                                <td>Type information visible in the code</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Type Parameters</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Parameter</th>
                                                <th>Convention</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>T</code></td>
                                                <td>Type</td>
                                                <td><code>Box&lt;T&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>E</code></td>
                                                <td>Element (collections)</td>
                                                <td><code>List&lt;E&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>K</code></td>
                                                <td>Key</td>
                                                <td><code>Map&lt;K, V&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>V</code></td>
                                                <td>Value</td>
                                                <td><code>Map&lt;K, V&gt;</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>N</code></td>
                                                <td>Number</td>
                                                <td><code>Calculator&lt;N&gt;</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Generic Classes</h2>
                                    <pre><code class="language-java">// Define a generic class
public class Box&lt;T&gt; {
    private T content;

    public void set(T content) {
        this.content = content;
    }

    public T get() {
        return content;
    }

    public boolean isEmpty() {
        return content == null;
    }
}

// Usage - T becomes String
Box&lt;String&gt; stringBox = new Box&lt;&gt;();
stringBox.set("Hello Generics");
String value = stringBox.get();  // No cast needed

// Usage - T becomes Integer
Box&lt;Integer&gt; intBox = new Box&lt;&gt;();
intBox.set(42);
Integer num = intBox.get();

// Multiple type parameters
public class Pair&lt;K, V&gt; {
    private K key;
    private V value;

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public K getKey() { return key; }
    public V getValue() { return value; }
}

Pair&lt;String, Integer&gt; pair = new Pair&lt;&gt;("age", 25);</code></pre>

                                    <h2>Generic Methods</h2>
                                    <p>Methods can have their own type parameters, independent of the class.</p>
                                    <pre><code class="language-java">public class Utility {

    // Generic method - works with any array type
    public static &lt;T&gt; void printArray(T[] array) {
        for (T element : array) {
            System.out.print(element + " ");
        }
        System.out.println();
    }

    // Generic method with return type
    public static &lt;T&gt; T getFirst(List&lt;T&gt; list) {
        if (list.isEmpty()) {
            return null;
        }
        return list.get(0);
    }

    // Multiple type parameters
    public static &lt;K, V&gt; boolean compare(Pair&lt;K, V&gt; p1, Pair&lt;K, V&gt; p2) {
        return p1.getKey().equals(p2.getKey()) &amp;&amp;
               p1.getValue().equals(p2.getValue());
    }
}

// Usage
Integer[] nums = {1, 2, 3};
String[] words = {"a", "b", "c"};

Utility.printArray(nums);   // Works with Integer[]
Utility.printArray(words);  // Works with String[]

List&lt;String&gt; names = List.of("Alice", "Bob");
String first = Utility.getFirst(names);  // Returns "Alice"</code></pre>

                                    <h2>Bounded Type Parameters</h2>
                                    <p>Restrict the types that can be used with a generic.</p>
                                    <pre><code class="language-java">// Upper bound: T must be Number or its subclass
public class Calculator&lt;T extends Number&gt; {
    private T value;

    public Calculator(T value) {
        this.value = value;
    }

    public double doubleValue() {
        return value.doubleValue();  // Can call Number methods!
    }
}

Calculator&lt;Integer&gt; intCalc = new Calculator&lt;&gt;(42);
Calculator&lt;Double&gt; dblCalc = new Calculator&lt;&gt;(3.14);
// Calculator&lt;String&gt; strCalc = new Calculator&lt;&gt;("x"); // Error!

// Multiple bounds
public &lt;T extends Comparable&lt;T&gt; &amp; Serializable&gt; T findMax(T a, T b) {
    return a.compareTo(b) > 0 ? a : b;
}</code></pre>

                                    <h2>Wildcards</h2>
                                    <p>Wildcards provide flexibility when the exact type doesn't matter.</p>
                                    <pre><code class="language-java">// Unbounded wildcard: ? - any type
public void printList(List&lt;?&gt; list) {
    for (Object item : list) {
        System.out.println(item);
    }
}

// Upper bounded: ? extends Type - read-only
public double sumOfList(List&lt;? extends Number&gt; list) {
    double sum = 0;
    for (Number n : list) {
        sum += n.doubleValue();
    }
    return sum;
}

List&lt;Integer&gt; ints = List.of(1, 2, 3);
List&lt;Double&gt; doubles = List.of(1.1, 2.2, 3.3);
sumOfList(ints);     // Works!
sumOfList(doubles);  // Works!

// Lower bounded: ? super Type - write-only
public void addNumbers(List&lt;? super Integer&gt; list) {
    list.add(1);
    list.add(2);
    list.add(3);
}

List&lt;Number&gt; nums = new ArrayList&lt;&gt;();
List&lt;Object&gt; objs = new ArrayList&lt;&gt;();
addNumbers(nums);  // Works!
addNumbers(objs);  // Works!</code></pre>

                                    <div class="info-box">
                                        <strong>PECS Rule:</strong> Producer Extends, Consumer Super.<br>
                                        • Use <code>? extends T</code> when you only <strong>read</strong> from a collection (producer)<br>
                                        • Use <code>? super T</code> when you only <strong>write</strong> to a collection (consumer)
                                    </div>

                                    <h2>Generic Interfaces</h2>
                                    <pre><code class="language-java">// Define a generic interface
public interface Repository&lt;T, ID&gt; {
    T findById(ID id);
    List&lt;T&gt; findAll();
    void save(T entity);
    void delete(T entity);
}

// Implement with specific types
public class UserRepository implements Repository&lt;User, Long&gt; {
    @Override
    public User findById(Long id) { /* ... */ }

    @Override
    public List&lt;User&gt; findAll() { /* ... */ }

    @Override
    public void save(User entity) { /* ... */ }

    @Override
    public void delete(User entity) { /* ... */ }
}</code></pre>

                                    <h2>Type Erasure</h2>
                                    <p>Java generics use <strong>type erasure</strong> - generic type information is removed at runtime.</p>
                                    <pre><code class="language-java">// At compile time
List&lt;String&gt; strings = new ArrayList&lt;&gt;();
List&lt;Integer&gt; integers = new ArrayList&lt;&gt;();

// At runtime, both become just List (raw type)
// This means:
strings.getClass() == integers.getClass()  // true!

// Limitations due to type erasure:
// - Cannot create generic arrays: new T[10]
// - Cannot use instanceof with generics: obj instanceof List&lt;String&gt;
// - Cannot create instances of type parameters: new T()</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/GenericsExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-generics" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Generics</strong> provide compile-time type safety and eliminate casting</li>
                                            <li>Use type parameters: <code>T</code> (Type), <code>E</code> (Element), <code>K,V</code> (Key, Value)</li>
                                            <li><strong>Bounded types</strong> (<code>extends</code>) restrict allowed types</li>
                                            <li><strong>Wildcards</strong>: <code>?</code> (any), <code>? extends T</code> (read), <code>? super T</code> (write)</li>
                                            <li><strong>PECS</strong>: Producer Extends, Consumer Super</li>
                                            <li><strong>Type erasure</strong>: Generic info removed at runtime</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% 
                                            // Linking to start of next module
                                            String prevLinkUrl = request.getContextPath() + "/tutorials/java/collections-iterators.jsp"; 
                                            String nextLinkUrl = request.getContextPath() + "/tutorials/java/exceptions-basics.jsp"; 
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Iterators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Module 9: Exceptions" />
                                                <jsp:param name="currentLessonId" value="collections-generics" />
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