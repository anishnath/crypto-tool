<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "json-http" );
        request.setAttribute("currentModule", "Packages & Standard Library" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>JSON & HTTP in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Go JSON encoding/decoding, HTTP requests, REST APIs, http package, and web services.">
            <meta name="keywords"
                content="go json, golang http, go rest api, json marshal, json unmarshal, http client, http server">

            <meta property="og:type" content="article">
            <meta property="og:title" content="JSON & HTTP in Go">
            <meta property="og:description" content="Master Go JSON and HTTP for web development.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/json-http.jsp">
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
    "name": "JSON & HTTP in Go",
    "description": "Learn Go JSON and HTTP with interactive examples.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/json-http.jsp",
    "teaches": ["json", "http", "rest api", "marshal", "unmarshal", "http client"],
    "timeRequired": "PT35M"
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="json-http">
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
                                    <span>JSON & HTTP</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">JSON & HTTP</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">JSON and HTTP are fundamental for modern web applications. Go's
                                        standard library
                                        provides excellent support for both. In this lesson, you'll learn to work with
                                        JSON data and
                                        build HTTP clients and servers.</p>

                                    <!-- Section 1: JSON Encoding -->
                                    <h2>JSON Encoding (Marshal)</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/json-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-marshal" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>JSON Struct Tags:</strong>
                                        <ul>
                                            <li><code>json:"name"</code> - Custom field name</li>
                                            <li><code>json:"name,omitempty"</code> - Omit if zero value</li>
                                            <li><code>json:"-"</code> - Skip this field</li>
                                            <li><code>json:",string"</code> - Encode as string</li>
                                        </ul>
                                    </div>

                                    <!-- Section 2: JSON Decoding -->
                                    <h2>JSON Decoding (Unmarshal)</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/json-basic.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-unmarshal" />
                                    </jsp:include>

                                    <h3>Working with Unknown JSON</h3>
                                    <pre><code class="language-go">// Use map for unknown structure
var data map[string]interface{}
err := json.Unmarshal(jsonData, &data)

// Access fields
name := data["name"].(string)
age := data["age"].(float64)  // JSON numbers are float64

// Or use json.RawMessage for partial parsing
type Response struct {
    Status string          `json:"status"`
    Data   json.RawMessage `json:"data"`  // Parse later
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: HTTP Client -->
                                    <h2>HTTP Client</h2>

                                    <h3>GET Request</h3>
                                    <pre><code class="language-go">resp, err := http.Get("https://api.example.com/users")
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()

body, err := io.ReadAll(resp.Body)
if err != nil {
    log.Fatal(err)
}

fmt.Println(string(body))</code></pre>

                                    <h3>POST Request with JSON</h3>
                                    <pre><code class="language-go">type User struct {
    Name  string `json:"name"`
    Email string `json:"email"`
}

user := User{Name: "Alice", Email: "alice@example.com"}
jsonData, _ := json.Marshal(user)

resp, err := http.Post(
    "https://api.example.com/users",
    "application/json",
    bytes.NewBuffer(jsonData),
)
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()

fmt.Println("Status:", resp.Status)</code></pre>

                                    <h3>Custom HTTP Request</h3>
                                    <pre><code class="language-go">client := &http.Client{
    Timeout: 10 * time.Second,
}

req, err := http.NewRequest("GET", "https://api.example.com/data", nil)
if err != nil {
    log.Fatal(err)
}

// Add headers
req.Header.Add("Authorization", "Bearer token123")
req.Header.Add("Content-Type", "application/json")

resp, err := client.Do(req)
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()

// Parse JSON response
var result map[string]interface{}
json.NewDecoder(resp.Body).Decode(&result)</code></pre>

                                    <!-- Section 4: HTTP Server -->
                                    <h2>HTTP Server</h2>

                                    <h3>Basic Server</h3>
                                    <pre><code class="language-go">func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World!")
}

func main() {
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}</code></pre>

                                    <h3>JSON API Server</h3>
                                    <pre><code class="language-go">type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}

var users = []User{
    {ID: 1, Name: "Alice", Email: "alice@example.com"},
    {ID: 2, Name: "Bob", Email: "bob@example.com"},
}

func getUsers(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(users)
}

func createUser(w http.ResponseWriter, r *http.Request) {
    var user User
    err := json.NewDecoder(r.Body).Decode(&user)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    user.ID = len(users) + 1
    users = append(users, user)
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(user)
}

func main() {
    http.HandleFunc("/users", func(w http.ResponseWriter, r *http.Request) {
        switch r.Method {
        case "GET":
            getUsers(w, r)
        case "POST":
            createUser(w, r)
        default:
            http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        }
    })
    
    log.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}</code></pre>

                                    <!-- Section 5: REST API Patterns -->
                                    <h2>REST API Patterns</h2>

                                    <h3>Router with Mux</h3>
                                    <pre><code class="language-go">import "github.com/gorilla/mux"

