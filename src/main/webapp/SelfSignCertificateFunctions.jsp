<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Self-Signed Certificate Generator - X.509 Certificate with SAN Support Free | 8gwifi.org</title>
    <meta name="description" content="Generate self-signed X.509 certificates online with Subject Alternative Names (SAN), custom expiry, and version support. Free SSL/TLS certificate generator for development and testing." />
    <meta name="keywords" content="self-signed certificate generator, X.509 certificate, SSL certificate, TLS certificate, SAN certificate, subject alternative names, openssl certificate, development certificate, test certificate" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/SelfSignCertificateFunctions.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Self-Signed Certificate Generator",
        "description": "Generate X.509 self-signed certificates with Subject Alternative Names (SAN), custom expiry periods, and certificate version support for development and testing environments.",
        "url": "https://8gwifi.org/SelfSignCertificateFunctions.jsp",
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
        "name": "How to Generate a Self-Signed Certificate",
        "description": "Step-by-step guide to create a self-signed X.509 certificate with custom settings",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Choose Key Generation Method",
                "text": "Select whether to generate a new RSA private key or use your existing private key"
            },
            {
                "@type": "HowToStep",
                "name": "Enter Certificate Details",
                "text": "Fill in the hostname (Common Name), organization, department, email, city, state, and country"
            },
            {
                "@type": "HowToStep",
                "name": "Configure Certificate Options",
                "text": "Set the certificate expiration period, add Subject Alternative Names (SANs), and select X.509 version"
            },
            {
                "@type": "HowToStep",
                "name": "Generate Certificate",
                "text": "Click Generate to create your self-signed certificate and private key pair"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org Self-Signed Certificate Generator"
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
                "name": "What is a self-signed certificate?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A self-signed certificate is a public-key certificate signed by its own private key rather than a Certificate Authority (CA). The signature protects data integrity but doesn't provide third-party authenticity verification. Self-signed certificates are commonly used in development, testing, and internal environments."
                }
            },
            {
                "@type": "Question",
                "name": "When should I use a self-signed certificate?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use self-signed certificates for: local development environments, internal testing, private networks, learning SSL/TLS concepts, and situations where you control both the server and all clients. For production public-facing websites, use certificates from trusted Certificate Authorities."
                }
            },
            {
                "@type": "Question",
                "name": "What are Subject Alternative Names (SANs)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Subject Alternative Names (SANs) allow a single certificate to secure multiple domain names, subdomains, or IP addresses. For example, one certificate can cover example.com, www.example.com, and api.example.com using SANs."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between X.509 v2 and v3 certificates?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "X.509 v3 certificates support extensions like Subject Alternative Names (SAN), Key Usage, and Extended Key Usage, making them more flexible for modern PKI requirements. X.509 v2 added issuer and subject unique identifiers but is rarely used. Most modern certificates use v3."
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            border-color: #28a745;
            background: #f8fff8;
        }
        .key-option.active {
            border-color: #28a745;
            background: #f8fff8;
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
            max-height: 300px;
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
        .openssl-cmd {
            margin-bottom: 0.5rem;
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
            border-color: #28a745;
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.15);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: #28a745;
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }
        .info-badge {
            display: inline-block;
            background: #e8f5e9;
            color: #2e7d32;
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
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 mb-1">Self-Signed Certificate Generator</h1>
        <p class="text-muted mb-0">Generate X.509 certificates with SAN support for development and testing</p>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-shield-alt"></i>
        <span>By Anish Nath</span>
    </div>
</div>

<!-- Trust Indicators -->
<div class="mb-4">
    <span class="info-badge"><i class="fas fa-lock"></i> Client-Side Processing</span>
    <span class="info-badge"><i class="fas fa-certificate"></i> X.509 v2/v3 Support</span>
    <span class="info-badge"><i class="fas fa-network-wired"></i> SAN Support</span>
    <span class="info-badge"><i class="fas fa-clock"></i> Custom Expiry</span>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-certificate me-2"></i>Certificate Details</h5>
            </div>
            <div class="card-body">
                <form id="certForm">
                    <input type="hidden" name="methodName" value="X509_CERTIFICATECREATOR">

                    <!-- Key Generation Options -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-key me-2"></i>Private Key Option</div>
                        <div class="key-option active" id="newKeyOption">
                            <input type="radio" name="encryptdecrypt" value="usesitekey" id="generateNewKey" checked>
                            <label for="generateNewKey" class="mb-0 cursor-pointer">
                                <strong>Generate New RSA Key</strong>
                                <small class="d-block text-muted">Create a new 2048-bit RSA private key</small>
                            </label>
                        </div>
                        <div class="key-option" id="existingKeyOption">
                            <input type="radio" name="encryptdecrypt" value="useprivatekey" id="useExistingKey">
                            <label for="useExistingKey" class="mb-0 cursor-pointer">
                                <strong>Use Existing Private Key</strong>
                                <small class="d-block text-muted">Provide your own RSA private key</small>
                            </label>
                        </div>
                        <div id="privateKeyInput" style="display: none;" class="mt-3">
                            <textarea class="form-control" rows="5" id="p_privatekey" name="p_privatekey"
                                      placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;...&#10;-----END RSA PRIVATE KEY-----"></textarea>
                        </div>
                    </div>

                    <!-- Subject Information -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-user me-2"></i>Subject Information</div>

                        <div class="mb-3">
                            <label for="hostname" class="form-label">
                                Hostname (CN) <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="hostname" name="hostname"
                                   placeholder="example.com" maxlength="64" required>
                            <small class="text-muted">Common Name - usually your domain name</small>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="company" class="form-label">Organization (O)</label>
                                <input type="text" class="form-control" id="company" name="company"
                                       placeholder="My Company" maxlength="64">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="department" class="form-label">Department (OU)</label>
                                <input type="text" class="form-control" id="department" name="department"
                                       placeholder="IT Department" maxlength="64">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email (E)</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="admin@example.com" maxlength="64">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="city" class="form-label">City (L)</label>
                                <input type="text" class="form-control" id="city" name="city"
                                       placeholder="San Francisco" maxlength="64">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="state" class="form-label">State (ST)</label>
                                <input type="text" class="form-control" id="state" name="state"
                                       placeholder="California" maxlength="64">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="country" class="form-label">Country (C)</label>
                            <select id="country" class="form-select" name="country">
                                <option value="US" selected>United States</option>
                                <option value="CA">Canada</option>
                                <option value="GB">United Kingdom</option>
                                <option value="DE">Germany</option>
                                <option value="FR">France</option>
                                <option value="AU">Australia</option>
                                <option value="JP">Japan</option>
                                <option value="IN">India</option>
                                <option value="CN">China</option>
                                <option value="BR">Brazil</option>
                                <option value="AF">Afghanistan</option>
                                <option value="AL">Albania</option>
                                <option value="DZ">Algeria</option>
                                <option value="AR">Argentina</option>
                                <option value="AT">Austria</option>
                                <option value="BE">Belgium</option>
                                <option value="CH">Switzerland</option>
                                <option value="CL">Chile</option>
                                <option value="CO">Colombia</option>
                                <option value="CZ">Czech Republic</option>
                                <option value="DK">Denmark</option>
                                <option value="EG">Egypt</option>
                                <option value="ES">Spain</option>
                                <option value="FI">Finland</option>
                                <option value="GR">Greece</option>
                                <option value="HK">Hong Kong</option>
                                <option value="HU">Hungary</option>
                                <option value="ID">Indonesia</option>
                                <option value="IE">Ireland</option>
                                <option value="IL">Israel</option>
                                <option value="IT">Italy</option>
                                <option value="KR">Korea, Republic of</option>
                                <option value="MX">Mexico</option>
                                <option value="MY">Malaysia</option>
                                <option value="NL">Netherlands</option>
                                <option value="NO">Norway</option>
                                <option value="NZ">New Zealand</option>
                                <option value="PH">Philippines</option>
                                <option value="PK">Pakistan</option>
                                <option value="PL">Poland</option>
                                <option value="PT">Portugal</option>
                                <option value="RO">Romania</option>
                                <option value="RU">Russian Federation</option>
                                <option value="SA">Saudi Arabia</option>
                                <option value="SE">Sweden</option>
                                <option value="SG">Singapore</option>
                                <option value="TH">Thailand</option>
                                <option value="TR">Turkey</option>
                                <option value="TW">Taiwan</option>
                                <option value="UA">Ukraine</option>
                                <option value="VN">Viet Nam</option>
                                <option value="ZA">South Africa</option>
                            </select>
                        </div>
                    </div>

                    <!-- Certificate Options -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-2"></i>Certificate Options</div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="expiry" class="form-label">Validity Period</label>
                                <select id="expiry" class="form-select" name="expiry">
                                    <option value="3653" selected>10 Years</option>
                                    <option value="1096">3 Years</option>
                                    <option value="366">1 Year</option>
                                    <option value="90">90 Days</option>
                                    <option value="30">30 Days</option>
                                    <option value="7">7 Days</option>
                                    <option value="1">1 Day</option>
                                    <option value="-100">Expired (100 days ago)</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">X.509 Version</label>
                                <div class="d-flex gap-3 mt-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="version" value="3" id="v3" checked>
                                        <label class="form-check-label" for="v3">v3 (Recommended)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="version" value="2" id="v2">
                                        <label class="form-check-label" for="v2">v2</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="alt_name" class="form-label">Subject Alternative Names (SAN)</label>
                            <input type="text" class="form-control" id="alt_name" name="alt_name"
                                   placeholder="*.example.com, api.example.com, localhost" maxlength="256">
                            <small class="text-muted">Comma-separated list of additional domain names or IPs</small>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success btn-lg w-100" id="generateBtn">
                        <i class="fas fa-certificate me-2"></i>Generate Certificate
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-file-code me-2"></i>Generated Certificate</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-certificate fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Your certificate will appear here</p>
                        <small class="text-muted">Fill in the form and click Generate</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border text-success" role="status">
                        <span class="visually-hidden">Generating...</span>
                    </div>
                    <p class="mt-2 mb-0">Generating certificate...</p>
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
        <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Command Reference</h5>
    </div>
    <div class="card-body p-0">
        <div class="terminal-block">
            <div class="terminal-header">
                <span>Generate Self-Signed Certificate</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privatekey.key -out certificate.crt">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Generate a new private key and self-signed certificate</div>
                <div class="openssl-cmd">$ openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout <code>privatekey.key</code> -out <code>certificate.crt</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Generate with Existing Key</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -x509 -sha256 -days 365 -key privatekey.key -out certificate.crt">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Generate certificate using existing private key</div>
                <div class="openssl-cmd">$ openssl req -x509 -sha256 -days 365 -key <code>privatekey.key</code> -out <code>certificate.crt</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Generate with SAN Extension</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj '/CN=example.com' -addext 'subjectAltName=DNS:example.com,DNS:*.example.com'">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Generate certificate with Subject Alternative Names</div>
                <div class="openssl-cmd">$ openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 \<br>  -keyout <code>key.pem</code> -out <code>cert.pem</code> \<br>  -subj '/CN=example.com' \<br>  -addext 'subjectAltName=DNS:example.com,DNS:*.example.com'</div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Verify Certificate</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl x509 -in certificate.crt -text -noout">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># View certificate details</div>
                <div class="openssl-cmd">$ openssl x509 -in <code>certificate.crt</code> -text -noout</div>
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
            <a href="PemParserFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>Certificate Parser</h6>
                <p>Decode and analyze X.509 certificates</p>
            </a>
            <a href="cafunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-sitemap me-1"></i>CA Chain Generator</h6>
                <p>Create Root CA, Intermediate, and Server certificates</p>
            </a>
            <a href="csrfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-signature me-1"></i>CSR Generator</h6>
                <p>Generate Certificate Signing Requests</p>
            </a>
            <a href="pempublic.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>Extract Public Key</h6>
                <p>Extract public key from certificates</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Self-Signed Certificates</h5>
    </div>
    <div class="card-body">
        <h6>What is a Self-Signed Certificate?</h6>
        <p>A self-signed certificate is a public-key certificate whose digital signature is verified by the public key contained within the certificate itself. Unlike CA-signed certificates, self-signed certificates are signed with their own private key rather than a trusted Certificate Authority.</p>
        <p>In the PKI (Public Key Infrastructure) trust model, certificates are normally signed by a Certificate Authority (CA) that vouches for the identity of the certificate holder. With self-signed certificates, you are essentially saying "trust me, I am who I say I am" without third-party verification. This makes them unsuitable for public trust but perfectly valid for controlled environments.</p>

        <h6 class="mt-4">How Certificate Trust Works</h6>
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong class="text-success"><i class="fas fa-check-circle me-1"></i>CA-Signed Certificate</strong>
                    <div class="mt-2" style="font-size: 0.9rem;">
                        <div class="mb-2">Browser/Client <i class="fas fa-arrow-right mx-2"></i> Your Certificate <i class="fas fa-arrow-right mx-2"></i> Intermediate CA <i class="fas fa-arrow-right mx-2"></i> Root CA</div>
                        <p class="text-muted mb-0">The browser trusts the Root CA (pre-installed in the trust store), which trusts the Intermediate CA, which signed your certificate. This creates a verifiable chain of trust.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong class="text-warning"><i class="fas fa-exclamation-circle me-1"></i>Self-Signed Certificate</strong>
                    <div class="mt-2" style="font-size: 0.9rem;">
                        <div class="mb-2">Browser/Client <i class="fas fa-arrow-right mx-2"></i> Your Certificate (self-signed)</div>
                        <p class="text-muted mb-0">No chain of trust exists. The certificate signed itself. Browsers show warnings because they cannot verify identity through a trusted third party.</p>
                    </div>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Anatomy of an X.509 Certificate</h6>
        <p>Every X.509 certificate contains these essential fields:</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th style="width: 25%;">Field</th>
                        <th>Description</th>
                        <th style="width: 30%;">Example</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Subject (DN)</strong></td>
                        <td>Distinguished Name identifying the certificate owner</td>
                        <td><code>CN=example.com, O=My Corp, C=US</code></td>
                    </tr>
                    <tr>
                        <td><strong>Issuer (DN)</strong></td>
                        <td>Who signed the certificate (same as Subject for self-signed)</td>
                        <td><code>CN=example.com, O=My Corp, C=US</code></td>
                    </tr>
                    <tr>
                        <td><strong>Serial Number</strong></td>
                        <td>Unique identifier assigned by the issuer</td>
                        <td><code>0x7A3B2C1D</code></td>
                    </tr>
                    <tr>
                        <td><strong>Validity Period</strong></td>
                        <td>Not Before and Not After timestamps</td>
                        <td><code>2024-01-01 to 2025-01-01</code></td>
                    </tr>
                    <tr>
                        <td><strong>Public Key</strong></td>
                        <td>The public key and algorithm (RSA, ECDSA, etc.)</td>
                        <td><code>RSA 2048-bit</code></td>
                    </tr>
                    <tr>
                        <td><strong>Signature</strong></td>
                        <td>Digital signature from the issuer</td>
                        <td><code>SHA256withRSA</code></td>
                    </tr>
                    <tr>
                        <td><strong>Extensions (v3)</strong></td>
                        <td>Additional attributes like SAN, Key Usage</td>
                        <td><code>subjectAltName: DNS:*.example.com</code></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Use Cases for Self-Signed Certificates</h6>
        <div class="row">
            <div class="col-md-6">
                <ul>
                    <li><strong>Local Development:</strong> Testing HTTPS on localhost without purchasing certificates</li>
                    <li><strong>CI/CD Pipelines:</strong> Automated testing environments that need TLS</li>
                    <li><strong>Internal APIs:</strong> Microservices communication within a controlled network</li>
                    <li><strong>Learning & Education:</strong> Understanding PKI, TLS handshakes, and certificate structures</li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul>
                    <li><strong>IoT & Embedded:</strong> Devices in closed networks where you control all endpoints</li>
                    <li><strong>Air-Gapped Systems:</strong> Networks without internet access to reach CAs</li>
                    <li><strong>Temporary Services:</strong> Short-lived services where CA overhead isn't justified</li>
                    <li><strong>Root CA Creation:</strong> Your own PKI starts with a self-signed root certificate</li>
                </ul>
            </div>
        </div>

        <h6 class="mt-4">X.509 Certificate Versions</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="p-3 bg-light rounded">
                    <strong>Version 3 (Recommended)</strong>
                    <p class="text-muted small mt-2 mb-2">The current standard, introduced in 1996. Required for modern TLS.</p>
                    <ul class="mb-0">
                        <li><strong>Subject Alternative Names (SAN):</strong> Multiple domains/IPs in one cert</li>
                        <li><strong>Key Usage:</strong> digitalSignature, keyEncipherment, etc.</li>
                        <li><strong>Extended Key Usage:</strong> serverAuth, clientAuth, codeSigning</li>
                        <li><strong>Basic Constraints:</strong> CA:TRUE/FALSE, path length</li>
                        <li><strong>CRL Distribution Points:</strong> Where to check revocation</li>
                        <li><strong>Authority Info Access:</strong> OCSP responder URLs</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 bg-light rounded">
                    <strong>Version 1 & 2 (Legacy)</strong>
                    <p class="text-muted small mt-2 mb-2">Original versions with limited functionality.</p>
                    <ul class="mb-0">
                        <li><strong>Version 1 (1988):</strong> Basic fields only - subject, issuer, validity, public key</li>
                        <li><strong>Version 2 (1993):</strong> Added Issuer/Subject Unique Identifiers</li>
                        <li>No extension support</li>
                        <li>Cannot specify SAN (only CN for hostname)</li>
                        <li>Modern browsers may reject v1/v2 certificates</li>
                        <li>Only use for legacy system compatibility</li>
                    </ul>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Subject Alternative Names (SAN) Explained</h6>
        <p>The SAN extension is critical for modern certificates. It allows a single certificate to secure multiple identities:</p>
        <div class="p-3 bg-dark text-light rounded mb-3" style="font-family: monospace; font-size: 0.85rem;">
            <div class="text-success"># Example SAN entries in a certificate</div>
            <div>X509v3 Subject Alternative Name:</div>
            <div class="ps-3">DNS:example.com</div>
            <div class="ps-3">DNS:www.example.com</div>
            <div class="ps-3">DNS:api.example.com</div>
            <div class="ps-3">DNS:*.staging.example.com</div>
            <div class="ps-3">IP Address:192.168.1.100</div>
            <div class="ps-3">IP Address:10.0.0.1</div>
        </div>
        <p><strong>Important:</strong> Since 2017, browsers like Chrome ignore the Common Name (CN) field for hostname validation and only check SANs. Always include your primary hostname in both CN and SAN for maximum compatibility.</p>

        <h6 class="mt-4">Installing Self-Signed Certificates</h6>
        <p>To avoid browser warnings, you can add your self-signed certificate to the system trust store:</p>
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="p-3 border rounded h-100">
                    <strong><i class="fab fa-apple me-1"></i> macOS</strong>
                    <ol class="small mt-2 mb-0">
                        <li>Open Keychain Access</li>
                        <li>Drag certificate to "System" keychain</li>
                        <li>Double-click cert, expand Trust</li>
                        <li>Set "Always Trust"</li>
                    </ol>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 border rounded h-100">
                    <strong><i class="fab fa-windows me-1"></i> Windows</strong>
                    <ol class="small mt-2 mb-0">
                        <li>Double-click .crt file</li>
                        <li>Click "Install Certificate"</li>
                        <li>Choose "Local Machine"</li>
                        <li>Place in "Trusted Root CA" store</li>
                    </ol>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 border rounded h-100">
                    <strong><i class="fab fa-linux me-1"></i> Linux (Ubuntu/Debian)</strong>
                    <ol class="small mt-2 mb-0">
                        <li><code>sudo cp cert.crt /usr/local/share/ca-certificates/</code></li>
                        <li><code>sudo update-ca-certificates</code></li>
                        <li>Restart browser/application</li>
                    </ol>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Common Browser Errors</h6>
        <div class="table-responsive">
            <table class="table table-sm">
                <thead class="table-light">
                    <tr>
                        <th>Error</th>
                        <th>Cause</th>
                        <th>Solution</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>NET::ERR_CERT_AUTHORITY_INVALID</code></td>
                        <td>Certificate not signed by trusted CA</td>
                        <td>Add to system trust store or click "Proceed anyway"</td>
                    </tr>
                    <tr>
                        <td><code>NET::ERR_CERT_COMMON_NAME_INVALID</code></td>
                        <td>Hostname doesn't match certificate CN/SAN</td>
                        <td>Regenerate with correct hostname in SAN</td>
                    </tr>
                    <tr>
                        <td><code>NET::ERR_CERT_DATE_INVALID</code></td>
                        <td>Certificate expired or not yet valid</td>
                        <td>Check system clock; regenerate if expired</td>
                    </tr>
                    <tr>
                        <td><code>SSL_ERROR_BAD_CERT_DOMAIN</code></td>
                        <td>Firefox: domain mismatch</td>
                        <td>Ensure domain is in SAN extension</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Security Considerations</h6>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Important:</strong> Self-signed certificates should not be used for production public-facing websites.
            They will trigger browser security warnings because they're not signed by a trusted CA.
            For production use, obtain certificates from trusted Certificate Authorities like Let's Encrypt (free), DigiCert, or Comodo.
        </div>

        <div class="alert alert-info mb-0">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Pro Tip:</strong> For development, consider using <a href="https://github.com/FiloSottile/mkcert" target="_blank" rel="noopener">mkcert</a> -
            a simple tool that creates locally-trusted certificates. It automatically installs a local CA in your system trust store,
            making your self-signed certificates trusted without manual steps.
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
$(document).ready(function() {
    // Key option toggle
    $('#newKeyOption').click(function() {
        $('#generateNewKey').prop('checked', true);
        $('#newKeyOption').addClass('active');
        $('#existingKeyOption').removeClass('active');
        $('#privateKeyInput').slideUp();
    });

    $('#existingKeyOption').click(function() {
        $('#useExistingKey').prop('checked', true);
        $('#existingKeyOption').addClass('active');
        $('#newKeyOption').removeClass('active');
        $('#privateKeyInput').slideDown();
    });

    // Form submission
    $('#certForm').submit(function(event) {
        event.preventDefault();

        var hostname = $('#hostname').val().trim();
        if (!hostname) {
            showError('Hostname (CN) is required');
            return;
        }

        // Show loading state
        $('#resultPlaceholder').hide();
        $('#resultContent').hide();
        $('#loadingSpinner').show();
        $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Generating...');

        $.ajax({
            type: "POST",
            url: "CipherFunctionality",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loadingSpinner').hide();
                $('#generateBtn').prop('disabled', false).html('<i class="fas fa-certificate me-2"></i>Generate Certificate');

                if (response.success) {
                    displayCertificate(response);
                } else {
                    showError(response.errorMessage || 'Failed to generate certificate');
                }
            },
            error: function(xhr, status, error) {
                $('#loadingSpinner').hide();
                $('#generateBtn').prop('disabled', false).html('<i class="fas fa-certificate me-2"></i>Generate Certificate');
                showError('Request failed: ' + error);
            }
        });
    });
});

