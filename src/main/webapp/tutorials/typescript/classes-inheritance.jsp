<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-inheritance" );
        request.setAttribute("currentModule", "Classes & OOP" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Inheritance - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript inheritance with extends, super, and method overriding for code reuse.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-inheritance.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })()</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "TypeScript Class Inheritance",
        "description": "Learn class inheritance with extends and super keywords.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "timeRequired": "PT20M",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2025-12-10",
        "dateModified": "2025-12-10"
    }
    </script>
        </head>

        <body class="tutorial-body no-preview" data-lesson="classes-inheritance">
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
                                        class="breadcrumb-separator">/</span><span>Inheritance</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Inheritance</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~22 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Inheritance allows classes to inherit properties and methods from
                                        parent classes, promoting code reuse and establishing hierarchies.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-inheritance.svg"
                                        alt="TypeScript Inheritance" class="diagram-image"
                                        style="max-width: 700px; margin: 2rem auto; display: block;">

                                    <h2>Basic Inheritance</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-inheritance.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-inheritance" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Key Concepts:</strong>
                                        <ul>
                                            <li><code>extends</code> - Creates inheritance relationship</li>
                                            <li><code>super()</code> - Calls parent constructor</li>
                                            <li>Child inherits ALL parent members</li>
                                            <li>Can override parent methods</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Method Overriding</h2>
                                    <p>Child classes can override parent methods to provide specific behavior:</p>
                                    <pre><code class="language-typescript">class Animal {
    makeSound(): void {
        console.log("Generic sound");
    }
}

class Cat extends Animal {
    makeSound(): void {  // Override
        console.log("Meow!");
    }
}

let cat = new Cat();
cat.makeSound();  // "Meow!"</code></pre>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Forgetting super() in Constructor</h4>
                                        <pre><code class="language-typescript">class Animal {
    constructor(public nameAnimal: string) {}
}

class Dog extends Animal {
    constructor(nameAnimal: string, public breed: string) {
        // ✗ Error - must call super() first!
        this.breed = breed;
    }
}

// ✓ Correct
class Dog extends Animal {
    constructor(nameAnimal: string, public breed: string) {
        super(nameAnimal);  // Call parent first
        this.breed = breed;
    }
}</code></pre>

                                        <h4>2. Accessing Private Parent Members</h4>
                                        <pre><code class="language-typescript">class Parent {
    private secret = "hidden";
}

class Child extends Parent {
    reveal() {
        console.log(this.secret);  // ✗ Error! Private
    }
}

// ✓ Use protected instead
class Parent {
    protected secret = "hidden";
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Favor composition over deep
                                        inheritance hierarchies. Keep hierarchies shallow (2-3 levels max).</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>extends</code> for inheritance</li>
                                            <li>Call <code>super()</code> in child constructor</li>
                                            <li>Child inherits all parent members</li>
                                            <li>Override methods for specific behavior</li>
                                            <li>Use <code>protected</code> for inheritance-friendly members</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-modifiers.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-abstract.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Access Modifiers" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Abstract Classes →" />
                                                <jsp:param name="currentLessonId" value="classes-inheritance" />
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