<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-best-practices" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Java Best Practices - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Java Best Practices and coding standards.">
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
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="practices-best-practices">
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
                                    <span>Best Practices</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Best Practices</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Writing code that works is not enough; professional code must be
                                        readable, maintainable, and efficient. These best practices will help you write
                                        code that your future self and teammates will thank you for.</p>

                                    <h2>Naming Conventions</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Element</th>
                                                <th>Convention</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Classes</td>
                                                <td>PascalCase (nouns)</td>
                                                <td><code>UserAccount</code>, <code>HttpClient</code></td>
                                            </tr>
                                            <tr>
                                                <td>Interfaces</td>
                                                <td>PascalCase (adjectives or nouns)</td>
                                                <td><code>Runnable</code>, <code>Comparable</code></td>
                                            </tr>
                                            <tr>
                                                <td>Methods</td>
                                                <td>camelCase (verbs)</td>
                                                <td><code>calculateTotal()</code>, <code>getUserById()</code></td>
                                            </tr>
                                            <tr>
                                                <td>Variables</td>
                                                <td>camelCase (nouns)</td>
                                                <td><code>userName</code>, <code>totalCount</code></td>
                                            </tr>
                                            <tr>
                                                <td>Constants</td>
                                                <td>UPPER_SNAKE_CASE</td>
                                                <td><code>MAX_SIZE</code>, <code>DEFAULT_TIMEOUT</code></td>
                                            </tr>
                                            <tr>
                                                <td>Packages</td>
                                                <td>lowercase</td>
                                                <td><code>com.company.project</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Clean Code Principles</h2>

                                    <h3>1. Single Responsibility Principle (SRP)</h3>
                                    <p>A class should have one, and only one, reason to change.</p>
                                    <pre><code class="language-java">// Bad: Class does too many things
class UserManager {
    void createUser() { }
    void deleteUser() { }
    void sendEmail() { }      // Not user management!
    void generateReport() { } // Not user management!
}

// Good: Each class has one responsibility
class UserService {
    void createUser() { }
    void deleteUser() { }
}

class EmailService {
    void sendEmail() { }
}

class ReportGenerator {
    void generateReport() { }
}</code></pre>

                                    <h3>2. Meaningful Names</h3>
                                    <pre><code class="language-java">// Bad
int d; // elapsed time in days
List&lt;int[]&gt; list1;

// Good
int elapsedTimeInDays;
List&lt;int[]&gt; flaggedCells;

// Bad method name
public List&lt;User&gt; get() { }

// Good method name
public List&lt;User&gt; getActiveUsersByDepartment(String dept) { }</code></pre>

                                    <h3>3. Keep Methods Small</h3>
                                    <pre><code class="language-java">// Bad: Method does too much
public void processOrder(Order order) {
    // validate order (20 lines)
    // calculate totals (15 lines)
    // apply discounts (10 lines)
    // save to database (10 lines)
    // send confirmation email (15 lines)
}

// Good: Extract methods
public void processOrder(Order order) {
    validateOrder(order);
    calculateTotals(order);
    applyDiscounts(order);
    saveOrder(order);
    sendConfirmation(order);
}

private void validateOrder(Order order) { /* ... */ }
private void calculateTotals(Order order) { /* ... */ }
// etc.</code></pre>

                                    <h2>Defensive Programming</h2>

                                    <h3>Validate Inputs</h3>
                                    <pre><code class="language-java">public void setAge(int age) {
    if (age < 0 || age > 150) {
        throw new IllegalArgumentException("Age must be between 0 and 150");
    }
    this.age = age;
}

// Using Objects utility class
public void setName(String name) {
    this.name = Objects.requireNonNull(name, "Name cannot be null");
}</code></pre>

                                    <h3>Return Empty Collections, Not Null</h3>
                                    <pre><code class="language-java">// Bad: Returns null
public List&lt;User&gt; getUsers() {
    if (noUsersFound) {
        return null;  // Caller must check for null!
    }
    return users;
}

// Good: Returns empty collection
public List&lt;User&gt; getUsers() {
    if (noUsersFound) {
        return Collections.emptyList();  // Safe to iterate
    }
    return users;
}</code></pre>

                                    <h3>Use Optional for Nullable Returns</h3>
                                    <pre><code class="language-java">// Bad: Returns null
public User findUserById(Long id) {
    // Returns null if not found
}

// Good: Returns Optional
public Optional&lt;User&gt; findUserById(Long id) {
    return Optional.ofNullable(userRepository.find(id));
}

