<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-hashing" ); request.setAttribute("currentModule", "Hashing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Advanced Hashing - System Design | DSA Tutorial</title>
            <meta name="description"
                content="Master advanced hashing - Consistent Hashing, Bloom Filters, Rolling Hash. Essential for system design interviews!">
            <meta name="keywords"
                content="consistent hashing, bloom filter, rolling hash, rabin-karp, distributed systems">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/advanced-hashing.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
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
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="advanced-hashing">
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
                                    <span>Advanced Hashing</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">🚀 Advanced Hashing</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                        <span class="interview-badge">⭐⭐ System Design</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Ready for <strong>system design interviews</strong>? Learn
                                        Consistent Hashing (used in DynamoDB!), Bloom Filters (used in Chrome!), and
                                        Rolling Hash (Rabin-Karp). These advanced techniques power real distributed
                                        systems!</p>
                                    <div class="warning-box">
                                        <h4>🎯 System Design Essentials!</h4>
                                        <p><strong>These appear in senior/staff interviews:</strong></p>
                                        <ul>
                                            <li>✅ <strong>Consistent Hashing</strong> - Load balancing, distributed
                                                caching</li>
                                            <li>✅ <strong>Bloom Filters</strong> - Space-efficient membership testing
                                            </li>
                                            <li>✅ <strong>Rolling Hash</strong> - Efficient pattern matching</li>
                                        </ul>
                                    </div>
                                    <h2>1. Consistent Hashing</h2>
                                    <div class="success-box">
                                        <h4>Distributed Systems Magic!</h4>
                                        <p><strong>Problem:</strong> How to distribute keys across servers with minimal
                                            redistribution when servers are added/removed?</p>
                                        <p><strong>Solution:</strong> Map both keys and servers to a hash ring!</p>
                                        <pre><code>Traditional Hashing:
server = hash(key) % N
Problem: Adding/removing server redistributes ALL keys!

Consistent Hashing:
- Map servers to ring: hash(server) → position
- Map keys to ring: hash(key) → position
- Key goes to next server clockwise
Result: Only K/N keys redistributed (K = total keys, N = servers)</code></pre>
                                        <p><strong>Used in:</strong> Memcached, Cassandra, DynamoDB, CDNs</p>
                                    </div>
                                    <h3>See Consistent Hashing</h3>
                                    <div id="advancedHashVisualization"></div>
                                    <h2>2. Bloom Filters</h2>
                                    <div class="success-box">
                                        <h4>Probabilistic Set Membership</h4>
                                        <p><strong>Key Property:</strong> Can have false positives, but NO false
                                            negatives!</p>
                                        <pre><code class="language-python">class BloomFilter:
    def __init__(self, size, num_hashes):
        self.bit_array = [0] * size
        self.num_hashes = num_hashes
    
    def add(self, item):
        for i in range(self.num_hashes):
            idx = hash(item, i) % size
            self.bit_array[idx] = 1
    
    def contains(self, item):
        for i in range(self.num_hashes):
            idx = hash(item, i) % size
            if self.bit_array[idx] == 0:
                return False  # Definitely NOT in set
        return True  # MIGHT be in set</code></pre>
                                        <p><strong>Trade-off:</strong> Space efficiency vs false positive rate</p>
                                        <p><strong>Used in:</strong> Chrome (malicious URLs), Medium (articles you've
                                            read), Bitcoin</p>
                                    </div>
                                    <h2>3. Rolling Hash (Rabin-Karp)</h2>
                                    <div class="success-box">
                                        <h4>Efficient Pattern Matching</h4>
                                        <p><strong>Idea:</strong> Compute hash incrementally as window slides</p>
                                        <pre><code class="language-python">def rabin_karp(text, pattern):
    # Hash pattern
    pattern_hash = hash(pattern)
    
    # Hash first window
    window_hash = hash(text[0:m])
    
    for i in range(len(text) - m + 1):
        if window_hash == pattern_hash:
            if text[i:i+m] == pattern:
                return i  # Found!
        
        # Roll hash: remove first, add next
        window_hash = roll(window_hash, text[i], text[i+m])</code></pre>
                                        <p><strong>Time:</strong> O(n + m) average (vs O(nm) brute force)</p>
                                        <p><strong>Used in:</strong> Plagiarism detection, DNA matching, rsync</p>
                                    </div>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/advanced-hashing.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-advanced" />
                                    </jsp:include>
                                    <h2>Real-World Applications</h2>
                                    <div class="info-box">
                                        <h4>Where These Are Used</h4>
                                        <h5>Consistent Hashing:</h5>
                                        <ul>
                                            <li>Amazon DynamoDB - data partitioning</li>
                                            <li>Memcached - distributed caching</li>
                                            <li>Cassandra - node assignment</li>
                                            <li>CDNs - server selection</li>
                                        </ul>
                                        <h5>Bloom Filters:</h5>
                                        <ul>
                                            <li>Google Chrome - malicious URL detection</li>
                                            <li>Medium - recommend unread articles</li>
                                            <li>Bitcoin - transaction verification</li>
                                            <li>Databases - avoid disk lookups</li>
                                        </ul>
                                        <h5>Rolling Hash:</h5>
                                        <ul>
                                            <li>Plagiarism detection systems</li>
                                            <li>DNA sequence matching</li>
                                            <li>File deduplication</li>
                                            <li>rsync - file synchronization</li>
                                        </ul>
                                    </div>
                                    <h2>Interview Tips</h2>
                                    <div class="tip-box">
                                        <h4>💡 System Design Interview</h4>
                                        <ul>
                                            <li>✅ <strong>Consistent Hashing:</strong> Mention for distributed caching,
                                                load balancing</li>
                                            <li>✅ <strong>Bloom Filters:</strong> Use when space is critical, false
                                                positives OK</li>
                                            <li>✅ <strong>Rolling Hash:</strong> Pattern matching, substring search</li>
                                            <li>✅ <strong>Know trade-offs:</strong> Space vs accuracy, consistency vs
                                                availability</li>
                                        </ul>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>Advanced Hashing Mastery</h3>
                                        <ol>
                                            <li><strong>Consistent Hashing:</strong> Distributed systems, minimal
                                                redistribution</li>
                                            <li><strong>Bloom Filters:</strong> Space-efficient, probabilistic
                                                membership</li>
                                            <li><strong>Rolling Hash:</strong> Efficient pattern matching O(n + m)</li>
                                            <li><strong>Real-world:</strong> Used in DynamoDB, Chrome, rsync!</li>
                                            <li><strong>Essential</strong> for system design interviews!</li>
                                        </ol>
                                    </div>
                                    <div class="success-box">
                                        <h3>🎉 Module 7: Hashing - 100% COMPLETE!</h3>
                                        <p>You've mastered all of hashing:</p>
                                        <ul>
                                            <li>✅ Hash Tables (collision resolution)</li>
                                            <li>✅ Hash Maps & Sets (interview patterns)</li>
                                            <li>✅ Advanced Hashing (system design)</li>
                                        </ul>
                                        <p><strong>You're ready for ANY hashing question!</strong> 🚀</p>
                                    </div>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hash-maps-sets.jsp" />
                                    <jsp:param name="prevTitle" value="Hash Maps & Sets" />
                                    <jsp:param name="nextLink" value="binary-tree.jsp" />
                                    <jsp:param name="nextTitle" value="Binary Tree" />
                                    <jsp:param name="currentLessonId" value="advanced-hashing" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/advanced-hashing-viz.js"></script>
        </body>

        </html>