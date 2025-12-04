<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Online Curl Tool – HTTP/HTTPS Website Accessibility Test – Free | 8gwifi.org</title>
    <meta name="description" content="Free online curl tool to test website accessibility over IPv4 and IPv6. Check HTTP/HTTPS connectivity, response headers, SSL certificates, and connection status." />
    <meta name="keywords" content="curl online, http test, https test, website accessibility, ipv6 test, ssl check, http headers, website checker, curl tool, web connectivity" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/curlfunctions.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Online Curl Tool - Test Website Accessibility" />
    <meta property="og:description" content="Test HTTP/HTTPS website accessibility with our free online curl tool. Check IPv4/IPv6 connectivity and response headers." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/curlfunctions.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/terminal.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Online Curl Tool – Website Accessibility & SSL Checks" />
    <meta name="twitter:description" content="Test HTTP/HTTPS accessibility, IPv4/IPv6, headers, SSL certs, and ports. Free curl tool." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/terminal.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Online Curl Tool",
        "alternateName": ["HTTP Test Tool", "Website Accessibility Checker", "Web Connectivity Test", "IPv6 Website Test"],
        "description": "Free online curl tool to test website accessibility over HTTP and HTTPS. Check IPv4/IPv6 connectivity, response headers, SSL certificates, and port accessibility.",
        "url": "https://8gwifi.org/curlfunctions.jsp",
        "image": "https://8gwifi.org/images/site/curl.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "HTTP/HTTPS connectivity test",
            "IPv4 and IPv6 support",
            "Custom port testing",
            "Response header analysis",
            "SSL certificate checking",
            "Website accessibility testing",
            "Protocol selection (HTTP/HTTPS)"
        ],
        "screenshot": "https://8gwifi.org/images/site/curl.png",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2021-02-08",
        "dateModified": "2025-01-28",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "audience": {
            "@type": "Audience",
            "audienceType": "Web Developers, Network Administrators, DevOps Engineers, System Administrators, IT Professionals"
        }
    }
    </script>

    <!-- JSON-LD FAQPage Schema for Rich Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is curl and what does it do?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Curl (Client URL) is a command-line tool for transferring data using various network protocols. It's commonly used to test HTTP/HTTPS connectivity, download files, send API requests, and debug web services. Curl supports protocols including HTTP, HTTPS, FTP, SFTP, and many more."
                }
            },
            {
                "@type": "Question",
                "name": "How do I test if a website supports IPv6?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "To test IPv6 support, you can use this tool with an IPv6 hostname (like ipv6.google.com) or curl with the -6 flag. A website supports IPv6 if it has AAAA DNS records and responds to connections over IPv6. Not all websites have IPv6 enabled yet."
                }
            },
            {
                "@type": "Question",
                "name": "What's the difference between HTTP and HTTPS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "HTTP (port 80) transfers data in plain text, while HTTPS (port 443) encrypts data using TLS/SSL. HTTPS provides security against eavesdropping, data tampering, and man-in-the-middle attacks. Modern websites should always use HTTPS for sensitive data."
                }
            },
            {
                "@type": "Question",
                "name": "What do HTTP status codes mean?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "HTTP status codes indicate the result of a request: 2xx (Success) - Request successful (200 OK, 201 Created). 3xx (Redirect) - Resource moved (301 Permanent, 302 Temporary). 4xx (Client Error) - Bad request or unauthorized (404 Not Found, 403 Forbidden). 5xx (Server Error) - Server problems (500 Internal Error, 503 Unavailable)."
                }
            },
            {
                "@type": "Question",
                "name": "Why does curl fail with SSL certificate errors?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "SSL errors occur when: 1) Certificate is expired or not yet valid, 2) Certificate doesn't match the domain, 3) Certificate is self-signed or from untrusted CA, 4) Certificate chain is incomplete. Use curl -k to skip verification (only for testing), or fix the certificate issue on the server."
                }
            },
            {
                "@type": "Question",
                "name": "How do I test a specific port with curl?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Curl uses the default port for each protocol (80 for HTTP, 443 for HTTPS) but you can specify a custom port using the colon notation: curl https://example.com:8443 or curl http://example.com:8080. This tool allows you to specify any port number for testing non-standard configurations."
                }
            }
        ]
    }
    </script>

    <!-- JSON-LD HowTo Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Test Website Accessibility with Curl",
        "description": "Step-by-step guide to test HTTP/HTTPS website connectivity",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Select Protocol",
                "text": "Choose HTTP or HTTPS depending on the target website's configuration"
            },
            {
                "@type": "HowToStep",
                "name": "Enter URL",
                "text": "Enter the hostname or domain name (without the protocol prefix)"
            },
            {
                "@type": "HowToStep",
                "name": "Set Port",
                "text": "Enter the port number (80 for HTTP, 443 for HTTPS, or custom port)"
            },
            {
                "@type": "HowToStep",
                "name": "Submit Request",
                "text": "Click Submit to test connectivity and view response details"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #0f766e;
            --theme-secondary: #14b8a6;
            --theme-gradient: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%);
            --theme-light: #f0fdfa;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(15, 118, 110, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(15, 118, 110, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 400px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 350px;
        }
        .result-content {
            display: none;
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
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
        }
        .preset-btn {
            padding: 0.4rem 0.75rem;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s;
        }
        .preset-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .scheme-btn {
            padding: 0.5rem 1rem;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.2s;
            flex: 1;
            text-align: center;
        }
        .scheme-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .scheme-btn.active {
            border-color: var(--theme-primary);
            background: var(--theme-gradient);
            color: white;
        }
        .scheme-btn .scheme-port { font-size: 0.7rem; opacity: 0.8; display: block; }
        .curl-output {
            background: #1e1e1e;
            color: #4ec9b0;
            font-family: monospace;
            font-size: 0.85rem;
            padding: 1rem;
            border-radius: 8px;
            white-space: pre-wrap;
            max-height: 400px;
            overflow-y: auto;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(15, 118, 110, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .http-status-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Online Curl Tool</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-globe"></i> HTTP/HTTPS</span>
            <span class="info-badge"><i class="fas fa-network-wired"></i> IPv4/IPv6</span>
            <span class="info-badge"><i class="fas fa-lock"></i> SSL</span>
</div>
</div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
</div>
</div>



<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-globe me-2"></i>Website Connectivity Test</h5>
            </div>
            <div class="card-body">
                <form id="curlForm">
                    <input type="hidden" name="methodName" value="NETWORKCURLCOMMAND">
                    <input type="hidden" name="getClientIpAddr" value="true">
                    <input type="hidden" name="scheme" id="scheme" value="https">

                    <!-- Protocol Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-lock me-1"></i>Protocol</div>
                        <div class="d-flex gap-2">
                            <div class="scheme-btn active" data-scheme="https" data-port="443">
                                HTTPS
                                <span class="scheme-port">Port 443</span>
                            </div>
                            <div class="scheme-btn" data-scheme="http" data-port="80">
                                HTTP
                                <span class="scheme-port">Port 80</span>
                            </div>
                        </div>
                    </div>

                    <!-- URL Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-link me-1"></i>URL / Hostname</div>
                        <input type="text" class="form-control" id="ipaddress" name="ipaddress" value="google.com" placeholder="e.g., google.com, ipv6.google.com">
                        <small class="text-muted">Enter hostname without http:// or https://</small>
                    </div>

                    <!-- Port -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-plug me-1"></i>Port</div>
                        <input type="text" class="form-control" id="port" name="port" value="443" oninput="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="e.g., 443, 80, 8080">
                        <small class="text-muted">Standard: 443 (HTTPS), 80 (HTTP)</small>
                    </div>

                    <!-- Quick Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Presets</div>
                        <div class="d-flex gap-2 flex-wrap mb-2">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com', 'https', 443)">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com', 'https', 443)">github.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('cloudflare.com', 'https', 443)">cloudflare.com</button>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('ipv6.google.com', 'https', 443)">IPv6 Google</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('ipv6.cloudflare.com', 'https', 443)">IPv6 Cloudflare</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="curlBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-paper-plane me-2"></i>Test Connectivity
                    </button>
                </form>
            </div>
        </div>

        <!-- HTTP Status Codes -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>HTTP Status Codes</h6>
            </div>
            <div class="card-body small p-2">
                <div class="d-flex justify-content-between mb-1">
                    <span><span class="badge bg-success">2xx</span> Success</span>
                    <span class="text-muted">200, 201, 204</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><span class="badge bg-info">3xx</span> Redirect</span>
                    <span class="text-muted">301, 302, 304</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><span class="badge bg-warning text-dark">4xx</span> Client Error</span>
                    <span class="text-muted">400, 403, 404</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span><span class="badge bg-danger">5xx</span> Server Error</span>
                    <span class="text-muted">500, 502, 503</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>Response</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-globe fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Response will appear here</p>
                        <small class="text-muted">Enter a URL and click Test Connectivity</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div class="curl-output" id="curlOutput"></div>
                </div>
            </div>
        </div>

        <!-- CLI Commands -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>CLI Commands</h6>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Basic curl request</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('curl -I https://google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ curl <code>-I https://google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Force IPv6</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('curl -6 https://ipv6.google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ curl <code>-6 https://ipv6.google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Verbose with headers</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('curl -v -I https://google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ curl <code>-v -I https://google.com</code></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Network Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="pingfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-satellite-dish me-1"></i>Ping Tool</h6>
                <p>Test ICMP connectivity</p>
            </a>
            <a href="httpstat.jsp" class="related-tool-card">
                <h6><i class="fas fa-tachometer-alt me-1"></i>HTTP Stats</h6>
                <p>Detailed HTTP timing</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Port Scanner</h6>
                <p>Scan open ports</p>
            </a>
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query DNS records</p>
            </a>
            <a href="mtr.jsp" class="related-tool-card">
                <h6><i class="fas fa-route me-1"></i>MTR Traceroute</h6>
                <p>Network path analysis</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>Whois Lookup</h6>
                <p>Domain registration info</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Curl & HTTP</h5>
    </div>
    <div class="card-body">
        <h6>What is Curl?</h6>
        <p>Curl (Client URL) is a command-line tool for transferring data using various network protocols. It's essential for testing APIs, debugging web services, downloading files, and checking website accessibility. This online tool provides a web-based interface for basic curl functionality.</p>

        <h6 class="mt-4">Common HTTP Status Codes</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm http-status-table">
                <thead>
                <tr><th>Code</th><th>Name</th><th>Description</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><span class="badge bg-success">200</span></td><td>OK</td><td>Request successful</td></tr>
                <tr><td><span class="badge bg-info">301</span></td><td>Moved Permanently</td><td>Resource permanently redirected</td></tr>
                <tr><td><span class="badge bg-info">302</span></td><td>Found</td><td>Temporary redirect</td></tr>
                <tr><td><span class="badge bg-warning text-dark">400</span></td><td>Bad Request</td><td>Invalid request syntax</td></tr>
                <tr><td><span class="badge bg-warning text-dark">403</span></td><td>Forbidden</td><td>Access denied</td></tr>
                <tr><td><span class="badge bg-warning text-dark">404</span></td><td>Not Found</td><td>Resource doesn't exist</td></tr>
                <tr><td><span class="badge bg-danger">500</span></td><td>Internal Server Error</td><td>Server-side error</td></tr>
                <tr><td><span class="badge bg-danger">503</span></td><td>Service Unavailable</td><td>Server temporarily unavailable</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-network-wired me-1"></i>IPv6 Testing</h6>
                    <p class="small mb-0">Use ipv6.google.com or ipv6.cloudflare.com to test IPv6 connectivity. These domains only resolve to IPv6 addresses (AAAA records), ensuring your connection uses IPv6.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-lock me-1"></i>SSL/TLS Certificates</h6>
                    <p class="small mb-0">HTTPS uses SSL/TLS to encrypt data. Certificate errors may occur with expired, self-signed, or mismatched certificates. Always ensure certificates are valid for production sites.</p>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Visible FAQs -->
<h2 class="mt-4" id="faqs">FAQs</h2>
<div class="accordion" id="curlFaqs">
    <div class="card"><div class="card-header"><h6 class="mb-0">Why does curl show SSL errors?</h6></div><div class="card-body small text-muted">Expired/invalid cert, mismatched domain, untrusted CA, or incomplete chain. Fix server certs; use -k only for testing.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">How to test IPv6?</h6></div><div class="card-body small text-muted">Use IPv6 hostnames or run curl -6. Ensure AAAA DNS records and IPv6 reachability.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">How to test a custom port?</h6></div><div class="card-body small text-muted">Specify the port in the URL (e.g., https://example.com:8443). This tool supports non‑standard ports.</div></div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share Curl Test</h5>
                <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="input-group">
                    <input type="text" class="form-control" id="shareUrlText" readonly>
                    <button class="btn btn-success" type="button" id="copyShareUrl"><i class="fas fa-copy"></i> Copy</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var lastUrl = null;
    var lastResult = null;

    $(document).ready(function() {
        loadFromUrl();

        // Protocol selection
        $('.scheme-btn').click(function() {
            $('.scheme-btn').removeClass('active');
            $(this).addClass('active');
            $('#scheme').val($(this).data('scheme'));
            $('#port').val($(this).data('port'));
        });

        $('#curlForm').submit(function(e) {
            e.preventDefault();
            performCurl();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function applyPreset(url, scheme, port) {
        $('#ipaddress').val(url);
        $('#scheme').val(scheme);
        $('#port').val(port);
        $('.scheme-btn').removeClass('active');
        $('.scheme-btn[data-scheme="' + scheme + '"]').addClass('active');
        showToast('Applied: ' + scheme + '://' + url);
    }

    function performCurl() {
        var url = $('#ipaddress').val().trim();
        if (!url) { showToast('Please enter a URL or hostname'); return; }

        // Remove protocol if present
        url = url.replace(/^https?:\/\//, '');
        $('#ipaddress').val(url);

        lastUrl = $('#scheme').val() + '://' + url + ':' + $('#port').val();
        $('#curlBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Testing...');

        $.ajax({
            type: 'POST',
            url: 'NetworkFunctionality',
            data: $('#curlForm').serialize(),
            dataType: 'json',
            success: function(response) {
                $('#curlBtn').prop('disabled', false).html('<i class="fas fa-paper-plane me-2"></i>Test Connectivity');
                lastResult = response;
                renderCurlResult(response);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
                $('#resultActions').show();
            },
            error: function(xhr, status, error) {
                $('#curlBtn').prop('disabled', false).html('<i class="fas fa-paper-plane me-2"></i>Test Connectivity');
                showError('Request failed: ' + error);
            }
        });
    }

    function renderCurlResult(data) {
        var html = '';

        if (!data.success) {
            html = '<div class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i>' + escapeHtml(data.error || 'Unknown error') + '</div>';
            $('#curlOutput').html(html);
            return;
        }

        // Connection info
        html += '<div class="mb-3">';
        html += '<div class="d-flex flex-wrap gap-2 mb-2">';
        html += '<span class="badge bg-success"><i class="fas fa-check me-1"></i>Connected</span>';
        html += '<span class="badge bg-info">' + escapeHtml(data.ipVersion) + '</span>';
        html += '<span class="badge" style="background: #0f766e;">' + escapeHtml(data.scheme.toUpperCase()) + '</span>';
        html += '</div>';
        html += '<div class="small" style="color: #9cdcfe;">';
        html += '<strong>URL:</strong> <code style="color: #ce9178;">' + escapeHtml(data.url) + '</code><br>';
        html += '<strong>Host:</strong> ' + escapeHtml(data.host) + '<br>';
        html += '<strong>Resolved IP:</strong> ' + escapeHtml(data.resolvedIp) + '<br>';
        html += '<strong>Port:</strong> ' + escapeHtml(data.port);
        html += '</div></div>';

        // HTTP Headers
        if (data.headers) {
            html += '<div class="mb-3">';
            html += '<div style="color: #dcdcaa; font-weight: 600; margin-bottom: 0.5rem;"><i class="fas fa-file-alt me-1"></i>HTTP Response Headers</div>';

            // Parse and colorize headers
            var headerHtml = parseHttpHeaders(data.headers);
            html += '<pre style="color: #4ec9b0; margin: 0; white-space: pre-wrap; font-size: 0.8rem;">' + headerHtml + '</pre>';
            html += '</div>';
        }

        // DNS Records
        if (data.dnsRecords && data.dnsRecords.length > 0) {
            html += '<div class="mb-3 pt-3" style="border-top: 1px solid #3c3c3c;">';
            html += '<div style="color: #dcdcaa; font-weight: 600; margin-bottom: 0.5rem;"><i class="fas fa-server me-1"></i>DNS Records</div>';
            html += '<table class="table table-sm table-dark mb-0" style="font-size: 0.75rem;">';
            html += '<thead><tr><th>Type</th><th>Value</th><th>TTL</th></tr></thead><tbody>';
            data.dnsRecords.forEach(function(rec) {
                html += '<tr>';
                html += '<td><span class="badge bg-secondary">' + escapeHtml(rec.type) + '</span></td>';
                html += '<td style="color: #9cdcfe;">' + escapeHtml(rec.value) + '</td>';
                html += '<td style="color: #808080;">' + escapeHtml(rec.ttl) + '</td>';
                html += '</tr>';
            });
            html += '</tbody></table>';
            html += '</div>';
        }

        // Location info
        if (data.location) {
            html += '<div class="mt-3 pt-3" style="border-top: 1px solid #3c3c3c;">';
            html += '<div style="color: #dcdcaa; font-weight: 600; margin-bottom: 0.5rem;"><i class="fas fa-map-marker-alt me-1"></i>IP Geolocation</div>';
            html += '<div class="row small">';
            if (data.location.country) html += '<div class="col-6 mb-1"><span style="color: #808080;">Country:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.country) + '</span></div>';
            if (data.location.city) html += '<div class="col-6 mb-1"><span style="color: #808080;">City:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.city) + '</span></div>';
            if (data.location.region) html += '<div class="col-6 mb-1"><span style="color: #808080;">Region:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.region) + '</span></div>';
            if (data.location.org) html += '<div class="col-6 mb-1"><span style="color: #808080;">Org:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.org) + '</span></div>';
            if (data.location.loc) html += '<div class="col-12"><span style="color: #808080;">Coordinates:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.loc) + '</span></div>';
            html += '</div></div>';
        }

        $('#curlOutput').html(html);
    }

    function parseHttpHeaders(headerText) {
        if (!headerText) return '';
        var lines = headerText.split('\n');
        var result = '';
        lines.forEach(function(line) {
            line = escapeHtml(line);
            // HTTP status line
            if (line.match(/^HTTP\//)) {
                var statusMatch = line.match(/(\d{3})/);
                if (statusMatch) {
                    var code = parseInt(statusMatch[1]);
                    var statusColor = '#4ec9b0';
                    if (code >= 200 && code < 300) statusColor = '#6a9955';
                    else if (code >= 300 && code < 400) statusColor = '#569cd6';
                    else if (code >= 400 && code < 500) statusColor = '#d7ba7d';
                    else if (code >= 500) statusColor = '#f14c4c';
                    result += '<span style="color: ' + statusColor + '; font-weight: bold;">' + line + '</span>\n';
                } else {
                    result += line + '\n';
                }
            }
            // Header name: value
            else if (line.includes(':')) {
                var parts = line.split(':');
                var name = parts[0];
                var value = parts.slice(1).join(':');
                result += '<span style="color: #9cdcfe;">' + name + '</span>:<span style="color: #ce9178;">' + value + '</span>\n';
            } else {
                result += line + '\n';
            }
        });
        return result;
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function showError(message) {
        $('#curlOutput').html('<span class="text-danger">' + message + '</span>');
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
    }

    function shareResults() {
        if (!lastUrl) return;
        var url = window.location.origin + window.location.pathname +
            '?url=' + encodeURIComponent($('#ipaddress').val()) +
            '&scheme=' + $('#scheme').val() +
            '&port=' + $('#port').val();
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (lastResult && lastResult.success) {
            var text = 'Curl Results for ' + lastResult.url + '\n';
            text += '====================\n';
            text += 'Host: ' + lastResult.host + '\n';
            text += 'Resolved IP: ' + lastResult.resolvedIp + '\n';
            text += 'IP Version: ' + lastResult.ipVersion + '\n';
            text += 'Scheme: ' + lastResult.scheme + '\n';
            text += 'Port: ' + lastResult.port + '\n\n';
            text += 'HTTP Headers:\n' + lastResult.headers + '\n';
            if (lastResult.dnsRecords && lastResult.dnsRecords.length > 0) {
                text += '\nDNS Records:\n';
                lastResult.dnsRecords.forEach(function(rec) {
                    text += rec.type + ': ' + rec.value + ' (TTL: ' + rec.ttl + ')\n';
                });
            }
            if (lastResult.location) {
                text += '\nGeolocation:\n';
                if (lastResult.location.country) text += 'Country: ' + lastResult.location.country + '\n';
                if (lastResult.location.city) text += 'City: ' + lastResult.location.city + '\n';
                if (lastResult.location.region) text += 'Region: ' + lastResult.location.region + '\n';
                if (lastResult.location.org) text += 'Organization: ' + lastResult.location.org + '\n';
            }
            navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
        } else {
            var text = $('#curlOutput').text();
            navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
        }
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var url = params.get('url');
        var scheme = params.get('scheme');
        var port = params.get('port');
        if (url) {
            $('#ipaddress').val(url);
            if (scheme) {
                $('#scheme').val(scheme);
                $('.scheme-btn').removeClass('active');
                $('.scheme-btn[data-scheme="' + scheme + '"]').addClass('active');
            }
            if (port) {
                $('#port').val(port);
            }
            setTimeout(function() { performCurl(); }, 500);
        }
    }

    function copyCommand(cmd) {
        navigator.clipboard.writeText(cmd).then(function() { showToast('Command copied!'); });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;"><div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);"><i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
