<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "plugins-loading" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Plugins & Dynamic Loading in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go plugins: build extensible applications, load plugins dynamically, implement hot reload, and create modular architectures with the plugin package.">
            <meta name="keywords"
                content="go plugins, golang plugin system, dynamic loading, hot reload, extensible applications, modular go">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Plugins & Dynamic Loading in Go">
            <meta property="og:description"
                content="Learn to build extensible Go applications with plugins and dynamic loading.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/plugins-loading.jsp">
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
    "name": "Plugins & Dynamic Loading in Go",
    "description": "Learn to build extensible Go applications using the plugin system for dynamic loading and hot reload.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/plugins-loading.jsp",
    "teaches": ["Plugins", "Dynamic Loading", "Hot Reload", "Extensibility"],
    "timeRequired": "PT40M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="plugins-loading">
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
                                    <span>Plugins & Dynamic Loading</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Plugins & Dynamic Loading</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~40 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Go's plugin package enables building extensible applications that
                                        can load code
                                        dynamically at runtime. Create modular architectures, support third-party
                                        extensions, and
                                        implement hot-reload functionality for development and production environments.
                                    </p>

                                    <div class="warning-box">
                                        <strong>Platform Support:</strong>
                                        <ul>
                                            <li>✓ Linux (full support)</li>
                                            <li>✓ macOS (full support)</li>
                                            <li>❌ Windows (not supported)</li>
                                            <li>⚠️ Requires same Go version for plugin and main app</li>
                                        </ul>
                                    </div>

                                    <!-- Section 1: Plugin Interface -->
                                    <h2>Plugin Interface Design</h2>
                                    <p>Define clear interfaces that plugins must implement:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/plugin-interface.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-plugin-interface" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Interface Design Tips:</strong>
                                        <ul>
                                            <li>Keep interfaces focused and minimal</li>
                                            <li>Include metadata (name, version, author)</li>
                                            <li>Provide lifecycle methods (Initialize, Shutdown)</li>
                                            <li>Version your plugin API</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Plugin Implementation -->
                                    <h2>Plugin Implementation</h2>
                                    <p>Implement the plugin interface in separate packages:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/plugin-impl.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-plugin-impl" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Building Plugins:</strong>
                                        <pre><code class="language-bash"># Build a plugin
go build -buildmode=plugin -o greeter.so plugin.go

# The .so file can be loaded at runtime
# Must be built with same Go version as main app</code></pre>
                                    </div>

                                    <!-- Section 3: Loading Plugins -->
                                    <h2>Loading Plugins</h2>
                                    <p>Use the plugin package to load and use plugins:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/plugin-loader.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-plugin-loader" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Plugin Loading Steps:</strong>
                                        <ol>
                                            <li>Open plugin file with <code>plugin.Open()</code></li>
                                            <li>Lookup exported symbol with <code>Lookup()</code></li>
                                            <li>Type assert to plugin interface</li>
                                            <li>Initialize and use the plugin</li>
                                        </ol>
                                    </div>

                                    <!-- Section 4: Plugin Manager -->
                                    <h2>Plugin Manager</h2>
                                    <p>Manage multiple plugins with a plugin manager:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/plugin-main.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-plugin-main" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Plugin Manager Features:</strong>
                                        <ul>
                                            <li>Load plugins from directory</li>
                                            <li>Track loaded plugins</li>
                                            <li>Handle load failures gracefully</li>
                                            <li>Provide plugin discovery</li>
                                            <li>Manage plugin lifecycle</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: Hot Reload -->
                                    <h2>Hot Reload</h2>
                                    <p>Implement hot-reload for development and dynamic updates:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/plugin-hotreload.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-plugin-hotreload" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Hot Reload Limitations:</strong>
                                        <ul>
                                            <li>Cannot unload plugins from memory</li>
                                            <li>Old plugin code remains in memory</li>
                                            <li>Must manage state transitions carefully</li>
                                            <li>Handle in-flight requests appropriately</li>
                                        </ul>
                                    </div>

                                    <!-- Use Cases -->
                                    <h2>Plugin Use Cases</h2>

                                    <div class="info-box">
                                        <h4>1. Extensible Applications</h4>
                                        <p>Allow third-party developers to extend your application:</p>
                                        <ul>
                                            <li>Text editors with language support plugins</li>
                                            <li>Build systems with custom task plugins</li>
                                            <li>API gateways with custom middleware</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>2. Feature Flags</h4>
                                        <p>Enable/disable features without recompiling:</p>
                                        <ul>
                                            <li>A/B testing different implementations</li>
                                            <li>Gradual feature rollout</li>
                                            <li>Customer-specific features</li>
                                        </ul>
                                    </div>

                                    <div class="info-box">
                                        <h4>3. Development Workflow</h4>
                                        <p>Improve development experience:</p>
                                        <ul>
                                            <li>Hot-reload during development</li>
                                            <li>Test different implementations</li>
                                            <li>Rapid prototyping</li>
                                        </ul>
                                    </div>

                                    <!-- Best Practices -->
                                    <h2>Best Practices</h2>

                                    <div class="best-practice-box">
                                        <strong>Plugin Design:</strong>
                                        <ul>
                                            <li>✓ Define clear, stable interfaces</li>
                                            <li>✓ Version your plugin API</li>
                                            <li>✓ Provide comprehensive documentation</li>
                                            <li>✓ Include example plugins</li>
                                            <li>✓ Handle errors gracefully</li>
                                        </ul>
                                    </div>

                                    <div class="best-practice-box">
                                        <strong>Plugin Loading:</strong>
                                        <ul>
                                            <li>✓ Validate plugin compatibility</li>
                                            <li>✓ Handle load failures</li>
                                            <li>✓ Provide fallback behavior</li>
                                            <li>✓ Log plugin operations</li>
                                            <li>✓ Implement timeouts</li>
                                        </ul>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Plugin-Based Calculator</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Build a calculator that loads operation plugins
                                            dynamically.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define Operation interface</li>
                                            <li>Implement plugins for +, -, *, /</li>
                                            <li>Load plugins from directory</li>
                                            <li>Execute operations dynamically</li>
                                        </ul>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-go">// operation.go - Interface
