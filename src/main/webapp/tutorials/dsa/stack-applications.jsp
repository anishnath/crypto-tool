<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "stack-applications" );
        request.setAttribute("currentModule", "Stacks & Queues" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Stack Applications - Expression Evaluation & More | DSA Tutorial</title>
            <meta name="description"
                content="Master stack applications - balanced parentheses, expression evaluation, function calls, undo/redo. THE most common stack interview questions!">
            <meta name="keywords"
                content="balanced parentheses, expression evaluation, postfix, infix, stack applications, interview questions">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Stack Applications - Real-World Uses">
            <meta property="og:description"
                content="Learn the most common stack interview questions - balanced parentheses and expression evaluation!">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/stack-applications.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">

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
        "name": "Stack Applications",
        "description": "Master stack applications including balanced parentheses, expression evaluation, and more.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Stack Applications", "Balanced Parentheses", "Expression Evaluation", "Interview Questions"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Data Structures and Algorithms Tutorial",
            "url": "https://8gwifi.org/tutorials/dsa/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="stack-applications">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-dsa.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Stack Applications</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🎯 Stack Applications</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                        <span class="interview-badge">⭐⭐⭐ Interview Favorites</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Now that you know stack basics, let's see where they really shine!
                                        <strong>Stack applications</strong> are everywhere: checking balanced
                                        parentheses, evaluating expressions, function calls, undo/redo. These are THE
                                        most common stack interview questions at Google, Amazon, and Microsoft!</p>

                                    <div class="warning-box">
                                        <h4>🎯 Interview Alert - Top 5 Applications!</h4>
                                        <p><strong>Master these for interviews:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Balanced Parentheses</strong> - #1 most common! (Easy)</li>
                                            <li>✅ <strong>Expression Evaluation</strong> - Postfix, infix (Medium)</li>
                                            <li>✅ <strong>Function Call Stack</strong> - Explain recursion (Conceptual)
                                            </li>
                                            <li>✅ <strong>Undo/Redo</strong> - Two-stack pattern (Design)</li>
                                            <li>✅ <strong>Next Greater Element</strong> - Monotonic stack (Advanced)
                                            </li>
                                        </ul>
                                        <p><strong>These appear in 80% of stack interviews!</strong></p>
                                    </div>

                                    <h2>Application 1: Balanced Parentheses</h2>

                                    <div class="success-box">
                                        <h4>THE Most Common Stack Question!</h4>
                                        <p><strong>Problem:</strong> Check if brackets are balanced</p>
                                        <pre><code>"()" → True
"()[]{}" → True
"(]" → False
"([)]" → False
"{[()]}" → True</code></pre>

                                        <p><strong>Algorithm:</strong></p>
                                        <pre><code class="language-python">def is_balanced(s):
    stack = []
    matching = {'(': ')', '[': ']', '{': '}'}
    
    for char in s:
        if char in matching:  # Opening bracket
            stack.append(char)
        elif char in matching.values():  # Closing
            if not stack:
                return False  # No matching opening
            if matching[stack.pop()] != char:
                return False  # Mismatch
    
    return len(stack) == 0  # All matched?</code></pre>

                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(n)</p>
                                        <p><strong>Key insight:</strong> Opening → push, Closing → pop and check!</p>
                                    </div>

                                    <h3>See It in Action</h3>
                                    <p>Watch how stacks solve real problems:</p>

                                    <div id="stackApplicationsVisualization"></div>

                                    <h2>Application 2: Expression Evaluation</h2>

                                    <div class="info-box">
                                        <h4>Three Notations</h4>

                                        <h5>Infix (Human-readable)</h5>
                                        <pre><code>A + B * C
(A + B) * C</code></pre>
                                        <p>Operator between operands - what we write</p>

                                        <h5>Postfix (Computer-friendly)</h5>
                                        <pre><code>A B C * +
A B + C *</code></pre>
                                        <p>Operator after operands - easy to evaluate!</p>

                                        <h5>Prefix (Polish notation)</h5>
                                        <pre><code>+ A * B C
* + A B C</code></pre>
                                        <p>Operator before operands - less common</p>
                                    </div>

                                    <h3>Infix to Postfix Conversion</h3>

                                    <div class="success-box">
                                        <h4>Why Convert?</h4>
                                        <p>Postfix has NO parentheses and is easy to evaluate!</p>

                                        <pre><code class="language-python">def infix_to_postfix(expr):
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
    stack = []
    postfix = []
    
    for char in expr:
        if char.isalnum():  # Operand
            postfix.append(char)
        elif char == '(':
            stack.append(char)
        elif char == ')':
            while stack and stack[-1] != '(':
                postfix.append(stack.pop())
            stack.pop()  # Remove '('
        else:  # Operator
            while (stack and stack[-1] != '(' and
                   precedence.get(stack[-1], 0) >= precedence[char]):
                postfix.append(stack.pop())
            stack.append(char)
    
    while stack:
        postfix.append(stack.pop())
    
    return ''.join(postfix)</code></pre>

                                        <p><strong>Example:</strong> A+B*C → ABC*+</p>
                                        <p><strong>Why?</strong> * has higher precedence, so B*C happens first!</p>
                                    </div>

                                    <h3>Evaluate Postfix Expression</h3>

                                    <div class="success-box">
                                        <h4>Simple Algorithm!</h4>
                                        <pre><code class="language-python">def evaluate_postfix(expr):
    stack = []
    
    for char in expr:
        if char.isdigit():
            stack.append(int(char))
        else:
            b = stack.pop()
            a = stack.pop()
            if char == '+': stack.append(a + b)
            elif char == '-': stack.append(a - b)
            elif char == '*': stack.append(a * b)
            elif char == '/': stack.append(a // b)
    
    return stack[0]</code></pre>

                                        <p><strong>Example:</strong> 23*5+ → 2*3+5 = 11</p>
                                        <ol>
                                            <li>Push 2, Push 3</li>
                                            <li>See *, pop 3 and 2, push 2*3=6</li>
                                            <li>Push 5</li>
                                            <li>See +, pop 5 and 6, push 6+5=11</li>
                                        </ol>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Application 3: Function Call Stack</h2>

                                    <div class="info-box">
                                        <h4>How Recursion Works</h4>
                                        <p>Every function call creates a <strong>stack frame</strong>:</p>
                                        <pre><code>main() {
    processData();  // Push main's frame
}

processData() {
    validate();     // Push processData's frame
}

validate() {
    return;         // Pop validate's frame
                    // Pop processData's frame
                    // Pop main's frame
}</code></pre>

                                        <p><strong>Stack frames contain:</strong></p>
                                        <ul>
                                            <li>Local variables</li>
                                            <li>Parameters</li>
                                            <li>Return address</li>
                                        </ul>

                                        <p><strong>Stack overflow:</strong> Too many nested calls!</p>
                                    </div>

                                    <h2>Application 4: Undo/Redo</h2>

                                    <div class="success-box">
                                        <h4>Two-Stack Pattern</h4>
                                        <pre><code class="language-python">class TextEditor:
    def __init__(self):
        self.text = ""
        self.undo_stack = []
        self.redo_stack = []
    
    def type(self, char):
        self.undo_stack.append(self.text)
        self.text += char
        self.redo_stack = []  # Clear redo!
    
    def undo(self):
        if self.undo_stack:
            self.redo_stack.append(self.text)
            self.text = self.undo_stack.pop()
    
    def redo(self):
        if self.redo_stack:
            self.undo_stack.append(self.text)
            self.text = self.redo_stack.pop()</code></pre>

                                        <p><strong>Key insight:</strong> New action clears redo stack!</p>
                                    </div>

                                    <h2>The Complete Code</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/stack-applications.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-stack-apps" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #1: Forgetting Empty Check</h4>
                                        <pre><code class="language-python"># WRONG - crashes if stack empty!
top = stack.pop()

# RIGHT - check first
if stack:
    top = stack.pop()</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Mistake #2: Wrong Operand Order in Postfix</h4>
                                        <pre><code class="language-python"># WRONG - reversed!
b = stack.pop()
a = stack.pop()
result = b - a  # Wrong order!

# RIGHT - first pop is second operand
b = stack.pop()
a = stack.pop()
result = a - b  # Correct!</code></pre>
                                    </div>

                                    <h2>Interview Tips</h2>

                                    <div class="tip-box">
                                        <h4>💡 How to Ace Stack Application Questions</h4>
                                        <ul>
                                            <li>✅ <strong>Balanced Parentheses:</strong> Most common! Practice
                                                variations</li>
                                            <li>✅ <strong>Expression Evaluation:</strong> Know all three notations</li>
                                            <li>✅ <strong>Operator Precedence:</strong> *, / before +, -</li>
                                            <li>✅ <strong>Postfix Evaluation:</strong> Operand order matters!</li>
                                            <li>✅ <strong>Two Stacks:</strong> Undo/redo pattern appears often</li>
                                            <li>✅ <strong>Edge Cases:</strong> Empty string, single char, all opening
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Stack Applications Mastery</h3>
                                        <ol>
                                            <li><strong>Balanced Parentheses:</strong> Opening→push, Closing→pop & check
                                            </li>
                                            <li><strong>Expression Evaluation:</strong> Postfix is easiest to evaluate
                                            </li>
                                            <li><strong>Infix to Postfix:</strong> Use operator precedence</li>
                                            <li><strong>Function Calls:</strong> Stack frames enable recursion</li>
                                            <li><strong>Undo/Redo:</strong> Two-stack pattern</li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Balanced
                                            parentheses is THE most common stack question. Master it first, then move to
                                            expression evaluation!</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered stack applications! Next: <strong>Advanced Stack
                                            Problems</strong> - Next Greater Element, Min Stack, and more challenging
                                        problems!</p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Implement balanced parentheses and postfix evaluation
                                        from scratch!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="stack-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Stack Basics" />
                                    <jsp:param name="nextLink" value="queue-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Queue Basics" />
                                    <jsp:param name="currentLessonId" value="stack-applications" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/stack-applications-viz.js"></script>
        </body>

        </html>