func main() {
    r := mux.NewRouter()
    
    // Routes
    r.HandleFunc("/users", getUsers).Methods("GET")
    r.HandleFunc("/users", createUser).Methods("POST")
    r.HandleFunc("/users/{id}", getUser).Methods("GET")
    r.HandleFunc("/users/{id}", updateUser).Methods("PUT")
    r.HandleFunc("/users/{id}", deleteUser).Methods("DELETE")
    
    log.Fatal(http.ListenAndServe(":8080", r))
}

func getUser(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]
    // ... find user by id
}</code></pre>

                                    <h3>Middleware</h3>
                                    <pre><code class="language-go">func loggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}

func authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        if token != "Bearer secret" {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        next.ServeHTTP(w, r)
    })
}

// Use middleware
r.Use(loggingMiddleware)
r.Use(authMiddleware)</code></pre>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Not closing response body</h4>
                                        <pre><code class="language-go">// ❌ Wrong - response body leak
resp, _ := http.Get(url)
body, _ := io.ReadAll(resp.Body)

// ✅ Correct - always close
resp, err := http.Get(url)
if err != nil {
    return err
}
defer resp.Body.Close()
body, _ := io.ReadAll(resp.Body)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Unexported struct fields</h4>
                                        <pre><code class="language-go">// ❌ Wrong - fields won't be marshaled
type User struct {
    name  string  // lowercase = unexported
    email string
}

// ✅ Correct - capitalize for export
type User struct {
    Name  string `json:"name"`
    Email string `json:"email"`
}</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Not checking HTTP status</h4>
                                        <pre><code class="language-go">// ❌ Wrong - assuming success
resp, _ := http.Get(url)
json.NewDecoder(resp.Body).Decode(&data)

// ✅ Correct - check status
resp, err := http.Get(url)
if err != nil {
    return err
}
defer resp.Body.Close()

if resp.StatusCode != http.StatusOK {
    return fmt.Errorf("bad status: %s", resp.Status)
}
json.NewDecoder(resp.Body).Decode(&data)</code></pre>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Weather API Client</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a weather API client.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Fetch weather data from a public API</li>
                                            <li>Parse JSON response into struct</li>
                                            <li>Display temperature and conditions</li>
                                            <li>Handle errors properly</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">package main

import (
    "encoding/json"
    "fmt"
    "io"
    "log"
    "net/http"
)

type WeatherResponse struct {
    Main struct {
        Temp     float64 `json:"temp"`
        Humidity int     `json:"humidity"`
    } `json:"main"`
    Weather []struct {
        Description string `json:"description"`
    } `json:"weather"`
    Name string `json:"name"`
}

func getWeather(city, apiKey string) (*WeatherResponse, error) {
    url := fmt.Sprintf(
        "https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=metric",
        city, apiKey,
    )
    
    resp, err := http.Get(url)
    if err != nil {
        return nil, fmt.Errorf("request failed: %w", err)
    }
    defer resp.Body.Close()
    
    if resp.StatusCode != http.StatusOK {
        body, _ := io.ReadAll(resp.Body)
        return nil, fmt.Errorf("API error: %s - %s", resp.Status, body)
    }
    
    var weather WeatherResponse
    err = json.NewDecoder(resp.Body).Decode(&weather)
    if err != nil {
        return nil, fmt.Errorf("decode failed: %w", err)
    }
    
    return &weather, nil
}

func main() {
    apiKey := "your-api-key"  // Get from openweathermap.org
    city := "London"
    
    weather, err := getWeather(city, apiKey)
    if err != nil {
        log.Fatal(err)
    }
    
    fmt.Printf("Weather in %s:\n", weather.Name)
    fmt.Printf("Temperature: %.1f°C\n", weather.Main.Temp)
    fmt.Printf("Humidity: %d%%\n", weather.Main.Humidity)
    if len(weather.Weather) > 0 {
        fmt.Printf("Conditions: %s\n", weather.Weather[0].Description)
    }
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>json.Marshal()</strong> converts Go → JSON</li>
                                            <li><strong>json.Unmarshal()</strong> converts JSON → Go</li>
                                            <li><strong>Struct tags</strong> control JSON field names</li>
                                            <li><strong>http.Get/Post()</strong> for simple requests</li>
                                            <li><strong>http.Client</strong> for custom requests</li>
                                            <li><strong>http.HandleFunc()</strong> creates server routes</li>
                                            <li><strong>Always close</strong> response bodies</li>
                                            <li><strong>Check HTTP status</strong> codes</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Congratulations on completing the Packages & Standard Library module! You now
                                        know how to
                                        organize code, work with files, and build web services. Next, you'll learn about
                                        <strong>Testing</strong>—how to write tests, benchmarks, and ensure code
                                        quality!
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="file-io.jsp" />
                                    <jsp:param name="prevTitle" value="File I/O" />
                                    <jsp:param name="nextLink" value="testing.jsp" />
                                    <jsp:param name="nextTitle" value="Testing" />
                                    <jsp:param name="currentLessonId" value="json-http" />
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