// Usage
findUserById(123)
    .ifPresent(user -> System.out.println(user.getName()));

String name = findUserById(123)
    .map(User::getName)
    .orElse("Unknown");</code></pre>

                                    <h2>Exception Handling</h2>
                                    <pre><code class="language-java">// Bad: Catching generic Exception
try {
    processFile();
} catch (Exception e) {
    e.printStackTrace();  // Don't just print!
}

// Good: Catch specific exceptions, handle properly
try {
    processFile();
} catch (FileNotFoundException e) {
    logger.error("File not found: " + e.getMessage());
    throw new ProcessingException("Configuration file missing", e);
} catch (IOException e) {
    logger.error("Error reading file", e);
    throw new ProcessingException("Failed to read file", e);
}

// Good: Try-with-resources for auto-closing
try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
    String line;
    while ((line = reader.readLine()) != null) {
        process(line);
    }
}  // Reader automatically closed</code></pre>

                                    <h2>Immutability</h2>
                                    <p>Immutable objects are thread-safe and easier to reason about.</p>
                                    <pre><code class="language-java">// Immutable class
public final class Money {
    private final BigDecimal amount;
    private final Currency currency;

    public Money(BigDecimal amount, Currency currency) {
        this.amount = amount;
        this.currency = currency;
    }

    // No setters! Return new instance instead
    public Money add(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException("Currency mismatch");
        }
        return new Money(this.amount.add(other.amount), this.currency);
    }

    public BigDecimal getAmount() {
        return amount;  // BigDecimal is already immutable
    }
}

// Using records (Java 16+) - automatically immutable
public record Point(int x, int y) { }</code></pre>

                                    <h2>Code Comments</h2>
                                    <pre><code class="language-java">// Bad: Comment states the obvious
i++; // Increment i

// Bad: Comment compensates for bad code
// Check if employee is eligible for benefits
if ((employee.flags &amp; HOURLY_FLAG) &amp;&amp; (employee.age > 65)) { }

// Good: Self-documenting code
if (employee.isEligibleForBenefits()) { }

// Good: Explain WHY, not WHAT
// Using insertion sort here because the list is nearly sorted
// and insertion sort is O(n) for nearly sorted data
insertionSort(nearySortedList);

// Good: Javadoc for public APIs
/**
 * Calculates compound interest.
 *
 * @param principal Initial investment amount
 * @param rate Annual interest rate (e.g., 0.05 for 5%)
 * @param years Number of years
 * @return Final amount after compound interest
 */
public BigDecimal calculateCompoundInterest(
        BigDecimal principal, double rate, int years) { }</code></pre>

                                    <h2>Common Pitfalls</h2>

                                    <h3>String Comparison</h3>
                                    <pre><code class="language-java">// Bad: == compares references
if (str1 == str2) { }

// Good: equals() compares content
if (str1.equals(str2)) { }

// Better: Handles null safely
if (Objects.equals(str1, str2)) { }

// Best for literals: Literal first avoids NullPointerException
if ("expected".equals(str1)) { }</code></pre>

                                    <h3>Floating Point Comparison</h3>
                                    <pre><code class="language-java">// Bad: Direct comparison fails due to precision
if (0.1 + 0.2 == 0.3) { }  // false!

// Good: Use threshold
double EPSILON = 0.0001;
if (Math.abs(a - b) < EPSILON) { }

// Best for money: Use BigDecimal
BigDecimal a = new BigDecimal("0.1");
BigDecimal b = new BigDecimal("0.2");
BigDecimal c = new BigDecimal("0.3");
a.add(b).equals(c);  // true</code></pre>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <strong>meaningful names</strong> that reveal intent</li>
                                            <li>Keep methods <strong>small and focused</strong> (SRP)</li>
                                            <li><strong>Validate inputs</strong> and fail fast</li>
                                            <li>Return <strong>empty collections</strong>, not null</li>
                                            <li>Use <strong>Optional</strong> for nullable returns</li>
                                            <li>Catch <strong>specific exceptions</strong> and handle properly</li>
                                            <li>Prefer <strong>immutable objects</strong> when possible</li>
                                            <li>Write <strong>self-documenting code</strong>; comment the "why"</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-patterns.jsp" ; String
                                    nextLinkUrl=request.getContextPath() + "/tutorials/java/practices-build-tools.jsp" ;
                                    %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Design Patterns" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Build Tools →" />
                                    <jsp:param name="currentLessonId" value="practices-best-practices" />
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