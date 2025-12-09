<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-patterns" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Design Patterns in Java - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Design Patterns in Java.">
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

        <body class="tutorial-body no-preview" data-lesson="practices-patterns">
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
                                    <span>Design Patterns</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Design Patterns</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Design patterns are reusable solutions to common problems in software
                                        design. They represent best practices evolved over time by experienced developers.
                                        Understanding these patterns is essential for writing maintainable, flexible code.</p>

                                    <h2>Pattern Categories</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Category</th>
                                                <th>Purpose</th>
                                                <th>Examples</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Creational</strong></td>
                                                <td>Object creation mechanisms</td>
                                                <td>Singleton, Factory, Builder</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Structural</strong></td>
                                                <td>Object composition</td>
                                                <td>Adapter, Decorator, Facade</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Behavioral</strong></td>
                                                <td>Object communication</td>
                                                <td>Observer, Strategy, Command</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Singleton Pattern</h2>
                                    <p>Ensures a class has only one instance and provides global access to it.</p>

                                    <h3>Thread-Safe Singleton (Bill Pugh)</h3>
                                    <pre><code class="language-java">public class Singleton {
    // Private constructor prevents instantiation
    private Singleton() {}

    // Inner class holds the singleton instance
    private static class Holder {
        private static final Singleton INSTANCE = new Singleton();
    }

    public static Singleton getInstance() {
        return Holder.INSTANCE;  // Lazy, thread-safe
    }
}</code></pre>

                                    <h3>Enum Singleton (Recommended)</h3>
                                    <pre><code class="language-java">public enum DatabaseConnection {
    INSTANCE;

    private Connection connection;

    DatabaseConnection() {
        // Initialize connection
        connection = createConnection();
    }

    public Connection getConnection() {
        return connection;
    }
}

// Usage
DatabaseConnection.INSTANCE.getConnection();</code></pre>

                                    <div class="info-box">
                                        <strong>Why Enum?</strong> Enum singletons are thread-safe, prevent reflection attacks,
                                        and handle serialization automatically.
                                    </div>

                                    <h2>Factory Pattern</h2>
                                    <p>Creates objects without exposing creation logic to the client.</p>
                                    <pre><code class="language-java">// Product interface
interface Shape {
    void draw();
}

// Concrete products
class Circle implements Shape {
    public void draw() { System.out.println("Drawing Circle"); }
}

class Rectangle implements Shape {
    public void draw() { System.out.println("Drawing Rectangle"); }
}

// Factory
class ShapeFactory {
    public static Shape createShape(String type) {
        return switch (type.toLowerCase()) {
            case "circle" -> new Circle();
            case "rectangle" -> new Rectangle();
            default -> throw new IllegalArgumentException("Unknown shape: " + type);
        };
    }
}

// Usage
Shape shape = ShapeFactory.createShape("circle");
shape.draw();</code></pre>

                                    <h2>Builder Pattern</h2>
                                    <p>Constructs complex objects step by step. Perfect for objects with many optional parameters.</p>
                                    <pre><code class="language-java">public class User {
    private final String firstName;    // required
    private final String lastName;     // required
    private final int age;             // optional
    private final String email;        // optional
    private final String phone;        // optional

    private User(Builder builder) {
        this.firstName = builder.firstName;
        this.lastName = builder.lastName;
        this.age = builder.age;
        this.email = builder.email;
        this.phone = builder.phone;
    }

    public static class Builder {
        // Required parameters
        private final String firstName;
        private final String lastName;

        // Optional parameters - initialized to defaults
        private int age = 0;
        private String email = "";
        private String phone = "";

        public Builder(String firstName, String lastName) {
            this.firstName = firstName;
            this.lastName = lastName;
        }

        public Builder age(int age) {
            this.age = age;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder phone(String phone) {
            this.phone = phone;
            return this;
        }

        public User build() {
            return new User(this);
        }
    }
}

// Usage - fluent, readable API
User user = new User.Builder("John", "Doe")
    .age(30)
    .email("john@example.com")
    .build();</code></pre>

                                    <h2>Strategy Pattern</h2>
                                    <p>Defines a family of algorithms and makes them interchangeable at runtime.</p>
                                    <pre><code class="language-java">// Strategy interface
interface PaymentStrategy {
    void pay(double amount);
}

// Concrete strategies
class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;

    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public void pay(double amount) {
        System.out.println("Paid $" + amount + " with credit card");
    }
}

class PayPalPayment implements PaymentStrategy {
    private String email;

    public PayPalPayment(String email) {
        this.email = email;
    }

