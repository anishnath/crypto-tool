<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>CSR Signer - Sign Certificate Signing Requests Online | 8gwifi.org</title>
    <meta name="description" content="Sign CSR (Certificate Signing Request) online and generate X.509 certificates. Support for CRL distribution points and OCSP URLs. Free certificate signing tool for testing and development." />
    <meta name="keywords" content="CSR signer, sign certificate signing request, generate certificate from CSR, online CSR signing, X.509 certificate, CRL distribution point, OCSP, openssl sign CSR" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/signcsr.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "CSR Signer",
        "description": "Sign Certificate Signing Requests (CSR) online and generate X.509 certificates with CRL and OCSP extension support for testing and development environments.",
        "url": "https://8gwifi.org/signcsr.jsp",
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
        "datePublished": "2017-12-21",
        "dateModified": "2025-01-15"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Sign a CSR and Generate a Certificate",
        "description": "Step-by-step guide to sign a Certificate Signing Request and generate an X.509 certificate",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Prepare Your CSR",
                "text": "Have your Certificate Signing Request (CSR) ready in PEM format"
            },
            {
                "@type": "HowToStep",
                "name": "Choose Signing Key",
                "text": "Select whether to use the site's intermediate CA key or provide your own CA private key"
            },
            {
                "@type": "HowToStep",
                "name": "Add Extensions (Optional)",
                "text": "Optionally add CRL Distribution Point and OCSP URLs for certificate revocation checking"
            },
            {
                "@type": "HowToStep",
                "name": "Sign CSR",
                "text": "Click Sign CSR to generate your X.509 certificate"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org CSR Signer"
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
                "name": "What is a CSR (Certificate Signing Request)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A CSR is a block of encoded text containing information about the entity requesting the certificate (like domain name, organization, location) and the public key. It's submitted to a Certificate Authority (CA) to be signed and create a certificate."
                }
            },
            {
                "@type": "Question",
                "name": "What is a CRL Distribution Point?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A CRL (Certificate Revocation List) Distribution Point is a URL embedded in the certificate that points to where clients can download the list of revoked certificates. This allows clients to check if a certificate has been revoked."
                }
            },
            {
                "@type": "Question",
                "name": "What is OCSP?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "OCSP (Online Certificate Status Protocol) is a real-time protocol for checking certificate revocation status. Unlike CRLs which must be downloaded entirely, OCSP allows clients to query the status of a single certificate, making it more efficient."
                }
            },
            {
                "@type": "Question",
                "name": "Can I use my own CA to sign the CSR?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, you can provide your own CA private key (in RSA PEM format) to sign the CSR. This is useful if you have your own PKI infrastructure and want to issue certificates under your own CA."
                }
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }
        .card-header-custom {
            background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
        }
        .form-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .form-section-title {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }
        .key-option {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 0.5rem;
        }
        .key-option:hover {
            border-color: #6f42c1;
            background: #f8f5ff;
        }
        .key-option.active {
            border-color: #6f42c1;
            background: #f8f5ff;
        }
        .key-option input[type="radio"] {
            margin-right: 0.5rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 400px;
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
        .cert-block {
            background: #1e1e1e;
            color: #d4d4d4;
            border-radius: 8px;
            padding: 1rem;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
            white-space: pre-wrap;
            word-break: break-all;
            max-height: 350px;
            overflow-y: auto;
            margin-bottom: 1rem;
        }
        .cert-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .cert-title {
            font-weight: 600;
            color: #495057;
        }
        .btn-group-sm .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
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
            font-size: 0.85rem;
        }
        .terminal-body code {
            color: #ce9178;
        }
        .cmd-description {
            color: #6a9955;
            font-size: 0.8rem;
        }
        .eeat-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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
            border-color: #6f42c1;
            box-shadow: 0 2px 8px rgba(111, 66, 193, 0.15);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: #6f42c1;
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }
        .info-badge {
            display: inline-block;
            background: #f3e8ff;
            color: #6f42c1;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .error-message {
            background: #fff5f5;
            border: 1px solid #fc8181;
            border-radius: 8px;
            padding: 1rem;
            color: #c53030;
        }
        .success-badge {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .csr-textarea {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 mb-1">CSR Signer</h1>
        <p class="text-muted mb-0">Sign Certificate Signing Requests and generate X.509 certificates</p>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-shield-alt"></i>
        <span>By Anish Nath</span>
    </div>
</div>

<!-- Trust Indicators -->
<div class="mb-4">
    <span class="info-badge"><i class="fas fa-file-signature"></i> CSR Signing</span>
    <span class="info-badge"><i class="fas fa-certificate"></i> X.509 Output</span>
    <span class="info-badge"><i class="fas fa-link"></i> CRL Support</span>
    <span class="info-badge"><i class="fas fa-sync-alt"></i> OCSP Support</span>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-file-signature me-2"></i>Sign CSR</h5>
            </div>
            <div class="card-body">
                <form id="csrForm">
                    <input type="hidden" name="methodName" value="CSR_SIGNER">

                    <!-- Signing Key Options -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-key me-2"></i>Signing Key</div>
                        <div class="key-option active" id="siteKeyOption">
                            <input type="radio" name="encryptdecrypt" value="usesitekey" id="useSiteKey" checked>
                            <label for="useSiteKey" class="mb-0 cursor-pointer">
                                <strong>Use Site CA Key</strong>
                                <small class="d-block text-muted">Sign with 8gwifi.org intermediate CA</small>
                            </label>
                        </div>
                        <div class="key-option" id="ownKeyOption">
                            <input type="radio" name="encryptdecrypt" value="useprivatekey" id="useOwnKey">
                            <label for="useOwnKey" class="mb-0 cursor-pointer">
                                <strong>Use Your CA Key</strong>
                                <small class="d-block text-muted">Provide your own CA private key (RSA)</small>
                            </label>
                        </div>
                        <div id="privateKeyInput" style="display: none;" class="mt-3">
                            <textarea class="form-control csr-textarea" rows="6" id="p_privatekey" name="p_privatekey"
                                      placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;Your CA Private Key&#10;-----END RSA PRIVATE KEY-----"></textarea>
                            <small class="text-muted">Your CA private key in PEM format</small>
                        </div>
                    </div>

                    <!-- CSR Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-file-code me-2"></i>Certificate Signing Request</div>
                        <textarea class="form-control csr-textarea" rows="8" id="p_pem" name="p_pem" required
                                  placeholder="-----BEGIN CERTIFICATE REQUEST-----&#10;Paste your CSR here&#10;-----END CERTIFICATE REQUEST-----">-----BEGIN CERTIFICATE REQUEST-----
MIICsjCCAZoCAQAwbTELMAkGA1UEBhMCQVMxDjAMBgNVBAgTBWRzZGFzMQ4wDAYD
VQQHEwVhc2RhczEOMAwGA1UEChMFYXNkYXMxDDAKBgNVBAsTA2FkczEMMAoGA1UE
AxMDYXNkMRIwEAYJKoZIhvcNAQkBFgNhc2QwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDSLn8SAW1bntdPqbZiyvYMuPfsPDT/uXVzTzUMkdAOdr+u7gPy
YcS7JxRXjhDnYQRY0cjlEdg1gNN4e8yl6FIX7HgHozxvDTKsS3PKDy9H05swatGf
aT9VfcxIzhF6l5yCbGazf1DSXGW/J3o5w1OHxeclfBEW3byCbetsmdBTVFWQ0G0y
iKI8lUpv8wCqtQARWtOV6RVz7Av2fENE7PNiKfDFbnNIzIBjP/t+G60TefAgKN0A
osy9jPiApvidFkGvO5M/cLYc7SWVMHfyZ6kb/K76tUWO49d4aO5NUBg8z1BbjkvU
46+yubw5/YNC9y2LnXwS47RuarASwx78sn2rAgMBAAGgADANBgkqhkiG9w0BAQsF
AAOCAQEAcTF63HzM6LzTfbc4Wf58lTVXMhAHjLr/PgU6iNXtOHTNlPlLFcy4oCM8
xZi72BQfME0NMkMqmXlVIe7X1czVNXZHtlS0mX1VBb6GGF69IuGfqlJSPq2f5tMD
A1NT//qtbhHl5h4mPcrLYqBrusTgM6i9Zhdjoy1zHLjaRhzFwTfrkaeOQStqtQR4
+BRMx8vIJXDQtnNX6HubVqde8j5KByCM9HaQIiuTyhcPOeqTXo0LtVMsp5wdHW48
EtfvDLu4hobL097fASTgTqfJbUd25cu8V61cI394ZgsqxuYHQfE9FH+3e6VfKA1h
+FmNMVCIpxYhu8W3gfCEj8P0wqEG2A==
-----END CERTIFICATE REQUEST-----</textarea>
                    </div>

                    <!-- Certificate Extensions -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-puzzle-piece me-2"></i>Certificate Extensions (Optional)</div>

                        <div class="mb-3">
                            <label for="crl" class="form-label">CRL Distribution Point</label>
                            <input type="text" class="form-control" id="crl" name="crl"
                                   placeholder="https://example.com/crl.pem" maxlength="256">
                            <small class="text-muted">URL where clients can download the Certificate Revocation List</small>
                        </div>

                        <div class="mb-3">
                            <label for="ocsp" class="form-label">OCSP Responder URL</label>
                            <input type="text" class="form-control" id="ocsp" name="ocsp"
                                   placeholder="https://example.com/ocsp" maxlength="256">
                            <small class="text-muted">URL of the OCSP responder for real-time revocation checking</small>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-lg w-100" id="signBtn" style="background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%); color: white;">
                        <i class="fas fa-file-signature me-2"></i>Sign CSR
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-certificate me-2"></i>Generated Certificate</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-certificate fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Your signed certificate will appear here</p>
                        <small class="text-muted">Paste a CSR and click Sign</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: #6f42c1;" role="status">
                        <span class="visually-hidden">Signing...</span>
                    </div>
                    <p class="mt-2 mb-0">Signing CSR...</p>
                </div>

                <div class="result-content" id="resultContent">
                    <!-- Results will be dynamically inserted here -->
                </div>
            </div>
        </div>
    </div>
</div>

<!-- OpenSSL Commands Reference -->
<div class="card tool-card mb-4">
    <div class="card-header bg-dark text-white">
        <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL CSR Commands</h5>
    </div>
    <div class="card-body p-0">
        <div class="terminal-block">
            <div class="terminal-header">
                <span>Generate RSA Private Key</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl genrsa -out domain.key 2048">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Generate a 2048-bit RSA private key</div>
                <div>$ openssl genrsa -out <code>domain.key</code> 2048</div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Create CSR from Private Key</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -new -sha256 -key domain.key -out domain.csr">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Create a Certificate Signing Request</div>
                <div>$ openssl req -new -sha256 -key <code>domain.key</code> -out <code>domain.csr</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Verify CSR Contents</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -noout -text -in domain.csr">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># View CSR details in human-readable format</div>
                <div>$ openssl req -noout -text -in <code>domain.csr</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Sign CSR with CA Key</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl x509 -req -in domain.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out domain.crt -days 365 -sha256">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Sign CSR using your CA certificate and key</div>
                <div>$ openssl x509 -req -in <code>domain.csr</code> -CA <code>ca.crt</code> -CAkey <code>ca.key</code> \<br>  -CAcreateserial -out <code>domain.crt</code> -days 365 -sha256</div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related Certificate Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="csrfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-alt me-1"></i>CSR Generator</h6>
                <p>Create Certificate Signing Requests</p>
            </a>
            <a href="PemParserFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>Certificate Parser</h6>
                <p>Decode and analyze X.509 certificates</p>
            </a>
            <a href="SelfSignCertificateFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-certificate me-1"></i>Self-Signed Certificate</h6>
                <p>Generate self-signed certificates</p>
            </a>
            <a href="cafunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-sitemap me-1"></i>CA Chain Generator</h6>
                <p>Create full certificate chains</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding CSR Signing</h5>
    </div>
    <div class="card-body">
        <h6>What is a Certificate Signing Request (CSR)?</h6>
        <p>A CSR is a block of encoded text submitted to a Certificate Authority (CA) when applying for an SSL/TLS certificate. It contains:</p>
        <ul>
            <li><strong>Public Key:</strong> The public key that will be included in the certificate</li>
            <li><strong>Distinguished Name (DN):</strong> Information identifying the certificate owner (CN, O, OU, L, ST, C)</li>
            <li><strong>Signature:</strong> Digital signature proving possession of the corresponding private key</li>
        </ul>

        <h6 class="mt-4">The CSR Signing Process</h6>
        <div class="row">
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded">
                    <i class="fas fa-key fa-2x mb-2" style="color: #6f42c1;"></i>
                    <div><strong>1. Generate Key Pair</strong></div>
                    <small class="text-muted">Create RSA/ECDSA private & public key</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded">
                    <i class="fas fa-file-alt fa-2x mb-2" style="color: #6f42c1;"></i>
                    <div><strong>2. Create CSR</strong></div>
                    <small class="text-muted">Combine public key with identity info</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded">
                    <i class="fas fa-file-signature fa-2x mb-2" style="color: #6f42c1;"></i>
                    <div><strong>3. CA Signs CSR</strong></div>
                    <small class="text-muted">CA verifies and signs the request</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded">
                    <i class="fas fa-certificate fa-2x mb-2" style="color: #6f42c1;"></i>
                    <div><strong>4. Certificate Issued</strong></div>
                    <small class="text-muted">Signed X.509 certificate returned</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Certificate Revocation Methods</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong><i class="fas fa-list me-1"></i> CRL (Certificate Revocation List)</strong>
                    <ul class="mt-2 mb-0 small">
                        <li>Periodic list of revoked certificates</li>
                        <li>Client downloads entire list</li>
                        <li>Can be cached for offline use</li>
                        <li>Less network overhead but may be stale</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong><i class="fas fa-sync-alt me-1"></i> OCSP (Online Certificate Status Protocol)</strong>
                    <ul class="mt-2 mb-0 small">
                        <li>Real-time revocation checking</li>
                        <li>Query status of single certificate</li>
                        <li>Always up-to-date status</li>
                        <li>Requires network connectivity</li>
                    </ul>
                </div>
            </div>
        </div>

        <h6 class="mt-4">CSR Fields Explained</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Field</th>
                        <th>Abbreviation</th>
                        <th>Description</th>
                        <th>Example</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Common Name</td>
                        <td>CN</td>
                        <td>Domain name or hostname</td>
                        <td>www.example.com</td>
                    </tr>
                    <tr>
                        <td>Organization</td>
                        <td>O</td>
                        <td>Legal company name</td>
                        <td>Example Corp</td>
                    </tr>
                    <tr>
                        <td>Organizational Unit</td>
                        <td>OU</td>
                        <td>Department or division</td>
                        <td>IT Department</td>
                    </tr>
                    <tr>
                        <td>Locality</td>
                        <td>L</td>
                        <td>City or town</td>
                        <td>San Francisco</td>
                    </tr>
                    <tr>
                        <td>State/Province</td>
                        <td>ST</td>
                        <td>State or province name</td>
                        <td>California</td>
                    </tr>
                    <tr>
                        <td>Country</td>
                        <td>C</td>
                        <td>Two-letter country code</td>
                        <td>US</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="alert alert-info mb-0 mt-4">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Note:</strong> For production environments, always use certificates signed by trusted public CAs.
            This tool is intended for testing, development, and learning purposes.
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
$(document).ready(function() {
    // Key option toggle
    $('#siteKeyOption').click(function() {
        $('#useSiteKey').prop('checked', true);
        $('#siteKeyOption').addClass('active');
        $('#ownKeyOption').removeClass('active');
        $('#privateKeyInput').slideUp();
    });

    $('#ownKeyOption').click(function() {
        $('#useOwnKey').prop('checked', true);
        $('#ownKeyOption').addClass('active');
        $('#siteKeyOption').removeClass('active');
        $('#privateKeyInput').slideDown();
    });

    // Form submission
    $('#csrForm').submit(function(event) {
        event.preventDefault();

        var csr = $('#p_pem').val().trim();
        if (!csr) {
            showError('Please provide a Certificate Signing Request (CSR)');
            return;
        }

        // Show loading state
        $('#resultPlaceholder').hide();
        $('#resultContent').hide();
        $('#loadingSpinner').show();
        $('#signBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Signing...');

        $.ajax({
            type: "POST",
            url: "GenCAFunctionality",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loadingSpinner').hide();
                $('#signBtn').prop('disabled', false).html('<i class="fas fa-file-signature me-2"></i>Sign CSR');

                if (response.success) {
                    displayCertificate(response);
                } else {
                    showError(response.errorMessage || 'Failed to sign CSR');
                }
            },
            error: function(xhr, status, error) {
                $('#loadingSpinner').hide();
                $('#signBtn').prop('disabled', false).html('<i class="fas fa-file-signature me-2"></i>Sign CSR');
                showError('Request failed: ' + error);
            }
        });
    });
});

