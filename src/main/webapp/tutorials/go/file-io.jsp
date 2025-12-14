<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "file-io" );
        request.setAttribute("currentModule", "Packages & Standard Library" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>File I/O in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go file I/O, reading files, writing files, os package, ioutil, bufio, and file operations.">
            <meta name="keywords"
                content="go file io, golang read file, go write file, os package, bufio, file operations">

            <meta property="og:type" content="article">
            <meta property="og:title" content="File I/O in Go">
            <meta property="og:description" content="Master Go file I/O and file operations.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/file-io.jsp">
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
    "name": "File I/O in Go",
    "description": "Learn Go file I/O operations with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/file-io.jsp",
    "teaches": ["file io", "reading files", "writing files", "os package", "bufio"],
    "timeRequired": "PT30M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="file-io">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-go.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/go/">Go</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>File I/O</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">File I/O</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">File I/O is essential for reading configuration, processing data,
                                        and saving
                                        results. Go provides powerful packages for file operations. In this lesson,
                                        you'll master
                                        reading, writing, and managing files.</p>

                                    <!-- Section 1: Reading Files -->
                                    <h2>Reading Files</h2>

                                    <h3>1. Read Entire File</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/file-io-read.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-read-all" />
                                    </jsp:include>

                                    <h3>2. Read Line by Line</h3>
                                    <pre><code class="language-go">func readLines(filename string) ([]string, error) {
    file, err := os.Open(filename)
    if err != nil {
        return nil, err
    }
    defer file.Close()
    
    var lines []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }
    
    return lines, scanner.Err()
}</code></pre>

                                    <h3>3. Read with Buffer</h3>
                                    <pre><code class="language-go">func readWithBuffer(filename string) error {
    file, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer file.Close()
    
    reader := bufio.NewReader(file)
    buffer := make([]byte, 1024)
    
    for {
        n, err := reader.Read(buffer)
        if err == io.EOF {
            break
        }
        if err != nil {
            return err
        }
        fmt.Print(string(buffer[:n]))
    }
    return nil
}</code></pre>

                                    <!-- Section 2: Writing Files -->
                                    <h2>Writing Files</h2>

                                    <h3>1. Write Entire File</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/file-io-write.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-write" />
                                    </jsp:include>

                                    <h3>2. Append to File</h3>
                                    <pre><code class="language-go">func appendToFile(filename, text string) error {
    file, err := os.OpenFile(filename, 
        os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
    if err != nil {
        return err
    }
    defer file.Close()
    
    _, err = file.WriteString(text + "\n")
    return err
}</code></pre>

                                    <h3>3. Buffered Writing</h3>
                                    <pre><code class="language-go">func writeWithBuffer(filename string, lines []string) error {
    file, err := os.Create(filename)
    if err != nil {
        return err
    }
    defer file.Close()
    
    writer := bufio.NewWriter(file)
    for _, line := range lines {
        _, err := writer.WriteString(line + "\n")
        if err != nil {
            return err
        }
    }
    return writer.Flush()  // Important!
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: File Operations -->
                                    <h2>File Operations</h2>

                                    <h3>Check if File Exists</h3>
                                    <pre><code class="language-go">func fileExists(filename string) bool {
    _, err := os.Stat(filename)
    return !os.IsNotExist(err)
}

// Or more detailed
func checkFile(filename string) {
    info, err := os.Stat(filename)
    if os.IsNotExist(err) {
        fmt.Println("File does not exist")
        return
    }
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Println("Name:", info.Name())
    fmt.Println("Size:", info.Size(), "bytes")
    fmt.Println("Mode:", info.Mode())
    fmt.Println("Modified:", info.ModTime())
    fmt.Println("IsDir:", info.IsDir())
}</code></pre>

                                    <h3>Copy, Move, Delete</h3>
                                    <pre><code class="language-go">// Copy file
func copyFile(src, dst string) error {
    data, err := os.ReadFile(src)
    if err != nil {
        return err
    }
    return os.WriteFile(dst, data, 0644)
}

// Move/Rename file
func moveFile(oldPath, newPath string) error {
    return os.Rename(oldPath, newPath)
}

// Delete file
func deleteFile(filename string) error {
    return os.Remove(filename)
}</code></pre>

                                    <!-- Section 4: Directory Operations -->
                                    <h2>Working with Directories</h2>

                                    <pre><code class="language-go">// Create directory
os.Mkdir("mydir", 0755)
os.MkdirAll("path/to/mydir", 0755)  // Create all parent dirs

// List directory
entries, err := os.ReadDir(".")
if err != nil {
    log.Fatal(err)
}

for _, entry := range entries {
    fmt.Println(entry.Name(), entry.IsDir())
}

// Walk directory tree
filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
    if err != nil {
        return err
    }
    fmt.Println(path, info.Size())
    return nil
})

