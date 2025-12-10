<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "classes-abstract" ); request.setAttribute("currentModule", "Classes & OOP"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Abstract Classes | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript abstract classes for defining contracts and shared behavior.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/classes-abstract.jsp">
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
        "name": "TypeScript Abstract Classes",
        "description": "Learn abstract classes for creating blueprints with abstract methods.",
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
        "isPartOf": {
            "@type": "Course",
            "name": "Typescript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
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

        <body class="tutorial-body no-preview" data-lesson="classes-abstract">
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
                                        class="breadcrumb-separator">/</span><span>Abstract Classes</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Abstract Classes</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Abstract classes provide a blueprint for other classes, defining
                                        methods that must be implemented by derived classes.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-abstract-classes.svg"
                                        alt="TypeScript Abstract Classes" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Abstract Classes</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/class-abstract.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-abstract" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Abstract Class Rules:</strong>
                                        <ul>
                                            <li>Cannot be instantiated directly</li>
                                            <li>Can have abstract methods (no implementation)</li>
                                            <li>Can have concrete methods (with implementation)</li>
                                            <li>Child classes MUST implement abstract methods</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Abstract vs Interface</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Abstract Class</th>
                                                <th>Interface</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Can have implementation</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Can be instantiated</td>
                                                <td>✗ No</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Multiple inheritance</td>
                                                <td>✗ No</td>
                                                <td>✓ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Constructor</td>
                                                <td>✓ Yes</td>
                                                <td>✗ No</td>
                                            </tr>
                                            <tr>
                                                <td>Use case</td>
                                                <td>Shared behavior + contract</td>
                                                <td>Pure contract</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Trying to Instantiate Abstract Class</h4>
                                        <pre><code class="language-typescript">abstract class Shape {
    abstract getArea(): number;
}

let shape = new Shape();  // ✗ Error!

// ✓ Create concrete child class
class Circle extends Shape {
    getArea() { return 0; }
}
let circle = new Circle();  // ✓ OK</code></pre>

                                        <h4>2. Not Implementing Abstract Methods</h4>
                                        <pre><code class="language-typescript">abstract class Animal {
    abstract makeSound(): void;
}

class Dog extends Animal {
    // ✗ Error - must implement makeSound()
}

// ✓ Correct
class Dog extends Animal {
    makeSound() { console.log("Woof"); }
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>When to Use:</strong> Use abstract classes when you
                                        have shared implementation AND want to enforce a contract.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Abstract classes combine interfaces and base classes</li>
                                            <li>Cannot instantiate abstract classes</li>
                                            <li>Child classes must implement abstract methods</li>
                                            <li>Can have both abstract and concrete members</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-inheritance.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-static.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Inheritance" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Static Members →" />
                                                <jsp:param name="currentLessonId" value="classes-abstract" />
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