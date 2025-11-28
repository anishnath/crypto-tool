<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Extract SSL Certificate from URL Online – Free | 8gwifi.org</title>
    <meta name="description" content="Extract SSL/TLS certificates from any website URL online. Get the full certificate chain in PEM format, view certificate details, and download certificates for analysis." />
    <meta name="keywords" content="extract ssl certificate, get certificate from url, ssl certificate chain, pem certificate, openssl s_client, certificate extraction, ssl checker" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/certs.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "SSL Certificate Extractor",
            "description": "Extract SSL/TLS certificates from any website URL. Get the full certificate chain in PEM format.",
            "url": "https://8gwifi.org/certs.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript",
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
            "datePublished": "2017-12-25",
            "dateModified": "2025-01-15"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Extract SSL Certificate from a Website",
            "description": "Step-by-step guide to extract SSL/TLS certificates from any URL",
            "step": [
                {
                    "@type": "HowToStep",
                    "name": "Enter URL",
                    "text": "Enter the domain name or URL of the website (e.g., google.com)"
                },
                {
                    "@type": "HowToStep",
                    "name": "Specify Port",
                    "text": "Enter the port number (default is 443 for HTTPS)"
                },
                {
                    "@type": "HowToStep",
                    "name": "Extract Certificates",
                    "text": "Click Extract to retrieve the full certificate chain in PEM format"
                }
            ],
            "tool": {
                "@type": "HowToTool",
                "name": "8gwifi.org SSL Certificate Extractor"
            }
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is a certificate chain?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "A certificate chain is a sequence of certificates where each certificate is signed by the next certificate in the chain, ending with a root CA certificate. It establishes trust from the server certificate to a trusted root."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What is PEM format?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "PEM (Privacy Enhanced Mail) is a Base64 encoded format for certificates, enclosed between -----BEGIN CERTIFICATE----- and -----END CERTIFICATE----- headers. It's the most common format for SSL certificates."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Why do I need the intermediate certificate?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Intermediate certificates bridge the trust between your server certificate and the root CA. Without them, browsers may show security warnings because they can't verify the complete chain of trust."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #0284c7;
            --theme-secondary: #0ea5e9;
            --theme-gradient: linear-gradient(135deg, #0284c7 0%, #0ea5e9 50%, #38bdf8 100%);
            --theme-light: #f0f9ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(2, 132, 199, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(2, 132, 199, 0.25);
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
            min-height: 300px;
            display: flex;
            flex-direction: column;
        }
        .result-placeholder {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
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
            margin-bottom: 0.25rem;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .terminal-block {
            background: #1e1e1e;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .terminal-header {
            background: #323232;
            color: #d4d4d4;
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .terminal-body {
            padding: 1rem;
            color: #4ec9b0;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
            overflow-x: auto;
        }
        .terminal-body code {
            color: #ce9178;
        }
        .cmd-description {
            color: #6a9955;
            font-size: 0.75rem;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(2, 132, 199, 0.2);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }
        .url-input-group {
            display: flex;
            gap: 0.5rem;
        }
        .url-input-group .url-field {
            flex: 1;
        }
        .url-input-group .port-field {
            width: 100px;
        }
        .protocol-badge {
            background: var(--theme-primary);
            color: white;
            padding: 0.5rem 0.75rem;
            border-radius: 6px 0 0 6px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">SSL Certificate Extractor</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-lock"></i> SSL/TLS</span>
            <span class="info-badge"><i class="fas fa-link"></i> Full Chain</span>
            <span class="info-badge"><i class="fas fa-file-code"></i> PEM Format</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-4 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-download me-2"></i>Extract Certificate</h5>
            </div>
            <div class="card-body">
                <form id="certForm">
                    <input type="hidden" name="methodName" value="CERTS_COMMAND">
                    <input type="hidden" name="getClientIpAddr" value="true">

                    <!-- URL Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-globe me-1"></i>Server Details</div>

                        <label class="small text-muted mb-1">Domain / Hostname</label>
                        <div class="input-group mb-2">
                            <span class="input-group-text" style="background: var(--theme-primary); color: white; font-size: 0.8rem;">
                                <i class="fas fa-lock me-1"></i>https://
                            </span>
                            <input type="text" class="form-control" id="ipaddress" name="ipaddress"
                                   value="8gwifi.org" placeholder="example.com" required>
                        </div>

                        <div class="row">
                            <div class="col-6">
                                <label class="small text-muted mb-1">Port</label>
                                <input type="text" class="form-control" id="port" name="port"
                                       value="443" placeholder="443"
                                       oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                            </div>
                            <div class="col-6">
                                <label class="small text-muted mb-1">Timeout (sec)</label>
                                <select class="form-select" id="timeout" name="timeout">
                                    <option value="5">5</option>
                                    <option value="10" selected>10</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Common Sites Quick Select -->
                    <div class="mb-3">
                        <label class="small text-muted mb-1">Quick Select</label>
                        <div class="d-flex flex-wrap gap-1">
                            <button type="button" class="btn btn-sm btn-outline-secondary quick-site" data-url="google.com">Google</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary quick-site" data-url="github.com">GitHub</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary quick-site" data-url="amazon.com">Amazon</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary quick-site" data-url="cloudflare.com">Cloudflare</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="submitBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-certificate me-2"></i>Extract Certificates
                    </button>
                </form>
            </div>
        </div>

        <!-- What You Get -->
        <div class="card tool-card mt-3">
            <div class="card-body">
                <h6 class="mb-3" style="color: var(--theme-primary);"><i class="fas fa-list-check me-2"></i>What You'll Get</h6>
                <ul class="small mb-0 ps-3">
                    <li class="mb-1">Server/Leaf certificate</li>
                    <li class="mb-1">Intermediate certificates</li>
                    <li class="mb-1">Root CA certificate (if sent)</li>
                    <li class="mb-1">All in PEM format</li>
                    <li>Ready for analysis or import</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-8 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-certificate me-2"></i>Certificate Chain</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="copyResult()" title="Copy All">
                        <i class="fas fa-copy"></i>
                    </button>
                    <button class="btn btn-sm btn-light" onclick="downloadResult()" title="Download">
                        <i class="fas fa-download"></i>
                    </button>
                </div>
            </div>
            <div class="card-body" style="overflow-y: auto; max-height: 500px;">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-certificate fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Certificates will appear here</p>
                        <small class="text-muted">Enter a URL and click Extract Certificates</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: var(--theme-primary);" role="status">
                        <span class="visually-hidden">Connecting...</span>
                    </div>
                    <p class="mt-2 mb-0">Connecting to server...</p>
                    <small class="text-muted">Extracting certificate chain</small>
                </div>

                <div class="result-content" id="resultContent">
                    <!-- Results will be dynamically inserted here -->
                </div>
            </div>
        </div>

        <!-- OpenSSL Commands Reference -->
        <div class="card tool-card mt-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Commands</h5>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Extract Certificate (Basic)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl s_client -connect example.com:443 </dev/null 2>/dev/null | openssl x509 -outform PEM">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Get server certificate only</div>
                        <div>$ openssl s_client -connect <code>example.com:443</code> &lt;/dev/null 2&gt;/dev/null | \<br>  openssl x509 -outform PEM</div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Extract Full Chain</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl s_client -showcerts -connect example.com:443 </dev/null 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Get entire certificate chain</div>
                        <div>$ openssl s_client -showcerts -connect <code>example.com:443</code> &lt;/dev/null | \<br>  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'</div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>With SNI (Server Name Indication)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl s_client -servername example.com -connect example.com:443 -showcerts </dev/null">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Required for servers hosting multiple domains</div>
                        <div>$ openssl s_client -servername <code>example.com</code> \<br>  -connect <code>example.com:443</code> -showcerts &lt;/dev/null</div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Save to File</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="echo | openssl s_client -servername example.com -connect example.com:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > certificate.pem">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Extract and save certificate to file</div>
                        <div>$ echo | openssl s_client -servername <code>example.com</code> \<br>  -connect <code>example.com:443</code> 2&gt;/dev/null | \<br>  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' &gt; <code>certificate.pem</code></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related SSL/TLS Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="PemParserFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-code me-1"></i>PEM Parser</h6>
                <p>Parse and decode PEM certificates</p>
            </a>
            <a href="certsverify.jsp" class="related-tool-card">
                <h6><i class="fas fa-check-double me-1"></i>Certificate Matcher</h6>
                <p>Verify certificate and key pairs</p>
            </a>
            <a href="ocsp.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>OCSP Checker</h6>
                <p>Check certificate revocation status</p>
            </a>
            <a href="sslscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>SSL Scanner</h6>
                <p>Scan SSL/TLS configuration</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding SSL Certificates</h5>
    </div>
    <div class="card-body">
        <h6>What is a Certificate Chain?</h6>
        <p>A certificate chain (or chain of trust) is a sequence of certificates that link your server certificate to a trusted root Certificate Authority (CA). The chain typically includes:</p>

        <div class="row mb-4">
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #dbeafe; border: 2px solid #3b82f6;">
                    <i class="fas fa-server fa-2x mb-2" style="color: #1d4ed8;"></i>
                    <div><strong>Server Certificate</strong></div>
                    <small class="text-muted">Your domain's certificate (leaf)</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #fef3c7; border: 2px solid #f59e0b;">
                    <i class="fas fa-link fa-2x mb-2" style="color: #d97706;"></i>
                    <div><strong>Intermediate CA</strong></div>
                    <small class="text-muted">Bridge between server and root</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #d1fae5; border: 2px solid #10b981;">
                    <i class="fas fa-building fa-2x mb-2" style="color: #059669;"></i>
                    <div><strong>Root CA</strong></div>
                    <small class="text-muted">Trusted by browsers/OS</small>
                </div>
            </div>
        </div>

        <!-- X.509 Certificate Structure -->
        <h6 class="mt-4"><i class="fas fa-sitemap me-1"></i>X.509 Certificate Structure</h6>
        <p class="small">An X.509 certificate contains the following key fields:</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th style="width: 25%;">Field</th>
                    <th>Description</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><strong>Version</strong></td>
                    <td>X.509 version (v1, v2, or v3). Most modern certificates use v3.</td>
                </tr>
                <tr>
                    <td><strong>Serial Number</strong></td>
                    <td>Unique identifier assigned by the CA. Used for revocation tracking.</td>
                </tr>
                <tr>
                    <td><strong>Signature Algorithm</strong></td>
                    <td>Algorithm used to sign (e.g., SHA256withRSA, SHA384withECDSA).</td>
                </tr>
                <tr>
                    <td><strong>Issuer</strong></td>
                    <td>Distinguished Name (DN) of the CA that issued the certificate.</td>
                </tr>
                <tr>
                    <td><strong>Validity Period</strong></td>
                    <td>Not Before and Not After dates defining certificate lifetime.</td>
                </tr>
                <tr>
                    <td><strong>Subject</strong></td>
                    <td>DN of the entity (domain/organization) the certificate is issued to.</td>
                </tr>
                <tr>
                    <td><strong>Public Key</strong></td>
                    <td>The subject's public key and algorithm (RSA, ECDSA, Ed25519).</td>
                </tr>
                <tr>
                    <td><strong>Extensions (v3)</strong></td>
                    <td>Additional attributes like SAN, Key Usage, Basic Constraints, etc.</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Certificate Types -->
        <h6 class="mt-4"><i class="fas fa-layer-group me-1"></i>Certificate Validation Levels</h6>
        <div class="row mb-3">
            <div class="col-md-4 mb-2">
                <div class="p-3 rounded h-100 border">
                    <div class="d-flex align-items-center mb-2">
                        <span class="badge bg-secondary me-2">DV</span>
                        <strong>Domain Validated</strong>
                    </div>
                    <small class="text-muted">
                        Basic validation - CA only verifies domain ownership via email, DNS, or HTTP challenge.
                        Fastest to obtain (minutes). Shows padlock only.
                    </small>
                </div>
            </div>
            <div class="col-md-4 mb-2">
                <div class="p-3 rounded h-100 border">
                    <div class="d-flex align-items-center mb-2">
                        <span class="badge bg-primary me-2">OV</span>
                        <strong>Organization Validated</strong>
                    </div>
                    <small class="text-muted">
                        CA verifies organization identity through business records.
                        Takes 1-3 days. Organization name visible in certificate details.
                    </small>
                </div>
            </div>
            <div class="col-md-4 mb-2">
                <div class="p-3 rounded h-100 border">
                    <div class="d-flex align-items-center mb-2">
                        <span class="badge bg-success me-2">EV</span>
                        <strong>Extended Validation</strong>
                    </div>
                    <small class="text-muted">
                        Strictest validation - legal, operational, and physical verification.
                        Takes 1-2 weeks. Previously showed green bar in browsers.
                    </small>
                </div>
            </div>
        </div>

        <!-- Key Extensions -->
        <h6 class="mt-4"><i class="fas fa-puzzle-piece me-1"></i>Important X.509 Extensions</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Extension</th>
                    <th>Purpose</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><strong>Subject Alternative Name (SAN)</strong></td>
                    <td>Additional domains/IPs the certificate covers. Essential for multi-domain certs.</td>
                </tr>
                <tr>
                    <td><strong>Key Usage</strong></td>
                    <td>Permitted uses: Digital Signature, Key Encipherment, Certificate Signing, etc.</td>
                </tr>
                <tr>
                    <td><strong>Extended Key Usage (EKU)</strong></td>
                    <td>Specific purposes: Server Auth (TLS), Client Auth, Code Signing, Email Protection.</td>
                </tr>
                <tr>
                    <td><strong>Basic Constraints</strong></td>
                    <td>Indicates if certificate is a CA (can sign other certs) and path length limit.</td>
                </tr>
                <tr>
                    <td><strong>Authority Info Access (AIA)</strong></td>
                    <td>URLs for OCSP responder and CA certificate (issuer) download.</td>
                </tr>
                <tr>
                    <td><strong>CRL Distribution Points</strong></td>
                    <td>URLs where Certificate Revocation Lists can be downloaded.</td>
                </tr>
                <tr>
                    <td><strong>Certificate Policies</strong></td>
                    <td>OIDs indicating validation level (DV/OV/EV) and CA practices.</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- TLS Handshake -->
        <h6 class="mt-4"><i class="fas fa-handshake me-1"></i>TLS Handshake Overview</h6>
        <p class="small">When you connect to an HTTPS website, the following happens:</p>
        <div class="row">
            <div class="col-12">
                <div class="d-flex flex-wrap align-items-center justify-content-center gap-2 mb-3 small">
                    <div class="p-2 rounded text-center" style="background: #dbeafe; min-width: 120px;">
                        <strong>1. Client Hello</strong><br>
                        <small>Supported ciphers, TLS version</small>
                    </div>
                    <i class="fas fa-arrow-right text-muted"></i>
                    <div class="p-2 rounded text-center" style="background: #fef3c7; min-width: 120px;">
                        <strong>2. Server Hello</strong><br>
                        <small>Selected cipher, certificate</small>
                    </div>
                    <i class="fas fa-arrow-right text-muted"></i>
                    <div class="p-2 rounded text-center" style="background: #d1fae5; min-width: 120px;">
                        <strong>3. Verify Cert</strong><br>
                        <small>Chain validation, revocation</small>
                    </div>
                    <i class="fas fa-arrow-right text-muted"></i>
                    <div class="p-2 rounded text-center" style="background: #fce7f3; min-width: 120px;">
                        <strong>4. Key Exchange</strong><br>
                        <small>Generate session keys</small>
                    </div>
                    <i class="fas fa-arrow-right text-muted"></i>
                    <div class="p-2 rounded text-center" style="background: #e0e7ff; min-width: 120px;">
                        <strong>5. Encrypted</strong><br>
                        <small>Secure communication</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Certificate Formats -->
        <h6 class="mt-4"><i class="fas fa-file-alt me-1"></i>Certificate Formats</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Format</th>
                    <th>Extension</th>
                    <th>Encoding</th>
                    <th>Description</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><strong>PEM</strong></td>
                    <td>.pem, .crt, .cer, .key</td>
                    <td>Base64 (ASCII)</td>
                    <td>Most common format. Human-readable with BEGIN/END headers. Can contain multiple certs.</td>
                </tr>
                <tr>
                    <td><strong>DER</strong></td>
                    <td>.der, .cer</td>
                    <td>Binary</td>
                    <td>Raw binary ASN.1 encoding. Common in Java and Windows. Single certificate only.</td>
                </tr>
                <tr>
                    <td><strong>PKCS#7 / P7B</strong></td>
                    <td>.p7b, .p7c</td>
                    <td>Base64 or Binary</td>
                    <td>Contains certificate chain only (no private key). Used by Windows and Java Tomcat.</td>
                </tr>
                <tr>
                    <td><strong>PKCS#12 / PFX</strong></td>
                    <td>.pfx, .p12</td>
                    <td>Binary</td>
                    <td>Password-protected archive with certificate + private key + chain. Used for export/import.</td>
                </tr>
                <tr>
                    <td><strong>JKS</strong></td>
                    <td>.jks, .keystore</td>
                    <td>Binary</td>
                    <td>Java KeyStore format. Being replaced by PKCS#12 in modern Java versions.</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Common Issues -->
        <h6 class="mt-4"><i class="fas fa-exclamation-triangle me-1"></i>Common Issues & Solutions</h6>
        <div class="accordion accordion-flush" id="issuesAccordion">
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed py-2" type="button" data-toggle="collapse" data-target="#issue1">
                        <strong>Incomplete Certificate Chain</strong>
                    </button>
                </h2>
                <div id="issue1" class="accordion-collapse collapse" data-parent="#issuesAccordion">
                    <div class="accordion-body small">
                        <p><strong>Symptom:</strong> Works in browsers but fails in curl, mobile apps, or API clients with "unable to verify" errors.</p>
                        <p><strong>Cause:</strong> Server not sending intermediate certificates. Browsers cache intermediates, other clients don't.</p>
                        <p><strong>Fix:</strong> Configure your server to send the full chain. Concatenate server cert + intermediates in your cert file:</p>
                        <code>cat server.crt intermediate.crt > fullchain.crt</code>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed py-2" type="button" data-toggle="collapse" data-target="#issue2">
                        <strong>Certificate Name Mismatch</strong>
                    </button>
                </h2>
                <div id="issue2" class="accordion-collapse collapse" data-parent="#issuesAccordion">
                    <div class="accordion-body small">
                        <p><strong>Symptom:</strong> Browser shows "Your connection is not private" or hostname verification fails.</p>
                        <p><strong>Cause:</strong> Certificate CN/SAN doesn't match the domain you're accessing.</p>
                        <p><strong>Fix:</strong> Ensure your certificate includes all domains in Subject Alternative Name (SAN). Wildcard certs (*.example.com) don't cover the apex domain (example.com).</p>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed py-2" type="button" data-toggle="collapse" data-target="#issue3">
                        <strong>Expired Certificate</strong>
                    </button>
                </h2>
                <div id="issue3" class="accordion-collapse collapse" data-parent="#issuesAccordion">
                    <div class="accordion-body small">
                        <p><strong>Symptom:</strong> NET::ERR_CERT_DATE_INVALID or "Certificate has expired" errors.</p>
                        <p><strong>Cause:</strong> Certificate's "Not After" date has passed, or server clock is wrong.</p>
                        <p><strong>Fix:</strong> Renew the certificate. Use auto-renewal tools like certbot. Also check server's system time with <code>date</code> command.</p>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed py-2" type="button" data-toggle="collapse" data-target="#issue4">
                        <strong>Self-Signed Certificate</strong>
                    </button>
                </h2>
                <div id="issue4" class="accordion-collapse collapse" data-parent="#issuesAccordion">
                    <div class="accordion-body small">
                        <p><strong>Symptom:</strong> ERR_CERT_AUTHORITY_INVALID or "Certificate is not trusted".</p>
                        <p><strong>Cause:</strong> Certificate was not signed by a trusted CA. The issuer is the same as the subject.</p>
                        <p><strong>Fix:</strong> For production, get a certificate from a trusted CA (Let's Encrypt is free). For development, add the self-signed cert to your trust store.</p>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed py-2" type="button" data-toggle="collapse" data-target="#issue5">
                        <strong>Wrong Certificate Returned (SNI)</strong>
                    </button>
                </h2>
                <div id="issue5" class="accordion-collapse collapse" data-parent="#issuesAccordion">
                    <div class="accordion-body small">
                        <p><strong>Symptom:</strong> Server returns certificate for wrong domain, or default/fallback certificate.</p>
                        <p><strong>Cause:</strong> Server Name Indication (SNI) not configured correctly. Multiple sites sharing one IP need SNI.</p>
                        <p><strong>Fix:</strong> Ensure your client sends SNI (use <code>-servername</code> with openssl). Check server's virtual host configuration.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Certificate Authorities -->
        <h6 class="mt-4"><i class="fas fa-building me-1"></i>Major Certificate Authorities</h6>
        <div class="row">
            <div class="col-md-6">
                <ul class="small mb-0">
                    <li><strong>Let's Encrypt</strong> - Free, automated DV certificates (90-day validity)</li>
                    <li><strong>DigiCert</strong> - Enterprise, high-assurance certificates</li>
                    <li><strong>Sectigo (Comodo)</strong> - Wide range of certificate products</li>
                    <li><strong>GlobalSign</strong> - Enterprise and IoT certificates</li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul class="small mb-0">
                    <li><strong>GoDaddy</strong> - Domain registrar with SSL services</li>
                    <li><strong>Entrust</strong> - Government and enterprise focused</li>
                    <li><strong>Amazon (ACM)</strong> - Free certs for AWS services</li>
                    <li><strong>Cloudflare</strong> - Free certs for proxied domains</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
    var lastResponse = null;

    $(document).ready(function() {
        // Quick site selection
        $('.quick-site').click(function() {
            $('#ipaddress').val($(this).data('url'));
        });

        // Form submission
        $('#certForm').submit(function(event) {
            event.preventDefault();

            var url = $('#ipaddress').val().trim();
            var port = $('#port').val().trim() || '443';

            if (!url) {
                showToast('Please enter a domain or URL');
                return;
            }

            // Remove protocol if present
            url = url.replace(/^https?:\/\//, '').replace(/\/.*$/, '');
            $('#ipaddress').val(url);

            // Show loading state
            $('#resultPlaceholder').hide();
            $('#resultContent').hide();
            $('#resultActions').hide();
            $('#loadingSpinner').show();
            $('#submitBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Connecting...');

            $.ajax({
                type: "POST",
                url: "GenCAFunctionality",
                data: $("#certForm").serialize(),
                dataType: "json",
                success: function(response) {
                    $('#loadingSpinner').hide();
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-certificate me-2"></i>Extract Certificates');

                    if (response.success) {
                        lastResponse = response;
                        renderCertificates(response);
                        $('#resultActions').show();
                    } else {
                        renderError(response);
                    }
                },
                error: function(xhr, status, error) {
                    $('#loadingSpinner').hide();
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-certificate me-2"></i>Extract Certificates');
                    $('#resultContent').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>Error connecting to server. Please check the URL and try again.</div>').show();
                }
            });
        });
    });

    function renderCertificates(response) {
        var html = '';

        // Summary header
        html += '<div class="alert alert-success mb-3">';
        html += '<div class="d-flex align-items-center">';
        html += '<i class="fas fa-check-circle fa-2x me-3"></i>';
        html += '<div>';
        html += '<strong>Successfully extracted ' + response.certificateCount + ' certificate(s)</strong><br>';
        html += '<small class="text-muted">from <strong>' + response.hostname + ':' + response.port + '</strong></small>';
        html += '</div>';
        html += '</div>';
        html += '</div>';

        // Certificate tabs
        html += '<ul class="nav nav-tabs mb-3" id="certTabs" role="tablist">';
        response.certificates.forEach(function(cert, idx) {
            var active = idx === 0 ? 'active' : '';
            var icon = getCertIcon(cert.type);
            html += '<li class="nav-item" role="presentation">';
            html += '<button class="nav-link ' + active + '" id="cert-tab-' + cert.index + '" data-toggle="tab" data-target="#cert-' + cert.index + '" type="button">';
            html += '<i class="' + icon + ' me-1"></i>' + getCertLabel(cert.type) + ' #' + cert.index;
            html += '</button>';
            html += '</li>';
        });
        html += '<li class="nav-item" role="presentation">';
        html += '<button class="nav-link" id="fullchain-tab" data-toggle="tab" data-target="#fullchain" type="button">';
        html += '<i class="fas fa-link me-1"></i>Full Chain';
        html += '</button>';
        html += '</li>';
        html += '</ul>';

        // Tab content
        html += '<div class="tab-content" id="certTabContent">';
        response.certificates.forEach(function(cert, idx) {
            var active = idx === 0 ? 'show active' : '';
            html += '<div class="tab-pane fade ' + active + '" id="cert-' + cert.index + '" role="tabpanel">';
            html += '<div class="d-flex justify-content-between align-items-center mb-2">';
            html += '<span class="badge ' + getBadgeClass(cert.type) + '">' + getCertLabel(cert.type) + ' Certificate</span>';
            html += '<button class="btn btn-sm btn-outline-primary" onclick="copyCert(' + (idx) + ')"><i class="fas fa-copy me-1"></i>Copy</button>';
            html += '</div>';
            html += '<textarea class="form-control font-monospace" rows="12" readonly style="font-size: 0.75rem; background: #f8fafc;">' + cert.pem + '</textarea>';
            html += '<div class="mt-2 d-flex gap-2">';
            html += '<a href="javascript:void(0)" onclick="parseCert(' + idx + ')" class="small btn btn-sm btn-outline-primary"><i class="fas fa-search me-1"></i>Parse Certificate</a>';
            html += '<a href="javascript:void(0)" onclick="openInPemParser(' + idx + ')" class="small btn btn-sm btn-outline-secondary"><i class="fas fa-external-link-alt me-1"></i>Open in PEM Parser</a>';
            html += '</div>';
            html += '</div>';
        });

        // Full chain tab
        html += '<div class="tab-pane fade" id="fullchain" role="tabpanel">';
        html += '<div class="d-flex justify-content-between align-items-center mb-2">';
        html += '<span class="badge bg-dark">Complete Certificate Chain</span>';
        html += '<div class="btn-group btn-group-sm">';
        html += '<button class="btn btn-outline-primary" onclick="copyFullChain()"><i class="fas fa-copy me-1"></i>Copy All</button>';
        html += '<button class="btn btn-outline-secondary" onclick="parseFullChain()"><i class="fas fa-search me-1"></i>Parse Chain</button>';
        html += '</div>';
        html += '</div>';
        html += '<textarea class="form-control font-monospace" rows="12" readonly style="font-size: 0.75rem; background: #f8fafc;" id="fullChainPem">' + response.fullChainPem + '</textarea>';
        html += '</div>';

        html += '</div>';

        $('#resultContent').html(html).show();

        // Initialize tab clicks
        $('#certTabs button').click(function(e) {
            e.preventDefault();
            var target = $(this).data('target');
            $('#certTabs button').removeClass('active');
            $(this).addClass('active');
            $('.tab-pane').removeClass('show active');
            $(target).addClass('show active');
        });
    }

    function renderError(response) {
        var html = '<div class="alert alert-danger">';
        html += '<div class="d-flex align-items-start">';
        html += '<i class="fas fa-exclamation-triangle fa-2x me-3 mt-1"></i>';
        html += '<div>';
        html += '<strong>Failed to extract certificates</strong><br>';
        if (response.hostname) {
            html += '<small class="text-muted">Target: ' + response.hostname + ':' + response.port + '</small><br>';
        }
        html += '<span class="mt-2 d-block">' + response.errorMessage + '</span>';
        html += '</div>';
        html += '</div>';
        html += '</div>';
        $('#resultContent').html(html).show();
    }

    function getCertIcon(type) {
        switch(type) {
            case 'server': return 'fas fa-server';
            case 'intermediate': return 'fas fa-link';
            case 'root': return 'fas fa-building';
            default: return 'fas fa-certificate';
        }
    }

    function getCertLabel(type) {
        switch(type) {
            case 'server': return 'Server';
            case 'intermediate': return 'Intermediate';
            case 'root': return 'Root CA';
            default: return 'Certificate';
        }
    }

    function getBadgeClass(type) {
        switch(type) {
            case 'server': return 'bg-primary';
            case 'intermediate': return 'bg-warning text-dark';
            case 'root': return 'bg-success';
            default: return 'bg-secondary';
        }
    }

    function copyCert(index) {
        if (lastResponse && lastResponse.certificates[index]) {
            navigator.clipboard.writeText(lastResponse.certificates[index].pem).then(function() {
                showToast('Certificate copied!');
            });
        }
    }

    function copyFullChain() {
        if (lastResponse && lastResponse.fullChainPem) {
            navigator.clipboard.writeText(lastResponse.fullChainPem).then(function() {
                showToast('Full chain copied!');
            });
        }
    }

    function parseCert(index) {
        if (lastResponse && lastResponse.certificates[index]) {
            var pem = lastResponse.certificates[index].pem;
            var url = 'PemParserFunctions.jsp?pem=' + encodeURIComponent(pem);
            window.open(url, '_blank');
        }
    }

    function openInPemParser(index) {
        parseCert(index);
    }

    function parseFullChain() {
        if (lastResponse && lastResponse.fullChainPem) {
            var url = 'PemParserFunctions.jsp?pem=' + encodeURIComponent(lastResponse.fullChainPem);
            window.open(url, '_blank');
        }
    }

    function copyCommand(btn) {
        var cmd = $(btn).data('cmd');
        navigator.clipboard.writeText(cmd).then(function() {
            showToast('Command copied!');
        });
    }

    function copyResult() {
        if (lastResponse && lastResponse.fullChainPem) {
            navigator.clipboard.writeText(lastResponse.fullChainPem).then(function() {
                showToast('Certificates copied!');
            });
        }
    }

    function downloadResult() {
        if (lastResponse && lastResponse.fullChainPem) {
            var domain = lastResponse.hostname.replace(/\./g, '_');
            var blob = new Blob([lastResponse.fullChainPem], {type: 'application/x-pem-file'});
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = domain + '_chain.pem';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            showToast('Certificate chain downloaded!');
        }
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show" role="alert">' +
            '<div class="toast-body text-white rounded" style="background: linear-gradient(135deg, #0284c7 0%, #0ea5e9 100%);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message +
            '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() {
            toast.fadeOut(function() { toast.remove(); });
        }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
