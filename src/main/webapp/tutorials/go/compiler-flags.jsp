<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "compiler-flags" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Compiler & Linker Flags in Go - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Go compiler and linker flags: optimize builds, control compilation, cross-compile, and fine-tune performance with gcflags and ldflags.">
            <meta name="keywords"
                content="go compiler flags, golang build optimization, gcflags, ldflags, cross compilation, build tags">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Compiler & Linker Flags in Go">
            <meta property="og:description" content="Learn to optimize Go builds with compiler and linker flags.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/compiler-flags.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror-modes/go.min.js">

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
    "name": "Compiler & Linker Flags in Go",
    "description": "Learn to optimize Go builds with compiler and linker flags for performance and size.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Advanced",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/compiler-flags.jsp",
    "teaches": ["Compiler Flags", "Build Optimization", "Cross-Compilation", "Build Tags"],
    "timeRequired": "PT35M"
}
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="compiler-flags">
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
                                    <span>Compiler & Linker Flags</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Compiler & Linker Flags</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Go's compiler and linker provide powerful flags to control build
                                        behavior,
                                        optimize performance, reduce binary size, and enable cross-compilation. Master
                                        these tools to
                                        create production-ready binaries tailored to your needs.</p>

                                    <!-- Section 1: Compiler Flags Overview -->
                                    <h2>Compiler Flags Overview</h2>
                                    <p>The Go compiler accepts flags through <code>-gcflags</code> to control
                                        compilation behavior:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/compiler-flags-demo.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-flags-demo" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Flag</th>
                                                <th>Purpose</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>-m</td>
                                                <td>Print optimization decisions</td>
                                                <td>Escape analysis, inlining</td>
                                            </tr>
                                            <tr>
                                                <td>-N</td>
                                                <td>Disable optimizations</td>
                                                <td>Debugging</td>
                                            </tr>
                                            <tr>
                                                <td>-l</td>
                                                <td>Disable inlining</td>
                                                <td>Debugging, profiling</td>
                                            </tr>
                                            <tr>
                                                <td>-S</td>
                                                <td>Print assembly listing</td>
                                                <td>Performance analysis</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 2: Build Tags -->
                                    <h2>Build Tags</h2>
                                    <p>Build tags enable conditional compilation for different platforms and features:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/build-tags.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-build-tags" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Build Tag Syntax:</strong>
                                        <pre><code class="language-go">// Old syntax (before Go 1.17)
// +build linux darwin
// +build amd64

// New syntax (Go 1.17+)
//go:build (linux || darwin) && amd64</code></pre>
                                    </div>

                                    <!-- Section 3: Optimization -->
                                    <h2>Optimization Levels</h2>
                                    <p>Control optimization and inlining for performance or debugging:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/optimization-levels.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-optimization" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Optimization Guidelines:</strong>
                                        <ul>
                                            <li>Default build: Full optimizations enabled</li>
                                            <li>Debug build: <code>-gcflags="-N -l"</code></li>
                                            <li>Size optimization: <code>-ldflags="-s -w"</code></li>
                                            <li>Profile before optimizing manually</li>
                                        </ul>
                                    </div>

                                    <!-- Section 4: Cross-Compilation -->
                                    <h2>Cross-Compilation</h2>
                                    <p>Build for different operating systems and architectures:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="go/cross-compile.go" />
                                        <jsp:param name="language" value="go" />
                                        <jsp:param name="editorId" value="compiler-cross-compile" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Quick Cross-Compile Examples:</strong>
                                        <pre><code class="language-bash"># Linux
GOOS=linux GOARCH=amd64 go build

# macOS (Intel)
GOOS=darwin GOARCH=amd64 go build

# macOS (Apple Silicon)
GOOS=darwin GOARCH=arm64 go build

# Windows
GOOS=windows GOARCH=amd64 go build

# List all platforms
go tool dist list</code></pre>
                                    </div>

                                    <!-- Linker Flags -->
                                    <h2>Linker Flags</h2>
                                    <p>Use <code>-ldflags</code> to control the linker:</p>

                                    <div class="info-box">
                                        <strong>Common Linker Flags:</strong>
                                        <pre><code class="language-bash"># Strip debug symbols
go build -ldflags="-s -w"

# Set version information
go build -ldflags="-X main.Version=1.0.0"

# Multiple flags
go build -ldflags="-s -w -X main.Version=1.0.0 -X main.BuildTime=$(date)"

