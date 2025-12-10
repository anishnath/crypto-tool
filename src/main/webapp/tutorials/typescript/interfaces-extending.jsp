<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "interfaces-extending" );
        request.setAttribute("currentModule", "Functions & Interfaces" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Extending Interfaces | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: learn to extend TypeScript interfaces to build complex types through inheritance and composition.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/interfaces-extending.jsp">
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
        "name": "TypeScript Interface Extending",
        "description": "Master interface extension for code reuse and composition.",
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

        <body class="tutorial-body no-preview" data-lesson="interfaces-extending">
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
                                        class="breadcrumb-separator">/</span><span>Extending Interfaces</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Extending Interfaces</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~15 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Interfaces can extend other interfaces to build complex types
                                        through inheritance, promoting code reuse and maintainability.</p>

                                    <h2>Extending Interfaces</h2>
                                    <p>Use the <code>extends</code> keyword to inherit properties from parent
                                        interfaces:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/interface-extend.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-extend" />
                                    </jsp:include>

                                    <div class="info-box"><strong>How It Works:</strong> The child interface inherits
                                        ALL properties from the parent, plus adds its own.</div>

                                    <h2>Multiple Inheritance</h2>
                                    <p>TypeScript interfaces can extend multiple interfaces at once:</p>
                                    <pre><code class="language-typescript">interface Timestamped {
    createdAt: Date;
    updatedAt: Date;
}

interface Named {
    firstName: string;
    lastName: string;
}

// Extends both interfaces
interface User extends Named, Timestamped {
    email: string;
}

let user: User = {
    firstName: "Alice",
    lastName: "Johnson",
    email: "alice@example.com",
    createdAt: new Date(),
    updatedAt: new Date()
};</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>When to Extend Interfaces</h2>
                                    <ul>
                                        <li><strong>Shared properties:</strong> Multiple types need common fields</li>
                                        <li><strong>Hierarchies:</strong> Base type with specialized variants</li>
                                        <li><strong>Composition:</strong> Combine multiple concerns</li>
                                        <li><strong>API responses:</strong> Base response + specific data</li>
                                    </ul>

                                    <h2>Interface Extension Patterns</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>Use Case</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Single Inheritance</strong></td>
                                                <td>Simple hierarchy</td>
                                                <td><code>Dog extends Animal</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Multiple Inheritance</strong></td>
                                                <td>Combine traits</td>
                                                <td><code>User extends Named, Timestamped</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Chain Extension</strong></td>
                                                <td>Deep hierarchy</td>
                                                <td><code>Admin extends User extends Person</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Conflicting Property Types</h4>
                                        <pre><code class="language-typescript">interface A {
    value: string;
}

interface B {
    value: number;
}

// ✗ Wrong - conflicting types for 'value'
interface C extends A, B { }  // Error!

// ✓ Correct - compatible types
interface A {
    value: string | number;
}

interface B {
    value: number;
}

interface C extends A, B { }  // OK</code></pre>

                                        <h4>2. Forgetting Parent Properties</h4>
                                        <pre><code class="language-typescript">interface Animal {
    nameAnimal: string;
}

interface Dog extends Animal {
    breed: string;
}

// ✗ Wrong - missing 'nameAnimal'
let dog: Dog = {
    breed: "Labrador"
};

// ✓ Correct
let dog: Dog = {
    nameAnimal: "Buddy",
    breed: "Labrador"
};</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Keep interface hierarchies
                                        shallow (2-3 levels max) for maintainability.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>extends</code> to inherit properties</li>
                                            <li>Can extend multiple interfaces</li>
                                            <li>Child inherits ALL parent properties</li>
                                            <li>Great for code reuse and composition</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 2. Next: <strong>Classes & OOP</strong>!
                                    </p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/types-aliases.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-basics.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Type Aliases" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Classes →" />
                                                <jsp:param name="currentLessonId" value="interfaces-extending" />
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