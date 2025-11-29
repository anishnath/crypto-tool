<!DOCTYPE html>
<html>

<head>
    <title>Apache VirtualHost Generator – Reverse Proxy & SSL Config | 8gwifi.org</title>
    <meta name="description"
        content="Generate Apache VirtualHost configurations with mod_proxy reverse proxy, mod_rewrite URL rewriting, SSL/TLS, load balancing, and security headers. Free Apache config tool.">
    <meta name="keywords"
        content="apache virtualhost, apache config generator, mod_proxy, mod_rewrite, apache ssl, reverse proxy apache, apache load balancer">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Apache VirtualHost Generator",
      "description": "Generate production-ready Apache VirtualHost configurations with reverse proxy and SSL.",
      "url": "https://8gwifi.org/apache-virtualhost-generator.jsp",
      "applicationCategory": "DevOpsApplication",
      "operatingSystem": "Linux",
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
          "name": "What is a VirtualHost in Apache?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "A VirtualHost allows Apache to serve multiple websites from a single server. Name-based virtual hosting uses different ServerName directives to distinguish sites on the same IP address, while IP-based virtual hosting uses different IP addresses per site."
          }
        },
        {
          "@type": "Question",
          "name": "How does mod_proxy work for reverse proxying?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "mod_proxy enables Apache to forward requests to backend application servers (like Node.js, Python, or Java apps) and return their responses to clients. ProxyPass maps URL paths to backend URLs, while ProxyPassReverse rewrites response headers for proper redirects."
          }
        },
        {
          "@type": "Question",
          "name": "What is the difference between Redirect and RewriteRule?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Redirect is a simple directive for basic URL redirection (e.g., HTTP to HTTPS). RewriteRule (from mod_rewrite) provides powerful pattern matching with regular expressions for complex URL transformations, conditional rewrites, and advanced routing."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #7c3aed;
                --theme-secondary: #db2777;
                --theme-gradient: linear-gradient(135deg, #7c3aed 0%, #db2777 100%);
                --theme-light: #f3e8ff;
            }

            .tool-card {
                border: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
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

            .code-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
                font-size: 0.85rem;
                white-space: pre-wrap;
                min-height: 500px;
                max-height: 700px;
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
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">

            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0">Apache VirtualHost Generator</h1>
                    <div class="mt-2">
                        <span class="info-badge"><i class="fas fa-exchange-alt"></i> Reverse Proxy</span>
                        <span class="info-badge"><i class="fas fa-lock"></i> SSL/TLS</span>
                        <span class="info-badge"><i class="fas fa-random"></i> URL Rewriting</span>
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
                            <form id="vhostForm">

                                <!-- Basic Settings -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-cog"></i> Basic Settings
                                    </div>
                                    <div class="form-group">
                                        <label for="serverName">ServerName</label>
                                        <input type="text" class="form-control" id="serverName" value="example.com">
                                    </div>
                                    <div class="form-group">
                                        <label for="serverAlias">ServerAlias (Optional)</label>
                                        <input type="text" class="form-control" id="serverAlias"
                                            placeholder="www.example.com">
                                        <small class="text-muted">Separate multiple with spaces</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="documentRoot">DocumentRoot</label>
                                        <input type="text" class="form-control" id="documentRoot"
                                            value="/var/www/example.com/public_html">
                                    </div>
                                    <div class="form-group">
                                        <label for="listenPort">Listen Port</label>
                                        <select class="form-control" id="listenPort">
                                            <option value="80">80 (HTTP)</option>
                                            <option value="443">443 (HTTPS)</option>
                                            <option value="8080">8080 (Custom)</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Quick Presets -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-magic"></i> Quick Presets
                                    </div>
                                    <div class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-primary m-1"
                                            onclick="loadPreset('static')">
                                            <i class="fas fa-file-code"></i> Static Site
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
                                            onclick="loadPreset('python')">
                                            <i class="fab fa-python"></i> Python/Django
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger m-1"
                                            onclick="loadPreset('api')">
                                            <i class="fas fa-code"></i> API Gateway
                                        </button>
                                    </div>
                                </div>

                                <!-- SSL/TLS -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-lock"></i> SSL/TLS
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableSSL">
                                        <label class="custom-control-label" for="enableSSL">Enable HTTPS</label>
                                    </div>
                                    <div id="sslSettings" style="display: none;">
                                        <div class="form-group">
                                            <label>Certificate File</label>
                                            <input type="text" class="form-control" id="sslCert"
                                                value="/etc/ssl/certs/example.com.crt">
                                        </div>
                                        <div class="form-group">
                                            <label>Private Key File</label>
                                            <input type="text" class="form-control" id="sslKey"
                                                value="/etc/ssl/private/example.com.key">
                                        </div>
                                        <div class="form-group">
                                            <label>Certificate Chain (Optional)</label>
                                            <input type="text" class="form-control" id="sslChain"
                                                placeholder="/etc/ssl/certs/example.com.chain.pem">
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="forceHttps" checked>
                                            <label class="custom-control-label" for="forceHttps">Force HTTPS
                                                Redirect</label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Reverse Proxy -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-exchange-alt"></i> Reverse Proxy (mod_proxy)
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableProxy">
                                        <label class="custom-control-label" for="enableProxy">Enable Reverse
                                            Proxy</label>
                                    </div>
                                    <div id="proxySettings" style="display: none;">
                                        <div class="form-group">
                                            <label>Backend URL</label>
                                            <input type="text" class="form-control" id="proxyBackend"
                                                value="http://localhost:3000">
                                        </div>
                                        <div class="form-group">
                                            <label>Proxy Path</label>
                                            <input type="text" class="form-control" id="proxyPath" value="/">
                                            <small class="text-muted">URL path to proxy (e.g., /api or /)</small>
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="proxyWebSocket">
                                            <label class="custom-control-label" for="proxyWebSocket">WebSocket
                                                Support</label>
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="proxyPreserveHost"
                                                checked>
                                            <label class="custom-control-label" for="proxyPreserveHost">Preserve Host
                                                Header</label>
                                        </div>
                                    </div>
                                </div>

                                <!-- URL Rewriting -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-random"></i> URL Rewriting (mod_rewrite)
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableRewrite">
                                        <label class="custom-control-label" for="enableRewrite">Enable URL
                                            Rewriting</label>
                                    </div>
                                    <div id="rewriteSettings" style="display: none;">
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="rewriteWWW">
                                            <label class="custom-control-label" for="rewriteWWW">Remove www
                                                Prefix</label>
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input"
                                                id="rewriteTrailingSlash">
                                            <label class="custom-control-label" for="rewriteTrailingSlash">Add Trailing
                                                Slash</label>
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="rewriteSPA">
                                            <label class="custom-control-label" for="rewriteSPA">SPA Routing (index.html
                                                fallback)</label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Security Headers -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-shield-alt"></i> Security Headers
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="headerHSTS" checked>
                                        <label class="custom-control-label" for="headerHSTS">HSTS (Strict
                                            Transport)</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="headerXFrame" checked>
                                        <label class="custom-control-label" for="headerXFrame">X-Frame-Options</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="headerXSS" checked>
                                        <label class="custom-control-label" for="headerXSS">X-XSS-Protection</label>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="headerContentType"
                                            checked>
                                        <label class="custom-control-label"
                                            for="headerContentType">X-Content-Type-Options</label>
                                    </div>
                                </div>

                                <!-- Performance -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-tachometer-alt"></i> Performance
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableCompression"
                                            checked>
                                        <label class="custom-control-label" for="enableCompression">Gzip Compression
                                            (mod_deflate)</label>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="enableCaching">
                                        <label class="custom-control-label" for="enableCaching">Browser Caching
                                            (mod_expires)</label>
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
                                <span>
                                    <i class="fas fa-file-code mr-2"></i>
                                    VirtualHost Configuration
                                </span>
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
                                <pre id="configOutput" class="code-preview mb-0"></pre>
                            </div>
                        </div>

                        <!-- Installation Instructions -->
                        <div class="card tool-card mt-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-terminal mr-2"></i>Installation</h5>
                            </div>
                            <div class="card-body">
                                <ol class="mb-0">
                                    <li>Save configuration to <code>/etc/apache2/sites-available/<span
                                                id="filename">example.com.conf</span></code></li>
                                    <li>Enable required modules:
                                        <pre class="bg-dark text-light p-2 mt-2"><code id="modulesCmd"></code></pre>
                                    </li>
                                    <li>Enable the site:
                                        <pre class="bg-dark text-light p-2 mt-2"><code>sudo a2ensite <span
                                                    id="sitename">example.com</span>
sudo systemctl reload apache2</code></pre>
                                    </li>
                                    <li>Test configuration: <code>sudo apache2ctl configtest</code></li>
                                </ol>
                            </div>
                        </div>

                        <!-- Educational Content -->
                        <div class="card tool-card mt-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Apache Best Practices</h5>
                            </div>
                            <div class="card-body">
                                <h6>mod_proxy vs mod_rewrite</h6>
                                <p><strong>mod_proxy</strong> is ideal for reverse proxying to application servers.
                                    <strong>mod_rewrite</strong> is for URL manipulation and complex routing logic.
                                </p>

                                <h6 class="mt-4">SSL Best Practices</h6>
                                <ul>
                                    <li>Use Let's Encrypt for free SSL certificates</li>
                                    <li>Enable HTTP/2 with <code>Protocols h2 http/1.1</code></li>
                                    <li>Set <code>SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1</code> for security</li>
                                    <li>Use strong cipher suites</li>
                                </ul>

                                <h6 class="mt-4">Performance Tips</h6>
                                <p>Enable <code>mod_http2</code> for HTTP/2 support, use <code>mod_cache</code> for
                                    caching, and configure <code>KeepAlive On</code> for connection reuse.</p>
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
            // Configuration Presets
            const presets = {
                static: {
                    name: 'Static Website',
                    serverName: 'mywebsite.com',
                    documentRoot: '/var/www/mywebsite.com/html',
                    listenPort: '80',
                    enableSSL: false,
                    enableProxy: false,
                    enableRewrite: true,
                    rewriteTrailingSlash: true,
                    rewriteSPA: false,
                    headerXFrame: true,
                    headerXSS: true,
                    enableCompression: true,
                    enableCaching: true
                },
                nodejs: {
                    name: 'Node.js/React App',
                    serverName: 'myapp.com',
                    documentRoot: '/var/www/myapp.com',
                    listenPort: '443',
                    enableSSL: true,
                    forceHttps: true,
                    enableProxy: true,
                    proxyBackend: 'http://localhost:3000',
                    proxyPath: '/',
                    proxyWebSocket: true,
                    proxyPreserveHost: true,
                    enableRewrite: false,
                    headerHSTS: true,
                    headerXFrame: true,
                    headerXSS: true,
                    headerContentType: true,
                    enableCompression: true,
                    enableCaching: true
                },
                wordpress: {
                    name: 'WordPress Site',
                    serverName: 'myblog.com',
                    documentRoot: '/var/www/wordpress',
                    listenPort: '443',
                    enableSSL: true,
                    forceHttps: true,
                    enableProxy: false,
                    enableRewrite: true,
                    rewriteWWW: true,
                    headerHSTS: true,
                    headerXFrame: true,
                    headerXSS: true,
                    enableCompression: true,
                    enableCaching: true
                },
                python: {
                    name: 'Python/Django App',
                    serverName: 'djangoapp.com',
                    documentRoot: '/var/www/djangoapp',
                    listenPort: '443',
                    enableSSL: true,
                    forceHttps: true,
                    enableProxy: true,
                    proxyBackend: 'http://localhost:8000',
                    proxyPath: '/',
                    proxyPreserveHost: true,
                    enableRewrite: false,
                    headerHSTS: true,
                    headerXFrame: true,
                    headerXSS: true,
                    headerContentType: true,
                    enableCompression: true,
                    enableCaching: false
                },
                api: {
                    name: 'API Gateway',
                    serverName: 'api.example.com',
                    documentRoot: '/var/www/api',
                    listenPort: '443',
                    enableSSL: true,
                    forceHttps: true,
                    enableProxy: true,
                    proxyBackend: 'http://localhost:8080',
                    proxyPath: '/',
                    proxyPreserveHost: true,
                    enableRewrite: false,
                    headerHSTS: true,
                    headerXFrame: true,
                    headerXSS: true,
                    headerContentType: true,
                    enableCompression: true,
                    enableCaching: false
                }
            };

            function loadPreset(presetName) {
                const preset = presets[presetName];
                if (!preset) return;

                // Basic Settings
                document.getElementById('serverName').value = preset.serverName || 'example.com';
                document.getElementById('documentRoot').value = preset.documentRoot || '/var/www/html';
                document.getElementById('listenPort').value = preset.listenPort || '80';

                // SSL/TLS
                document.getElementById('enableSSL').checked = preset.enableSSL || false;
                document.getElementById('enableSSL').dispatchEvent(new Event('change'));
                if (preset.enableSSL) {
                    document.getElementById('sslCert').value = `/etc/ssl/certs/${preset.serverName}.crt`;
                    document.getElementById('sslKey').value = `/etc/ssl/private/${preset.serverName}.key`;
                }
                document.getElementById('forceHttps').checked = preset.forceHttps || false;

                // Reverse Proxy
                document.getElementById('enableProxy').checked = preset.enableProxy || false;
                document.getElementById('enableProxy').dispatchEvent(new Event('change'));
                if (preset.enableProxy) {
                    document.getElementById('proxyBackend').value = preset.proxyBackend || 'http://localhost:3000';
                    document.getElementById('proxyPath').value = preset.proxyPath || '/';
                    document.getElementById('proxyWebSocket').checked = preset.proxyWebSocket || false;
                    document.getElementById('proxyPreserveHost').checked = preset.proxyPreserveHost !== false;
                }

                // URL Rewriting
                document.getElementById('enableRewrite').checked = preset.enableRewrite || false;
                document.getElementById('enableRewrite').dispatchEvent(new Event('change'));
                if (preset.enableRewrite) {
                    document.getElementById('rewriteWWW').checked = preset.rewriteWWW || false;
                    document.getElementById('rewriteTrailingSlash').checked = preset.rewriteTrailingSlash || false;
                    document.getElementById('rewriteSPA').checked = preset.rewriteSPA || false;
                }

                // Security Headers
                document.getElementById('headerHSTS').checked = preset.headerHSTS || false;
                document.getElementById('headerXFrame').checked = preset.headerXFrame || false;
                document.getElementById('headerXSS').checked = preset.headerXSS || false;
                document.getElementById('headerContentType').checked = preset.headerContentType || false;

                // Performance
                document.getElementById('enableCompression').checked = preset.enableCompression || false;
                document.getElementById('enableCaching').checked = preset.enableCaching || false;

                // Generate configuration
                generateConfig();
            }

            function generateConfig() {
                const serverName = document.getElementById('serverName').value;
                const serverAlias = document.getElementById('serverAlias').value;
                const documentRoot = document.getElementById('documentRoot').value;
                const listenPort = document.getElementById('listenPort').value;

                const enableSSL = document.getElementById('enableSSL').checked;
                const sslCert = document.getElementById('sslCert').value;
                const sslKey = document.getElementById('sslKey').value;
                const sslChain = document.getElementById('sslChain').value;
                const forceHttps = document.getElementById('forceHttps').checked;

                const enableProxy = document.getElementById('enableProxy').checked;
                const proxyBackend = document.getElementById('proxyBackend').value;
                const proxyPath = document.getElementById('proxyPath').value;
                const proxyWebSocket = document.getElementById('proxyWebSocket').checked;
                const proxyPreserveHost = document.getElementById('proxyPreserveHost').checked;

                const enableRewrite = document.getElementById('enableRewrite').checked;
                const rewriteWWW = document.getElementById('rewriteWWW').checked;
                const rewriteTrailingSlash = document.getElementById('rewriteTrailingSlash').checked;
                const rewriteSPA = document.getElementById('rewriteSPA').checked;

                const headerHSTS = document.getElementById('headerHSTS').checked;
                const headerXFrame = document.getElementById('headerXFrame').checked;
                const headerXSS = document.getElementById('headerXSS').checked;
                const headerContentType = document.getElementById('headerContentType').checked;

                const enableCompression = document.getElementById('enableCompression').checked;
                const enableCaching = document.getElementById('enableCaching').checked;

                let config = `# Generated by 8gwifi.org Apache VirtualHost Generator\n`;
                config += `# Date: ${new Date().toISOString()}\n\n`;

                // HTTP to HTTPS redirect
                if (enableSSL && forceHttps) {
                    config += `<VirtualHost *:80>\n`;
                    config += `    ServerName ${serverName}\n`;
                    if (serverAlias) config += `    ServerAlias ${serverAlias}\n`;
                    config += `    \n`;
                    config += `    # Redirect all HTTP to HTTPS\n`;
                    config += `    Redirect permanent / https://${serverName}/\n`;
                    config += `</VirtualHost>\n\n`;
                }

                // Main VirtualHost
                const vhostPort = enableSSL ? '443' : listenPort;
                config += `<VirtualHost *:${vhostPort}>\n`;
                config += `    ServerName ${serverName}\n`;
                if (serverAlias) config += `    ServerAlias ${serverAlias}\n`;

                if (!enableProxy) {
                    config += `    DocumentRoot ${documentRoot}\n`;
                }

                config += `    \n`;

                // SSL Configuration
                if (enableSSL) {
                    config += `    # SSL Configuration\n`;
                    config += `    SSLEngine on\n`;
                    config += `    SSLCertificateFile ${sslCert}\n`;
                    config += `    SSLCertificateKeyFile ${sslKey}\n`;
                    if (sslChain) {
                        config += `    SSLCertificateChainFile ${sslChain}\n`;
                    }
                    config += `    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1\n`;
                    config += `    SSLCipherSuite HIGH:!aNULL:!MD5:!3DES\n`;
                    config += `    SSLHonorCipherOrder on\n`;
                    config += `    \n`;
                }

                // Security Headers
                if (headerHSTS || headerXFrame || headerXSS || headerContentType) {
                    config += `    # Security Headers\n`;
                    if (headerHSTS && enableSSL) {
                        config += `    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"\n`;
                    }
                    if (headerXFrame) {
                        config += `    Header always set X-Frame-Options "SAMEORIGIN"\n`;
                    }
                    if (headerXSS) {
                        config += `    Header always set X-XSS-Protection "1; mode=block"\n`;
                    }
                    if (headerContentType) {
                        config += `    Header always set X-Content-Type-Options "nosniff"\n`;
                    }
                    config += `    \n`;
                }

                // Reverse Proxy
                if (enableProxy) {
                    config += `    # Reverse Proxy Configuration\n`;
                    if (proxyPreserveHost) {
                        config += `    ProxyPreserveHost On\n`;
                    }
                    config += `    ProxyPass ${proxyPath} ${proxyBackend}\n`;
                    config += `    ProxyPassReverse ${proxyPath} ${proxyBackend}\n`;

                    if (proxyWebSocket) {
                        config += `    \n`;
                        config += `    # WebSocket Support\n`;
                        config += `    RewriteEngine On\n`;
                        config += `    RewriteCond %{HTTP:Upgrade} websocket [NC]\n`;
                        config += `    RewriteCond %{HTTP:Connection} upgrade [NC]\n`;
                        config += `    RewriteRule ^/(.*) ws://${proxyBackend.replace('http://', '')}/$1 [P,L]\n`;
                    }
                    config += `    \n`;
                }

                // URL Rewriting
                if (enableRewrite) {
                    config += `    # URL Rewriting\n`;
                    config += `    RewriteEngine On\n`;

                    if (rewriteWWW) {
                        config += `    \n`;
                        config += `    # Remove www prefix\n`;
                        config += `    RewriteCond %{HTTP_HOST} ^www\\.(.*)$ [NC]\n`;
                        config += `    RewriteRule ^(.*)$ ${enableSSL ? 'https' : 'http'}://%1$1 [R=301,L]\n`;
                    }

                    if (rewriteTrailingSlash) {
                        config += `    \n`;
                        config += `    # Add trailing slash\n`;
                        config += `    RewriteCond %{REQUEST_FILENAME} !-f\n`;
                        config += `    RewriteCond %{REQUEST_URI} !(.*)/$\n`;
                        config += `    RewriteRule ^(.*)$ $1/ [R=301,L]\n`;
                    }

                    if (rewriteSPA) {
                        config += `    \n`;
                        config += `    # SPA Routing (fallback to index.html)\n`;
                        config += `    RewriteCond %{REQUEST_FILENAME} !-f\n`;
                        config += `    RewriteCond %{REQUEST_FILENAME} !-d\n`;
                        config += `    RewriteRule . /index.html [L]\n`;
                    }
                    config += `    \n`;
                }

                // Directory Configuration
                if (!enableProxy) {
                    config += `    <Directory ${documentRoot}>\n`;
                    config += `        Options -Indexes +FollowSymLinks\n`;
                    config += `        AllowOverride All\n`;
                    config += `        Require all granted\n`;
                    config += `    </Directory>\n`;
                    config += `    \n`;
                }

                // Compression
                if (enableCompression) {
                    config += `    # Compression\n`;
                    config += `    <IfModule mod_deflate.c>\n`;
                    config += `        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json\n`;
                    config += `    </IfModule>\n`;
                    config += `    \n`;
                }

                // Browser Caching
                if (enableCaching) {
                    config += `    # Browser Caching\n`;
                    config += `    <IfModule mod_expires.c>\n`;
                    config += `        ExpiresActive On\n`;
                    config += `        ExpiresByType image/jpg "access plus 1 year"\n`;
                    config += `        ExpiresByType image/jpeg "access plus 1 year"\n`;
                    config += `        ExpiresByType image/png "access plus 1 year"\n`;
                    config += `        ExpiresByType text/css "access plus 1 month"\n`;
                    config += `        ExpiresByType application/javascript "access plus 1 month"\n`;
                    config += `    </IfModule>\n`;
                    config += `    \n`;
                }

                // Logs
                config += `    # Logs\n`;
                config += `    ErrorLog \${APACHE_LOG_DIR}/${serverName}-error.log\n`;
                config += `    CustomLog \${APACHE_LOG_DIR}/${serverName}-access.log combined\n`;

                config += `</VirtualHost>`;

                document.getElementById('configOutput').textContent = config;
                updateFilename(serverName);
                updateModulesCommand();
            }

            function updateFilename(serverName) {
                document.getElementById('filename').textContent = serverName + '.conf';
                document.getElementById('sitename').textContent = serverName;
            }

            function updateModulesCommand() {
                const modules = ['ssl', 'headers'];

                if (document.getElementById('enableProxy').checked) {
                    modules.push('proxy', 'proxy_http');
                    if (document.getElementById('proxyWebSocket').checked) {
                        modules.push('proxy_wstunnel');
                    }
                }

                if (document.getElementById('enableRewrite').checked) {
                    modules.push('rewrite');
                }

                if (document.getElementById('enableCompression').checked) {
                    modules.push('deflate');
                }

                if (document.getElementById('enableCaching').checked) {
                    modules.push('expires');
                }

                const cmd = modules.map(m => `sudo a2enmod ${m}`).join('\n');
                document.getElementById('modulesCmd').textContent = cmd;
            }

            // Event Listeners
            document.getElementById('enableSSL').addEventListener('change', function () {
                document.getElementById('sslSettings').style.display = this.checked ? 'block' : 'none';
                if (this.checked) {
                    document.getElementById('listenPort').value = '443';
                } else {
                    document.getElementById('listenPort').value = '80';
                }
                generateConfig();
            });

            document.getElementById('enableProxy').addEventListener('change', function () {
                document.getElementById('proxySettings').style.display = this.checked ? 'block' : 'none';
                generateConfig();
            });

            document.getElementById('enableRewrite').addEventListener('change', function () {
                document.getElementById('rewriteSettings').style.display = this.checked ? 'block' : 'none';
                generateConfig();
            });

            const inputs = document.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.addEventListener('input', generateConfig);
                input.addEventListener('change', generateConfig);
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
                    serverAlias: document.getElementById('serverAlias').value,
                    documentRoot: document.getElementById('documentRoot').value,
                    listenPort: document.getElementById('listenPort').value,
                    enableSSL: document.getElementById('enableSSL').checked,
                    sslCert: document.getElementById('sslCert').value,
                    sslKey: document.getElementById('sslKey').value,
                    sslChain: document.getElementById('sslChain').value,
                    forceHttps: document.getElementById('forceHttps').checked,
                    enableProxy: document.getElementById('enableProxy').checked,
                    proxyBackend: document.getElementById('proxyBackend').value,
                    proxyPath: document.getElementById('proxyPath').value,
                    proxyWebSocket: document.getElementById('proxyWebSocket').checked,
                    proxyPreserveHost: document.getElementById('proxyPreserveHost').checked,
                    enableRewrite: document.getElementById('enableRewrite').checked,
                    rewriteWWW: document.getElementById('rewriteWWW').checked,
                    rewriteTrailingSlash: document.getElementById('rewriteTrailingSlash').checked,
                    rewriteSPA: document.getElementById('rewriteSPA').checked,
                    headerHSTS: document.getElementById('headerHSTS').checked,
                    headerXFrame: document.getElementById('headerXFrame').checked,
                    headerXSS: document.getElementById('headerXSS').checked,
                    headerContentType: document.getElementById('headerContentType').checked,
                    enableCompression: document.getElementById('enableCompression').checked,
                    enableCaching: document.getElementById('enableCaching').checked
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

                        Object.keys(formData).forEach(key => {
                            const element = document.getElementById(key);
                            if (element) {
                                if (element.type === 'checkbox') {
                                    element.checked = formData[key];
                                    element.dispatchEvent(new Event('change'));
                                } else {
                                    element.value = formData[key];
                                }
                            }
                        });

                        generateConfig();
                    } catch (e) {
                        console.error('Error loading from URL:', e);
                        generateConfig();
                    }
                } else {
                    generateConfig();
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