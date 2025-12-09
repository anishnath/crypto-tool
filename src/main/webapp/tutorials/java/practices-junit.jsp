<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-junit" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Unit Testing in Java - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Unit Testing in Java using JUnit.">
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

        <body class="tutorial-body no-preview" data-lesson="practices-junit">
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
                                    <span>Unit Testing</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Unit Testing with JUnit</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Unit testing is a critical part of professional software
                                        development. JUnit is the most popular testing framework for Java, enabling
                                        you to write automated, repeatable tests that verify your code works correctly.</p>

                                    <h2>Why Unit Testing?</h2>
                                    <ul>
                                        <li><strong>Catch bugs early:</strong> Find issues before they reach production</li>
                                        <li><strong>Refactor with confidence:</strong> Change code knowing tests will catch regressions</li>
                                        <li><strong>Documentation:</strong> Tests show how code is meant to be used</li>
                                        <li><strong>Better design:</strong> Testable code is usually better designed</li>
                                    </ul>

                                    <h2>JUnit 5 Setup (Maven)</h2>
                                    <pre><code class="language-xml">&lt;dependency&gt;
    &lt;groupId&gt;org.junit.jupiter&lt;/groupId&gt;
    &lt;artifactId&gt;junit-jupiter&lt;/artifactId&gt;
    &lt;version&gt;5.10.0&lt;/version&gt;
    &lt;scope&gt;test&lt;/scope&gt;
&lt;/dependency&gt;</code></pre>

                                    <h2>Basic Test Structure</h2>
                                    <pre><code class="language-java">import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {

    private Calculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new Calculator();  // Fresh instance for each test
    }

    @Test
    @DisplayName("Adding two positive numbers")
    void testAddPositiveNumbers() {
        assertEquals(5, calculator.add(2, 3));
    }

    @Test
    void testAddNegativeNumbers() {
        assertEquals(-5, calculator.add(-2, -3));
    }

    @Test
    void testDivideByZero() {
        assertThrows(ArithmeticException.class, () -> {
            calculator.divide(10, 0);
        });
    }
}</code></pre>

                                    <h2>Common Assertions</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Assertion</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>assertEquals(expected, actual)</code></td>
                                                <td>Values are equal</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertNotEquals(a, b)</code></td>
                                                <td>Values are not equal</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertTrue(condition)</code></td>
                                                <td>Condition is true</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertFalse(condition)</code></td>
                                                <td>Condition is false</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertNull(object)</code></td>
                                                <td>Object is null</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertNotNull(object)</code></td>
                                                <td>Object is not null</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertThrows(Exception.class, () -&gt; ...)</code></td>
                                                <td>Code throws exception</td>
                                            </tr>
                                            <tr>
                                                <td><code>assertArrayEquals(arr1, arr2)</code></td>
                                                <td>Arrays are equal</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Lifecycle Annotations</h2>
                                    <pre><code class="language-java">class LifecycleTest {

    @BeforeAll
    static void initAll() {
        // Runs once before all tests (e.g., database connection)
    }

    @BeforeEach
    void init() {
        // Runs before each test (e.g., reset state)
    }

    @Test
    void testSomething() {
        // Your test
    }

    @AfterEach
    void tearDown() {
        // Runs after each test (e.g., cleanup)
    }

    @AfterAll
    static void tearDownAll() {
        // Runs once after all tests (e.g., close connection)
    }
}</code></pre>

                                    <h2>Parameterized Tests</h2>
                                    <p>Run the same test with different inputs:</p>
                                    <pre><code class="language-java">import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.*;

class ParameterizedTests {

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 4, 5})
    void testIsPositive(int number) {
        assertTrue(number > 0);
    }

    @ParameterizedTest
    @CsvSource({
        "1, 1, 2",
        "2, 3, 5",
        "10, 20, 30"
    })
    void testAdd(int a, int b, int expected) {
        assertEquals(expected, calculator.add(a, b));
    }

    @ParameterizedTest
    @MethodSource("provideStringsForIsBlank")
    void testIsBlank(String input, boolean expected) {
        assertEquals(expected, StringUtils.isBlank(input));
    }

    static Stream&lt;Arguments&gt; provideStringsForIsBlank() {
        return Stream.of(
            Arguments.of(null, true),
            Arguments.of("", true),
            Arguments.of("  ", true),
            Arguments.of("hello", false)
        );
    }
}</code></pre>

                                    <h2>Testing Best Practices</h2>
                                    <div class="info-box">
                                        <strong>AAA Pattern:</strong>
                                        <ul style="margin-bottom: 0;">
                                            <li><strong>Arrange:</strong> Set up test data and conditions</li>
                                            <li><strong>Act:</strong> Execute the code being tested</li>
                                            <li><strong>Assert:</strong> Verify the results</li>
                                        </ul>
                                    </div>

                                    <pre><code class="language-java">@Test
void testUserRegistration() {
    // Arrange
    UserService service = new UserService();
    User user = new User("john@example.com", "password123");

    // Act
    boolean result = service.register(user);

    // Assert
    assertTrue(result);
    assertNotNull(service.findByEmail("john@example.com"));
}</code></pre>

                                    <h2>Test Naming Conventions</h2>
                                    <pre><code class="language-java">// Good test names describe behavior
@Test void shouldReturnTrueWhenUserIsAdmin() { }
@Test void shouldThrowExceptionWhenEmailIsInvalid() { }
@Test void givenValidUser_whenRegister_thenSuccess() { }

// Avoid vague names
@Test void test1() { }  // Bad
@Test void testUser() { }  // Bad</code></pre>

                                    <h2>Mocking with Mockito</h2>
                                    <p>Mock dependencies to isolate the code under test:</p>
                                    <pre><code class="language-java">import static org.mockito.Mockito.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    void testFindUser() {
        // Arrange - define mock behavior
        User mockUser = new User("john@example.com");
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

        // Act
        User result = userService.findById(1L);

        // Assert
        assertEquals("john@example.com", result.getEmail());
        verify(userRepository, times(1)).findById(1L);
    }
}</code></pre>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <strong>JUnit 5</strong> for modern Java testing</li>
                                            <li>Follow <strong>AAA pattern</strong>: Arrange, Act, Assert</li>
                                            <li>Use <strong>@BeforeEach</strong> for test setup</li>
                                            <li>Use <strong>parameterized tests</strong> to reduce duplication</li>
                                            <li>Use <strong>Mockito</strong> to mock dependencies</li>
                                            <li>Write <strong>descriptive test names</strong> that explain behavior</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-packages.jsp" ; String
                                    nextLinkUrl=request.getContextPath() + "/tutorials/java/practices-patterns.jsp" ; %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Code Organization" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Design Patterns →" />
                                    <jsp:param name="currentLessonId" value="practices-junit" />
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