<!DOCTYPE html>
<html>

<head>
    <title>Nginx Config Generator Online – Advanced & Free | 8gwifi.org</title>
    <meta name="description"
        content="Generate production-ready Nginx configurations online. Advanced features: Reverse Proxy, Load Balancing, Security Headers (HSTS, CSP), SPA routing, and Performance tuning. Free DevOps tool.">
    <meta name="keywords"
        content="nginx config generator, nginx online tool, nginx reverse proxy, nginx load balancing, nginx security headers, nginx hsts config, devops tools">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Nginx Config Generator",
      "description": "Advanced online tool to generate secure, high-performance Nginx server blocks.",
      "url": "https://8gwifi.org/nginx-config-generator.jsp",
      "applicationCategory": "DevOpsApplication",
      "operatingSystem": "Any",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org"},
      "datePublished": "2024-01-15",
      "dateModified": "2025-11-29"
    }
    </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "How do I enable HTTPS with this config?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The generator creates a standard SSL block compatible with Let's Encrypt. You simply need to point the 'ssl_certificate' and 'ssl_certificate_key' directives to your actual file paths after running Certbot."
          }
        },
        {
          "@type": "Question",
          "name": "What are the recommended Security Headers?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "We recommend enabling HSTS (Strict-Transport-Security), X-Frame-Options (DENY or SAMEORIGIN), and X-Content-Type-Options (nosniff) to protect against common attacks like Clickjacking and MIME sniffing."
          }
        },
        {
          "@type": "Question",
          "name": "Can I use this for React or Vue apps?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes! Enable 'SPA Mode' in the Routing section. This adds a 'try_files $uri $uri/ /index.html;' directive, which is required for client-side routing to work correctly."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #4f46e5;
                --theme-secondary: #7c3aed;
                --theme-gradient: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
                --theme-light: #f5f3ff;
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

            .config-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
                font-size: 0.85rem;
                white-space: pre-wrap;
                min-height: 500px;
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
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>
        <%@ include file="footer_adsense.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Nginx Config Generator</h1>
                        <div class="mt-2">
                            <span class="info-badge"><i class="fas fa-shield-alt"></i> Secure Defaults</span>
                            <span class="info-badge"><i class="fas fa-bolt"></i> High Performance</span>
                            <span class="info-badge"><i class="fas fa-server"></i> Load Balancing</span>
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
                                <form id="nginxForm">

                                    <!-- Basic Settings -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-globe"></i> Basic Settings
                                        </div>
                                        <div class="form-group">
                                            <label for="serverName">Domain / Server Name</label>
                                            <input type="text" class="form-control" id="serverName"
                                                placeholder="example.com" value="example.com">
                                        </div>
                                        <div class="form-group">
                                            <label for="listenPort">Listen Port</label>
                                            <input type="number" class="form-control" id="listenPort" value="80">
                                        </div>
                                        <div class="form-group">
                                            <label for="rootDirectory">Root Directory</label>
                                            <input type="text" class="form-control" id="rootDirectory"
                                                value="/var/www/html">
                                        </div>
                                    </div>

                                    <!-- Routing & Proxy -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-route"></i> Routing & Proxy
                                        </div>

                                        <div class="custom-control custom-switch mb-3">
                                            <input type="checkbox" class="custom-control-input" id="enableProxy">
                                            <label class="custom-control-label" for="enableProxy">Reverse Proxy / Load
                                                Balancer</label>
                                        </div>

                                        <div class="collapse" id="proxySettings">
                                            <div class="form-group">
                                                <label>Upstream Servers (one per line)</label>
                                                <textarea class="form-control" id="upstreamServers" rows="3"
                                                    placeholder="localhost:3000&#10;10.0.0.1:8080 weight=2">localhost:3000</textarea>
                                                <small class="text-muted">Supports <code>weight=N</code>,
                                                    <code>max_fails=N</code></small>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="proxyWebsockets"
                                                    checked>
                                                <label class="custom-control-label" for="proxyWebsockets">Support
                                                    WebSockets</label>
                                            </div>
                                        </div>

                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="enableSpa">
                                            <label class="custom-control-label" for="enableSpa">SPA Mode
                                                (React/Vue/Angular)</label>
                                        </div>
                                    </div>

                                    <!-- Security -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-lock"></i> Security & HTTPS
                                        </div>

                                        <div class="custom-control custom-switch mb-3">
                                            <input type="checkbox" class="custom-control-input" id="enableHttps">
                                            <label class="custom-control-label" for="enableHttps">Enable HTTPS
                                                (SSL)</label>
                                        </div>

                                        <div class="custom-control custom-switch mb-3">
                                            <input type="checkbox" class="custom-control-input" id="forceHttps"
                                                disabled>
                                            <label class="custom-control-label" for="forceHttps">Force HTTP to HTTPS
                                                Redirect</label>
                                        </div>

                                        <h6 class="small font-weight-bold mt-3">Security Headers</h6>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="headerHsts">
                                            <label class="custom-control-label" for="headerHsts">HSTS
                                                (Strict-Transport-Security)</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="headerXfo" checked>
                                            <label class="custom-control-label" for="headerXfo">X-Frame-Options
                                                (DENY)</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="headerXss" checked>
                                            <label class="custom-control-label" for="headerXss">X-XSS-Protection</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="headerCsp">
                                            <label class="custom-control-label" for="headerCsp">Content-Security-Policy
                                                (Basic)</label>
                                        </div>
                                    </div>

                                    <!-- Performance -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-tachometer-alt"></i> Performance
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="enableGzip" checked>
                                            <label class="custom-control-label" for="enableGzip">Gzip
                                                Compression</label>
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="enableCache">
                                            <label class="custom-control-label" for="enableCache">Browser Caching
                                                (Static
                                                Files)</label>
                                        </div>
                                        <div class="form-row mt-2">
                                            <div class="col">
                                                <label class="small">Client Max Body Size</label>
                                                <input type="text" class="form-control form-control-sm" id="clientBody"
                                                    value="10M">
                                            </div>
                                            <div class="col">
                                                <label class="small">Keepalive Timeout</label>
                                                <input type="text" class="form-control form-control-sm" id="keepalive"
                                                    value="65">
                                            </div>
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
                                    <span class="mb-0"><i class="fas fa-code mr-2"></i>nginx.conf</span>
                                    <div>
                                        <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()">
                                            <i class="fas fa-share-alt"></i> Share
                                        </button>
                                        <button class="btn btn-sm btn-light text-dark" onclick="copyConfig()">
                                            <i class="fas fa-copy"></i> Copy
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body p-0">
                                    <div id="configOutput" class="config-preview"></div>
                                </div>
                            </div>

                            <!-- Configuration Presets -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-magic"></i> Quick Presets
                                </div>
                                <div class="text-center">
                                    <button type="button" class="btn btn-sm btn-outline-primary m-1"
                                        onclick="loadPreset('static')">
                                        <i class="fas fa-file-code"></i> Static Website
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success m-1"
                                        onclick="loadPreset('nodejs')">
                                        <i class="fab fa-node-js"></i> Node.js/React
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-info m-1"
                                        onclick="loadPreset('wordpress')">
                                        <i class="fab fa-wordpress"></i> WordPress
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-warning m-1"
                                        onclick="loadPreset('loadbalancer')">
                                        <i class="fas fa-balance-scale"></i> Load Balancer
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger m-1"
                                        onclick="loadPreset('api')">
                                        <i class="fas fa-code"></i> API Gateway
                                    </button>
                                </div>
                            </div>

                            <!-- Educational Content -->
                            <div class="card tool-card mt-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Understanding Nginx</h5>
                                </div>
                                <div class="card-body">
                                    <h6>Key Concepts</h6>
                                    <ul>
                                        <li><strong>Server Block:</strong> Defines a virtual server (like Apache's
                                            VirtualHost).</li>
                                        <li><strong>Reverse Proxy:</strong> Nginx accepts requests and forwards them to
                                            backend servers (Node.js, Python, Go).</li>
                                        <li><strong>Upstream:</strong> A group of backend servers used for load
                                            balancing.
                                        </li>
                                    </ul>

                                    <h6 class="mt-4">Common CLI Commands</h6>
                                    <pre class="bg-dark text-light p-2 rounded small"><code># Test configuration syntax
sudo nginx -t

# Reload configuration without downtime
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx</code></pre>
                                </div>
                            </div>

                            <div class="mt-3 text-right">
                                <%@ include file="footer_adsense.jsp" %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Related Tools -->
                <div class="row mb-5">
                    <div class="col-12">
                        <div class="card tool-card">
                            <div class="card-header bg-light">
                                <h6 class="mb-0"><i class="fas fa-tools mr-2"></i>Related DevOps Tools</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <a href="systemd-generator.jsp" class="text-decoration-none text-dark">
                                            <div class="border rounded p-3 hover-bg-light">
                                                <h6 class="text-primary"><i class="fas fa-cogs mr-2"></i>Systemd
                                                    Generator
                                                </h6>
                                                <small>Create .service files for Linux services</small>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <a href="chmod-calculator.jsp" class="text-decoration-none text-dark">
                                            <div class="border rounded p-3 hover-bg-light">
                                                <h6 class="text-success"><i class="fas fa-lock mr-2"></i>Chmod
                                                    Calculator
                                                </h6>
                                                <small>Visual Linux permissions generator</small>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <a href="sslscan.jsp" class="text-decoration-none text-dark">
                                            <div class="border rounded p-3 hover-bg-light">
                                                <h6 class="text-info"><i class="fas fa-shield-alt mr-2"></i>SSL Scanner
                                                </h6>
                                                <small>Analyze server SSL/TLS configuration</small>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Educational Content -->
            <div class="card tool-card mt-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Understanding Nginx</h5>
                </div>
                <div class="card-body">
                    <h6>Reverse Proxy vs Load Balancer</h6>
                    <p>A <strong>Reverse Proxy</strong> sits in front of your web servers and forwards client
                        requests to those web servers. A <strong>Load Balancer</strong> distributes incoming network
                        traffic across a group of backend servers to ensure no single server bears too much load.
                    </p>

                    <h6 class="mt-4">Security Headers Explained</h6>
                    <ul>
                        <li><strong>HSTS:</strong> Tells browsers to only access the site via HTTPS.</li>
                        <li><strong>X-Frame-Options:</strong> Prevents your site from being embedded in iframes
                            (clickjacking protection).</li>
                        <li><strong>CSP:</strong> Controls which resources the user agent is allowed to load for a
                            given page.</li>
                    </ul>
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
                                <i class="fas fa-info-circle"></i> Anyone with this link can view this
                                configuration.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-3 text-right">
                <%@ include file="footer_adsense.jsp" %>
            </div>



            <script>
                // Configuration Presets
                const presets = {
                    static: {
                        name: 'Static Website',
                        serverName: 'mywebsite.com',
                        listenPort: '80',
                        rootDirectory: '/var/www/mywebsite.com/html',
                        enableProxy: false,
                        enableSpa: true,
                        enableHttps: false,
                        enableGzip: true,
                        enableCache: true,
                        headerXfo: true,
                        headerXss: true,
                        headerCsp: false
                    },
                    nodejs: {
                        name: 'Node.js/React App',
                        serverName: 'myapp.com',
                        listenPort: '80',
                        rootDirectory: '/var/www/html',
                        enableProxy: true,
                        upstreamServers: 'localhost:3000',
                        proxyWebsockets: true,
                        enableSpa: true,
                        enableHttps: true,
                        forceHttps: true,
                        headerHsts: true,
                        headerXfo: true,
                        headerXss: true,
                        enableGzip: true,
                        enableCache: true
                    },
                    wordpress: {
                        name: 'WordPress Site',
                        serverName: 'myblog.com',
                        listenPort: '80',
                        rootDirectory: '/var/www/wordpress',
                        enableProxy: false,
                        enableSpa: false,
                        enableHttps: true,
                        forceHttps: true,
                        headerHsts: true,
                        headerXfo: true,
                        enableGzip: true,
                        enableCache: true,
                        clientBody: '64M'
                    },
                    loadbalancer: {
                        name: 'Load Balancer',
                        serverName: 'loadbalancer.com',
                        listenPort: '80',
                        rootDirectory: '/var/www/html',
                        enableProxy: true,
                        upstreamServers: 'server1:8080\nserver2:8080\nserver3:8080',
                        proxyWebsockets: false,
                        enableSpa: false,
                        enableHttps: false,
                        enableGzip: true,
                        keepalive: '120'
                    },
                    api: {
                        name: 'API Gateway',
                        serverName: 'api.example.com',
                        listenPort: '443',
                        rootDirectory: '/var/www/html',
                        enableProxy: true,
                        upstreamServers: 'localhost:8080',
                        proxyWebsockets: false,
                        enableSpa: false,
                        enableHttps: true,
                        forceHttps: true,
                        headerHsts: true,
                        headerXfo: true,
                        headerCsp: true,
                        enableGzip: true,
                        clientBody: '10M'
                    }
                };

                function loadPreset(presetName) {
                    const preset = presets[presetName];
                    if (!preset) return;

                    // Basic Settings
                    document.getElementById('serverName').value = preset.serverName || 'example.com';
                    document.getElementById('listenPort').value = preset.listenPort || '80';
                    document.getElementById('rootDirectory').value = preset.rootDirectory || '/var/www/html';

                    // Proxy Settings
                    document.getElementById('enableProxy').checked = preset.enableProxy || false;
                    $('#proxySettings').collapse(preset.enableProxy ? 'show' : 'hide');
                    if (preset.upstreamServers) {
                        document.getElementById('upstreamServers').value = preset.upstreamServers;
                    }
                    document.getElementById('proxyWebsockets').checked = preset.proxyWebsockets || false;
                    document.getElementById('enableSpa').checked = preset.enableSpa || false;

                    // HTTPS Settings
                    document.getElementById('enableHttps').checked = preset.enableHttps || false;
                    document.getElementById('forceHttps').checked = preset.forceHttps || false;
                    document.getElementById('forceHttps').disabled = !preset.enableHttps;

                    // Security Headers
                    document.getElementById('headerHsts').checked = preset.headerHsts || false;
                    document.getElementById('headerXfo').checked = preset.headerXfo || false;
                    document.getElementById('headerXss').checked = preset.headerXss || false;
                    document.getElementById('headerCsp').checked = preset.headerCsp || false;

                    // Performance
                    document.getElementById('enableGzip').checked = preset.enableGzip || false;
                    document.getElementById('enableCache').checked = preset.enableCache || false;
                    if (preset.clientBody) {
                        document.getElementById('clientBody').value = preset.clientBody;
                    }
                    if (preset.keepalive) {
                        document.getElementById('keepalive').value = preset.keepalive;
                    }

                    // Regenerate config
                    generateConfig();
                }


                function generateConfig() {
                    const serverName = document.getElementById('serverName').value;
                    const port = document.getElementById('listenPort').value;
                    const root = document.getElementById('rootDirectory').value;

                    // Proxy
                    const isProxy = document.getElementById('enableProxy').checked;
                    const upstream = document.getElementById('upstreamServers').value;
                    const ws = document.getElementById('proxyWebsockets').checked;
                    const spa = document.getElementById('enableSpa').checked;

                    // Security
                    const https = document.getElementById('enableHttps').checked;
                    const forceHttps = document.getElementById('forceHttps').checked;
                    const hsts = document.getElementById('headerHsts').checked;
                    const xfo = document.getElementById('headerXfo').checked;
                    const xss = document.getElementById('headerXss').checked;
                    const csp = document.getElementById('headerCsp').checked;

                    // Perf
                    const gzip = document.getElementById('enableGzip').checked;
                    const cache = document.getElementById('enableCache').checked;
                    const bodySize = document.getElementById('clientBody').value;
                    const keepalive = document.getElementById('keepalive').value;

                    let config = `# Generated by 8gwifi.org Nginx Config Generator
# Date: ${new Date().toISOString()}

`;

                    // Upstream block
                    if (isProxy && upstream.trim()) {
                        config += `upstream backend_servers {
`;
                        upstream.split('\n').forEach(line => {
                            if (line.trim()) config += `    server ${line.trim()};\n`;
                        });
                        config += `}\n\n`;
                    }

                    config += `server {
    listen ${port};
    server_name ${serverName};
    
    # Root Directory
    root ${root};
    index index.html index.htm;

    # Performance
    client_max_body_size ${bodySize};
    keepalive_timeout ${keepalive};
`;

                    if (gzip) {
                        config += `
    # Gzip Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
`;
                    }

                    if (https) {
                        config += `
    # SSL Configuration
    # listen 443 ssl http2;
    # ssl_certificate /etc/letsencrypt/live/${serverName}/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/${serverName}/privkey.pem;
`;
                    }

                    if (forceHttps) {
                        config += `
    # Force HTTPS
    if ($scheme != "https") {
        return 301 https://$host$request_uri;
    }
`;
                    }

                    // Security Headers
                    if (hsts || xfo || xss || csp) {
                        config += `\n    # Security Headers\n`;
                        if (hsts) config += `    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;\n`;
                        if (xfo) config += `    add_header X-Frame-Options "DENY" always;\n`;
                        if (xss) config += `    add_header X-XSS-Protection "1; mode=block" always;\n`;
                        if (csp) config += `    add_header Content-Security-Policy "default-src 'self';" always;\n`;
                    }

                    // Locations
                    config += `\n    location / {\n`;

                    if (isProxy) {
                        config += `        proxy_pass http://backend_servers;\n`;
                        config += `        proxy_set_header Host $host;\n`;
                        config += `        proxy_set_header X-Real-IP $remote_addr;\n`;
                        config += `        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n`;

                        if (ws) {
                            config += `        # WebSocket Support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";\n`;
                        }
                    } else if (spa) {
                        config += `        try_files $uri $uri/ /index.html;\n`;
                    } else {
                        config += `        try_files $uri $uri/ =404;\n`;
                    }

                    config += `    }\n`;

                    if (cache) {
                        config += `
    # Static File Caching
    location ~* \\.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
`;
                    }

                    config += `}`;

                    document.getElementById('configOutput').textContent = config;
                }

                // Event Listeners
                const inputs = document.querySelectorAll('input, textarea');
                inputs.forEach(input => {
                    input.addEventListener('input', generateConfig);
                    input.addEventListener('change', generateConfig);
                });

                // UI Logic
                document.getElementById('enableProxy').addEventListener('change', function () {
                    if (this.checked) {
                        $('#proxySettings').collapse('show');
                    } else {
                        $('#proxySettings').collapse('hide');
                    }
                });

                document.getElementById('enableHttps').addEventListener('change', function () {
                    document.getElementById('forceHttps').disabled = !this.checked;
                    if (!this.checked) document.getElementById('forceHttps').checked = false;
                    generateConfig();
                });

                function copyConfig() {
                    const text = document.getElementById('configOutput').textContent;
                    navigator.clipboard.writeText(text).then(() => {
                        const btn = document.querySelector('.btn-light');
                        const original = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        setTimeout(() => btn.innerHTML = original, 2000);
                    });
                }

                function shareUrl() {
                    const formData = {
                        serverName: document.getElementById('serverName').value,
                        listenPort: document.getElementById('listenPort').value,
                        rootDirectory: document.getElementById('rootDirectory').value,
                        enableProxy: document.getElementById('enableProxy').checked,
                        upstreamServers: document.getElementById('upstreamServers').value,
                        proxyWebsockets: document.getElementById('proxyWebsockets').checked,
                        enableSpa: document.getElementById('enableSpa').checked,
                        enableHttps: document.getElementById('enableHttps').checked,
                        forceHttps: document.getElementById('forceHttps').checked,
                        headerHsts: document.getElementById('headerHsts').checked,
                        headerXfo: document.getElementById('headerXfo').checked,
                        headerXss: document.getElementById('headerXss').checked,
                        headerCsp: document.getElementById('headerCsp').checked,
                        enableGzip: document.getElementById('enableGzip').checked,
                        enableCache: document.getElementById('enableCache').checked,
                        clientBody: document.getElementById('clientBody').value,
                        keepalive: document.getElementById('keepalive').value
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

                            document.getElementById('serverName').value = formData.serverName || 'example.com';
                            document.getElementById('listenPort').value = formData.listenPort || '80';
                            document.getElementById('rootDirectory').value = formData.rootDirectory || '/var/www/html';

                            document.getElementById('enableProxy').checked = formData.enableProxy || false;
                            if (formData.enableProxy) $('#proxySettings').collapse('show');

                            document.getElementById('upstreamServers').value = formData.upstreamServers || 'localhost:3000';
                            document.getElementById('proxyWebsockets').checked = formData.proxyWebsockets || false;
                            document.getElementById('enableSpa').checked = formData.enableSpa || false;

                            document.getElementById('enableHttps').checked = formData.enableHttps || false;
                            document.getElementById('forceHttps').checked = formData.forceHttps || false;
                            document.getElementById('forceHttps').disabled = !formData.enableHttps;

                            document.getElementById('headerHsts').checked = formData.headerHsts || false;
                            document.getElementById('headerXfo').checked = formData.headerXfo || false;
                            document.getElementById('headerXss').checked = formData.headerXss || false;
                            document.getElementById('headerCsp').checked = formData.headerCsp || false;

                            document.getElementById('enableGzip').checked = formData.enableGzip || false;
                            document.getElementById('enableCache').checked = formData.enableCache || false;
                            document.getElementById('clientBody').value = formData.clientBody || '10M';
                            document.getElementById('keepalive').value = formData.keepalive || '65';

                        } catch (e) {
                            console.error('Error loading from URL:', e);
                        }
                    }
                    generateConfig();
                }

                // Copy share URL button
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

                // Initial Run
                loadFromUrl();
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>

                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>