<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- JavaScript Tutorial - Classes Lesson 24: ES6 Classes, constructor, methods, inheritance (extends, super) --%>
        <% request.setAttribute("currentLesson", "classes" ); request.setAttribute("currentModule", "Advanced Concepts"
            ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">

                <title>JavaScript Classes | 8gwifi.org Tutorials</title>
                <meta name="description"
                    content="Learn about ES6 Classes in JavaScript. Understand class syntax, constructors, methods, and inheritance with extends and super.">
                <meta name="keywords"
                    content="JavaScript classes, ES6 classes, class inheritance, extends, super, constructor">

                <meta property="og:type" content="article">
                <meta property="og:title" content="JavaScript Classes">
                <meta property="og:description" content="Master ES6 JavaScript Classes">
                <meta property="og:site_name" content="8gwifi.org Tutorials">

                <link rel="icon" type="image/svg+xml"
                    href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
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
            <%-- Ads --%>
                <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
            </head>

            <body class="tutorial-body" data-lesson="classes">
                <div class="tutorial-layout">
                    <%@ include file="../tutorial-header.jsp" %>

                        <main class="tutorial-main">
                            <%@ include file="../tutorial-sidebar-javascript.jsp" %>
                                <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                                <article class="tutorial-content">
                                    <nav class="breadcrumb">
                                        <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/">JavaScript</a>
                                        <span class="breadcrumb-separator">/</span>
                                        <span>Classes</span>
                                    </nav>

                                    <header class="lesson-header">
                                        <h1 class="lesson-title">JavaScript Classes</h1>
                                        <div class="lesson-meta">
                                            <span>Advanced</span>
                                            <span>~20 min read</span>
                                        </div>
                                    </header>

                                    <div class="lesson-body">
                                        <h2>Introduction to Classes</h2>
                                        <p>
                                            ES6 introduced JavaScript Classes. Classes are templates for creating
                                            objects. They encapsulate data with code to work on that data.
                                        </p>
                                        <p>
                                            <strong>Note:</strong> JavaScript classes are built on prototypes but
                                            provide a cleaner syntax.
                                        </p>

                                        <h2>Class Syntax</h2>
                                        <p>
                                            Use the <code>class</code> keyword to create a class. Always add a method
                                            named <code>constructor()</code>.
                                        </p>

                                        <% String classHtml="<h2>Class Demo</h2>\n<p id='classOutput'></p>" ; String
                                            classJs="class Car {\n  constructor(name, year) {\n    this.name = name;\n    this.year = year;\n  }\n  \n  age() {\n    let date = new Date();\n    return date.getFullYear() - this.year;\n  }\n}\n\nlet myCar = new Car('Ford', 2014);\ndocument.getElementById('classOutput').innerHTML = \n  `My car is ${myCar.age()} years old.`;"
                                            ; %>
                                            <jsp:include page="../tutorial-editor.jsp">
                                                <jsp:param name="editorId" value="editor-class" />
                                                <jsp:param name="initialHtml" value="<%=classHtml%>" />
                                                <jsp:param name="initialJs" value="<%=classJs%>" />
                                                <jsp:param name="defaultTab" value="js" />
                                            </jsp:include>

                                            <h2>Class Inheritance</h2>
                                            <p>
                                                To create a class inheritance, use the <code>extends</code> keyword. A
                                                class created with a class inheritance inherits all the methods from
                                                another class.
                                            </p>
                                            <p>
                                                The <code>super()</code> method refers to the parent class. By calling
                                                the <code>super()</code> method in the constructor method, we call the
                                                parent's constructor method and get access to the parent's properties
                                                and methods.
                                            </p>

                                            <% String
                                                inheritHtml="<h2>Inheritance Demo</h2>\n<p id='inheritOutput'></p>" ;
                                                String
                                                inheritJs="class Car {\n  constructor(brand) {\n    this.carname = brand;\n  }\n  present() {\n    return 'I have a ' + this.carname;\n  }\n}\n\nclass Model extends Car {\n  constructor(brand, mod) {\n    super(brand);\n    this.model = mod;\n  }\n  show() {\n    return this.present() + ', it is a ' + this.model;\n  }\n}\n\nlet myCar = new Model('Ford', 'Mustang');\ndocument.getElementById('inheritOutput').innerHTML = myCar.show();"
                                                ; %>
                                                <jsp:include page="../tutorial-editor.jsp">
                                                    <jsp:param name="editorId" value="editor-inherit" />
                                                    <jsp:param name="initialHtml" value="<%=inheritHtml%>" />
                                                    <jsp:param name="initialJs" value="<%=inheritJs%>" />
                                                    <jsp:param name="defaultTab" value="js" />
                                                </jsp:include>

                                                <h2>Getters and Setters</h2>
                                                <p>
                                                    Classes also allow you to use getters and setters. It can be smart
                                                    to use getters and setters for your properties, especially if you
                                                    want to do something special with the value before returning them,
                                                    or before you set them.
                                                </p>

                                                <% String
                                                    getsetHtml="<h2>Getter/Setter Demo</h2>\n<p id='getsetOutput'></p>"
                                                    ; String
                                                    getsetJs="class Car {\n  constructor(brand) {\n    this._carname = brand;\n  }\n  \n  get carname() {\n    return this._carname;\n  }\n  \n  set carname(x) {\n    this._carname = x;\n  }\n}\n\nlet myCar = new Car('Ford');\nmyCar.carname = 'Volvo';\n\ndocument.getElementById('getsetOutput').innerHTML = myCar.carname;"
                                                    ; %>
                                                    <jsp:include page="../tutorial-editor.jsp">
                                                        <jsp:param name="editorId" value="editor-getset" />
                                                        <jsp:param name="initialHtml" value="<%=getsetHtml%>" />
                                                        <jsp:param name="initialJs" value="<%=getsetJs%>" />
                                                        <jsp:param name="defaultTab" value="js" />
                                                    </jsp:include>

                                                    <h2>Static Methods</h2>
                                                    <p>
                                                        Static methods are defined on the class itself, not on the
                                                        instance of the class. You cannot call a static method on an
                                                        object, only on the class.
                                                    </p>

                                                    <% String
                                                        staticHtml="<h2>Static Method Demo</h2>\n<p id='staticOutput'></p>"
                                                        ; String
                                                        staticJs="class Car {\n  constructor(name) {\n    this.name = name;\n  }\n  static hello() {\n    return 'Hello!!';\n  }\n}\n\nlet myCar = new Car('Ford');\n\n// You can call it on the Class\nlet msg = Car.hello();\n\n// But NOT on the object\n// myCar.hello(); // This would raise an error\n\ndocument.getElementById('staticOutput').innerHTML = msg;"
                                                        ; %>
                                                        <jsp:include page="../tutorial-editor.jsp">
                                                            <jsp:param name="editorId" value="editor-static" />
                                                            <jsp:param name="initialHtml" value="<%=staticHtml%>" />
                                                            <jsp:param name="initialJs" value="<%=staticJs%>" />
                                                            <jsp:param name="defaultTab" value="js" />
                                                        </jsp:include>

                                                        <h2>Summary</h2>
                                                        <div class="card" style="margin: var(--space-6) 0;">
                                                            <ul style="margin: 0; padding-left: var(--space-6);">
                                                                <li>Classes are a template for creating objects.</li>
                                                                <li>The <code>constructor</code> method is called
                                                                    automatically when a new object is created.</li>
                                                                <li><code>extends</code> is used for inheritance.</li>
                                                                <li><code>super()</code> calls the parent constructor.
                                                                </li>
                                                                <li>Static methods belong to the class, not the
                                                                    instance.</li>
                                                            </ul>
                                                        </div>

                                                        <jsp:include page="../tutorial-quiz.jsp">
                                                            <jsp:param name="quizId" value="quiz-classes" />
                                                            <jsp:param name="question"
                                                                value="Which keyword is used to create a class inheritance?" />
                                                            <jsp:param name="option1" value="inherits" />
                                                            <jsp:param name="option2" value="extends" />
                                                            <jsp:param name="option3" value="super" />
                                                            <jsp:param name="option4" value="implements" />
                                                            <jsp:param name="correctAnswer" value="2" />
                                                        </jsp:include>

                                                        <jsp:include page="../tutorial-nav.jsp">
                                                            <jsp:param name="prevLink" value="prototypes.jsp" />
                                                            <jsp:param name="prevTitle" value="Prototypes" />
                                                            <jsp:param name="nextLink" value="async-basics.jsp" />
                                                            <jsp:param name="nextTitle" value="Async Basics" />
                                                            <jsp:param name="currentLessonId" value="classes" />
                                                        </jsp:include>
                                    </div>
                                </article>

                                <aside class="tutorial-preview" id="previewPanel">
                                    <div class="preview-header">
                                        <span>Live Preview</span>
                                        <button class="btn btn-ghost btn-icon" onclick="refreshPreview()"
                                            title="Refresh">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M23 4v6h-6M1 20v-6h6" />
                                                <path
                                                    d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
                                            </svg>
                                        </button>
                                    </div>
                                    <iframe id="previewFrame" class="preview-frame"
                                        sandbox="allow-scripts allow-same-origin"></iframe>
                                </aside>
                        </main>

                        <%@ include file="../tutorial-footer.jsp" %>
                </div>

                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
                <script
                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
                <script
                    src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
                <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            </body>

            </html>