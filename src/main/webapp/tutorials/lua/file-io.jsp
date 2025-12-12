<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "file-io" ); request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>File I/O in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master file I/O in Lua: reading and writing files, file modes, binary files, and file system operations.">
            <meta name="keywords"
                content="lua file io, lua read file, lua write file, io.open, file handling lua, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="File I/O in Lua - Lua Tutorial">
            <meta property="og:description" content="Learn file I/O in Lua: read, write, and manage files effectively.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/file-io.jsp">
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
        "name": "File I/O in Lua",
        "description": "Master file I/O in Lua: reading, writing, and managing files.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/file-io.jsp",
        "keywords": "lua file io, read file, write file, io.open, file handling",
        "educationalLevel": "Intermediate",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["File I/O", "Reading files", "Writing files", "File modes", "File operations"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "url": "https://8gwifi.org/tutorials/lua/"
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
                "name": "File I/O"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="file-io">
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
                                    <span>File I/O</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">File I/O in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">File I/O (Input/Output) is essential for reading and writing data to
                                        files. Lua provides a simple yet powerful I/O library for working with files. In
                                        this lesson, you'll learn how to read from files, write to files, handle
                                        different
                                        file modes, and perform common file operations. Let's explore file I/O in Lua!
                                    </p>

                                    <!-- Opening Files -->
                                    <h2>Opening Files</h2>
                                    <p>Use <code>io.open()</code> to open a file:</p>

                                    <pre><code class="language-lua">-- Open file for reading
local file, err = io.open("data.txt", "r")

if not file then
    print("Error:", err)
else
    -- Use file
    file:close()
end</code></pre>

                                    <h3>File Modes</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Mode</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>"r"</code></td>
                                                <td>Read mode (default)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"w"</code></td>
                                                <td>Write mode (overwrites existing file)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"a"</code></td>
                                                <td>Append mode (adds to end of file)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"r+"</code></td>
                                                <td>Read and write (file must exist)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"w+"</code></td>
                                                <td>Read and write (overwrites)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"a+"</code></td>
                                                <td>Read and append</td>
                                            </tr>
                                            <tr>
                                                <td><code>"rb", "wb"</code></td>
                                                <td>Binary mode</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/file-reading.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <!-- Reading Files -->
                                    <h2>Reading Files</h2>

                                    <h3>Read Entire File</h3>
                                    <pre><code class="language-lua">local file = io.open("data.txt", "r")
if file then
    local content = file:read("*all")
    print(content)
    file:close()
end</code></pre>

                                    <h3>Read Line by Line</h3>
                                    <pre><code class="language-lua">local file = io.open("data.txt", "r")
if file then
    for line in file:lines() do
        print(line)
    end
    file:close()
end</code></pre>

                                    <h3>Read Modes</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Mode</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>"*all"</code></td>
                                                <td>Read entire file</td>
                                            </tr>
                                            <tr>
                                                <td><code>"*line"</code></td>
                                                <td>Read next line (default)</td>
                                            </tr>
                                            <tr>
                                                <td><code>"*number"</code></td>
                                                <td>Read a number</td>
                                            </tr>
                                            <tr>
                                                <td><code>n</code></td>
                                                <td>Read n characters</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-lua">local file = io.open("data.txt", "r")
if file then
    -- Read 10 characters
    local chunk = file:read(10)
    
    -- Read a number
    local num = file:read("*number")
    
    -- Read a line
    local line = file:read("*line")
    
    file:close()
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/file-reading.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-reading" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Writing Files -->
                                    <h2>Writing Files</h2>

                                    <h3>Write to File</h3>
                                    <pre><code class="language-lua">local file = io.open("output.txt", "w")
if file then
    file:write("Hello, World!\n")
    file:write("Line 2\n")
    file:write("Line 3\n")
    file:close()
end</code></pre>

                                    <h3>Append to File</h3>
                                    <pre><code class="language-lua">local file = io.open("output.txt", "a")
if file then
    file:write("Appended line\n")
    file:close()
end</code></pre>

                                    <h3>Write Multiple Values</h3>
                                    <pre><code class="language-lua">local file = io.open("output.txt", "w")
if file then
    file:write("Name: ", "Alice", "\n")
    file:write("Age: ", tostring(25), "\n")
    file:close()
end</code></pre>

                                    <!-- Simple I/O Model -->
                                    <h2>Simple I/O Model</h2>
                                    <p>Lua also provides a simple I/O model using default files:</p>

                                    <pre><code class="language-lua">-- Set input file
io.input("data.txt")
local content = io.read("*all")
io.close()

-- Set output file
io.output("output.txt")
io.write("Hello, World!\n")
io.close()

-- Read from stdin, write to stdout
local line = io.read()
io.write("You entered: ", line, "\n")</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/file-writing.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-writing" />
                                    </jsp:include>

                                    <!-- File Operations -->
                                    <h2>Common File Operations</h2>

                                    <h3>Check if File Exists</h3>
                                    <pre><code class="language-lua">local function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

if fileExists("data.txt") then
    print("File exists")
end</code></pre>

                                    <h3>Copy File</h3>
                                    <pre><code class="language-lua">local function copyFile(source, dest)
    local input = io.open(source, "rb")
    if not input then
        return false, "Cannot open source file"
    end
    
    local output = io.open(dest, "wb")
    if not output then
        input:close()
        return false, "Cannot create destination file"
    end
    
    local content = input:read("*all")
    output:write(content)
    
    input:close()
    output:close()
    
    return true
end

copyFile("source.txt", "destination.txt")</code></pre>

                                    <h3>Read CSV File</h3>
                                    <pre><code class="language-lua">local function readCSV(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Cannot open file"
    end
    
    local rows = {}
    for line in file:lines() do
        local row = {}
        for value in line:gmatch("([^,]+)") do
            table.insert(row, value)
        end
        table.insert(rows, row)
    end
    
    file:close()
    return rows
end

local data = readCSV("data.csv")
for i, row in ipairs(data) do
    print(table.concat(row, " | "))
end</code></pre>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/file-operations.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-operations" />
                                    </jsp:include>

                                    <!-- Best Practices -->
                                    <h2>File I/O Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Best Practices:</strong>
                                        <ul>
                                            <li><strong>Always close files:</strong> Use <code>file:close()</code> when
                                                done
                                            </li>
                                            <li><strong>Check for errors:</strong> Always check if
                                                <code>io.open()</code>
                                                succeeded</li>
                                            <li><strong>Use binary mode for binary files:</strong> "rb", "wb"</li>
                                            <li><strong>Handle large files carefully:</strong> Read in chunks, not all
                                                at
                                                once</li>
                                            <li><strong>Use pcall() for file operations:</strong> Catch unexpected
                                                errors
                                            </li>
                                            <li><strong>Flush buffers when needed:</strong> <code>file:flush()</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <h3>Safe File Operations</h3>
                                    <pre><code class="language-lua">local function safeReadFile(filename)
    local success, result = pcall(function()
        local file = assert(io.open(filename, "r"))
        local content = file:read("*all")
        file:close()
        return content
    end)
    
    if success then
        return result
    else
        return nil, result
    end
end

local content, err = safeReadFile("data.txt")
if not content then
    print("Error:", err)
else
    print("Content:", content)
end</code></pre>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these file I/O challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-file-io.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Opening files with <code>io.open()</code></li>
                                            <li>Different file modes (r, w, a, r+, w+, a+)</li>
                                            <li>Reading files (entire, line by line, chunks)</li>
                                            <li>Writing and appending to files</li>
                                            <li>Simple I/O model with default files</li>
                                            <li>Common file operations (exists, copy, CSV)</li>
                                            <li>File I/O best practices</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've learned file I/O! In the final lesson, we'll explore
                                        <strong>performance optimization</strong>—how to write fast, efficient Lua code
                                        and
                                        profile your applications. Let's finish strong! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="coroutines.jsp" />
                                    <jsp:param name="prevTitle" value="Coroutines" />
                                    <jsp:param name="nextLink" value="performance.jsp" />
                                    <jsp:param name="nextTitle" value="Performance" />
                                    <jsp:param name="currentLessonId" value="file-io" />
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