package main

type Operation interface {
    Name() string
    Execute(a, b float64) (float64, error)
}

// add_plugin.go - Addition plugin
package main

type AddOperation struct{}

func (op *AddOperation) Name() string {
    return "add"
}

func (op *AddOperation) Execute(a, b float64) (float64, error) {
    return a + b, nil
}

var Operation Operation = &AddOperation{}

// Build: go build -buildmode=plugin -o add.so add_plugin.go

// main.go - Calculator
package main

import (
    "fmt"
    "log"
    "plugin"
)

func main() {
    // Load plugin
    p, err := plugin.Open("add.so")
    if err != nil {
        log.Fatal(err)
    }
    
    // Lookup symbol
    symbol, err := p.Lookup("Operation")
    if err != nil {
        log.Fatal(err)
    }
    
    // Type assert
    op, ok := symbol.(Operation)
    if !ok {
        log.Fatal("Invalid operation type")
    }
    
    // Execute
    result, err := op.Execute(10, 5)
    if err != nil {
        log.Fatal(err)
    }
    
    fmt.Printf("%s(10, 5) = %.2f\n", op.Name(), result)
}</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Plugins</strong> enable extensible applications</li>
                                            <li><strong>plugin.Open()</strong> loads plugin files</li>
                                            <li><strong>Lookup()</strong> finds exported symbols</li>
                                            <li><strong>Type assertion</strong> converts to interface</li>
                                            <li><strong>Build mode</strong> -buildmode=plugin</li>
                                            <li><strong>Linux/macOS only</strong> (not Windows)</li>
                                            <li><strong>Same Go version</strong> required</li>
                                            <li><strong>Cannot unload</strong> plugins</li>
                                            <li><strong>Hot reload</strong> possible with care</li>
                                            <li><strong>Use cases</strong> - extensions, features, development</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>Congratulations!</h2>
                                    <p>You've completed all advanced Go topics! You now have a comprehensive
                                        understanding of
                                        memory management, escape analysis, CGO integration, unsafe operations, compiler
                                        optimization, and plugin systems. You're ready to build high-performance,
                                        extensible Go
                                        applications for production use!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="compiler-flags.jsp" />
                                    <jsp:param name="prevTitle" value="Compiler & Linker Flags" />
                                    <jsp:param name="nextLink" value="../" />
                                    <jsp:param name="nextTitle" value="All Tutorials" />
                                    <jsp:param name="currentLessonId" value="plugins-loading" />
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