function displayCertificate(data) {
    var html = '<div class="mb-3">';
    html += '<span class="success-badge"><i class="fas fa-check-circle me-1"></i>CSR Signed Successfully</span>';

    // Metadata badges
    html += '<div class="mt-2">';
    if (data.usedProvidedKey) {
        html += '<span class="info-badge"><i class="fas fa-key me-1"></i>Your CA Key</span>';
    } else {
        html += '<span class="info-badge"><i class="fas fa-key me-1"></i>Site CA Key</span>';
    }
    if (data.crlDistributionPoint) {
        html += '<span class="info-badge"><i class="fas fa-list me-1"></i>CRL Added</span>';
    }
    if (data.ocspUrl) {
        html += '<span class="info-badge"><i class="fas fa-sync-alt me-1"></i>OCSP Added</span>';
    }
    html += '</div>';
    html += '</div>';

    // Certificate PEM
    html += '<div class="cert-header">';
    html += '<span class="cert-title"><i class="fas fa-certificate me-2"></i>X.509 Certificate (PEM)</span>';
    html += '<div class="btn-group btn-group-sm">';
    html += '<button class="btn btn-outline-secondary" onclick="copyToClipboard(\'certPem\')"><i class="fas fa-copy"></i> Copy</button>';
    html += '<button class="btn btn-outline-secondary" onclick="downloadFile(\'certPem\', \'certificate.crt\')"><i class="fas fa-download"></i> Download</button>';
    html += '<a class="btn btn-outline-success" href="PemParserFunctions.jsp?pem=' + encodeURIComponent(data.certificatePem) + '" target="_blank"><i class="fas fa-search"></i> Parse</a>';
    html += '</div></div>';
    html += '<div class="cert-block" id="certPem">' + escapeHtml(data.certificatePem) + '</div>';

    // Extension info if present
    if (data.crlDistributionPoint || data.ocspUrl) {
        html += '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i><strong>Certificate Extensions Added:</strong><ul class="mb-0 mt-2">';
        if (data.crlDistributionPoint) {
            html += '<li>CRL Distribution Point: <code>' + escapeHtml(data.crlDistributionPoint) + '</code></li>';
        }
        if (data.ocspUrl) {
            html += '<li>OCSP Responder: <code>' + escapeHtml(data.ocspUrl) + '</code></li>';
        }
        html += '</ul></div>';
    }

    $('#resultContent').html(html).show();
}

function showError(message) {
    var html = '<div class="error-message">';
    html += '<i class="fas fa-exclamation-circle me-2"></i>';
    html += '<strong>Error:</strong> ' + escapeHtml(message);
    html += '</div>';

    $('#resultPlaceholder').hide();
    $('#resultContent').html(html).show();
}

function copyToClipboard(elementId) {
    var text = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(text).then(function() {
        showToast('Copied to clipboard!');
    }).catch(function(err) {
        var textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        showToast('Copied to clipboard!');
    });
}

function downloadFile(elementId, filename) {
    var text = document.getElementById(elementId).innerText;
    var blob = new Blob([text], { type: 'text/plain' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

function copyCommand(btn) {
    var cmd = $(btn).data('cmd');
    navigator.clipboard.writeText(cmd).then(function() {
        showToast('Command copied!');
    });
}

function showToast(message) {
    var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
        '<div class="toast show" role="alert">' +
        '<div class="toast-body text-white rounded" style="background: #6f42c1;">' +
        '<i class="fas fa-check me-2"></i>' + message +
        '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() {
        toast.fadeOut(function() { toast.remove(); });
    }, 2000);
}

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
</script>

<%@ include file="body-close.jsp"%>
