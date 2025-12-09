<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "io-serialization" ); request.setAttribute("currentModule", "File I/O" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Serialization - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Serialization. How to save objects to files and read them back using Serializable interface.">
            <meta name="keywords"
                content="java serialization, java serializable, java objectoutputstream, java objectinputstream, transient keyword">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Serialization - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Save and restore Java objects with Serialization.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/io-serialization.jsp">
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
    "name": "Java Serialization",
    "description": "Guide to Java Serialization.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Serialization", "Deserialization", "transient keyword"],
    "timeRequired": "PT15M",
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

        <body class="tutorial-body no-preview" data-lesson="io-serialization">
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
                                    <span>Serialization</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Serialization</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Serialization</strong> converts Java objects into byte streams
                                        for storage or transmission. <strong>Deserialization</strong> reconstructs objects
                                        from those bytes. This enables object persistence, network transfer, and caching.</p>

                                    <h2>Why Serialization?</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Use Case</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Persistence</strong></td>
                                                <td>Save object state to files or databases</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Network Transfer</strong></td>
                                                <td>Send objects between JVMs (RMI, distributed systems)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Caching</strong></td>
                                                <td>Store objects in memory caches (Redis, Memcached)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Deep Copy</strong></td>
                                                <td>Clone objects by serializing and deserializing</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>The Serializable Interface</h2>
                                    <p><code>java.io.Serializable</code> is a marker interface (no methods). Implementing
                                        it tells Java that this class can be serialized.</p>
                                    <pre><code class="language-java">import java.io.Serializable;

public class User implements Serializable {
    // Recommended: Define a version ID for compatibility
    private static final long serialVersionUID = 1L;

    private String username;
    private String email;
    private int age;

    public User(String username, String email, int age) {
        this.username = username;
        this.email = email;
        this.age = age;
    }

    // Getters and setters...

    @Override
    public String toString() {
        return "User{username='" + username + "', email='" + email + "', age=" + age + "}";
    }
}</code></pre>

                                    <div class="info-box">
                                        <strong>serialVersionUID:</strong> A unique version identifier for the class.
                                        If you modify the class and the UID changes, deserialization of old data will fail
                                        with <code>InvalidClassException</code>. Always define it explicitly!
                                    </div>

                                    <h2>Serializing Objects</h2>
                                    <p>Use <code>ObjectOutputStream</code> to write objects to a file:</p>
                                    <pre><code class="language-java">import java.io.*;

public class SerializeDemo {
    public static void main(String[] args) {
        User user = new User("john_doe", "john@example.com", 25);

        // Serialize - save object to file
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream("user.ser"))) {

            oos.writeObject(user);
            System.out.println("Object serialized successfully!");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}</code></pre>

                                    <h2>Deserializing Objects</h2>
                                    <p>Use <code>ObjectInputStream</code> to read objects from a file:</p>
                                    <pre><code class="language-java">import java.io.*;

public class DeserializeDemo {
    public static void main(String[] args) {
        // Deserialize - read object from file
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream("user.ser"))) {

            User user = (User) ois.readObject();
            System.out.println("Deserialized: " + user);

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}</code></pre>

                                    <h2>The transient Keyword</h2>
                                    <p>Fields marked <code>transient</code> are excluded from serialization. Use this for:</p>
                                    <ul>
                                        <li>Sensitive data (passwords, tokens)</li>
                                        <li>Computed/derived values</li>
                                        <li>Non-serializable objects</li>
                                    </ul>
                                    <pre><code class="language-java">public class Account implements Serializable {
    private static final long serialVersionUID = 1L;

    private String username;
    private transient String password;     // NOT serialized
    private transient double cachedBalance; // NOT serialized

    public Account(String username, String password) {
        this.username = username;
        this.password = password;
    }
}

// After deserialization:
// - username = "john"
// - password = null (transient fields get default values)
// - cachedBalance = 0.0</code></pre>

                                    <h2>Serializing Collections</h2>
                                    <pre><code class="language-java">import java.io.*;
import java.util.*;

public class SerializeCollection {
    public static void main(String[] args) throws Exception {
        List&lt;User&gt; users = new ArrayList&lt;&gt;();
        users.add(new User("alice", "alice@example.com", 30));
        users.add(new User("bob", "bob@example.com", 25));

        // Serialize the entire list
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream("users.ser"))) {
            oos.writeObject(users);
        }

        // Deserialize the list
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream("users.ser"))) {
            @SuppressWarnings("unchecked")
            List&lt;User&gt; loadedUsers = (List&lt;User&gt;) ois.readObject();
            loadedUsers.forEach(System.out::println);
        }
    }
}</code></pre>

                                    <h2>Custom Serialization</h2>
                                    <p>Override <code>writeObject</code> and <code>readObject</code> for custom behavior:</p>
                                    <pre><code class="language-java">public class SecureUser implements Serializable {
    private static final long serialVersionUID = 1L;

    private String username;
    private transient String password;

    // Custom serialization - encrypt password before saving
    private void writeObject(ObjectOutputStream oos) throws IOException {
        oos.defaultWriteObject();  // Serialize non-transient fields
        oos.writeObject(encrypt(password));  // Manually write encrypted password
    }

    // Custom deserialization - decrypt password after loading
    private void readObject(ObjectInputStream ois)
            throws IOException, ClassNotFoundException {
        ois.defaultReadObject();  // Deserialize non-transient fields
        this.password = decrypt((String) ois.readObject());  // Decrypt password
    }

    private String encrypt(String data) { /* encryption logic */ }
    private String decrypt(String data) { /* decryption logic */ }
}</code></pre>

                                    <h2>Inheritance and Serialization</h2>
                                    <pre><code class="language-java">// Parent class is NOT Serializable
