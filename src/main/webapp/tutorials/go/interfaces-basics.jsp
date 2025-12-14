<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "interfaces-basics" );
        request.setAttribute("currentModule", "Pointers & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Interface Basics in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go interfaces, implicit implementation, polymorphism, empty interface, and interface satisfaction. Master Go's approach to abstraction.">
            <meta name="keywords"
                content="go interfaces, golang interfaces, go polymorphism, empty interface, interface satisfaction, go abstraction">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Interface Basics in Go">
            <meta property="og:description" content="Master Go interfaces and polymorphism.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/interfaces-basics.jsp">
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
    "name": "Interface Basics in Go",
    "description": "Learn Go interfaces, implicit implementation, and polymorphism with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/interfaces-basics.jsp",
    "teaches": ["interfaces", "polymorphism", "implicit implementation", "empty interface"],
    "timeRequired": "PT40M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="interfaces-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-go.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/go/">Go</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Interface Basics</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Interface Basics</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Interfaces are Go's way of defining behavior. They enable
                                        polymorphism without
                                        inheritance, making code flexible and testable. In this lesson, you'll learn how
                                        interfaces
                                        work, how to define them, and how to use them effectively.</p>

                                    <!-- Section 1: What is an Interface? -->
                                    <h2>What is an Interface?</h2>
                                    <p>An interface is a collection of method signatures. Any type that implements all
                                        the methods
                                        automatically satisfies the interface:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/interfaces-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-interfaces" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Interface Characteristics:</strong>
                                        <ul>
                                            <li><strong>Implicit implementation</strong> - No "implements" keyword
                                                needed</li>
                                            <li><strong>Duck typing</strong> - "If it walks like a duck and quacks like
                                                a duck..."</li>
                                            <li><strong>Polymorphism</strong> - Different types can satisfy the same
                                                interface</li>
                                            <li><strong>Decoupling</strong> - Depend on behavior, not concrete types
                                            </li>
                                        </ul>
                                    </div>

                                    <h3>Interface Syntax</h3>
                                    <pre><code class="language-go">type InterfaceName interface {
    Method1(param type) returnType
    Method2(param type) returnType
    // ... more methods
}</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Interface names often end with "-er" (Reader,
                                        Writer, Stringer).
                                        Keep interfaces small—preferably one or two methods!
                                    </div>

                                    <!-- Section 2: Implicit Implementation -->
                                    <h2>Implicit Implementation</h2>
                                    <p>Go doesn't require explicit declaration of interface implementation:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/interfaces-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-implicit" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Why Implicit Implementation?</strong>
                                        <ul>
                                            <li>Types can satisfy interfaces from other packages</li>
                                            <li>No need to modify existing code</li>
                                            <li>More flexible and decoupled</li>
                                            <li>Easier to test (mock interfaces)</li>
                                        </ul>
                                    </div>

                                    <div class="diagram-container">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-interfaces-polymorphism.svg"
                                            alt="Interfaces and Polymorphism in Go" class="tutorial-diagram"
                                            style="max-width: 100%; height: auto; margin: 2rem 0;" />
                                        <p class="diagram-caption">Figure: Interfaces and Polymorphism - How different
                                            types (Circle, Rectangle) can satisfy the same interface (Shape)</p>
                                    </div>

                                    <!-- Section 3: Interface Values -->
                                    <h2>Interface Values</h2>
                                    <p>An interface value holds a value of a specific type:</p>

                                    <pre><code class="language-go">var s Shape
s = Circle{Radius: 5}    // s holds a Circle
s = Rectangle{W: 3, H: 4} // s now holds a Rectangle

// Interface value has two components:
// 1. Concrete type (Circle or Rectangle)
// 2. Concrete value (the actual data)</code></pre>

                                    <h3>Nil Interface Values</h3>
                                    <pre><code class="language-go">var s Shape  // nil interface (both type and value are nil)

// Calling method on nil interface panics
s.Area()  // panic!

// Check for nil
if s != nil {
    s.Area()
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 4: Empty Interface -->
                                    <h2>The Empty Interface</h2>
                                    <p>The empty interface <code>interface{}</code> can hold values of any type:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/interfaces-values.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-empty" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Empty Interface Uses:</strong>
                                        <ul>
                                            <li>Functions that accept any type (like <code>fmt.Println</code>)</li>
                                            <li>Generic data structures (before Go 1.18 generics)</li>
                                            <li>JSON unmarshaling to unknown structures</li>
                                        </ul>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Note:</strong> Go 1.18+ introduced generics with <code>any</code> as an
                                        alias for
                                        <code>interface{}</code>. Use <code>any</code> in new code for clarity!
                                    </div>

                                    <!-- Section 5: Interface Composition -->
                                    <h2>Interface Composition</h2>
                                    <p>Interfaces can be composed from other interfaces:</p>

                                    <pre><code class="language-go">type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

// Composed interface
type ReadWriter interface {
    Reader
    Writer
}

type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Compose small interfaces into larger ones. This
                                        follows the
                                        "Interface Segregation Principle"—clients shouldn't depend on methods they don't
                                        use.
                                    </div>

                                    <!-- Section 6: Practical Examples -->
                                    <h2>Practical Interface Patterns</h2>

                                    <h3>1. Dependency Injection</h3>
                                    <pre><code class="language-go">// Define interface for what you need
type DataStore interface {
    Save(data string) error
    Load() (string, error)
}

// Business logic depends on interface
type Service struct {
    store DataStore
}

func (s *Service) Process(data string) error {
    return s.store.Save(data)
}

// Different implementations
type FileStore struct { /* ... */ }
func (f *FileStore) Save(data string) error { /* ... */ }
func (f *FileStore) Load() (string, error) { /* ... */ }

type MemoryStore struct { /* ... */ }
func (m *MemoryStore) Save(data string) error { /* ... */ }
func (m *MemoryStore) Load() (string, error) { /* ... */ }</code></pre>

                                    <h3>2. Testing with Mocks</h3>
                                    <pre><code class="language-go">// Production code
type EmailSender interface {
    Send(to, subject, body string) error
}

type UserService struct {
    emailer EmailSender
}

// Test code
type MockEmailer struct {
    sentEmails []string
}

func (m *MockEmailer) Send(to, subject, body string) error {
    m.sentEmails = append(m.sentEmails, to)
    return nil
}

// Test
func TestUserService(t *testing.T) {
    mock := &MockEmailer{}
    service := UserService{emailer: mock}
    // Test without sending real emails!
}</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Interface pollution (too many interfaces)</h4>
                                        <pre><code class="language-go">// ❌ Wrong - unnecessary interface
type UserGetter interface {
    GetUser(id int) User
}

type UserService struct{}
func (s *UserService) GetUser(id int) User { /* ... */ }

// Only one implementation? Don't need interface!

// ✅ Correct - use concrete type
type UserService struct{}
func (s *UserService) GetUser(id int) User { /* ... */ }

// Create interface only when you need abstraction</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Pointer vs value receivers</h4>
                                        <pre><code class="language-go">type Printer interface {
    Print()
}

type Document struct {
    content string
}

// Pointer receiver
func (d *Document) Print() {
    fmt.Println(d.content)
}

// ❌ Wrong - value doesn't satisfy interface
var p Printer = Document{content: "test"}  // Error!

// ✅ Correct - use pointer
var p Printer = &Document{content: "test"}  // OK</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Returning concrete type instead of interface</h4>
                                        <pre><code class="language-go">// ❌ Less flexible
func NewUserService() *UserService {
    return &UserService{}
}

// ✅ Better - return interface
type UserStore interface {
    GetUser(id int) User
}

func NewUserService() UserStore {
    return &UserService{}
}
// Callers depend on interface, not concrete type</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Payment Processor</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a payment processing system with interfaces.
                                        </p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define a <code>PaymentMethod</code> interface with <code>Pay(amount float64)
                                                    error</code></li>
                                            <li>Implement <code>CreditCard</code> and <code>PayPal</code> types</li>
                                            <li>Create a <code>processPayment</code> function that accepts the interface
                                            </li>
                                            <li>Test with both payment methods</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "fmt"
)

// PaymentMethod interface
type PaymentMethod interface {
    Pay(amount float64) error
}

// CreditCard implementation
type CreditCard struct {
    Number string
    Name   string
}

func (c CreditCard) Pay(amount float64) error {
    fmt.Printf("Charging $%.2f to credit card %s\n", amount, c.Number)
    return nil
}

// PayPal implementation
type PayPal struct {
    Email string
}

func (p PayPal) Pay(amount float64) error {
    fmt.Printf("Charging $%.2f to PayPal account %s\n", amount, p.Email)
    return nil
}

// Bitcoin implementation (bonus)
type Bitcoin struct {
    WalletAddress string
}

func (b Bitcoin) Pay(amount float64) error {
    fmt.Printf("Sending $%.2f worth of Bitcoin to %s\n", amount, b.WalletAddress)
    return nil
}

// Process payment using any payment method
func processPayment(method PaymentMethod, amount float64) error {
    fmt.Printf("Processing payment of $%.2f...\n", amount)
    return method.Pay(amount)
}

func main() {
    // Test with different payment methods
    cc := CreditCard{
        Number: "**** **** **** 1234",
        Name:   "Alice Smith",
    }
    
    pp := PayPal{
        Email: "alice@example.com",
    }
    
    btc := Bitcoin{
        WalletAddress: "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
    }
    
    // Process payments
    processPayment(cc, 99.99)
    fmt.Println()
    processPayment(pp, 49.99)
    fmt.Println()
    processPayment(btc, 199.99)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Interfaces</strong> define behavior through method signatures
                                            </li>
                                            <li><strong>Implicit implementation</strong> - no "implements" keyword
                                                needed</li>
                                            <li><strong>Any type</strong> that has the methods satisfies the interface
                                            </li>
                                            <li><strong>Empty interface</strong> (interface{} or any) accepts any type
                                            </li>
                                            <li><strong>Interface composition</strong> builds larger interfaces from
                                                smaller ones</li>
                                            <li><strong>Keep interfaces small</strong> - preferably 1-2 methods</li>
                                            <li><strong>Accept interfaces, return structs</strong> (usually)</li>
                                            <li><strong>Use interfaces</strong> for abstraction, testing, and
                                                flexibility</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand interface basics, you're ready to learn about
                                        <strong>Type Switches &
                                            Common Interfaces</strong>. You'll discover how to work with interface
                                        values at runtime
                                        and explore Go's standard library interfaces.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="pointers.jsp" />
                                    <jsp:param name="prevTitle" value="Pointers" />
                                    <jsp:param name="nextLink" value="type-switches.jsp" />
                                    <jsp:param name="nextTitle" value="Type Switches & Common Interfaces" />
                                    <jsp:param name="currentLessonId" value="interfaces-basics" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/go.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>