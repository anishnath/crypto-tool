<!DOCTYPE html>
<html>

<head>
    <title>Dockerfile Generator Online – Multi-Stage Builds & Security | 8gwifi.org</title>
    <meta name="description"
        content="Generate production-ready Dockerfiles with multi-stage builds, security best practices, and optimization. Advanced Docker container generator with popular base images (Node, Python, Go, Java, .NET, Rust).">
    <meta name="keywords"
        content="dockerfile generator, docker multi-stage builds, docker security, docker optimization, container best practices, dockerfile online, docker base images">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "@name": "Dockerfile Generator",
      "description": "Advanced online tool to generate secure, optimized Dockerfiles with multi-stage builds.",
      "url": "https://8gwifi.org/dockerfile-generator.jsp",
      "applicationCategory": "DevOpsApplication",
      "operatingSystem": "Any",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org"},
      "datePublished": "2025-01-15",
      "dateModified": "2025-01-15"
    }
    </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What are multi-stage builds in Docker?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Multi-stage builds allow you to use multiple FROM statements in a Dockerfile. Each FROM begins a new build stage. You can selectively copy artifacts from one stage to another, leaving behind everything you don't need in the final image. This drastically reduces image size and improves security by excluding build tools from production images."
          }
        },
        {
          "@type": "Question",
          "name": "Why should I run containers as non-root user?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Running containers as root poses a security risk. If an attacker compromises your application, they gain root-level access within the container. Creating a non-root user limits the blast radius of potential security vulnerabilities and follows the principle of least privilege."
          }
        },
        {
          "@type": "Question",
          "name": "How do I optimize Docker image size?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Use Alpine or slim base images, leverage multi-stage builds to exclude build dependencies, combine RUN commands to reduce layers, use .dockerignore to exclude unnecessary files, and order layers from least to most frequently changed to maximize cache effectiveness."
          }
        },
        {
          "@type": "Question",
          "name": "What is a Docker HEALTHCHECK?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "HEALTHCHECK instructs Docker how to test whether a container is still working. Docker runs the specified command periodically, and if it fails consistently, the container is marked as unhealthy. This is crucial for orchestration platforms like Kubernetes to restart failed containers automatically."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #1e40af;
                --theme-secondary: #0891b2;
                --theme-gradient: linear-gradient(135deg, #1e40af 0%, #0891b2 100%);
                --theme-light: #dbeafe;
            }

            .tool-card {
                border: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                transition: transform 0.2s;
            }

            .card-header-custom {
                background: var(--theme-gradient);
                color: white;
                font-weight: 600;
            }

            .form-section {
                background-color: var(--theme-light);
                padding: 1rem;
                border-radius: 0.5rem;
                margin-bottom: 1rem;
            }

            .form-section-title {
                color: var(--theme-primary);
                font-weight: 700;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
            }

            .form-section-title i {
                margin-right: 0.5rem;
            }

            .code-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
                font-size: 0.85rem;
                white-space: pre-wrap;
                min-height: 400px;
                max-height: 600px;
                overflow-y: auto;
                border: 1px solid #334155;
            }

            .eeat-badge {
                background: var(--theme-gradient);
                color: white;
                padding: 0.35rem 0.75rem;
                border-radius: 20px;
                font-size: 0.75rem;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .info-badge {
                background-color: var(--theme-light);
                color: var(--theme-primary);
                padding: 0.25rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: 600;
                margin-right: 0.5rem;
            }

            .sticky-preview {
                position: sticky;
                top: 80px;
            }

            .tab-content>.tab-pane {
                padding: 1rem 0;
            }

            .nav-tabs .nav-link {
                color: var(--theme-primary);
                border: none;
                border-bottom: 2px solid transparent;
            }

            .nav-tabs .nav-link.active {
                color: var(--theme-primary);
                border-bottom: 2px solid var(--theme-primary);
                background: none;
            }
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>
        <%@ include file="footer_adsense.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Dockerfile Generator</h1>
                        <div class="mt-2">
                            <span class="info-badge"><i class="fas fa-shield-alt"></i> Security First</span>
                            <span class="info-badge"><i class="fas fa-layer-group"></i> Multi-Stage Builds</span>
                            <span class="info-badge"><i class="fas fa-compress"></i> Size Optimized</span>
                        </div>
                    </div>
                    <div class="eeat-badge">
                        <i class="fas fa-user-check"></i>
                        <span>Anish Nath</span>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column: Inputs -->
                    <div class="col-lg-5">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom">
                                <i class="fas fa-sliders-h mr-2"></i> Configuration
                            </div>
                            <div class="card-body">
                                <form id="dockerfileForm">

                                    <!-- Base Image Selection -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fab fa-docker"></i> Base Image
                                        </div>
                                        <div class="form-group">
                                            <label for="imagePreset">Language/Runtime</label>
                                            <select class="form-control" id="imagePreset">
                                                <option value="node">Node.js</option>
                                                <option value="python">Python</option>
                                                <option value="go">Go</option>
                                                <option value="java">Java</option>
                                                <option value="dotnet">.NET</option>
                                                <option value="rust">Rust</option>
                                                <option value="custom">Custom</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="baseImage">Base Image</label>
                                            <select class="form-control" id="baseImage">
                                                <option value="node:20-alpine">node:20-alpine (Recommended)</option>
                                                <option value="node:20-slim">node:20-slim</option>
                                                <option value="node:20">node:20</option>
                                            </select>
                                        </div>
                                        <div class="form-group" id="customImageGroup" style="display: none;">
                                            <label for="customImage">Custom Base Image</label>
                                            <input type="text" class="form-control" id="customImage"
                                                placeholder="ubuntu:22.04">
                                        </div>
                                    </div>

                                    <!-- Quick Presets -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-magic"></i> Quick Presets
                                        </div>
                                        <div class="text-center">
                                            <button type="button" class="btn btn-sm btn-outline-primary m-1"
                                                onclick="loadPreset('node-prod')">
                                                <i class="fab fa-node-js"></i> Node.js (Production)
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-success m-1"
                                                onclick="loadPreset('python-ml')">
                                                <i class="fab fa-python"></i> Python ML
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-info m-1"
                                                onclick="loadPreset('go-minimal')">
                                                <i class="fas fa-code"></i> Go (Minimal)
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-warning m-1"
                                                onclick="loadPreset('java-spring')">
                                                <i class="fab fa-java"></i> Java Spring
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Build Configuration -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-cogs"></i> Build Configuration
                                        </div>
                                        <div class="custom-control custom-switch mb-3">
                                            <input type="checkbox" class="custom-control-input" id="multiStage" checked>
                                            <label class="custom-control-label" for="multiStage">Multi-Stage
                                                Build</label>
                                        </div>
                                        <div class="form-group">
                                            <label for="workdir">Working Directory</label>
                                            <input type="text" class="form-control" id="workdir" value="/app">
                                        </div>
                                        <div class="form-group">
                                            <label for="packageFile">Package/Dependency File</label>
                                            <input type="text" class="form-control" id="packageFile"
                                                placeholder="package.json">
                                            <small class="text-muted">For dependency caching optimization</small>
                                        </div>
                                        <div class="form-group">
                                            <label for="installCmd">Install Command</label>
                                            <input type="text" class="form-control" id="installCmd"
                                                placeholder="npm ci --only=production">
                                        </div>
                                        <div class="form-group">
                                            <label for="buildCmd">Build Command (Optional)</label>
                                            <input type="text" class="form-control" id="buildCmd"
                                                placeholder="npm run build">
                                        </div>
                                    </div>

                                    <!-- Runtime Configuration -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-play-circle"></i> Runtime
                                        </div>
                                        <div class="form-group">
                                            <label for="exposePort">Expose Port</label>
                                            <input type="number" class="form-control" id="exposePort" value="8080">
                                        </div>
                                        <div class="form-group">
                                            <label for="startCmd">Start Command</label>
                                            <input type="text" class="form-control" id="startCmd"
                                                placeholder='["node", "index.js"]'>
                                            <small class="text-muted">JSON array format</small>
                                        </div>
                                    </div>

                                    <!-- Security -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-lock"></i> Security
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="nonRootUser"
                                                checked>
                                            <label class="custom-control-label" for="nonRootUser">Run as Non-Root
                                                User</label>
                                        </div>
                                        <div class="form-group" id="userGroup">
                                            <label for="username">Username</label>
                                            <input type="text" class="form-control" id="username" value="appuser">
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="healthcheck"
                                                checked>
                                            <label class="custom-control-label" for="healthcheck">Add
                                                HEALTHCHECK</label>
                                        </div>
                                        <div class="form-group" id="healthcheckGroup">
                                            <label for="healthcheckCmd">Healthcheck Command</label>
                                            <input type="text" class="form-control" id="healthcheckCmd"
                                                placeholder='CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'>
                                        </div>
                                    </div>

                                    <!-- Optimization -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-tachometer-alt"></i> Optimization
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="dockerignore"
                                                checked>
                                            <label class="custom-control-label" for="dockerignore">Generate
                                                .dockerignore</label>
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="labels" checked>
                                            <label class="custom-control-label" for="labels">Add Metadata
                                                Labels</label>
                                        </div>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Preview -->
                    <div class="col-lg-7">
                        <div class="sticky-preview">
                            <div class="card tool-card">
                                <div
                                    class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                    <ul class="nav nav-tabs card-header-tabs mb-0" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active text-white" data-toggle="tab" href="#dockerfile"
                                                role="tab">
                                                <i class="fab fa-docker mr-1"></i>Dockerfile
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-white-50" data-toggle="tab" href="#dockerignore"
                                                role="tab">
                                                <i class="fas fa-file-alt mr-1"></i>.dockerignore
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-white-50" data-toggle="tab" href="#commands"
                                                role="tab">
                                                <i class="fas fa-terminal mr-1"></i>Commands
                                            </a>
                                        </li>
                                    </ul>
                                    <div>
                                        <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()">
                                            <i class="fas fa-share-alt"></i> Share
                                        </button>
                                        <button class="btn btn-sm btn-light text-dark" onclick="copyDockerfile()">
                                            <i class="fas fa-copy"></i> Copy
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body p-0">
                                    <div class="tab-content">
                                        <div class="tab-pane fade show active" id="dockerfile" role="tabpanel">
                                            <pre id="dockerfileOutput" class="code-preview mb-0"></pre>
                                        </div>
                                        <div class="tab-pane fade" id="dockerignore" role="tabpanel">
                                            <pre id="dockerignoreOutput" class="code-preview mb-0"></pre>
                                        </div>
                                        <div class="tab-pane fade" id="commands" role="tabpanel">
                                            <pre id="commandsOutput" class="code-preview mb-0"></pre>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Educational Content -->
                            <div class="card tool-card mt-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Docker Best Practices
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <h6>Why Multi-Stage Builds?</h6>
                                    <p>Multi-stage builds separate your build environment from your runtime environment.
                                        Build tools (compilers, dev dependencies) stay in early stages, while only the
                                        compiled artifacts move to the final stage. This reduces image size by
                                        <strong>up
                                            to 90%</strong> and improves security.
                                    </p>

                                    <h6 class="mt-4">Security Checklist</h6>
                                    <ul>
                                        <li><strong>Non-root user:</strong> Limits damage from container breakouts</li>
                                        <li><strong>Alpine/slim images:</strong> Fewer packages = smaller attack surface
                                        </li>
                                        <li><strong>.dockerignore:</strong> Prevents secrets from being copied</li>
                                        <li><strong>No hardcoded secrets:</strong> Use environment variables or secrets
                                            management</li>
                                        <li><strong>Pin versions:</strong> Use specific tags, not <code>latest</code>
                                        </li>
                                    </ul>

                                    <h6 class="mt-4">Layer Optimization</h6>
                                    <p>Order Dockerfile instructions from least to most frequently changed. Copy
                                        dependency files first, install them, then copy source code. This maximizes
                                        cache
                                        hits during rebuilds.</p>
                                </div>
                            </div>

                            <div class="mt-3 text-right">
                                <%@ include file="footer_adsense.jsp" %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Share URL Modal -->
            <div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                            <h5 class="modal-title">
                                <i class="fas fa-share-alt"></i> Share Configuration
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="input-group mb-3">
                                <input type="text" class="form-control" id="shareUrlText" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-success" id="copyShareUrl">
                                        <i class="fas fa-copy"></i> Copy
                                    </button>
                                </div>
                            </div>
                            <p class="text-muted small mb-0">
                                <i class="fas fa-info-circle"></i> Anyone with this link can view this configuration.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Base image presets
                const imagePresets = {
                    node: [
                        { value: 'node:20-alpine', label: 'node:20-alpine (Recommended)' },
                        { value: 'node:20-slim', label: 'node:20-slim' },
                        { value: 'node:20', label: 'node:20' },
                        { value: 'node:18-alpine', label: 'node:18-alpine' }
                    ],
                    python: [
                        { value: 'python:3.12-alpine', label: 'python:3.12-alpine (Recommended)' },
                        { value: 'python:3.12-slim', label: 'python:3.12-slim' },
                        { value: 'python:3.11-alpine', label: 'python:3.11-alpine' },
                        { value: 'python:3.11-slim', label: 'python:3.11-slim' }
                    ],
                    go: [
                        { value: 'golang:1.21-alpine', label: 'golang:1.21-alpine (Build)' },
                        { value: 'alpine:3.19', label: 'alpine:3.19 (Runtime)' },
                        { value: 'golang:1.21-bullseye', label: 'golang:1.21-bullseye' }
                    ],
                    java: [
                        { value: 'eclipse-temurin:21-jre-alpine', label: 'eclipse-temurin:21-jre-alpine (Recommended)' },
                        { value: 'eclipse-temurin:21-jdk-alpine', label: 'eclipse-temurin:21-jdk-alpine (Build)' },
                        { value: 'amazoncorretto:21-alpine', label: 'amazoncorretto:21-alpine' }
                    ],
                    dotnet: [
                        { value: 'mcr.microsoft.com/dotnet/sdk:8.0', label: 'dotnet/sdk:8.0 (Build)' },
                        { value: 'mcr.microsoft.com/dotnet/aspnet:8.0', label: 'dotnet/aspnet:8.0 (Runtime)' },
                        { value: 'mcr.microsoft.com/dotnet/runtime:8.0-alpine', label: 'dotnet/runtime:8.0-alpine' }
                    ],
                    rust: [
                        { value: 'rust:1.75-alpine', label: 'rust:1.75-alpine (Build)' },
                        { value: 'alpine:3.19', label: 'alpine:3.19 (Runtime)' },
                        { value: 'rust:1.75-slim', label: 'rust:1.75-slim' }
                    ],
                    custom: []
                };

                // Presets
                const presets = {
                    'node-prod': {
                        language: 'node',
                        baseImage: 'node:20-alpine',
                        workdir: '/app',
                        enableMultiStage: true,
                        buildCommand: 'npm run build',
                        nonRootUser: 'node',
                        exposePort: '3000',
                        startCommand: 'node dist/index.js',
                        enableHealthcheck: true,
                        healthcheckUrl: 'http://localhost:3000/health'
                    },
                    'python-ml': {
                        language: 'python',
                        baseImage: 'python:3.11-slim',
                        workdir: '/app',
                        enableMultiStage: false,
                        buildCommand: '',
                        nonRootUser: 'appuser',
                        exposePort: '8000',
                        startCommand: 'python main.py',
                        enableHealthcheck: true,
                        healthcheckUrl: 'http://localhost:8000/'
                    },
                    'go-minimal': {
                        language: 'go',
                        baseImage: 'golang:1.21-alpine',
                        workdir: '/app',
                        enableMultiStage: true,
                        buildCommand: 'go build -o main .',
                        nonRootUser: 'nobody',
                        exposePort: '8080',
                        startCommand: './main',
                        enableHealthcheck: true,
                        healthcheckUrl: 'http://localhost:8080/health'
                    },
                    'java-spring': {
                        language: 'java',
                        baseImage: 'maven:3.9-eclipse-temurin-21',
                        workdir: '/app',
                        enableMultiStage: true,
                        buildCommand: 'mvn clean package -DskipTests',
                        nonRootUser: 'spring',
                        exposePort: '8080',
                        startCommand: 'java -jar target/*.jar',
                        enableHealthcheck: true,
                        healthcheckUrl: 'http://localhost:8080/actuator/health'
                    }
                };

                function loadPreset(presetName) {
                    const preset = presets[presetName];
                    if (!preset) return;

                    document.getElementById('imagePreset').value = preset.language;
                    document.getElementById('imagePreset').dispatchEvent(new Event('change'));

                    setTimeout(() => {
                        // The baseImage will be set by the imagePreset change event
                        document.getElementById('workdir').value = preset.workdir;
                        document.getElementById('multiStage').checked = preset.enableMultiStage;
                        document.getElementById('buildCmd').value = preset.buildCommand;
                        document.getElementById('username').value = preset.nonRootUser;
                        document.getElementById('exposePort').value = preset.exposePort;
                        document.getElementById('startCmd').value = preset.startCommand;
                        document.getElementById('healthcheck').checked = preset.enableHealthcheck;
                        document.getElementById('healthcheckCmd').value = `CMD wget --no-verbose --tries=1 --spider ${preset.healthcheckUrl} || exit 1`;

                        generateDockerfile();
                    }, 100);
                }

                // Default commands by language
                const languageDefaults = {
                    node: {
                        packageFile: 'package.json',
                        installCmd: 'npm ci --only=production',
                        buildCmd: 'npm run build',
                        startCmd: '["node", "index.js"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'
                    },
                    python: {
                        packageFile: 'requirements.txt',
                        installCmd: 'pip install --no-cache-dir -r requirements.txt',
                        buildCmd: '',
                        startCmd: '["python", "app.py"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'
                    },
                    go: {
                        packageFile: 'go.mod',
                        installCmd: 'go mod download',
                        buildCmd: 'go build -o app .',
                        startCmd: '["./app"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'
                    },
                    java: {
                        packageFile: 'pom.xml',
                        installCmd: 'mvn clean install -DskipTests',
                        buildCmd: 'mvn package',
                        startCmd: '["java", "-jar", "target/app.jar"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1'
                    },
                    dotnet: {
                        packageFile: '*.csproj',
                        installCmd: 'dotnet restore',
                        buildCmd: 'dotnet publish -c Release -o out',
                        startCmd: '["dotnet", "app.dll"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'
                    },
                    rust: {
                        packageFile: 'Cargo.toml',
                        installCmd: 'cargo fetch',
                        buildCmd: 'cargo build --release',
                        startCmd: '["./target/release/app"]',
                        healthcheck: 'CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1'
                    }
                };

                function generateDockerfile() {
                    const imagePreset = document.getElementById('imagePreset').value;
                    const multiStage = document.getElementById('multiStage').checked;
                    const workdir = document.getElementById('workdir').value;
                    const packageFile = document.getElementById('packageFile').value;
                    const installCmd = document.getElementById('installCmd').value;
                    const buildCmd = document.getElementById('buildCmd').value;
                    const exposePort = document.getElementById('exposePort').value;
                    const startCmd = document.getElementById('startCmd').value;
                    const nonRootUser = document.getElementById('nonRootUser').checked;
                    const username = document.getElementById('username').value;
                    const healthcheck = document.getElementById('healthcheck').checked;
                    const healthcheckCmd = document.getElementById('healthcheckCmd').value;
                    const addLabels = document.getElementById('labels').checked;

                    let baseImage = document.getElementById('baseImage').value;
                    if (imagePreset === 'custom') {
                        baseImage = document.getElementById('customImage').value || 'alpine:latest';
                    }

                    let dockerfile = `# Generated by 8gwifi.org Dockerfile Generator\n`;
                    dockerfile += `# Date: ${new Date().toISOString()}\n\n`;

                    if (multiStage && buildCmd) {
                        // Multi-stage build
                        dockerfile += `# Build Stage\nFROM ${baseImage} AS builder\n\n`;
                        dockerfile += `WORKDIR ${workdir}\n\n`;

                        if (packageFile && installCmd) {
                            dockerfile += `# Copy dependency files for caching\n`;
                            dockerfile += `COPY ${packageFile} ./\n\n`;
                            dockerfile += `# Install dependencies\n`;
                            dockerfile += `RUN ${installCmd}\n\n`;
                        }

                        dockerfile += `# Copy source code\n`;
                        dockerfile += `COPY . .\n\n`;

                        if (buildCmd) {
                            dockerfile += `# Build application\n`;
                            dockerfile += `RUN ${buildCmd}\n\n`;
                        }

                        // Runtime stage
                        const runtimeImage = imagePreset === 'go' || imagePreset === 'rust' ? 'alpine:3.19' : baseImage;
                        dockerfile += `# Runtime Stage\n`;
                        dockerfile += `FROM ${runtimeImage}\n\n`;
                    } else {
                        // Single stage
                        dockerfile += `FROM ${baseImage}\n\n`;
                    }

                    dockerfile += `WORKDIR ${workdir}\n\n`;

                    if (nonRootUser) {
                        dockerfile += `# Create non-root user\n`;
                        if (baseImage.includes('alpine')) {
                            dockerfile += `RUN adduser -D ${username}\n\n`;
                        } else {
                            dockerfile += `RUN useradd -m -s /bin/bash ${username}\n\n`;
                        }
                    }

                    if (multiStage && buildCmd) {
                        dockerfile += `# Copy artifacts from builder\n`;
                        if (nonRootUser) {
                            dockerfile += `COPY --from=builder --chown=${username}:${username} ${workdir} ${workdir}\n\n`;
                        } else {
                            dockerfile += `COPY --from=builder ${workdir} ${workdir}\n\n`;
                        }
                    } else {
                        if (packageFile && installCmd) {
                            dockerfile += `# Install dependencies\n`;
                            dockerfile += `COPY ${packageFile} ./\n`;
                            dockerfile += `RUN ${installCmd}\n\n`;
                            dockerfile += `# Copy source\n`;
                            if (nonRootUser) {
                                dockerfile += `COPY --chown=${username}:${username} . .\n\n`;
                            } else {
                                dockerfile += `COPY . .\n\n`;
                            }
                        } else {
                            if (nonRootUser) {
                                dockerfile += `COPY --chown=${username}:${username} . .\n\n`;
                            } else {
                                dockerfile += `COPY . .\n\n`;
                            }
                        }
                    }

                    if (nonRootUser) {
                        dockerfile += `# Switch to non-root user\n`;
                        dockerfile += `USER ${username}\n\n`;
                    }

                    dockerfile += `# Expose port\n`;
                    dockerfile += `EXPOSE ${exposePort}\n\n`;

                    if (healthcheck && healthcheckCmd) {
                        dockerfile += `# Health check\n`;
                        dockerfile += `HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\\n`;
                        dockerfile += `  ${healthcheckCmd}\n\n`;
                    }

                    if (addLabels) {
                        dockerfile += `# Metadata labels\n`;
                        dockerfile += `LABEL maintainer="your-email@example.com"\n`;
                        dockerfile += `LABEL version="1.0.0"\n`;
                        dockerfile += `LABEL description="Generated Dockerfile"\n\n`;
                    }

                    dockerfile += `# Start command\n`;
                    dockerfile += `CMD ${startCmd}`;

                    document.getElementById('dockerfileOutput').textContent = dockerfile;
                    generateDockerignore();
                    generateCommands();
                }

                function generateDockerignore() {
                    const showDockerignore = document.getElementById('dockerignore').checked;
                    const imagePreset = document.getElementById('imagePreset').value;

                    if (!showDockerignore) {
                        document.getElementById('dockerignoreOutput').textContent = '# .dockerignore generation disabled';
                        return;
                    }

                    let ignoreContent = `# Generated by 8gwifi.org\n\n`;
                    ignoreContent += `# Git\n.git\n.gitignore\n.gitattributes\n\n`;
                    ignoreContent += `# CI/CD\n.github\n.gitlab-ci.yml\n.travis.yml\nJenkinsfile\n\n`;
                    ignoreContent += `# Documentation\nREADME.md\nDOCS\ndocs\n*.md\n\n`;
                    ignoreContent += `# Docker\nDockerfile\ndocker-compose.yml\n.dockerignore\n\n`;
                    ignoreContent += `# IDE\n.vscode\n.idea\n*.swp\n*.swo\n*~\n\n`;
                    ignoreContent += `# OS\n.DS_Store\nThumbs.db\n\n`;
                    ignoreContent += `# Logs\nlogs\n*.log\nnpm-debug.log*\nyarn-debug.log*\n\n`;
                    ignoreContent += `# Tests\n__tests__\ntest\ntests\n*.test.js\n*.spec.js\ncoverage\n\n`;

                    // Language-specific
                    if (imagePreset === 'node') {
                        ignoreContent += `# Node.js\nnode_modules\nnpm-debug.log\n.npm\n.env\n.env.local\n`;
                    } else if (imagePreset === 'python') {
                        ignoreContent += `# Python\n__pycache__\n*.pyc\n*.pyo\n*.pyd\n.Python\nvenv\nenv\n.venv\n`;
                    } else if (imagePreset === 'go') {
                        ignoreContent += `# Go\nvendor\n`;
                    } else if (imagePreset === 'java') {
                        ignoreContent += `# Java\ntarget\n*.class\n.mvn\n`;
                    } else if (imagePreset === 'dotnet') {
                        ignoreContent += `# .NET\nbin\nobj\n*.user\n`;
                    } else if (imagePreset === 'rust') {
                        ignoreContent += `# Rust\ntarget\nCargo.lock\n`;
                    }

                    document.getElementById('dockerignoreOutput').textContent = ignoreContent;
                }

                function generateCommands() {
                    const baseImage = document.getElementById('baseImage').value;
                    const exposePort = document.getElementById('exposePort').value;

                    let commands = `# Docker Build & Run Commands\n\n`;
                    commands += `# Build the image\n`;
                    commands += `docker build -t myapp:latest .\n\n`;
                    commands += `# Run the container\n`;
                    commands += `docker run -d -p ${exposePort}:${exposePort} --name myapp myapp:latest\n\n`;
                    commands += `# View logs\n`;
                    commands += `docker logs -f myapp\n\n`;
                    commands += `# Stop container\n`;
                    commands += `docker stop myapp\n\n`;
                    commands += `# Remove container\n`;
                    commands += `docker rm myapp\n\n`;
                    commands += `# Tag for registry\n`;
                    commands += `docker tag myapp:latest registry.example.com/myapp:latest\n\n`;
                    commands += `# Push to registry\n`;
                    commands += `docker push registry.example.com/myapp:latest`;

                    document.getElementById('commandsOutput').textContent = commands;
                }

                // Event Listeners
                document.getElementById('imagePreset').addEventListener('change', function () {
                    const preset = this.value;
                    const baseImageSelect = document.getElementById('baseImage');
                    const customGroup = document.getElementById('customImageGroup');

                    if (preset === 'custom') {
                        baseImageSelect.style.display = 'none';
                        customGroup.style.display = 'block';
                    } else {
                        baseImageSelect.style.display = 'block';
                        customGroup.style.display = 'none';

                        // Update base image options
                        baseImageSelect.innerHTML = '';
                        imagePresets[preset].forEach(opt => {
                            const option = document.createElement('option');
                            option.value = opt.value;
                            option.textContent = opt.label;
                            baseImageSelect.appendChild(option);
                        });

                        // Update defaults
                        const defaults = languageDefaults[preset];
                        if (defaults) {
                            document.getElementById('packageFile').value = defaults.packageFile;
                            document.getElementById('installCmd').value = defaults.installCmd;
                            document.getElementById('buildCmd').value = defaults.buildCmd;
                            document.getElementById('startCmd').value = defaults.startCmd;
                            document.getElementById('healthcheckCmd').value = defaults.healthcheck;
                        }
                    }
                    generateDockerfile();
                });

                document.getElementById('nonRootUser').addEventListener('change', function () {
                    document.getElementById('userGroup').style.display = this.checked ? 'block' : 'none';
                    generateDockerfile();
                });

                document.getElementById('healthcheck').addEventListener('change', function () {
                    document.getElementById('healthcheckGroup').style.display = this.checked ? 'block' : 'none';
                    generateDockerfile();
                });

                const inputs = document.querySelectorAll('input, select, textarea');
                inputs.forEach(input => {
                    input.addEventListener('input', generateDockerfile);
                    input.addEventListener('change', generateDockerfile);
                });

                function copyDockerfile() {
                    const activeTab = document.querySelector('.nav-link.active').getAttribute('href');
                    let text = '';

                    if (activeTab === '#dockerfile') {
                        text = document.getElementById('dockerfileOutput').textContent;
                    } else if (activeTab === '#dockerignore') {
                        text = document.getElementById('dockerignoreOutput').textContent;
                    } else {
                        text = document.getElementById('commandsOutput').textContent;
                    }

                    navigator.clipboard.writeText(text).then(() => {
                        const btn = document.querySelector('.btn-light');
                        const original = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        setTimeout(() => btn.innerHTML = original, 2000);
                    });
                }

                function shareUrl() {
                    const formData = {
                        imagePreset: document.getElementById('imagePreset').value,
                        baseImage: document.getElementById('baseImage').value,
                        customImage: document.getElementById('customImage').value,
                        multiStage: document.getElementById('multiStage').checked,
                        workdir: document.getElementById('workdir').value,
                        packageFile: document.getElementById('packageFile').value,
                        installCmd: document.getElementById('installCmd').value,
                        buildCmd: document.getElementById('buildCmd').value,
                        exposePort: document.getElementById('exposePort').value,
                        startCmd: document.getElementById('startCmd').value,
                        nonRootUser: document.getElementById('nonRootUser').checked,
                        username: document.getElementById('username').value,
                        healthcheck: document.getElementById('healthcheck').checked,
                        healthcheckCmd: document.getElementById('healthcheckCmd').value,
                        dockerignore: document.getElementById('dockerignore').checked,
                        labels: document.getElementById('labels').checked
                    };

                    try {
                        const jsonData = JSON.stringify(formData);
                        const base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
                        const urlEncoded = encodeURIComponent(base64Encoded);
                        const shareUrl = window.location.origin + window.location.pathname + '?data=' + urlEncoded;

                        document.getElementById('shareUrlText').value = shareUrl;
                        $('#shareUrlModal').modal('show');
                    } catch (e) {
                        console.error('Error generating share URL:', e);
                    }
                }

                function loadFromUrl() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const dataParam = urlParams.get('data');

                    if (dataParam) {
                        try {
                            const base64Decoded = decodeURIComponent(dataParam);
                            const jsonData = decodeURIComponent(escape(atob(base64Decoded)));
                            const formData = JSON.parse(jsonData);

                            document.getElementById('imagePreset').value = formData.imagePreset || 'node';
                            document.getElementById('imagePreset').dispatchEvent(new Event('change'));

                            setTimeout(() => {
                                if (formData.baseImage) document.getElementById('baseImage').value = formData.baseImage;
                                if (formData.customImage) document.getElementById('customImage').value = formData.customImage;
                                document.getElementById('multiStage').checked = formData.multiStage !== false;
                                document.getElementById('workdir').value = formData.workdir || '/app';
                                document.getElementById('packageFile').value = formData.packageFile || '';
                                document.getElementById('installCmd').value = formData.installCmd || '';
                                document.getElementById('buildCmd').value = formData.buildCmd || '';
                                document.getElementById('exposePort').value = formData.exposePort || '8080';
                                document.getElementById('startCmd').value = formData.startCmd || '["node", "index.js"]';
                                document.getElementById('nonRootUser').checked = formData.nonRootUser !== false;
                                document.getElementById('username').value = formData.username || 'appuser';
                                document.getElementById('healthcheck').checked = formData.healthcheck !== false;
                                document.getElementById('healthcheckCmd').value = formData.healthcheckCmd || '';
                                document.getElementById('dockerignore').checked = formData.dockerignore !== false;
                                document.getElementById('labels').checked = formData.labels !== false;

                                document.getElementById('nonRootUser').dispatchEvent(new Event('change'));
                                document.getElementById('healthcheck').dispatchEvent(new Event('change'));
                                generateDockerfile();
                            }, 100);

                        } catch (e) {
                            console.error('Error loading from URL:', e);
                        }
                    } else {
                        generateDockerfile();
                    }
                }

                document.getElementById('copyShareUrl').addEventListener('click', function () {
                    const shareUrl = document.getElementById('shareUrlText').value;
                    navigator.clipboard.writeText(shareUrl).then(() => {
                        const btn = this;
                        const originalText = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        btn.classList.remove('btn-success');
                        btn.classList.add('btn-dark');
                        setTimeout(function () {
                            btn.innerHTML = originalText;
                            btn.classList.remove('btn-dark');
                            btn.classList.add('btn-success');
                        }, 2000);
                    });
                });

                // Initialize
                loadFromUrl();
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>