    @Override
    public void pay(double amount) {
        System.out.println("Paid $" + amount + " via PayPal");
    }
}

// Context
class ShoppingCart {
    private PaymentStrategy paymentStrategy;

    public void setPaymentStrategy(PaymentStrategy strategy) {
        this.paymentStrategy = strategy;
    }

    public void checkout(double amount) {
        paymentStrategy.pay(amount);
    }
}

// Usage - switch strategies at runtime
ShoppingCart cart = new ShoppingCart();
cart.setPaymentStrategy(new CreditCardPayment("1234-5678"));
cart.checkout(100.00);

cart.setPaymentStrategy(new PayPalPayment("user@email.com"));
cart.checkout(50.00);</code></pre>

                                    <h2>Observer Pattern</h2>
                                    <p>Defines a one-to-many dependency between objects. When one object changes state,
                                       all dependents are notified automatically.</p>
                                    <pre><code class="language-java">import java.util.ArrayList;
import java.util.List;

// Observer interface
interface Observer {
    void update(String message);
}

// Subject (Observable)
class NewsAgency {
    private List&lt;Observer&gt; observers = new ArrayList&lt;&gt;();
    private String news;

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    public void setNews(String news) {
        this.news = news;
        notifyObservers();
    }

    private void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(news);
        }
    }
}

// Concrete observer
class NewsChannel implements Observer {
    private String name;

    public NewsChannel(String name) {
        this.name = name;
    }

    @Override
    public void update(String news) {
        System.out.println(name + " received: " + news);
    }
}

// Usage
NewsAgency agency = new NewsAgency();
agency.addObserver(new NewsChannel("CNN"));
agency.addObserver(new NewsChannel("BBC"));

agency.setNews("Breaking: Java 21 Released!");
// Output:
// CNN received: Breaking: Java 21 Released!
// BBC received: Breaking: Java 21 Released!</code></pre>

                                    <h2>Decorator Pattern</h2>
                                    <p>Adds behavior to objects dynamically without affecting other objects.</p>
                                    <pre><code class="language-java">// Component interface
interface Coffee {
    String getDescription();
    double getCost();
}

// Concrete component
class SimpleCoffee implements Coffee {
    public String getDescription() { return "Coffee"; }
    public double getCost() { return 2.00; }
}

// Base decorator
abstract class CoffeeDecorator implements Coffee {
    protected Coffee coffee;

    public CoffeeDecorator(Coffee coffee) {
        this.coffee = coffee;
    }
}

// Concrete decorators
class MilkDecorator extends CoffeeDecorator {
    public MilkDecorator(Coffee coffee) { super(coffee); }

    public String getDescription() {
        return coffee.getDescription() + ", Milk";
    }

    public double getCost() {
        return coffee.getCost() + 0.50;
    }
}

class SugarDecorator extends CoffeeDecorator {
    public SugarDecorator(Coffee coffee) { super(coffee); }

    public String getDescription() {
        return coffee.getDescription() + ", Sugar";
    }

    public double getCost() {
        return coffee.getCost() + 0.25;
    }
}

// Usage - stack decorators
Coffee coffee = new SimpleCoffee();
coffee = new MilkDecorator(coffee);
coffee = new SugarDecorator(coffee);

System.out.println(coffee.getDescription()); // Coffee, Milk, Sugar
System.out.println("$" + coffee.getCost());  // $2.75</code></pre>

                                    <h2>When to Use Each Pattern</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>Use When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Singleton</strong></td>
                                                <td>Single shared resource (database connection, logger, config)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Factory</strong></td>
                                                <td>Object creation depends on runtime conditions</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Builder</strong></td>
                                                <td>Complex objects with many optional parameters</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Strategy</strong></td>
                                                <td>Multiple algorithms that can be swapped at runtime</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Observer</strong></td>
                                                <td>One-to-many event notification</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Decorator</strong></td>
                                                <td>Add responsibilities to objects dynamically</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Singleton:</strong> Use enum or Bill Pugh idiom for thread safety</li>
                                            <li><strong>Factory:</strong> Centralizes object creation logic</li>
                                            <li><strong>Builder:</strong> Creates readable APIs for complex objects</li>
                                            <li><strong>Strategy:</strong> Enables runtime algorithm selection</li>
                                            <li><strong>Observer:</strong> Decouples event sources from handlers</li>
                                            <li><strong>Decorator:</strong> Adds features without subclassing</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath() + "/tutorials/java/practices-junit.jsp" ;
                                    String nextLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-best-practices.jsp" ; %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Unit Testing" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Best Practices →" />
                                    <jsp:param name="currentLessonId" value="practices-patterns" />
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