# External linker flags
go build -ldflags="-extldflags '-static'"</code></pre>
                                    </div>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Flag</th>
                                                <th>Purpose</th>
                                                <th>Effect</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>-s</td>
                                                <td>Strip symbol table</td>
                                                <td>Smaller binary, no symbols</td>
                                            </tr>
                                            <tr>
                                                <td>-w</td>
                                                <td>Strip DWARF debug info</td>
                                                <td>Smaller binary, no debug</td>
                                            </tr>
                                            <tr>
                                                <td>-X</td>
                                                <td>Set string variable</td>
                                                <td>Inject build info</td>
                                            </tr>
                                            <tr>
                                                <td>-extldflags</td>
                                                <td>External linker flags</td>
                                                <td>Static linking, etc.</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Build Modes -->
                                    <h2>Build Modes</h2>
                                    <p>Different build modes for different use cases:</p>

                                    <div class="info-box">
                                        <strong>Build Mode Examples:</strong>
                                        <pre><code class="language-bash"># Default executable
go build

# Shared library
go build -buildmode=c-shared -o lib.so

# Static library
go build -buildmode=c-archive -o lib.a

# Plugin
go build -buildmode=plugin -o plugin.so

# Position Independent Executable
go build -buildmode=pie</code></pre>
                                    </div>

                                    <!-- Common Patterns -->
                                    <h2>Common Build Patterns</h2>

                                    <div class="best-practice-box">
                                        <h4>Development Build</h4>
                                        <pre><code class="language-bash">go build -gcflags="-N -l"</code></pre>
                                        <p>Disables optimizations for easier debugging.</p>
                                    </div>

                                    <div class="best-practice-box">
                                        <h4>Production Build</h4>
                                        <pre><code class="language-bash">go build -ldflags="-s -w" -trimpath</code></pre>
                                        <p>Minimal binary size, no debug info, no file paths.</p>
                                    </div>

                                    <div class="best-practice-box">
                                        <h4>Versioned Build</h4>
                                        <pre><code class="language-bash">go build -ldflags="-X main.Version=$(git describe --tags) -X main.BuildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)"</code></pre>
                                        <p>Embeds version and build time.</p>
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Multi-Platform Build Script</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a build script that compiles for multiple
                                            platforms with version info.</p>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-bash">#!/bin/bash

# Build script for multi-platform releases

VERSION=$(git describe --tags --always --dirty)
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LDFLAGS="-s -w -X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

platforms=(
    "linux/amd64"
    "linux/arm64"
    "darwin/amd64"
    "darwin/arm64"
    "windows/amd64"
)

for platform in "${platforms[@]}"; do
    GOOS=${platform%/*}
    GOARCH=${platform#*/}
    output="myapp-${GOOS}-${GOARCH}"
    
    if [ "$GOOS" = "windows" ]; then
        output="${output}.exe"
    fi
    
    echo "Building for $GOOS/$GOARCH..."
    
    CGO_ENABLED=0 GOOS=$GOOS GOARCH=$GOARCH \
        go build -ldflags="$LDFLAGS" -trimpath -o "dist/$output"
    
    if [ $? -eq 0 ]; then
        echo "✓ Built dist/$output"
    else
        echo "✗ Failed to build for $GOOS/$GOARCH"
        exit 1
    fi
done

echo ""
echo "Build complete!"
echo "Version: $VERSION"
echo "Build Time: $BUILD_TIME"
ls -lh dist/</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>-gcflags</strong> controls compiler behavior</li>
                                            <li><strong>-ldflags</strong> controls linker behavior</li>
                                            <li><strong>Build tags</strong> enable conditional compilation</li>
                                            <li><strong>Cross-compilation</strong> via GOOS/GOARCH</li>
                                            <li><strong>-N -l</strong> for debug builds</li>
                                            <li><strong>-s -w</strong> for minimal binaries</li>
                                            <li><strong>-X</strong> injects build-time values</li>
                                            <li><strong>-trimpath</strong> removes file paths</li>
                                            <li><strong>Build modes</strong> for libraries and plugins</li>
                                            <li><strong>Profile first</strong>, optimize second</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>You've mastered compiler and linker flags! You can now optimize builds,
                                        cross-compile, and
                                        control every aspect of the build process. Next, explore <strong>plugins and
                                            dynamic
                                            loading</strong> to create extensible Go applications with hot-reloadable
                                        components!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="unsafe-package.jsp" />
                                    <jsp:param name="prevTitle" value="Unsafe Package" />
                                    <jsp:param name="nextLink" value="plugins-loading.jsp" />
                                    <jsp:param name="nextTitle" value="Plugins & Dynamic Loading" />
                                    <jsp:param name="currentLessonId" value="compiler-flags" />
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