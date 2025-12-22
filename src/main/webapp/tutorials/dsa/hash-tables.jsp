<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hash-tables" ); request.setAttribute("currentModule", "Hashing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hash Tables - O(1) Average Case | DSA Tutorial</title>
            <meta name="description"
                content="Master hash tables - hash functions, collision resolution, chaining, open addressing. Essential for interviews!">
            <meta name="keywords"
                content="hash table, hash function, collision resolution, chaining, open addressing, O(1)">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/hash-tables.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror-modes/python.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/dsa/styles/visualization.css">
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

        <body class="tutorial-body no-preview" data-lesson="hash-tables">
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
                                    <span>Hash Tables</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title"># Hash Tables</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                        <span class="interview-badge">⭐⭐⭐ Essential</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Imagine you're building a phone book app. You have millions of names
                                        and phone numbers. How do you find someone's number quickly? Searching through
                                        the entire list would take forever. This is where <strong>hash tables</strong>
                                        come in — one of the most elegant solutions in computer science for fast
                                        lookups.</p>

                                    <h2>The Problem: Slow Lookups</h2>

                                    <p>Let's start with a real scenario. You have a list of contacts:</p>

                                    <div class="info-box">
                                        <h4>📱 The Phone Book Challenge</h4>
                                        <p>You need to find "Alice" in a list of 1 million contacts.</p>
                                        <ul>
                                            <li><strong>Array (unsorted):</strong> Check each person one by one → O(n)
                                                time</li>
                                            <li><strong>Array (sorted):</strong> Binary search → O(log n) time</li>
                                            <li><strong>What if we could do better?</strong> → O(1) time!</li>
                                        </ul>
                                    </div>

                                    <h2>The Solution: Hash Tables</h2>

                                    <p>Hash tables solve this by using a clever trick: instead of searching, we
                                        <strong>calculate</strong> where the data should be.
                                    </p>

                                    <div class="success-box">
                                        <h4>💡 The Core Idea</h4>
                                        <p>Think of a hash table like an apartment building with numbered mailboxes:</p>
                                        <pre><code>1. Take a name: "Alice"
2. Run it through a hash function: hash("Alice") = 42
3. Store Alice's number in mailbox #42
4. To find Alice later: hash("Alice") = 42 → check mailbox #42

Result: Direct access in O(1) time!</code></pre>
                                        <p><strong>Key insight:</strong> We convert the name into a number (the
                                            mailbox), then go straight there!</p>
                                    </div>
                                    <h3>See It in Action</h3>
                                    <div id="hashTableVisualization"></div>
                                    <h2>Hash Functions</h2>
                                    <div class="info-box">
                                        <h4>Three Common Methods</h4>
                                        <h5>1. Division Method</h5>
                                        <pre><code class="language-python">def hash_division(key, table_size):
    return key % table_size  # Simple and fast!</code></pre>
                                        <p><strong>Best:</strong> Use prime table size</p>
                                        <h5>2. Multiplication Method</h5>
                                        <pre><code class="language-python">def hash_multiplication(key, table_size):
    A = 0.618  # Golden ratio
    return int(table_size * ((key * A) % 1))</code></pre>
                                        <p><strong>Best:</strong> Better distribution</p>
                                        <h5>3. String Hashing</h5>
                                        <pre><code class="language-python">def hash_string(s, table_size):
    hash_val = 0
    for char in s:
        hash_val = (hash_val * 31 + ord(char)) % table_size
    return hash_val</code></pre>
                                        <p><strong>Best:</strong> Polynomial rolling hash</p>
                                    </div>
                                    <h2>Collision Resolution</h2>
                                    <div class="success-box">
                                        <h4>Method 1: Chaining</h4>
                                        <p><strong>Idea:</strong> Store colliding elements in a linked list</p>
                                        <pre><code>[0] → Empty
[1] → "banana" → "grape"  (collision!)
[2] → Empty
[3] → "apple"</code></pre>
                                        <p><strong>Pros:</strong> Simple, handles high load factors</p>
                                        <p><strong>Cons:</strong> Extra memory for pointers</p>
                                    </div>
                                    <div class="success-box">
                                        <h4>Method 2: Open Addressing (Linear Probing)</h4>
                                        <p><strong>Idea:</strong> If slot is full, try next slot</p>
                                        <pre><code>hash("apple") = 3 → [3] is full