class Person {
    String name;
    int age;

    // MUST have no-arg constructor for deserialization!
    public Person() {
        this.name = "Unknown";
        this.age = 0;
    }
}

// Child class IS Serializable
class Employee extends Person implements Serializable {
    private static final long serialVersionUID = 1L;
    String employeeId;

    public Employee(String name, int age, String employeeId) {
        this.name = name;
        this.age = age;
        this.employeeId = employeeId;
    }
}

// After deserialization:
// - employeeId = "E123" (serialized)
// - name = "Unknown" (from parent's no-arg constructor)
// - age = 0 (from parent's no-arg constructor)</code></pre>

                                    <div class="info-box">
                                        <strong>Rule:</strong> If a parent class is not Serializable, it MUST have a
                                        no-argument constructor. Parent fields won't be serialized and will be
                                        initialized via that constructor during deserialization.
                                    </div>

                                    <h2>Externalizable Interface</h2>
                                    <p>For complete control over serialization, implement <code>Externalizable</code>:</p>
                                    <pre><code class="language-java">import java.io.*;

public class Product implements Externalizable {
    private String name;
    private double price;
    private transient int stockCount;

    // REQUIRED: public no-arg constructor
    public Product() {}

    public Product(String name, double price, int stockCount) {
        this.name = name;
        this.price = price;
        this.stockCount = stockCount;
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeUTF(name);
        out.writeDouble(price);
        // Don't write stockCount
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException {
        name = in.readUTF();
        price = in.readDouble();
        stockCount = 0;  // Default value
    }
}</code></pre>

                                    <h2>Serialization vs Externalizable</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Serializable</th>
                                                <th>Externalizable</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Control</td>
                                                <td>Automatic (default behavior)</td>
                                                <td>Full manual control</td>
                                            </tr>
                                            <tr>
                                                <td>Performance</td>
                                                <td>Slower (uses reflection)</td>
                                                <td>Faster (direct read/write)</td>
                                            </tr>
                                            <tr>
                                                <td>No-arg constructor</td>
                                                <td>Not required</td>
                                                <td>Required (public)</td>
                                            </tr>
                                            <tr>
                                                <td>transient fields</td>
                                                <td>Supported</td>
                                                <td>You decide what to write</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Security Considerations</h2>
                                    <div class="info-box" style="background-color: #fff3cd; border-color: #ffc107;">
                                        <strong>Warning:</strong> Java serialization has known security vulnerabilities.
                                        Deserializing untrusted data can lead to remote code execution attacks.
                                        <ul style="margin-bottom: 0;">
                                            <li>Never deserialize data from untrusted sources</li>
                                            <li>Consider using JSON (Jackson, Gson) or Protocol Buffers instead</li>
                                            <li>Use serialization filters (Java 9+) to restrict allowed classes</li>
                                        </ul>
                                    </div>

                                    <h2>Modern Alternatives</h2>
                                    <pre><code class="language-java">// JSON with Jackson (recommended for most use cases)
ObjectMapper mapper = new ObjectMapper();

// Serialize to JSON
String json = mapper.writeValueAsString(user);
// {"username":"john","email":"john@example.com","age":25}

// Deserialize from JSON
User user = mapper.readValue(json, User.class);

// JSON with Gson
Gson gson = new Gson();
String json = gson.toJson(user);
User user = gson.fromJson(json, User.class);</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/io-serialization.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-serialize" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Serializable</strong>: Marker interface for automatic serialization</li>
                                            <li><strong>serialVersionUID</strong>: Always define for version compatibility</li>
                                            <li><strong>transient</strong>: Exclude fields from serialization</li>
                                            <li><strong>ObjectOutputStream/ObjectInputStream</strong>: Write/read objects</li>
                                            <li><strong>Externalizable</strong>: Full control over serialization format</li>
                                            <li><strong>Security</strong>: Never deserialize untrusted data; consider JSON alternatives</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/io-scanner.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/io-nio.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Scanner Class" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="NIO (New I/O) →" />
                                                <jsp:param name="currentLessonId" value="io-serialization" />
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