function displayCertificate(data) {
    var html = '<div class="mb-3">';
    html += '<span class="success-badge"><i class="fas fa-check-circle me-1"></i>Certificate Generated Successfully</span>';

    // Metadata badges
    html += '<div class="mt-2">';
    html += '<span class="info-badge"><i class="fas fa-server me-1"></i>' + escapeHtml(data.hostname) + '</span>';
    html += '<span class="info-badge"><i class="fas fa-clock me-1"></i>' + escapeHtml(data.expiry) + '</span>';
    html += '<span class="info-badge"><i class="fas fa-tag me-1"></i>' + escapeHtml(data.version) + '</span>';
    if (data.altNames) {
        html += '<span class="info-badge"><i class="fas fa-network-wired me-1"></i>SAN: ' + escapeHtml(data.altNames) + '</span>';
    }
    html += '</div>';
    html += '</div>';

    // Certificate PEM
    html += '<div class="cert-header">';
    html += '<span class="cert-title"><i class="fas fa-certificate me-2"></i>Certificate (PEM)</span>';
    html += '<div class="btn-group btn-group-sm">';
    html += '<button class="btn btn-outline-secondary" onclick="copyToClipboard(\'certPem\')"><i class="fas fa-copy"></i> Copy</button>';
    html += '<button class="btn btn-outline-secondary" onclick="downloadFile(\'certPem\', \'' + data.hostname + '.crt\')"><i class="fas fa-download"></i> Download</button>';
    html += '<a class="btn btn-outline-success" href="PemParserFunctions.jsp?pem=' + encodeURIComponent(data.certificatePem) + '" target="_blank"><i class="fas fa-search"></i> Parse</a>';
    html += '</div></div>';
    html += '<div class="cert-block" id="certPem">' + escapeHtml(data.certificatePem) + '</div>';

    // Private Key (if generated)
    if (data.privateKey && !data.usedProvidedKey) {
        html += '<div class="cert-header">';
        html += '<span class="cert-title"><i class="fas fa-key me-2"></i>Private Key (RSA)</span>';
        html += '<div class="btn-group btn-group-sm">';
        html += '<button class="btn btn-outline-secondary" onclick="copyToClipboard(\'privateKey\')"><i class="fas fa-copy"></i> Copy</button>';
        html += '<button class="btn btn-outline-secondary" onclick="downloadFile(\'privateKey\', \'' + data.hostname + '.key\')"><i class="fas fa-download"></i> Download</button>';
        html += '</div></div>';
        html += '<div class="cert-block" id="privateKey">' + escapeHtml(data.privateKey) + '</div>';
        html += '<div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i><strong>Keep your private key secure!</strong> Never share it publicly or commit it to version control.</div>';
    }

    // Decoded Certificate Info
    if (data.certificateDecoded) {
        html += '<div class="cert-header">';
        html += '<span class="cert-title"><i class="fas fa-info-circle me-2"></i>Certificate Details</span>';
        html += '<button class="btn btn-sm btn-outline-secondary" onclick="copyToClipboard(\'certDecoded\')"><i class="fas fa-copy"></i> Copy</button>';
        html += '</div>';
        html += '<div class="cert-block" id="certDecoded" style="max-height: 400px;">' + escapeHtml(data.certificateDecoded) + '</div>';
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
        // Fallback for older browsers
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
    // Simple toast notification
    var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
        '<div class="toast show" role="alert">' +
        '<div class="toast-body bg-success text-white rounded">' +
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