Try [4] → [4] is full
Try [5] → [5] is empty, insert here!</code></pre>
                                        <p><strong>Pros:</strong> Better cache performance</p>
                                        <p><strong>Cons:</strong> Clustering, load factor must be < 1</p>
                                    </div>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h2>Load Factor</h2>
                                    <div class="info-box">
                                        <h4>α = n/m (items / table size)</h4>
                                        <p><strong>Guidelines:</strong></p>
                                        <ul>
                                            <li>α < 0.75: Good performance</li>
                                            <li>α > 0.75: Consider rehashing</li>
                                            <li>Chaining: Can exceed 1.0</li>
                                            <li>Open Addressing: Must be < 1.0</li>
                                        </ul>
                                        <p><strong>Rehashing:</strong> Double table size, reinsert all elements</p>
                                    </div>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/hash-tables.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-hash" />
                                    </jsp:include>

                                    <h2>Real-World Applications</h2>
                                    <div class="info-box">
                                        <h4>🌍 Where Hash Tables Are Used</h4>
                                        <p>Hash tables are everywhere in real software:</p>
                                        <ul>
                                            <li><strong>Databases:</strong> Index lookups for fast queries</li>
                                            <li><strong>Caching:</strong> Store frequently accessed data (Redis,
                                                Memcached)</li>
                                            <li><strong>Compilers:</strong> Symbol tables for variable names</li>
                                            <li><strong>Web browsers:</strong> DNS cache, browser history</li>
                                            <li><strong>Programming languages:</strong> Python dicts, Java HashMap,
                                                JavaScript objects</li>
                                        </ul>
                                        <p>Almost every modern application uses hash tables internally!</p>
                                    </div>

                                    <h2>Interview Tips</h2>
                                    <div class="tip-box">
                                        <h4>💡 Common Interview Questions</h4>
                                        <p>Hash tables appear frequently in coding interviews. Here are patterns to
                                            recognize:</p>
                                        <ul>
                                            <li>✅ <strong>Fast lookups:</strong> "Find if X exists" → Use hash table
                                            </li>
                                            <li>✅ <strong>Counting:</strong> "Count frequency of elements" → Hash table
                                            </li>
                                            <li>✅ <strong>Pairs:</strong> "Find two numbers that sum to X" → Hash table
                                                (Two Sum pattern)</li>
                                            <li>✅ <strong>Grouping:</strong> "Group items by property" → Hash table</li>
                                        </ul>
                                        <p><strong>Key points to mention:</strong></p>
                                        <ul>
                                            <li>O(1) average case for operations</li>
                                            <li>Collision resolution method (chaining or open addressing)</li>
                                            <li>Load factor management</li>
                                        </ul>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>Hash tables are a powerful data structure that provide fast lookups by
                                            converting keys into array indices:</p>
                                        <ol>
                                            <li><strong>Core concept:</strong> Use hash functions to map keys to
                                                positions</li>
                                            <li><strong>Performance:</strong> O(1) average case for insert, search, and
                                                delete</li>
                                            <li><strong>Hash functions:</strong> Division, multiplication, and string
                                                hashing methods</li>
                                            <li><strong>Collision handling:</strong> Chaining (linked lists) or open
                                                addressing (probing)</li>
                                            <li><strong>Load factor:</strong> Keep α < 0.75 for optimal performance</li>
                                            <li><strong>Applications:</strong> Used in databases, caches, compilers, and
                                                more!</li>
                                        </ol>
                                    </div>
                                    <h2>What's Next?</h2>
                                    <p>Now that you understand how hash tables work internally, let's explore practical
                                        implementations! Next up: <strong>Hash Maps & Sets</strong> — the data
                                        structures you'll use in everyday programming.</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="stack-queue-combined.jsp" />
                                    <jsp:param name="prevTitle" value="Combined Problems" />
                                    <jsp:param name="nextLink" value="hash-maps-sets.jsp" />
                                    <jsp:param name="nextTitle" value="Hash Maps & Sets" />
                                    <jsp:param name="currentLessonId" value="hash-tables" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/hash-tables-viz.js"></script>
        </body>

        </html>