<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables-arrays");
   request.setAttribute("currentModule", "Variables & Environment"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Arrays - Declaring, Accessing Elements, Iterating, Associative Arrays | 8gwifi.org</title>
    <meta name="description"
        content="Master Bash arrays: indexed arrays, accessing elements with \${array[index]}, iterating with @ and *, array length \${#array[@]}, and associative arrays (key-value pairs).">
    <meta name="keywords"
        content="bash arrays, bash array indexing, bash array length, bash associative arrays, bash iterate array, bash array operations, bash array tutorial">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Arrays - Declaring, Accessing Elements, Iterating, Associative Arrays">
    <meta property="og:description" content="Master Bash arrays: indexed arrays, accessing elements, iterating, and associative arrays for key-value storage.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/variables-arrays.jsp">
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
        "name": "Bash Arrays",
        "description": "Master Bash arrays: indexed arrays, accessing elements, iterating, array length, and associative arrays.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Array declaration", "Array indexing", "Array access \${array[index]}", "Array iteration", "@ and * indices", "Array length \${#array[@]}", "Associative arrays", "Array operations"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="variables-arrays">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Arrays</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Arrays</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Arrays in Bash allow you to store multiple values in a single variable. They're incredibly useful for working with lists, processing multiple files, and handling related data together. Bash supports both indexed arrays (with numeric indices) and associative arrays (with string keys, like a dictionary). Once you master arrays, you'll write more powerful and flexible scripts!</p>

                    <!-- Section 1: Declaring Arrays -->
                    <h2>Declaring Arrays</h2>
                    <p>In Bash, arrays can be declared in several ways. The simplest is assigning multiple values in parentheses.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-arrays.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-arrays" />
                    </jsp:include>

                    <pre><code class="language-bash"># Different ways to declare arrays

# Method 1: Direct assignment
fruits=("apple" "banana" "cherry")

# Method 2: Explicit declare (optional)
declare -a numbers=(1 2 3 4 5)

# Method 3: Individual assignment
colors[0]="red"
colors[1]="green"
colors[2]="blue"

# Method 4: Sparse array (skip indices)
items[0]="first"
items[5]="fifth"  # indices 1-4 are empty</code></pre>

                    <div class="info-box">
                        <strong>Array Indices:</strong><br>
                        - Bash arrays are zero-indexed (first element is at index 0)<br>
                        - Indices don't have to be sequential (sparse arrays are allowed)<br>
                        - You can start with any index number
                    </div>

                    <!-- Section 2: Accessing Array Elements -->
                    <h2>Accessing Array Elements</h2>
                    <p>Access individual elements using the syntax <code>\${array[index]}</code>. Always use braces when accessing array elements!</p>

                    <pre><code class="language-bash">fruits=("apple" "banana" "cherry")

# Access individual elements
echo \${fruits[0]}  # apple (first element)
echo \${fruits[1]}  # banana (second element)
echo \${fruits[2]}  # cherry (third element)

# Access all elements
echo \${fruits[@]}  # All elements separately
echo \${fruits[*]}  # All elements as one string</code></pre>

                    <!-- Section 3: Array Length -->
                    <h2>Array Length</h2>
                    <p>Get the number of elements in an array using <code>\${#array[@]}</code>. This is different from string length!</p>

                    <pre><code class="language-bash">fruits=("apple" "banana" "cherry")

# Number of elements
echo \${#fruits[@]}  # Output: 3

# Length of specific element
echo \${#fruits[0]}  # Output: 5 (length of "apple")
echo \${#fruits[@]}  # Output: 3 (number of elements)

# Note the difference:
# \${#var} = length of string
# \${#array[@]} = number of array elements</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 4: Iterating Through Arrays -->
                    <h2>Iterating Through Arrays</h2>
                    <p>Use <code>for</code> loops to iterate through array elements. Always use <code>"\${array[@]}"</code> to preserve spaces in elements.</p>

                    <pre><code class="language-bash">fruits=("apple" "banana" "cherry")

# Iterate through values
for fruit in "\${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# Iterate with indices
for i in "\${!fruits[@]}"; do
    echo "Index $i: \${fruits[$i]}"
done

# Iterate through indices
for index in "\${!fruits[@]}"; do
    echo "fruits[$index]=\${fruits[$index]}"
done</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Always use <code>"\${array[@]}"</code> (with quotes) when iterating! This preserves spaces in array elements. Unquoted <code>\${array[@]}</code> or using <code>\${array[*]}</code> can break with elements containing spaces.
                    </div>

                    <!-- Section 5: Modifying Arrays -->
                    <h2>Modifying Arrays</h2>
                    <p>You can modify existing elements, add new elements, and remove elements from arrays.</p>

                    <pre><code class="language-bash">fruits=("apple" "banana" "cherry")

# Modify an element
fruits[1]="blueberry"
echo \${fruits[@]}  # apple blueberry cherry

# Add elements (append)
fruits+=("date" "elderberry")
echo \${fruits[@]}  # apple blueberry cherry date elderberry

# Add single element
fruits+="fig"  # Note: this appends to last element!
echo \${fruits[@]}

# Remove elements (creates sparse array)
unset fruits[2]
echo \${fruits[@]}  # apple blueberry date elderberry (index 2 is gone)</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> When you <code>unset</code> an array element, it creates a "sparse" array with gaps. The indices don't automatically renumber. To remove gaps, you'd need to create a new array: <code>new_array=("\${old_array[@]}")</code>
                    </div>

                    <!-- Section 6: Associative Arrays -->
                    <h2>Associative Arrays (Bash 4+)</h2>
                    <p>Associative arrays (also called hashes or dictionaries) use string keys instead of numeric indices. They're perfect for key-value storage.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-arrays-advanced.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-arrays-advanced" />
                    </jsp:include>

                    <pre><code class="language-bash"># Declare associative array (Bash 4+)
declare -A person

# Assign values using string keys
person[name]="Alice"
person[age]=25
person[city]="New York"

# Access values
echo \${person[name]}  # Alice
echo \${person[age]}   # 25

# Get all keys
echo \${!person[@]}  # name age city

# Get all values
echo \${person[@]}   # Alice 25 New York</code></pre>

                    <div class="info-box">
                        <strong>Associative Arrays:</strong><br>
                        - Must be declared with <code>declare -A array_name</code><br>
                        - Use string keys instead of numeric indices<br>
                        - Available in Bash 4.0 and later<br>
                        - Perfect for configuration data, mappings, and key-value storage
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using $array instead of \${array[@]} or \${array[index]}</h4>
                        <pre><code class="language-bash"># Wrong - only gets first element
fruits=("apple" "banana" "cherry")
echo $fruits  # Only prints: apple

# Correct - use \${array[@]} for all elements
echo \${fruits[@]}  # Prints: apple banana cherry

# Or \${array[index]} for specific element
echo \${fruits[1]}  # Prints: banana</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not using quotes when iterating arrays</h4>
                        <pre><code class="language-bash"># Wrong - breaks with spaces
items=("file one.txt" "file two.txt")
for item in \${items[@]}; do
    echo "$item"  # Prints: file, one.txt, file, two.txt (4 iterations!)
done

# Correct - use quotes
for item in "\${items[@]}"; do
    echo "$item"  # Prints: file one.txt, file two.txt (2 iterations)
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing \${#array[@]} with \${#array[0]}</h4>
                        <pre><code class="language-bash">fruits=("apple" "banana")

# Wrong - gets length of first element, not array size
length=\${#fruits}  # Gets length of "apple" (5), not array size!

# Correct - use [@] for array length
size=\${#fruits[@]}  # Gets number of elements (2)
first_length=\${#fruits[0]}  # Gets length of first element (5)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not declaring associative arrays</h4>
                        <pre><code class="language-bash"># Wrong - creates indexed array, not associative
person[name]="Alice"  # Creates indexed array with index "name" (weird behavior)

# Correct - declare first
declare -A person
person[name]="Alice"  # Creates associative array</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Work with Arrays</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that demonstrates array operations!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create an array with at least 5 elements</li>
                            <li>Display the array length</li>
                            <li>Display the first and last elements</li>
                            <li>Modify one element</li>
                            <li>Add two new elements</li>
                            <li>Iterate through all elements and display them</li>
                            <li>(Optional) Create an associative array with 3 key-value pairs</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Array operations exercise

# Create array
colors=("red" "green" "blue" "yellow" "purple")

# Display array length
echo "Array length: \${#colors[@]}"
echo ""

# Display first and last elements
echo "First element: \${colors[0]}"
last_index=$((\${#colors[@]} - 1))
echo "Last element: \${colors[$last_index]}"
echo ""

# Modify an element
colors[2]="cyan"
echo "After modifying index 2: \${colors[@]}"
echo ""

# Add elements
colors+=("orange" "pink")
echo "After adding elements: \${colors[@]}"
echo ""

# Iterate through array
echo "All colors:"
for color in "\${colors[@]}"; do
    echo "  - $color"
done
echo ""

# Associative array example
declare -A person
person[name]="Alice"
person[age]=25
person[city]="New York"

echo "Associative array:"
for key in "\${!person[@]}"; do
    echo "  $key: \${person[$key]}"
done</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Declaration:</strong> <code>array=(item1 item2 item3)</code> or <code>declare -a array</code></li>
                            <li><strong>Access Element:</strong> <code>\${array[index]}</code> (zero-indexed)</li>
                            <li><strong>All Elements:</strong> <code>\${array[@]}</code> (separate) or <code>\${array[*]}</code> (one string)</li>
                            <li><strong>Array Length:</strong> <code>\${#array[@]}</code> (number of elements)</li>
                            <li><strong>Element Length:</strong> <code>\${#array[index]}</code> (length of specific element)</li>
                            <li><strong>Modify:</strong> <code>array[index]=value</code></li>
                            <li><strong>Add:</strong> <code>array+=(new items)</code> or <code>array+=("new")</code></li>
                            <li><strong>Remove:</strong> <code>unset array[index]</code> (creates sparse array)</li>
                            <li><strong>Iterate:</strong> <code>for item in "\${array[@]}"; do ... done</code></li>
                            <li><strong>Indices:</strong> <code>\${!array[@]}</code> gets all indices</li>
                            <li><strong>Associative:</strong> <code>declare -A array</code> then <code>array[key]=value</code></li>
                            <li><strong>Always quote:</strong> Use <code>"\${array[@]}"</code> to preserve spaces</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Perfect! You've mastered arrays in Bash. Now you're ready to move on to <strong>Strings & Text Processing</strong>. You'll learn about string operations, parameter expansion for pattern matching, and here documents - essential tools for text manipulation and data processing in Bash!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="variables-special.jsp" />
                    <jsp:param name="prevTitle" value="Special Variables" />
                    <jsp:param name="nextLink" value="strings-basics.jsp" />
                    <jsp:param name="nextTitle" value="String Basics" />
                    <jsp:param name="currentLessonId" value="variables-arrays" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>

