<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-iterators" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Iterators - Custom Iterators, Iterator Protocol, __iter__ & __next__ | 8gwifi.org</title>
            <meta name="description"
                content="Master Python iterators and the iterator protocol. Learn how to create custom iterators using __iter__ and __next__, understand iterables vs iterators, and build efficient iteration patterns.">
            <meta name="keywords"
                content="python iterator, python iterable, python next, python __iter__, python __next__, iterator protocol, custom iterator">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Iterators - Custom Iterators, Iterator Protocol, __iter__ & __next__">
            <meta property="og:description"
                content="Master Python iterators and the iterator protocol. Learn how to create custom iterators using __iter__ and __next__ with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-iterators.jsp">
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
        "name": "Python Iterators",
        "description": "Master Python iterators and the iterator protocol. Learn how to create custom iterators using __iter__ and __next__.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Iterator protocol", "Iterables vs iterators", "__iter__ method", "__next__ method", "Custom iterators", "StopIteration exception", "Iterator pattern", "Memory-efficient iteration"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="adv-iterators">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Advanced</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Iterators</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">An iterator is an object that implements the iterator protocol,
                                        allowing you to traverse through a sequence of values one at a time. Unlike lists
                                        or tuples that store all values in memory, iterators generate values on-demand,
                                        making them memory-efficient for large datasets. Understanding iterators unlocks
                                        powerful patterns for custom iteration behavior!</p>

                                    <h2>Iterables vs Iterators</h2>
                                    <p>An <strong>iterable</strong> is any object you can iterate over (lists, tuples,
                                        strings, dicts). An <strong>iterator</strong> is an object that produces the next
                                        value when you call <code>next()</code> on it. When you use a <code>for</code>
                                        loop, Python automatically converts the iterable into an iterator.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-iterators-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Difference:</strong><br>
                                        - <strong>Iterable:</strong> Has <code>__iter__()</code> method that returns an
                                        iterator<br>
                                        - <strong>Iterator:</strong> Has both <code>__iter__()</code> (returns self) and
                                        <code>__next__()</code> (returns next value)<br><br>
                                        All iterators are iterables, but not all iterables are iterators. Lists are
                                        iterables but not iterators until converted.
                                    </div>

                                    <h2>The Iterator Protocol</h2>
                                    <p>To create a custom iterator, you must implement two methods: <code>__iter__()</code>
                                        and <code>__next__()</code>. The <code>__iter__()</code> method returns the
                                        iterator object itself (or a new iterator object). The <code>__next__()</code>
                                        method returns the next value and raises <code>StopIteration</code> when there are
                                        no more items.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-iterators-protocol.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-protocol" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> You can use the built-in <code>iter()</code> function to
                                        get an iterator from any iterable, and <code>next()</code> to manually advance
                                        through values. This gives you fine-grained control over iteration!
                                    </div>

                                    <h2>Creating Custom Iterators</h2>
                                    <p>Custom iterators let you define exactly how iteration works for your objects. This
                                        is powerful for lazy evaluation, infinite sequences, or custom traversal logic.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-iterators-custom.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-custom" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Memory Efficiency of Iterators</h2>
                                    <p>Unlike lists that store all values in memory, iterators generate values
                                        on-demand. This makes them perfect for large datasets or infinite sequences that
                                        wouldn't fit in memory.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-iterators-memory.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-memory" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Once an iterator is exhausted (raises
                                        <code>StopIteration</code>), you can't reuse it. To iterate again, you need to
                                        create a new iterator by calling <code>__iter__()</code> or using
                                        <code>iter()</code> again. This is why you can only iterate over a file handle
                                        once!
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to raise StopIteration</h4>
                                        <pre><code class="language-python"># Wrong - will loop forever or return None
class Counter:
    def __iter__(self):
        self.count = 0
        return self
    
    def __next__(self):
        if self.count < 5:
            self.count += 1
            return self.count
        # Missing: raise StopIteration

