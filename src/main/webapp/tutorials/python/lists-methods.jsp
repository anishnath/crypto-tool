<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "lists-methods");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python List Methods - append, sort, remove, pop & More | 8gwifi.org</title>
    <meta name="description"
        content="Master Python list methods: append, extend, insert for adding; remove, pop, clear for deleting; sort, reverse for ordering; and index, count for searching.">
    <meta name="keywords"
        content="python list methods, python append, python pop, python sort list, python remove from list, python list functions, python extend vs append">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python List Methods - append, sort, remove, pop & More">
    <meta property="og:description" content="Complete guide to Python list methods for adding, removing, sorting, and searching.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/lists-methods.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "name": "Python List Methods",
        "description": "Master Python list methods for adding, removing, sorting, and searching list elements.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["append()", "extend()", "insert()", "remove()", "pop()", "sort()", "reverse()", "index()", "count()"],
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

<body class="tutorial-body no-preview" data-lesson="lists-methods">
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
                    <span>List Methods</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">List Methods</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Python lists come with powerful built-in methods that let you manipulate data
                    with ease. Whether you need to add items, remove duplicates, sort data, or find elements,
                    there's a method for that. Mastering these methods is essential for writing clean, efficient Python code!</p>

                    <!-- Section 1: Adding Elements -->
                    <h2>Adding Elements</h2>
                    <p>Three methods let you add elements to a list: <code>append()</code> adds one item to the end,
                    <code>insert()</code> adds at a specific position, and <code>extend()</code> adds multiple items
                    from another iterable.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-methods-adding.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-adding" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>append() vs extend():</strong> <code>append()</code> adds its argument as a single
                        element, even if it's a list. <code>extend()</code> iterates over its argument and adds
                        each element individually. Use <code>append()</code> for single items, <code>extend()</code>
                        for combining lists.
                    </div>

                    <!-- Section 2: Removing Elements -->
                    <h2>Removing Elements</h2>
                    <p>Python provides several ways to remove elements: <code>remove()</code> by value,
                    <code>pop()</code> by index (with return), <code>del</code> by index or slice, and
                    <code>clear()</code> to empty the entire list.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-methods-removing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-removing" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>pop()</code> when you need the removed value (like
                        implementing a stack). Use <code>remove()</code> when you know the value but not the index.
                        Use <code>del</code> when removing multiple items with a slice.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Sorting and Ordering -->
                    <h2>Sorting and Ordering</h2>
                    <p>Sort lists with <code>sort()</code> (modifies in place) or <code>sorted()</code> (returns new list).
                    Reverse with <code>reverse()</code> or <code>reversed()</code>. Both support custom sorting with
                    the <code>key</code> parameter.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-methods-sorting.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-sorting" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>In-Place vs New List:</strong> <code>sort()</code> and <code>reverse()</code> modify
                        the original list and return <code>None</code>. Don't do <code>x = mylist.sort()</code> -
                        x will be None! Use <code>sorted()</code> or <code>reversed()</code> if you need to keep
                        the original list unchanged.
                    </div>

                    <!-- Section 4: Searching and Counting -->
                    <h2>Searching and Counting</h2>
                    <p>Find elements with <code>index()</code>, count occurrences with <code>count()</code>,
                    and check membership with the <code>in</code> operator.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-methods-searching.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-searching" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Assigning result of sort() or reverse()</h4>
                        <pre><code class="language-python"># Wrong - sort() returns None!
numbers = [3, 1, 2]
sorted_nums = numbers.sort()
print(sorted_nums)  # None!

# Correct
numbers.sort()  # Modifies in place
print(numbers)  # [1, 2, 3]

# Or use sorted() for new list
sorted_nums = sorted([3, 1, 2])</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. remove() raises error if item not found</h4>
                        <pre><code class="language-python"># Wrong - crashes if item doesn't exist
fruits = ["apple", "banana"]
fruits.remove("grape")  # ValueError!

# Correct - check first
if "grape" in fruits:
    fruits.remove("grape")
else:
    print("Not found")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing append() with extend()</h4>
                        <pre><code class="language-python"># Unexpected result
list1 = [1, 2, 3]
list1.append([4, 5])
print(list1)  # [1, 2, 3, [4, 5]] - nested list!

# What you probably wanted
list2 = [1, 2, 3]
list2.extend([4, 5])
print(list2)  # [1, 2, 3, 4, 5]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Modifying list while iterating</h4>
                        <pre><code class="language-python"># Wrong - removing while iterating causes issues
numbers = [1, 2, 3, 4, 5]
for num in numbers:
    if num % 2 == 0:
        numbers.remove(num)  # Skips elements!

# Correct - iterate over copy or use list comprehension
numbers = [1, 2, 3, 4, 5]
numbers = [num for num in numbers if num % 2 != 0]
print(numbers)  # [1, 3, 5]</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: List Operations</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Perform various operations on a list of numbers.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Add the number 10 to the end of the list</li>
                            <li>Remove the first occurrence of 5</li>
                            <li>Sort the list in ascending order</li>
                            <li>Print the final list</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-lists-methods.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-methods" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">numbers = [5, 2, 9, 1, 5, 6]

# Add 10 to end
numbers.append(10)

# Remove first 5
numbers.remove(5)

# Sort ascending
numbers.sort()

print(f"Final list: {numbers}")
# Output: [1, 2, 5, 6, 9, 10]</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Adding:</strong> <code>append(x)</code>, <code>insert(i, x)</code>, <code>extend(iterable)</code></li>
                            <li><strong>Removing:</strong> <code>remove(x)</code>, <code>pop([i])</code>, <code>del list[i]</code>, <code>clear()</code></li>
                            <li><strong>Sorting:</strong> <code>sort()</code> (in-place), <code>sorted()</code> (new list)</li>
                            <li><strong>Reversing:</strong> <code>reverse()</code> (in-place), <code>reversed()</code> (iterator)</li>
                            <li><strong>Searching:</strong> <code>index(x)</code>, <code>count(x)</code>, <code>x in list</code></li>
                            <li><strong>In-place methods:</strong> Return <code>None</code>, modify original</li>
                            <li><strong>Functional versions:</strong> <code>sorted()</code>, <code>reversed()</code> preserve original</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you've mastered list methods, let's learn <strong>List Comprehensions</strong> -
                    Python's elegant, one-liner syntax for creating and transforming lists. It's one of Python's
                    most loved features!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="lists.jsp" />
                    <jsp:param name="prevTitle" value="Lists" />
                    <jsp:param name="nextLink" value="lists-comprehension.jsp" />
                    <jsp:param name="nextTitle" value="List Comprehensions" />
                    <jsp:param name="currentLessonId" value="lists-methods" />
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
