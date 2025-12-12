<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "variables" ); request.setAttribute("currentModule", "Getting Started" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Variables & Types in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Lua variables, data types, and dynamic typing. Master local vs global variables, type checking, and Lua's 8 basic types. Free interactive tutorial.">
            <meta name="keywords"
                content="lua variables, lua types, lua data types, local variables, global variables, dynamic typing, lua tutorial">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/variables.jsp">
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
        "name": "Variables & Types in Lua",
        "description": "Learn Lua variables, data types, and dynamic typing. Master local vs global variables, type checking, and Lua's 8 basic types.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/variables.jsp",
        "keywords": "lua variables, lua types, lua data types, local variables, dynamic typing",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Lua variables", "Lua data types", "Local vs global", "Dynamic typing", "Type checking"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "description": "Complete Lua programming course from beginner to advanced with interactive examples",
            "url": "https://8gwifi.org/tutorials/lua/",
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            }
        },
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    }
    </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Tutorials",
                "item": "https://8gwifi.org/tutorials/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Lua",
                "item": "https://8gwifi.org/tutorials/lua/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Variables & Types"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="variables">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-lua.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Variables & Types</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Variables & Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Variables are containers for storing data values. In this lesson,
                                        you'll learn
                                        how to create and use variables in Lua, understand Lua's 8 basic data types, and
                                        master the
                                        difference between local and global variables. Lua's dynamic typing makes
                                        working with variables
                                        simple and flexible!</p>

                                    <!-- Creating Variables -->
                                    <h2>Creating Variables</h2>
                                    <p>In Lua, creating a variable is as simple as assigning a value to a name. Let's
                                        start with
                                        the basics:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/variables-basic.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basic" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Points:</strong>
                                        <ul>
                                            <li>Use <code>local</code> keyword to create local variables (recommended)
                                            </li>
                                            <li>Variable names can contain letters, digits, and underscores</li>
                                            <li>Variable names must start with a letter or underscore</li>
                                            <li>Lua is case-sensitive: <code>name</code> and <code>Name</code> are
                                                different variables</li>
                                        </ul>
                                    </div>

                                    <!-- Local vs Global -->
                                    <h2>Local vs Global Variables</h2>
                                    <p>This is one of the most important concepts in Lua!</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Scope</th>
                                                <th>When to Use</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Local</strong></td>
                                                <td><code>local x = 10</code></td>
                                                <td>Current block/function</td>
                                                <td>Almost always (default choice)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Global</strong></td>
                                                <td><code>x = 10</code></td>
                                                <td>Entire program</td>
                                                <td>Rarely (can cause bugs)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Variables without the <code>local</code> keyword are
                                        global by default!
                                        This is different from most other languages and a common source of bugs.
                                        <strong>Always use
                                            <code>local</code></strong> unless you specifically need a global variable.
                                    </div>

                                    <pre><code class="language-lua">-- Good: Local variable
local score = 100

-- Bad: Global variable (avoid!)
score = 100  -- Oops, this is global!

-- Correct way to create multiple local variables
local x, y, z = 1, 2, 3</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Get in the habit of always typing <code>local</code>
                                        when creating
                                        variables. Your future self (and your teammates) will thank you!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Lua's 8 Types -->
                                    <h2>Lua's 8 Basic Types</h2>
                                    <p>Lua has 8 basic data types. Let's explore each one:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/variables-types.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-types" />
                                    </jsp:include>

                                    <h3>Type Descriptions</h3>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>nil</code></td>
                                                <td>Represents "no value" or "nothing"</td>
                                                <td><code>local x = nil</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>boolean</code></td>
                                                <td>True or false values</td>
                                                <td><code>local flag = true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>number</code></td>
                                                <td>Integers and floating-point numbers</td>
                                                <td><code>local age = 25</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>string</code></td>
                                                <td>Text/characters</td>
                                                <td><code>local name = "Lua"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>function</code></td>
                                                <td>Executable code blocks</td>
                                                <td><code>local f = function() end</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>table</code></td>
                                                <td>Lua's main data structure</td>
                                                <td><code>local t = {1, 2, 3}</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>userdata</code></td>
                                                <td>C data (advanced)</td>
                                                <td>Used for C integration</td>
                                            </tr>
                                            <tr>
                                                <td><code>thread</code></td>
                                                <td>Coroutines (advanced)</td>
                                                <td>For concurrent programming</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Dynamic Typing -->
                                    <h2>Dynamic Typing</h2>
                                    <p>Lua is <strong>dynamically typed</strong>, which means variables don't have fixed
                                        types—they
                                        can hold any type of value and can change types during execution:</p>

                                    <pre><code class="language-lua">local x = 42          -- x is a number
print(type(x))        -- "number"

x = "Hello"           -- Now x is a string
print(type(x))        -- "string"

x = true              -- Now x is a boolean
print(type(x))        -- "boolean"</code></pre>

                                    <div class="info-box">
                                        <strong>type() Function:</strong> Use <code>type(variable)</code> to check what
                                        type a
                                        variable currently holds. This returns a string like <code>"number"</code>,
                                        <code>"string"</code>,
                                        <code>"boolean"</code>, etc.
                                    </div>

                                    <!-- Nil and Undefined -->
                                    <h2>Understanding nil</h2>
                                    <p><code>nil</code> is Lua's way of representing "nothing" or "no value". It's used
                                        in several ways:</p>

                                    <pre><code class="language-lua">-- Uninitialized variables are nil
local x
print(x)  -- nil

-- Explicitly set to nil
local y = nil

-- Deleting a variable (set to nil)
local z = 100
z = nil  -- z is now "deleted"

-- Checking for nil
if x == nil then
    print("x has no value")