# Correct - explicitly raise StopIteration
class Counter:
    def __iter__(self):
        self.count = 0
        return self
    
    def __next__(self):
        if self.count < 5:
            self.count += 1
            return self.count
        raise StopIteration  # Signal end of iteration</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Trying to iterate over an exhausted iterator</h4>
                                        <pre><code class="language-python"># Wrong - iterator is exhausted after first loop
numbers = iter([1, 2, 3])
for n in numbers:
    print(n)

for n in numbers:  # This won't print anything!
    print(n)

# Correct - create a new iterator for each loop
numbers = [1, 2, 3]
for n in numbers:  # Automatically creates iterator
    print(n)

for n in numbers:  # Creates a new iterator
    print(n)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Confusing iterables with iterators</h4>
                                        <pre><code class="language-python"># Wrong - list is iterable but not an iterator
my_list = [1, 2, 3]
next(my_list)  # TypeError: 'list' object is not an iterator

# Correct - convert to iterator first
my_list = [1, 2, 3]
my_iterator = iter(my_list)
print(next(my_iterator))  # Works: 1
print(next(my_iterator))  # Works: 2</code></pre>
                                    </div>

                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a countdown iterator that counts down from a
                                            given number to 1, then raises StopIteration.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Implement a <code>Countdown</code> class with <code>__iter__</code> and
                                                <code>__next__</code> methods</li>
                                            <li>Initialize with a starting number</li>
                                            <li>Return numbers in descending order (start, start-1, ..., 1)</li>
                                            <li>Raise <code>StopIteration</code> when countdown reaches 0</li>
                                            <li>Test it with both a for loop and manual <code>next()</code> calls</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-iterators.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-iterators" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">class Countdown:
    def __init__(self, start):
        self.start = start
        self.current = start
    
    def __iter__(self):
        self.current = self.start  # Reset for new iteration
        return self
    
    def __next__(self):
        if self.current > 0:
            value = self.current
            self.current -= 1
            return value
        else:
            raise StopIteration


# Test with for loop
print("Countdown from 5:")
for num in Countdown(5):
    print(num)

# Test with manual next()
print("\nManual iteration from 3:")
counter = Countdown(3)
it = iter(counter)
print(next(it))  # 3
print(next(it))  # 2
print(next(it))  # 1
# next(it) would raise StopIteration</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Iterable:</strong> Object with <code>__iter__()</code> that can be
                                                looped over (lists, tuples, strings, dicts)</li>
                                            <li><strong>Iterator:</strong> Object with both <code>__iter__()</code> and
                                                <code>__next__()</code> that produces values on-demand</li>
                                            <li><strong>Iterator Protocol:</strong> Implement <code>__iter__()</code>
                                                (returns self) and <code>__next__()</code> (returns next value, raises
                                                StopIteration when done)</li>
                                            <li><strong>Memory Efficiency:</strong> Iterators generate values lazily,
                                                perfect for large datasets</li>
                                            <li><strong>One-time Use:</strong> Iterators are consumed after one pass; create
                                                new ones for multiple iterations</li>
                                            <li><strong>Built-in Functions:</strong> Use <code>iter()</code> to get an
                                                iterator from an iterable, <code>next()</code> to manually advance</li>
                                            <li><strong>StopIteration:</strong> Must raise this exception to signal end of
                                                iteration</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now you understand the iterator protocol! Next, we'll explore
                                        <strong>generators</strong>, which provide a simpler way to create iterators using
                                        the <code>yield</code> keyword. Generators are iterators under the hood, but
                                        Python handles all the <code>__iter__</code> and <code>__next__</code> boilerplate
                                        for you!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="oop-dataclass.jsp" />
                                    <jsp:param name="prevTitle" value="Dataclasses" />
                                    <jsp:param name="nextLink" value="adv-generators.jsp" />
                                    <jsp:param name="nextTitle" value="Generators" />
                                    <jsp:param name="currentLessonId" value="adv-iterators" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>