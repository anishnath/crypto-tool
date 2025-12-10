<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-basics" ); request.setAttribute("currentModule", "Classes & OOP"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Classes - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript classes: properties, methods, constructors, and object-oriented programming fundamentals.">
            <meta name="keywords"
                content="typescript classes, typescript oop, class properties, class methods, typescript constructor">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })()</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"TypeScript Classes","learningResourceType":"tutorial","educationalLevel":"Beginner","timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"TypeScript Tutorial","url":"https://8gwifi.org/tutorials/typescript/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="classes-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb"><a
                                        href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span
                                        class="breadcrumb-separator">/</span><a
                                        href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a><span
                                        class="breadcrumb-separator">/</span><span>Class Basics</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">TypeScript Classes</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Classes are blueprints for creating objects with properties and
                                        methods. TypeScript classes add type safety to JavaScript's class syntax, making
                                        object-oriented programming more robust.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-class-structure.svg"
                                        alt="TypeScript Class Structure" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Basic Class Syntax</h2>
                                    <p>A class defines properties (data) and methods (behavior) for objects:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-basic.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Class Components:</strong>
                                        <ul>
                                            <li><strong>Properties:</strong> Variables that hold data</li>
                                            <li><strong>Constructor:</strong> Special method that initializes objects
                                            </li>
                                            <li><strong>Methods:</strong> Functions that define behavior</li>
                                            <li><strong>this:</strong> Refers to the current instance</li>
                                        </ul>
                                    </div>

                                    <h2>Properties and Methods</h2>
                                    <p>Properties store state, methods define behavior:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-properties.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-properties" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Always type your class properties. This provides
                                        autocomplete and catches errors early.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The Constructor</h2>
                                    <p>The constructor runs when creating a new instance:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-constructor.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-constructor" />
                                    </jsp:include>

                                    <h3>Constructor Rules</h3>
                                    <ul>
                                        <li>Named <code>constructor</code> (not the class name)</li>
                                        <li>Only ONE constructor per class</li>
                                        <li>Automatically called with <code>new</code></li>
                                        <li>Can have parameters with default values</li>
                                    </ul>

                                    <h2>Class vs Interface</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Class</th>
                                                <th>Interface</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Creates objects</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Has implementation</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Can be instantiated</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Runtime presence</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No (compile-time only)</td>
                                            </tr>
                                            <tr>
                                                <td>Use case</td>
                                                <td>Create objects</td>
                                                <td>Define contracts</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Forgetting 'new' Keyword</h4>
                                        <pre><code class="language-typescript">class Person {
    constructor(public personName: string) {}
}

// ✗ Wrong - calling class like a function
let person = Person("Alice");  // Error!

// ✓ Correct - use 'new'
let person = new Person("Alice");</code></pre>

                                        <h4>2. Not Typing Properties</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - implicit 'any' type
class User {
    userName;  // any type!
}

// ✓ Correct - explicit type
class User {
    userName: string;
}</code></pre>

                                        <h4>3. Forgetting 'this' Keyword</h4>
                                        <pre><code class="language-typescript">class Counter {
    count: number = 0;
    
    increment() {
        count++;  // ✗ Wrong - 'count' is not defined
    }
    
    incrementCorrect() {
        this.count++;  // ✓ Correct
    }
}</code></pre>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Class properties are NOT initialized by default.
                                        Always initialize them in the declaration or constructor.
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Classes</strong> are blueprints for creating objects</li>
                                            <li><strong>Properties</strong> store data with types</li>
                                            <li><strong>Methods</strong> define behavior</li>
                                            <li><strong>Constructor</strong> initializes new instances</li>
                                            <li>Use <code>new</code> keyword to create instances</li>
                                            <li>Always use <code>this</code> to access properties/methods</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next: <strong>Constructors</strong> in depth with parameter properties!</p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/interfaces-extending.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-constructor.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Extending Interfaces" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Constructors →" />
                                                <jsp:param name="currentLessonId" value="classes-basics" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>