// Remove directory
os.Remove("mydir")        // Empty dir only
os.RemoveAll("mydir")     // Recursive</code></pre>

                                    <!-- Section 5: File Permissions -->
                                    <h2>File Permissions</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Mode</th>
                                                <th>Octal</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>0644</td>
                                                <td>rw-r--r--</td>
                                                <td>Owner: read/write, Others: read</td>
                                            </tr>
                                            <tr>
                                                <td>0755</td>
                                                <td>rwxr-xr-x</td>
                                                <td>Owner: all, Others: read/execute</td>
                                            </tr>
                                            <tr>
                                                <td>0600</td>
                                                <td>rw-------</td>
                                                <td>Owner: read/write only</td>
                                            </tr>
                                            <tr>
                                                <td>0777</td>
                                                <td>rwxrwxrwx</td>
                                                <td>Everyone: all permissions</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting to close files</h4>
                                        <pre><code class="language-go">// ❌ Wrong - file not closed
file, _ := os.Open("file.txt")
// ... use file ...

// ✅ Correct - use defer
file, err := os.Open("file.txt")
if err != nil {
    return err
}
defer file.Close()  // Always close!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not checking errors</h4>
                                        <pre><code class="language-go">// ❌ Wrong - ignoring errors
data, _ := os.ReadFile("config.json")

// ✅ Correct - handle errors
data, err := os.ReadFile("config.json")
if err != nil {
    log.Fatal(err)
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not flushing buffers</h4>
                                        <pre><code class="language-go">// ❌ Wrong - data might not be written
writer := bufio.NewWriter(file)
writer.WriteString("data")
// Missing flush!

// ✅ Correct - flush before closing
writer := bufio.NewWriter(file)
writer.WriteString("data")
writer.Flush()  // Ensure data is written</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Log File Manager</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a log file manager.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Create a function to append log entries with timestamps</li>
                                            <li>Read and display all log entries</li>
                                            <li>Clear old logs (delete file)</li>
                                            <li>Handle errors properly</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "bufio"
    "fmt"
    "os"
    "time"
)

const logFile = "app.log"

func appendLog(message string) error {
    file, err := os.OpenFile(logFile, 
        os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
    if err != nil {
        return err
    }
    defer file.Close()
    
    timestamp := time.Now().Format("2006-01-02 15:04:05")
    logEntry := fmt.Sprintf("[%s] %s\n", timestamp, message)
    
    _, err = file.WriteString(logEntry)
    return err
}

func readLogs() error {
    file, err := os.Open(logFile)
    if err != nil {
        if os.IsNotExist(err) {
            fmt.Println("No logs found")
            return nil
        }
        return err
    }
    defer file.Close()
    
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        fmt.Println(scanner.Text())
    }
    
    return scanner.Err()
}

func clearLogs() error {
    return os.Remove(logFile)
}

func main() {
    // Write logs
    appendLog("Application started")
    appendLog("Processing data")
    appendLog("Task completed")
    
    // Read logs
    fmt.Println("=== Log Entries ===")
    if err := readLogs(); err != nil {
        fmt.Println("Error reading logs:", err)
    }
    
    // Clear logs
    fmt.Println("\nClearing logs...")
    if err := clearLogs(); err != nil {
        fmt.Println("Error clearing logs:", err)
    } else {
        fmt.Println("Logs cleared successfully")
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>os.ReadFile()</strong> reads entire file</li>
                                            <li><strong>os.WriteFile()</strong> writes entire file</li>
                                            <li><strong>bufio</strong> for buffered I/O (efficient)</li>
                                            <li><strong>defer file.Close()</strong> always close files</li>
                                            <li><strong>os.Stat()</strong> gets file info</li>
                                            <li><strong>filepath.Walk()</strong> traverses directories</li>
                                            <li><strong>Always check errors</strong> for file operations</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can work with files, you're ready to learn about <strong>JSON &
                                            HTTP</strong>.
                                        You'll discover how to work with JSON data and make HTTP requests—essential for
                                        modern
                                        applications!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="packages-modules.jsp" />
                                    <jsp:param name="prevTitle" value="Packages & Modules" />
                                    <jsp:param name="nextLink" value="json-http.jsp" />
                                    <jsp:param name="nextTitle" value="JSON & HTTP" />
                                    <jsp:param name="currentLessonId" value="file-io" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/go.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>