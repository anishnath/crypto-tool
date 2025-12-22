<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hash-maps-sets" ); request.setAttribute("currentModule", "Hashing" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hash Maps & Sets - Interview Patterns | DSA Tutorial</title>
            <meta name="description"
                content="Master HashMap & HashSet with Two Sum, Group Anagrams, and more! Essential interview patterns with O(1) operations.">
            <meta name="keywords" content="hashmap, hashset, two sum, group anagrams, interview patterns, O(1)">
            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/hash-maps-sets.jsp">
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

        <body class="tutorial-body no-preview" data-lesson="hash-maps-sets">
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
                                    <span>Hash Maps & Sets</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">📊 Hash Maps & Sets</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~25 min read</span>
                                        <span class="interview-badge">⭐⭐⭐ Must Know!</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">In the previous lesson, you learned how hash tables work internally.
                                        Now let's explore the data structures you'll actually use in your programs:
                                        <strong>HashMap</strong> (for key-value pairs) and <strong>HashSet</strong> (for
                                        unique collections). These are built into almost every programming language!
                                    </p>

                                    <h2>From Theory to Practice</h2>

                                    <p>You've seen how hash tables provide O(1) lookups. But in real programming, you
                                        rarely implement a hash table from scratch. Instead, you use:</p>

                                    <div class="info-box">
                                        <h4>📚 Built-in Hash-Based Structures</h4>
                                        <ul>
                                            <li><strong>Python:</strong> <code>dict</code> (HashMap) and
                                                <code>set</code> (HashSet)
                                            </li>
                                            <li><strong>Java:</strong> <code>HashMap</code> and <code>HashSet</code>
                                            </li>
                                            <li><strong>JavaScript:</strong> <code>Map</code> and <code>Set</code></li>
                                            <li><strong>C++:</strong> <code>unordered_map</code> and
                                                <code>unordered_set</code>
                                            </li>
                                        </ul>
                                        <p>These are your everyday tools for fast lookups and unique collections!</p>
                                    </div>

                                    <h2>HashMap vs HashSet</h2>

                                    <p>Let's understand when to use each:</p>

                                    <div class="info-box">
                                        <h4>Key Differences</h4>
                                        <table>
                                            <tr>
                                                <th>Feature</th>
                                                <th>HashMap</th>
                                                <th>HashSet</th>
                                            </tr>
                                            <tr>
                                                <td>Stores</td>
                                                <td>Key-Value pairs</td>
                                                <td>Unique values only</td>
                                            </tr>
                                            <tr>
                                                <td>Duplicates</td>
                                                <td>Unique keys, values can repeat</td>
                                                <td>No duplicates</td>
                                            </tr>
                                            <tr>
                                                <td>Use Case</td>
                                                <td>Frequency counting, lookups</td>
                                                <td>Duplicate detection</td>
                                            </tr>
                                            <tr>
                                                <td>Time</td>
                                                <td>O(1) average</td>
                                                <td>O(1) average</td>
                                            </tr>
                                        </table>
                                    </div>

                                    <div class="success-box">
                                        <h4>💡 Quick Decision Guide</h4>
                                        <p><strong>Use HashMap when:</strong></p>
                                        <ul>
                                            <li>You need to associate values with keys (like a dictionary)</li>
                                            <li>You're counting frequencies</li>
                                            <li>You need to look up related information</li>
                                        </ul>
                                        <p><strong>Use HashSet when:</strong></p>
                                        <ul>
                                            <li>You only care about presence/absence</li>
                                            <li>You need to remove duplicates</li>
                                            <li>You're checking membership</li>
                                        </ul>
                                    </div>
                                    <h3>See Two Sum in Action</h3>
                                    <div id="hashMapVisualization"></div>

                                    <h2>Common Problem-Solving Techniques</h2>

                                    <p>Now let's explore five powerful techniques using HashMap and HashSet. These
                                        patterns solve many real-world programming challenges:</p>

                                    <h3>1. Finding Pairs: The Two Sum Problem</h3>
                                    <div class="success-box">
                                        <h4>Problem: Find Two Numbers That Add Up to a Target</h4>
                                        <p>Given an array of numbers and a target, find two numbers that sum to the
                                            target.</p>
                                        <pre><code class="language-python">def two_sum(nums, target):
    seen = {}  # HashMap: value → index
    
    for i, num in enumerate(nums):
        complement = target - num
        
        if complement in seen:
            return [seen[complement], i]
        
        seen[num] = i
    
    return []</code></pre>
                                        <p><strong>Time:</strong> O(n), <strong>Space:</strong> O(n)</p>
                                        <p><strong>Key insight:</strong> Store what you've seen, check for complement!
                                        </p>
                                    </div>
                                    <h3>2. Grouping Items: Anagrams</h3>
                                    <div class="success-box">
                                        <h4>Problem: Group Words That Are Anagrams</h4>
                                        <p>Given a list of words, group together words that are anagrams (same letters,
                                            different order).</p>
                                        <pre><code class="language-python">def group_anagrams(words):
    groups = {}  # sorted_word → [anagrams]
    
    for word in words:
        key = ''.join(sorted(word))
        if key not in groups:
            groups[key] = []
        groups[key].append(word)
    
    return list(groups.values())</code></pre>
                                        <p><strong>Example:</strong> ["eat", "tea", "ate"] → same key "aet"</p>
                                    </div>
                                    <h3>3. Counting Frequencies</h3>
                                    <div class="success-box">
                                        <h4>Problem: Find First Non-Repeating Character</h4>
                                        <p>Given a string, find the first character that appears only once.</p>
                                        <pre><code class="language-python">def first_non_repeating(s):
    freq = {}
    for char in s:
        freq[char] = freq.get(char, 0) + 1
    
    for char in s:
        if freq[char] == 1:
            return char
    
    return None</code></pre>
                                        <p><strong>Pattern:</strong> Count frequencies, then find first with count 1</p>
                                    </div>
                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>
                                    <h3>4. Prefix Sum Technique</h3>
                                    <div class="success-box">
                                        <h4>Problem: Count Subarrays with Sum K</h4>
                                        <p>Find how many contiguous subarrays sum to a target value K.</p>
                                        <pre><code class="language-python">def subarray_sum_k(nums, k):
    prefix_sum = 0
    sum_count = {0: 1}
    result = 0
    
    for num in nums:
        prefix_sum += num
        
        if prefix_sum - k in sum_count:
            result += sum_count[prefix_sum - k]
        
        sum_count[prefix_sum] = sum_count.get(prefix_sum, 0) + 1
    
    return result</code></pre>
                                        <p><strong>Trick:</strong> Use HashMap to store prefix sums!</p>
                                    </div>
                                    <h3>5. Detecting Duplicates</h3>
                                    <div class="success-box">
                                        <h4>Problem: Check if Array Has Duplicates</h4>
                                        <p>Determine if an array contains any duplicate values.</p>
                                        <pre><code class="language-python">def contains_duplicate(nums):
    seen = set()
    
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    
    return False</code></pre>
                                        <p><strong>HashSet makes it O(n)!</strong> (vs O(n²) brute force)</p>
                                    </div>
                                    <h2>The Complete Code</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/hash-maps-sets.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-hashmap" />
                                    </jsp:include>
                                    <h2>When to Use These Techniques</h2>
                                    <div class="tip-box">
                                        <h4>💡 Recognizing the Right Tool</h4>
                                        <p>Here's how to recognize when to use HashMap or HashSet:</p>
                                        <ul>
                                            <li>✅ <strong>"Find pair that..."</strong> → Two Sum pattern with HashMap
                                            </li>
                                            <li>✅ <strong>"Group by..."</strong> → HashMap with custom keys</li>
                                            <li>✅ <strong>"Count how many..."</strong> → HashMap for frequency counting
                                            </li>
                                            <li>✅ <strong>"Check duplicates"</strong> → HashSet for O(n) solution</li>
                                            <li>✅ <strong>"Subarray sum"</strong> → Prefix sum + HashMap</li>
                                        </ul>
                                        <p><strong>These techniques appear frequently in coding challenges and
                                                real-world programming!</strong></p>
                                    </div>
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>What You've Learned</h3>
                                        <p>You now know how to use HashMap and HashSet to solve common programming
                                            problems:</p>
                                        <ol>
                                            <li><strong>HashMap:</strong> Key-value pairs for lookups, counting, and
                                                associations</li>
                                            <li><strong>HashSet:</strong> Unique collections for membership testing and
                                                duplicate removal</li>
                                            <li><strong>Five techniques:</strong> Pairs, grouping, frequencies, prefix
                                                sums, duplicates</li>
                                            <li><strong>Performance:</strong> All operations are O(1) average case</li>
                                            <li><strong>Applications:</strong> These patterns solve many real
                                                programming challenges</li>
                                        </ol>
                                    </div>
                                    <h2>What's Next?</h2>
                                    <p>You've learned the practical use of hash-based structures. Next up:
                                        <strong>Advanced Hashing</strong> — techniques used in distributed systems and
                                        large-scale applications!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="hash-tables.jsp" />
                                    <jsp:param name="prevTitle" value="Hash Tables" />
                                    <jsp:param name="nextLink" value="advanced-hashing.jsp" />
                                    <jsp:param name="nextTitle" value="Advanced Hashing" />
                                    <jsp:param name="currentLessonId" value="hash-maps-sets" />
                                </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script src="<%=request.getContextPath()%>/tutorials/dsa/algorithms/hash-maps-sets-viz.js"></script>
        </body>

        </html>