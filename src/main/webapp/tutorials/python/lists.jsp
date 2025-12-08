<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "lists");
   request.setAttribute("currentModule", "Data Structures"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Lists - Complete Guide to Creating, Indexing & Slicing | 8gwifi.org</title>
    <meta name="description"
        content="Master Python lists - the most versatile data structure. Learn to create lists, access elements with indexing, extract sublists with slicing, and modify list contents.">
    <meta name="keywords"
        content="python lists, python list tutorial, python list indexing, python list slicing, python array, python list examples, python list operations">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Lists - Complete Guide to Creating, Indexing & Slicing">
    <meta property="og:description" content="Master Python lists with comprehensive examples on creation, indexing, slicing, and modification.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/lists.jsp">
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
        "name": "Python Lists",
        "description": "Master Python lists - creating, indexing, slicing, and modifying list data structures.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Creating lists", "List indexing", "Negative indexing", "List slicing", "Modifying lists", "List membership"],
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

<body class="tutorial-body no-preview" data-lesson="lists">
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
                    <span>Lists</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Lists</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Lists are Python's most versatile data structure - ordered, mutable collections
                    that can hold any type of data. Think of a list like a dynamic container that can grow, shrink,
                    and change its contents at any time. If you're coming from other languages, lists are similar
                    to arrays but much more powerful!</p>

                    <!-- Section 1: Creating Lists -->
                    <h2>Creating Lists</h2>
                    <p>Lists are created using square brackets <code>[]</code> with items separated by commas.
                    Python lists can hold any data type - numbers, strings, booleans, even other lists!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-creating.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-creating" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>List Characteristics:</strong> Lists in Python are (1) <strong>Ordered</strong> -
                        items maintain their insertion order, (2) <strong>Mutable</strong> - you can change, add,
                        and remove items, (3) <strong>Allow duplicates</strong> - the same value can appear multiple
                        times, and (4) <strong>Heterogeneous</strong> - can mix different data types in one list.
                    </div>

                    <!-- Section 2: Indexing -->
                    <h2>Accessing Elements with Indexing</h2>
                    <p>Every item in a list has a position called an index. Python uses zero-based indexing - the
                    first element is at index 0, the second at index 1, and so on. You can also use negative
                    indices to count from the end!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-indexing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-indexing" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use negative indexing when you need elements from the end of a list.
                        <code>my_list[-1]</code> always gives you the last element, regardless of list length - much
                        cleaner than <code>my_list[len(my_list)-1]</code>!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Slicing -->
                    <h2>Extracting Sublists with Slicing</h2>
                    <p>Slicing lets you extract a portion of a list using the syntax <code>list[start:end:step]</code>.
                    It creates a new list containing elements from <code>start</code> up to (but not including)
                    <code>end</code>, optionally skipping by <code>step</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-slicing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-slicing" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Slicing Creates a Copy!</strong> When you slice a list, Python creates a new list.
                        The original list remains unchanged. This is important to remember for memory usage with
                        large lists. <code>my_list[:]</code> is a common idiom to create a shallow copy of a list.
                    </div>

                    <!-- Section 4: Modifying -->
                    <h2>Modifying Lists</h2>
                    <p>Unlike strings and tuples, lists are mutable - you can change their contents after creation.
                    You can modify individual elements, replace entire sections, add new elements, or remove existing ones.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lists-modifying.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-modifying" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. IndexError - Accessing invalid index</h4>
                        <pre><code class="language-python"># Wrong - index out of range
fruits = ["apple", "banana", "cherry"]
print(fruits[3])  # IndexError! Valid indices: 0, 1, 2

# Correct - check length first or use try/except
if len(fruits) > 3:
    print(fruits[3])
else:
    print("Index out of range")</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing index and value</h4>
                        <pre><code class="language-python"># Wrong - remove() takes value, not index
numbers = [10, 20, 30]
numbers.remove(1)  # Tries to remove VALUE 1, not index 1!

# Correct
numbers.remove(20)  # Remove by value
# OR
numbers.pop(1)      # Remove by index</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Off-by-one in slicing</h4>
                        <pre><code class="language-python"># Wrong assumption - end index is exclusive!
numbers = [0, 1, 2, 3, 4]
first_three = numbers[0:2]  # Only gets [0, 1], not [0, 1, 2]

# Correct - remember end is exclusive
first_three = numbers[0:3]  # Gets [0, 1, 2]
# Or more simply:
first_three = numbers[:3]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting that assignment creates references</h4>
                        <pre><code class="language-python"># Wrong - both variables point to same list!
original = [1, 2, 3]
copy = original  # This is NOT a copy!
copy.append(4)
print(original)  # [1, 2, 3, 4] - original changed too!

# Correct - create actual copy
copy = original[:]      # Slice copy
copy = original.copy()  # copy() method
copy = list(original)   # list() constructor</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Shopping List Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create and manipulate a shopping list.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a list with "milk", "eggs", "bread"</li>
                            <li>Print the second item (eggs)</li>
                            <li>Change "bread" to "whole wheat bread"</li>
                            <li>Add "butter" to the end of the list</li>
                            <li>Print the final list</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-lists-basics.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-lists" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Create the shopping list
shopping_list = ["milk", "eggs", "bread"]

# Print second item (index 1)
print(shopping_list[1])  # eggs

# Change bread to whole wheat bread (index 2)
shopping_list[2] = "whole wheat bread"

# Add butter to end
shopping_list.append("butter")

print(f"Final Shopping List: {shopping_list}")
# Output: ['milk', 'eggs', 'whole wheat bread', 'butter']</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Creating:</strong> Use <code>[]</code> with comma-separated values</li>
                            <li><strong>Properties:</strong> Ordered, mutable, allow duplicates, heterogeneous</li>
                            <li><strong>Positive index:</strong> <code>list[0]</code> = first, <code>list[1]</code> = second</li>
                            <li><strong>Negative index:</strong> <code>list[-1]</code> = last, <code>list[-2]</code> = second to last</li>
                            <li><strong>Slicing:</strong> <code>list[start:end:step]</code> - end is exclusive!</li>
                            <li><strong>Modifying:</strong> <code>list[i] = value</code>, <code>append()</code>, <code>insert()</code>, <code>remove()</code>, <code>pop()</code></li>
                            <li><strong>Copy:</strong> Use <code>list[:]</code> or <code>.copy()</code>, not <code>=</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you understand how to create and access lists, let's explore the powerful built-in
                    <strong>List Methods</strong> that let you sort, search, count, and transform your lists with ease!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-nested.jsp" />
                    <jsp:param name="prevTitle" value="Nested Loops" />
                    <jsp:param name="nextLink" value="lists-methods.jsp" />
                    <jsp:param name="nextTitle" value="List Methods" />
                    <jsp:param name="currentLessonId" value="lists" />
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