end</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Use <code>nil</code> to indicate "no value" or
                                        to delete
                                        table entries. It's Lua's way of saying "this doesn't exist" or "this has been
                                        removed."
                                    </div>

                                    <!-- Truthiness -->
                                    <h2>Truthiness in Lua</h2>
                                    <p>In conditional statements, Lua considers only two values as "false":</p>

                                    <ul>
                                        <li><code>false</code> (the boolean value)</li>
                                        <li><code>nil</code> (no value)</li>
                                    </ul>

                                    <p><strong>Everything else is considered "true"</strong>, including:</p>

                                    <pre><code class="language-lua">if 0 then print("0 is true!") end           -- Prints!
if "" then print("Empty string is true!") end  -- Prints!
if {} then print("Empty table is true!") end   -- Prints!

-- Only these are false:
if false then print("Won't print") end
if nil then print("Won't print") end</code></pre>

                                    <div class="warning-box">
                                        <strong>Watch Out:</strong> Unlike many other languages, <code>0</code> and
                                        empty strings
                                        are <strong>truthy</strong> in Lua! Only <code>false</code> and <code>nil</code>
                                        are falsy.
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting 'local' keyword</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">count = 0  -- Oops! This is global!</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">local count = 0  -- Local variable</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Assuming 0 is false</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">local x = 0
if not x then  -- This won't work! 0 is truthy
    print("x is zero")
end</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">local x = 0
if x == 0 then  -- Explicitly check for 0
    print("x is zero")
end</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using undefined variables</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">print(myVariable)  -- nil (no error!)</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">local myVariable = "Hello"
print(myVariable)  -- "Hello"</code></pre>
                                    </div>

                                    <!-- Variable Naming -->
                                    <h2>Variable Naming Conventions</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Convention</th>
                                                <th>Example</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>snake_case</td>
                                                <td><code>user_name</code></td>
                                                <td>Standard Lua convention</td>
                                            </tr>
                                            <tr>
                                                <td>camelCase</td>
                                                <td><code>userName</code></td>
                                                <td>Also common</td>
                                            </tr>
                                            <tr>
                                                <td>UPPER_CASE</td>
                                                <td><code>MAX_SIZE</code></td>
                                                <td>Constants</td>
                                            </tr>
                                            <tr>
                                                <td>_private</td>
                                                <td><code>_internal</code></td>
                                                <td>Private/internal variables</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Reserved Words:</strong> You cannot use Lua keywords as variable names:
                                        <code>and</code>, <code>break</code>, <code>do</code>, <code>else</code>,
                                        <code>elseif</code>,
                                        <code>end</code>, <code>false</code>, <code>for</code>, <code>function</code>,
                                        <code>if</code>,
                                        <code>in</code>, <code>local</code>, <code>nil</code>, <code>not</code>,
                                        <code>or</code>,
                                        <code>repeat</code>, <code>return</code>, <code>then</code>, <code>true</code>,
                                        <code>until</code>,
                                        <code>while</code>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Practice with Variables</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create variables of different types and practice type
                                            checking.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create at least one variable of each type (nil, boolean, number, string)
                                            </li>
                                            <li>Use the <code>type()</code> function to check their types</li>
                                            <li>Create a table with your favorite things</li>
                                            <li>Use <code>local</code> for all variables</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="lua/exercises/ex-variables.lua" />
                                            <jsp:param name="language" value="lua" />
                                            <jsp:param name="editorId" value="exercise-variables" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-lua">-- 1. Create a variable with your name (string)
local myName = "Alice"

-- 2. Create a variable with your age (number)
local myAge = 25

-- 3. Create a variable that says if you like programming (boolean)
local likesProgramming = true

-- 4. Create a table with your favorite things
local favorites = {
    color = "blue",
    number = 7,
    language = "Lua"
}

-- Print everything
print("Name:", myName)
print("Age:", myAge)
print("Likes programming?", likesProgramming)
print("Favorite color:", favorites.color)
print("Favorite number:", favorites.number)
print("Favorite language:", favorites.language)

-- Bonus: Check types
print("\nTypes:")
print("myName is a", type(myName))
print("myAge is a", type(myAge))
print("likesProgramming is a", type(likesProgramming))
print("favorites is a", type(favorites))</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Variables:</strong> Use <code>local</code> keyword to create
                                                local variables (recommended)</li>
                                            <li><strong>Global vs Local:</strong> Variables without <code>local</code>
                                                are global (avoid this!)</li>
                                            <li><strong>8 Types:</strong> nil, boolean, number, string, function, table,
                                                userdata, thread</li>
                                            <li><strong>Dynamic Typing:</strong> Variables can change types during
                                                execution</li>
                                            <li><strong>type():</strong> Use <code>type(x)</code> to check a variable's
                                                type</li>
                                            <li><strong>nil:</strong> Represents "no value" or undefined</li>
                                            <li><strong>Truthiness:</strong> Only <code>false</code> and
                                                <code>nil</code> are falsy; everything else is truthy</li>
                                            <li><strong>Naming:</strong> Use snake_case or camelCase; avoid reserved
                                                keywords</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Excellent work! You now understand variables and types in Lua. In the next
                                        module, we'll explore
                                        <strong>Operators & Control Flow</strong>, where you'll learn how to perform
                                        calculations, compare
                                        values, and make decisions in your code. Get ready to make your programs
                                        interactive! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hello-world.jsp" />
                                    <jsp:param name="prevTitle" value="Hello World" />
                                    <jsp:param name="nextLink" value="operators.jsp" />
                                    <jsp:param name="nextTitle" value="Operators" />
                                    <jsp:param name="currentLessonId" value="variables" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/lua.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>