<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-logging" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Logging in Java - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn how to use Logging in Java.">
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

        <body class="tutorial-body no-preview" data-lesson="practices-logging">
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
                                    <span>Logging</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Logging with SLF4J and Logback</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Logging is essential for monitoring, debugging, and auditing applications.
                                        Proper logging helps you understand what your application is doing without attaching a debugger.</p>

                                    <h2>Logging Frameworks</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Framework</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>SLF4J</strong></td>
                                                <td>Facade/API - use this in your code</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Logback</strong></td>
                                                <td>Implementation - fast, feature-rich (recommended)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Log4j2</strong></td>
                                                <td>Implementation - async logging, plugins</td>
                                            </tr>
                                            <tr>
                                                <td><strong>java.util.logging</strong></td>
                                                <td>Built-in JDK logging (limited features)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Best Practice:</strong> Always code against SLF4J (the facade), then choose
                                        an implementation (Logback or Log4j2) at deployment time. This allows switching
                                        implementations without changing code.
                                    </div>

                                    <h2>Setup (Maven)</h2>
                                    <pre><code class="language-xml">&lt;!-- SLF4J API --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;org.slf4j&lt;/groupId&gt;
    &lt;artifactId&gt;slf4j-api&lt;/artifactId&gt;
    &lt;version&gt;2.0.9&lt;/version&gt;
&lt;/dependency&gt;

&lt;!-- Logback implementation --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;ch.qos.logback&lt;/groupId&gt;
    &lt;artifactId&gt;logback-classic&lt;/artifactId&gt;
    &lt;version&gt;1.4.11&lt;/version&gt;
&lt;/dependency&gt;</code></pre>

                                    <h2>Basic Usage</h2>
                                    <pre><code class="language-java">import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserService {
    // Create logger for this class
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    public User findById(Long id) {
        logger.debug("Looking up user with id: {}", id);

        User user = userRepository.findById(id);

        if (user == null) {
            logger.warn("User not found: {}", id);
            return null;
        }

        logger.info("Found user: {}", user.getEmail());
        return user;
    }

    public void processPayment(Order order) {
        logger.info("Processing payment for order: {}", order.getId());

        try {
            paymentGateway.charge(order);
            logger.info("Payment successful for order: {}", order.getId());
        } catch (PaymentException e) {
            logger.error("Payment failed for order: {}", order.getId(), e);
            throw e;
        }
    }
}</code></pre>

                                    <h2>Log Levels</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Level</th>
                                                <th>When to Use</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>ERROR</code></td>
                                                <td>Application errors, requires attention</td>
                                                <td>Database connection failed</td>
                                            </tr>
                                            <tr>
                                                <td><code>WARN</code></td>
                                                <td>Potential problems, recoverable</td>
                                                <td>Retry attempt, deprecated API used</td>
                                            </tr>
                                            <tr>
                                                <td><code>INFO</code></td>
                                                <td>Important business events</td>
                                                <td>User registered, order placed</td>
                                            </tr>
                                            <tr>
                                                <td><code>DEBUG</code></td>
                                                <td>Detailed flow information</td>
                                                <td>Method entry/exit, variable values</td>
                                            </tr>
                                            <tr>
                                                <td><code>TRACE</code></td>
                                                <td>Most detailed, rarely used</td>
                                                <td>Loop iterations, low-level details</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Parameterized Logging</h2>
                                    <pre><code class="language-java">// BAD: String concatenation (always evaluated)
logger.debug("Processing user: " + user.getName() + " with id: " + user.getId());

// GOOD: Parameterized (only evaluated if level is enabled)
logger.debug("Processing user: {} with id: {}", user.getName(), user.getId());

