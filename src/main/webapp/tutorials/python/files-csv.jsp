<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-csv");
   request.setAttribute("currentModule", "File Handling"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python CSV Files - reader, writer, DictReader, DictWriter | 8gwifi.org</title>
    <meta name="description"
        content="Master Python CSV handling - use csv.reader and csv.writer for basic operations, DictReader/DictWriter for dictionaries, and handle different dialects and delimiters.">
    <meta name="keywords"
        content="python csv, python read csv, python write csv, python DictReader, python DictWriter, python csv module, python csv delimiter">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python CSV Files - reader, writer, DictReader, DictWriter">
    <meta property="og:description" content="Master Python CSV handling: reading, writing, and processing tabular data.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/files-csv.jsp">
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
        "name": "Python CSV Files",
        "description": "Master Python CSV handling - use the csv module to read, write, and process tabular data from CSV files.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["csv.reader and csv.writer", "DictReader and DictWriter", "Handling headers", "CSV dialects and delimiters", "Quoting options", "Practical data processing"],
        "timeRequired": "PT30M",
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

<body class="tutorial-body no-preview" data-lesson="files-csv">
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
                    <span>CSV Files</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">CSV Files</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">CSV (Comma-Separated Values) is one of the most common data formats - every
                    spreadsheet application can export to it, databases can import it, and it's human-readable.
                    Python's built-in <code>csv</code> module handles all the tricky parts: quoting, escaping,
                    different delimiters, and headers. Whether you're processing financial data, user records, or
                    scientific measurements, mastering CSV is essential!</p>

                    <!-- Section 1: Reading -->
                    <h2>Reading CSV Files</h2>
                    <p>The <code>csv.reader()</code> returns an iterator that yields each row as a list of strings.
                    For more convenient access by column names, <code>csv.DictReader()</code> yields each row as
                    a dictionary with column headers as keys. This makes code more readable and maintainable.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/csv-reading.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-reading" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>reader vs DictReader:</strong><br>
                        <code>csv.reader(f)</code> - Rows as lists: <code>row[0], row[1]</code><br>
                        <code>csv.DictReader(f)</code> - Rows as dicts: <code>row['name'], row['age']</code><br>
                        Use reader for simple, positional access.<br>
                        Use DictReader when columns have meaning - code is clearer!
                    </div>

                    <!-- Section 2: Writing -->
                    <h2>Writing CSV Files</h2>
                    <p>Use <code>csv.writer()</code> to write lists of values, and <code>csv.DictWriter()</code>
                    to write dictionaries. Always open files with <code>newline=""</code> on Windows to prevent
                    blank lines between rows. The <code>writeheader()</code> method writes column names.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/csv-writing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-writing" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Windows Users!</strong> Always use <code>newline=""</code> when opening CSV files
                        for writing: <code>open("file.csv", "w", newline="")</code>. Without this, you'll get
                        extra blank lines between rows. This is because the csv module handles line endings itself.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Dialects -->
                    <h2>Dialects and Options</h2>
                    <p>Not all CSV files use commas! European files often use semicolons, tab-separated values (TSV)
                    are common, and different applications quote fields differently. The csv module supports various
                    dialects and lets you customize delimiter, quoting, and other options.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/csv-dialects.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-dialects" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Quoting Constants:</strong><br>
                        <code>csv.QUOTE_MINIMAL</code> - Only quote when needed (default)<br>
                        <code>csv.QUOTE_ALL</code> - Quote all fields<br>
                        <code>csv.QUOTE_NONNUMERIC</code> - Quote non-numeric fields<br>
                        <code>csv.QUOTE_NONE</code> - Never quote (escape special chars)<br>
                        Use QUOTE_ALL for maximum compatibility with other tools.
                    </div>

                    <!-- Section 4: Practical -->
                    <h2>Practical Examples</h2>
                    <p>In real projects, you'll process CSV data: calculate totals, filter rows, group by categories,
                    add computed columns, and transform data. The csv module combines well with Python's built-in
                    functions and collections for powerful data processing.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/csv-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting newline="" on Windows</h4>
                        <pre><code class="language-python"># Wrong - creates extra blank lines on Windows!
with open("data.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Correct - always use newline=""
with open("data.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(data)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not handling commas in data</h4>
                        <pre><code class="language-python"># Wrong - manual string building breaks on commas!
data = ["Alice", "New York, NY", "30"]
line = ",".join(data)  # "Alice,New York, NY,30" - 4 fields!

# Correct - let csv module handle quoting
with open("data.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(data)  # "Alice","New York, NY","30"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Assuming all fields are strings</h4>
                        <pre><code class="language-python"># Wrong - CSV values are always strings!
with open("data.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        total = row['quantity'] * row['price']  # TypeError!

# Correct - convert to numbers
with open("data.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        total = int(row['quantity']) * float(row['price'])</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Reading the same file twice</h4>
                        <pre><code class="language-python"># Wrong - reader is exhausted after first loop!
with open("data.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
    for row in reader:  # Empty! Iterator exhausted
        process(row)

# Correct - read into list or open again
with open("data.csv", "r") as f:
    rows = list(csv.reader(f))  # Store in memory
for row in rows:
    print(row)
for row in rows:  # Works!
    process(row)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. DictWriter with missing keys</h4>
                        <pre><code class="language-python"># Wrong - KeyError if dict missing a field!
fieldnames = ["name", "age", "city"]
data = {"name": "Alice", "age": 30}  # Missing 'city'!

with open("data.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writerow(data)  # KeyError: 'city'

# Correct - use extrasaction and restval
with open("data.csv", "w", newline="") as f:
    writer = csv.DictWriter(
        f, fieldnames=fieldnames,
        extrasaction='ignore',  # Ignore extra keys
        restval=""  # Default for missing keys
    )
    writer.writerow(data)  # Works!</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Sales Report Generator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Process sales data and generate a summary report CSV.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Read a sales CSV with columns: product, quantity, price</li>
                            <li>Calculate total revenue per product</li>
                            <li>Write a summary CSV with: product, total_quantity, total_revenue</li>
                            <li>Sort by revenue (highest first)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-files-csv.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-csv" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">import csv
import os
from collections import defaultdict

# Create sample sales data
sales_csv = """product,quantity,price
Widget,10,9.99
Gadget,5,19.99
Widget,8,9.99
Gadget,12,19.99
Thing,20,5.00
Widget,15,9.99
Thing,25,5.00"""

with open("sales.csv", "w") as f:
    f.write(sales_csv)

# Process sales data
totals = defaultdict(lambda: {"quantity": 0, "revenue": 0.0})

with open("sales.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        product = row["product"]
        qty = int(row["quantity"])
        price = float(row["price"])
        totals[product]["quantity"] += qty
        totals[product]["revenue"] += qty * price

# Convert to sorted list (by revenue, descending)
summary = [
    {"product": p, "total_quantity": d["quantity"], "total_revenue": f"{d['revenue']:.2f}"}
    for p, d in sorted(totals.items(), key=lambda x: -x[1]["revenue"])
]

# Write summary report
with open("summary.csv", "w", newline="") as f:
    fieldnames = ["product", "total_quantity", "total_revenue"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(summary)

# Display result
print("=== Sales Summary ===")
with open("summary.csv", "r") as f:
    print(f.read())

# Cleanup
os.remove("sales.csv")
os.remove("summary.csv")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Read with reader:</strong> <code>csv.reader(f)</code> - rows as lists</li>
                            <li><strong>Read with DictReader:</strong> <code>csv.DictReader(f)</code> - rows as dicts</li>
                            <li><strong>Write with writer:</strong> <code>csv.writer(f)</code> with <code>writerow()</code></li>
                            <li><strong>Write with DictWriter:</strong> <code>csv.DictWriter(f, fieldnames=[])</code></li>
                            <li><strong>Write header:</strong> <code>writer.writeheader()</code></li>
                            <li><strong>Batch write:</strong> <code>writer.writerows(data)</code></li>
                            <li><strong>Custom delimiter:</strong> <code>delimiter=";"</code> or <code>delimiter="\t"</code></li>
                            <li><strong>Windows fix:</strong> Always use <code>newline=""</code> when writing</li>
                            <li><strong>Quoting:</strong> <code>quoting=csv.QUOTE_ALL</code> for safety</li>
                            <li><strong>Convert types:</strong> CSV values are strings - convert with int/float</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>CSV is great for tabular data, but for more complex structures you'll need <strong>JSON</strong>.
                    JSON supports nested objects, arrays, and multiple data types - perfect for configuration files,
                    API responses, and hierarchical data. Let's learn how to read and write JSON with Python!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-paths.jsp" />
                    <jsp:param name="prevTitle" value="Working with Paths" />
                    <jsp:param name="nextLink" value="files-json.jsp" />
                    <jsp:param name="nextTitle" value="JSON Files" />
                    <jsp:param name="currentLessonId" value="files-csv" />
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