// With exception (exception is always the last argument)
logger.error("Failed to process user: {}", userId, exception);</code></pre>

                                    <h2>Logback Configuration</h2>
                                    <p>Create <code>src/main/resources/logback.xml</code>:</p>
                                    <pre><code class="language-xml">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;configuration&gt;

    &lt;!-- Console output --&gt;
    &lt;appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender"&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n&lt;/pattern&gt;
        &lt;/encoder&gt;
    &lt;/appender&gt;

    &lt;!-- File output with rotation --&gt;
    &lt;appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;file&gt;logs/app.log&lt;/file&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;fileNamePattern&gt;logs/app.%d{yyyy-MM-dd}.log&lt;/fileNamePattern&gt;
            &lt;maxHistory&gt;30&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n&lt;/pattern&gt;
        &lt;/encoder&gt;
    &lt;/appender&gt;

    &lt;!-- Set log levels for specific packages --&gt;
    &lt;logger name="com.example.myapp" level="DEBUG" /&gt;
    &lt;logger name="org.springframework" level="INFO" /&gt;
    &lt;logger name="org.hibernate.SQL" level="DEBUG" /&gt;

    &lt;!-- Root logger --&gt;
    &lt;root level="INFO"&gt;
        &lt;appender-ref ref="CONSOLE" /&gt;
        &lt;appender-ref ref="FILE" /&gt;
    &lt;/root&gt;

&lt;/configuration&gt;</code></pre>

                                    <h2>MDC (Mapped Diagnostic Context)</h2>
                                    <p>Add contextual information to all log messages in a thread:</p>
                                    <pre><code class="language-java">import org.slf4j.MDC;

public class RequestFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        try {
            // Add context that appears in all logs for this request
            MDC.put("requestId", UUID.randomUUID().toString());
            MDC.put("userId", getCurrentUserId());

            chain.doFilter(request, response);
        } finally {
            MDC.clear();  // Always clean up!
        }
    }
}

// In logback.xml, use %X{key} to include MDC values:
// &lt;pattern&gt;%d [%X{requestId}] [%X{userId}] %level %logger - %msg%n&lt;/pattern&gt;

// Output: 2024-01-15 10:30:45 [abc-123] [user42] INFO UserService - User logged in</code></pre>

                                    <h2>Logging Best Practices</h2>

                                    <h3>What to Log</h3>
                                    <ul>
                                        <li>Application startup/shutdown</li>
                                        <li>Configuration values (not secrets!)</li>
                                        <li>Business events (orders, registrations)</li>
                                        <li>Errors with full stack traces</li>
                                        <li>Integration points (API calls, DB queries)</li>
                                    </ul>

                                    <h3>What NOT to Log</h3>
                                    <ul>
                                        <li>Passwords, tokens, API keys</li>
                                        <li>Credit card numbers, SSNs</li>
                                        <li>Personal data (GDPR compliance)</li>
                                        <li>Large data structures (use DEBUG level)</li>
                                    </ul>

                                    <pre><code class="language-java">// BAD: Logging sensitive data
logger.info("User login: {} with password: {}", username, password);

// GOOD: Mask sensitive data
logger.info("User login: {}", username);

// BAD: Logging large objects at INFO
logger.info("Response: {}", hugeJsonResponse);

// GOOD: Log at DEBUG, or log summary
logger.debug("Full response: {}", hugeJsonResponse);
logger.info("Received {} items", response.getItems().size());</code></pre>

                                    <h2>Performance Tips</h2>
                                    <pre><code class="language-java">// Check level before expensive operations
if (logger.isDebugEnabled()) {
    logger.debug("Expensive computation result: {}", computeExpensiveValue());
}

// Use lazy evaluation (SLF4J 2.0+)
logger.atDebug()
    .addArgument(() -> expensiveComputation())
    .log("Result: {}");</code></pre>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <strong>SLF4J</strong> facade with <strong>Logback</strong> implementation</li>
                                            <li>Use <strong>parameterized logging</strong> (not string concatenation)</li>
                                            <li>Choose <strong>appropriate log levels</strong> for different messages</li>
                                            <li>Configure <strong>file rotation</strong> to manage disk space</li>
                                            <li>Use <strong>MDC</strong> for request tracking across logs</li>
                                            <li><strong>Never log</strong> passwords, tokens, or PII</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-build-tools.jsp" ; String
                                    nextLinkUrl=request.getContextPath() + "/tutorials/java/practices-debugging.jsp" ;
                                    %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Build Tools" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Debugging →" />
                                    <jsp:param name="currentLessonId" value="practices-logging" />
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