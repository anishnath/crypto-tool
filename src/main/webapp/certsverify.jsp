<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Certificate Key Matcher Online - Free | 8gwifi.org</title>
    <meta name="description" content="Verify if a certificate, CSR, and private key belong to the same key pair. Check certificate matches private key online. Free SSL/TLS certificate verification tool." />
    <meta name="keywords" content="certificate matches private key, verify CSR matches certificate, SSL certificate verification, private key validation, certificate key pair checker, openssl verify certificate" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/certsverify.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Certificate/CSR/Private Key Matcher",
        "description": "Verify if a certificate, CSR, and private key belong to the same key pair by comparing their public key fingerprints.",
        "url": "https://8gwifi.org/certsverify.jsp",
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
        "datePublished": "2017-09-25",
        "dateModified": "2025-01-15"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Verify Certificate Matches Private Key",
        "description": "Step-by-step guide to check if a certificate, CSR, and private key belong to the same key pair",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Paste First Input",
                "text": "Paste your X.509 certificate, CSR, or private key in the first input field"
            },
            {
                "@type": "HowToStep",
                "name": "Paste Second Input",
                "text": "Paste the item you want to compare against in the second field"
            },
            {
                "@type": "HowToStep",
                "name": "Click Verify",
                "text": "Click the Verify Match button to compare the public key fingerprints"
            },
            {
                "@type": "HowToStep",
                "name": "Review Results",
                "text": "Check if the SHA-1 fingerprints match indicating the same key pair"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org Certificate Key Matcher"
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
                "name": "How do I check if a certificate matches a private key?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Paste the certificate and private key in the two input fields. The tool extracts the public key from both and compares their SHA-1 fingerprints. If they match, the certificate and private key belong to the same key pair."
                }
            },
            {
                "@type": "Question",
                "name": "Can I verify a CSR against a private key?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, you can compare a CSR (Certificate Signing Request) with a private key. The tool extracts the public key from both and verifies they derive from the same key pair."
                }
            },
            {
                "@type": "Question",
                "name": "What causes a certificate and key mismatch?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Common causes include: using a certificate issued for a different CSR, regenerating the private key after CSR submission, mixing up certificates from different domains, or using the wrong intermediate/root certificates."
                }
            },
            {
                "@type": "Question",
                "name": "What combinations can I verify?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "You can verify any combination: Certificate vs Private Key, Certificate vs CSR, CSR vs Private Key, or even two certificates to see if they use the same key pair."
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
            border-color: #11998e;
            box-shadow: 0 2px 8px rgba(17, 153, 142, 0.15);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: #11998e;
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }
        .info-badge {
            display: inline-block;
            background: #e6f7f5;
            color: #11998e;
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
        .pem-textarea {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
        }
        .match-result {
            text-align: center;
            padding: 2rem;
        }
        .match-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        .match-success {
            color: #38a169;
        }
        .match-fail {
            color: #e53e3e;
        }
        .hash-display {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }
        .hash-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        .hash-row:last-child {
            border-bottom: none;
        }
        .hash-label {
            font-weight: 600;
            color: #495057;
        }
        .hash-value {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
            color: #6c757d;
            word-break: break-all;
        }
        .type-badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .type-cert {
            background: #e3f2fd;
            color: #1565c0;
        }
        .type-csr {
            background: #fff3e0;
            color: #e65100;
        }
        .type-key {
            background: #fce4ec;
            color: #c2185b;
        }
        .vs-divider {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem;
            color: #6c757d;
            font-weight: bold;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 mb-1">Certificate/CSR/Key Matcher</h1>
        <p class="text-muted mb-0">Verify if certificate, CSR, and private key belong to the same key pair</p>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-shield-alt"></i>
        <span>By Anish Nath</span>
    </div>
</div>

<!-- Trust Indicators -->
<div class="mb-4">
    <span class="info-badge"><i class="fas fa-certificate"></i> X.509 Certificates</span>
    <span class="info-badge"><i class="fas fa-file-alt"></i> CSR Verification</span>
    <span class="info-badge"><i class="fas fa-key"></i> Private Keys</span>
    <span class="info-badge"><i class="fas fa-fingerprint"></i> SHA-1 Fingerprint</span>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-check-double me-2"></i>Verify Match</h5>
            </div>
            <div class="card-body">
                <form id="verifyForm">
                    <input type="hidden" name="methodName" value="METHOD_VERIFY_CERTSCSR">

                    <!-- Input 1 -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-file-code me-2"></i>Input 1 (Certificate/CSR/Key)</div>
                        <textarea class="form-control pem-textarea" rows="8" id="publickeyparama" name="publickeyparama" required
                                  placeholder="-----BEGIN CERTIFICATE-----&#10;Paste certificate, CSR, or private key&#10;-----END CERTIFICATE-----">-----BEGIN CERTIFICATE-----
MIIDejCCAmKgAwIBAgIBADANBgkqhkiG9w0BAQUFADAVMRMwEQYDVQQDDAo4Z3dp
Zmkub3JnMB4XDTE4MTIwNTAyNDcwMVoXDTE4MTIxODIwMzMzNlowTTELMAkGA1UE
BhMCSU4xDjAMBgNVBAgTBWhlbGxvMQswCQYDVQQHEwJMSzEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAy8gFNDFfWlew0dG0LCY/TFPtAjkJFYQ2J7lmSeO9M46m1SCtFqEh0EPH
5AzEmJwoLKmfum1x+sly8KyU0z6qYjLZzuhX802JFW0uou7DEYxmgMfseQEzy4lw
p9MwsrFh3+iCrlZFWc7oojATgYUUxa59Fy7dSE3dHW96kG+eH6Gqh6+Vb5h+qCIX
pOOvAriJeHI1lu7C3z6D+jdQ2LKmKRMaUXXXScL+tc0XexMmNI0vKGgl6+YVqrnR
a6HCmMGvU28jyoX+y1JLbUi/0osZCX9rkyX+VIe7emtBtrchFlyEzwXNEtfCJdq5
onYyREPPRoCxBgbWJFR3sc9ZP+96sQIDAQABo4GcMIGZMDwGA1UdIwQ1MDOAFCH9
G/3LXwM+Qbi6hWlajJIu40m0oRWkEzARMQ8wDQYDVQQDDAZyb290Q0GCBJzTHJ0w
HQYDVR0OBBYEFDJwMvLRtriA0dJkyVqQJO6C++dJMBIGA1UdEwEB/wQIMAYBAf8C
AQAwDgYDVR0PAQH/BAQDAgWgMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMBMA0GCSqG
SIb3DQEBBQUAA4IBAQA9sceNKFobk7TulmNew13hfLhvsBt6U4THe18IBwKfIC5D
qM6b2ss9AFof3GFPT1REPOZnAzTrYi3Ios7GyGM8oPrTiSyGfrkA8pnPuxZeUhhh
CYnLe5GCfAhR0ntgFF+qrh7RQkRXUHvUpQJ75tkAG3/XFq04E6WdX99iLRB0Bpib
4X6xQXP9cjNxoC5dkU3g2Mopk9HuRMhV/QuGENrT6qfMs1GbkbRT/IXAVwWd54gN
xdZFWmzQK9YsiOPAsSeVXyL53Iw1a9Osonq6LFjG7wkw8L4fGVqqRKTGxjxa2HWD
buCOnYR8sjq8JHJUx1s+/kH0g5a90CnfYfKX+thq
-----END CERTIFICATE-----</textarea>
                    </div>

                    <div class="vs-divider">
                        <i class="fas fa-exchange-alt me-2"></i> VS
                    </div>

                    <!-- Input 2 -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-file-code me-2"></i>Input 2 (Certificate/CSR/Key)</div>
                        <textarea class="form-control pem-textarea" rows="8" id="privatekeyparama" name="privatekeyparama" required
                                  placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;Paste certificate, CSR, or private key&#10;-----END RSA PRIVATE KEY-----">-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAy8gFNDFfWlew0dG0LCY/TFPtAjkJFYQ2J7lmSeO9M46m1SCt
FqEh0EPH5AzEmJwoLKmfum1x+sly8KyU0z6qYjLZzuhX802JFW0uou7DEYxmgMfs
eQEzy4lwp9MwsrFh3+iCrlZFWc7oojATgYUUxa59Fy7dSE3dHW96kG+eH6Gqh6+V
b5h+qCIXpOOvAriJeHI1lu7C3z6D+jdQ2LKmKRMaUXXXScL+tc0XexMmNI0vKGgl
6+YVqrnRa6HCmMGvU28jyoX+y1JLbUi/0osZCX9rkyX+VIe7emtBtrchFlyEzwXN
EtfCJdq5onYyREPPRoCxBgbWJFR3sc9ZP+96sQIDAQABAoIBADX0V6xiBiUdYqur
IlEuL0Q+VFpqT4Vq5AvQgsy9h7LG6lUzuaBsOU+zIpG277aYYeqxXqE1qSAFhnFC
wITN6r7lR9YInoDE3q7VoatyHCPhUKJ4TJwdPWF+ml1VBWfKn2dxYGhYXzRQHDgV
EpUQb1eHw4cH2X7zXsAUbBch9nPZGNcVtDxu/i9tbPvuEtls2LWoF+a11VLWzO2+
B66xau1iH8+tnp5dO3Mozp6QBB9DNvkib/yttsyB0DbI5dmB9Ip4vtDTOMd0Axiw
a4FdD18JNhRkEnB6oDXE1fuuUflVobizQl4tnktj46K+UQoq5JVIL08VW5rrpmsX
h33uSgECgYEA9O/ah5pVtBs/v5dGpqBnfS0uEvqPbB9ez7p764Ss/wxyst/vL5xo
66iYLWQTMntPiY0RxUrfIoK9DCdHRP+VuloH3qDn0Gp879jwQejoWwQJTBczxVL1
NW9FeQuJMWjsrNETBjlEzc6waqL3HLcHdrKgernltbbFPCwIrXnjOUkCgYEA1PxL
YsfgUXprMJy8F3+1sX6Yj3L6fAk5ww2lIHLtyZfj1rdRVP/p7BjUGzLBmCU+vDQp
RlJ0i50tzM/YPR7H5ifT9CxNbV11PxDP336TvfX9xzxMS1nmT/tB79iOZhA7KKD8
4b0hOo0wddlYUMtCgHfVSTFEuygrt1nmgAXu3ikCgYAQNYM/sA314kvAsREi28Cd
fwzqgpxVKmpK0ut6dYhBRKCeh8U7YF1tIvYXIuVGVPS5hJVlegP0M7SxBjRoM4XE
FEsrB3jvyOxFrxSPOAuQYl7/IxXw/AFwLNHrJcFJfMkU0q0wnz+XYxM3q1sxEkez
KjUGiiDSeqroxX05hbRsyQKBgAHBQm3B79s8Av4XjIU1DC42ONOVwvKasNsmlaG6
0LLEiaAPSqBEq4zCd5zxwh6az/WFCIIH0+YCmYoCfGmkg0kmMtzkMI8iIgEvBkd1
J4p9KGYn3QkR6I/oJhbv1dyJbbNcADlr8YYl+6w86jlgM2ATnLJJsaNJJXMRTpDn
e5xhAoGAOvS8kjoL/+TbZ/AUaKHN9ib3/Zy4T1/6xZWSywaXgQrTuuzSdk7u3h55
D+XIY5+z4cP/jXjz+rbb6wwly3jIrBSbRpiONZvgl1BTI+uSVkRGljG6pYjATYrj
qg7WtcdDmov5XOjXzi6kehiubVMympqsyibZZQe3WGo6LP6J0rU=
-----END RSA PRIVATE KEY-----</textarea>
                    </div>

                    <button type="submit" class="btn btn-lg w-100" id="verifyBtn" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white;">
                        <i class="fas fa-check-double me-2"></i>Verify Match
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-clipboard-check me-2"></i>Verification Result</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-check-double fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Verification result will appear here</p>
                        <small class="text-muted">Paste items and click Verify Match</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: #11998e;" role="status">
                        <span class="visually-hidden">Verifying...</span>
                    </div>
                    <p class="mt-2 mb-0">Verifying keys...</p>
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
        <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Verification Commands</h5>
    </div>
    <div class="card-body p-0">
        <div class="terminal-block">
            <div class="terminal-header">
                <span>Get Certificate Modulus (MD5)</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl x509 -noout -modulus -in certificate.crt | openssl md5">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Extract modulus hash from certificate</div>
                <div>$ openssl x509 -noout -modulus -in <code>certificate.crt</code> | openssl md5</div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Get Private Key Modulus (MD5)</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl rsa -noout -modulus -in private.key | openssl md5">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Extract modulus hash from private key</div>
                <div>$ openssl rsa -noout -modulus -in <code>private.key</code> | openssl md5</div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Get CSR Modulus (MD5)</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl req -noout -modulus -in request.csr | openssl md5">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Extract modulus hash from CSR</div>
                <div>$ openssl req -noout -modulus -in <code>request.csr</code> | openssl md5</div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Verify Certificate Against CA</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl verify -CAfile ca-bundle.crt certificate.crt">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Verify certificate chain against CA bundle</div>
                <div>$ openssl verify -CAfile <code>ca-bundle.crt</code> <code>certificate.crt</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Check Certificate Expiry</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl x509 -noout -dates -in certificate.crt">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Display certificate validity dates</div>
                <div>$ openssl x509 -noout -dates -in <code>certificate.crt</code></div>
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
                <h6><i class="fas fa-search me-1"></i>PEM Parser</h6>
                <p>Decode and analyze PEM certificates</p>
            </a>
            <a href="csrfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-alt me-1"></i>CSR Generator</h6>
                <p>Create Certificate Signing Requests</p>
            </a>
            <a href="SelfSignCertificateFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-certificate me-1"></i>Self-Signed Certificate</h6>
                <p>Generate self-signed certificates</p>
            </a>
            <a href="signcsr.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-signature me-1"></i>CSR Signer</h6>
                <p>Sign CSRs and generate certificates</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Certificate Verification</h5>
    </div>
    <div class="card-body">
        <h6>Why Verify Certificate/Key Matching?</h6>
        <p>When deploying SSL/TLS certificates, it's critical to ensure the certificate, private key, and CSR all belong to the same key pair. Mismatched components will cause SSL handshake failures.</p>

        <div class="row mb-4">
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-certificate fa-2x mb-2" style="color: #1565c0;"></i>
                    <div><strong>Certificate</strong></div>
                    <small class="text-muted">Contains public key + identity info, signed by CA</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-file-alt fa-2x mb-2" style="color: #e65100;"></i>
                    <div><strong>CSR</strong></div>
                    <small class="text-muted">Request containing public key + identity info</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-key fa-2x mb-2" style="color: #c2185b;"></i>
                    <div><strong>Private Key</strong></div>
                    <small class="text-muted">Secret key that matches the public key</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">How Verification Works</h6>
        <p>The tool extracts the <strong>public key modulus</strong> from both inputs and computes their SHA-1 fingerprint. If the fingerprints match, both inputs derive from the same cryptographic key pair.</p>

        <div class="alert alert-info">
            <strong><i class="fas fa-info-circle me-1"></i> Verification Process:</strong>
            <ol class="mb-0 mt-2">
                <li>Extract public key from Input 1 (certificate extracts embedded public key)</li>
                <li>Extract public key from Input 2 (private key derives public key)</li>
                <li>Compute SHA-1 hash of both public keys</li>
                <li>Compare the hashes - if identical, keys match</li>
            </ol>
        </div>

        <h6 class="mt-4">Common Verification Scenarios</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Input 1</th>
                        <th>Input 2</th>
                        <th>Use Case</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="type-badge type-cert">Certificate</span></td>
                        <td><span class="type-badge type-key">Private Key</span></td>
                        <td>Verify before deploying to web server</td>
                    </tr>
                    <tr>
                        <td><span class="type-badge type-csr">CSR</span></td>
                        <td><span class="type-badge type-key">Private Key</span></td>
                        <td>Verify before submitting CSR to CA</td>
                    </tr>
                    <tr>
                        <td><span class="type-badge type-cert">Certificate</span></td>
                        <td><span class="type-badge type-csr">CSR</span></td>
                        <td>Verify certificate issued for correct CSR</td>
                    </tr>
                    <tr>
                        <td><span class="type-badge type-cert">Certificate</span></td>
                        <td><span class="type-badge type-cert">Certificate</span></td>
                        <td>Check if two certs use same key pair</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Troubleshooting Mismatches</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-warning mb-0">
                    <strong><i class="fas fa-exclamation-triangle me-1"></i> Common Causes:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>Regenerated private key after CSR creation</li>
                        <li>Certificate issued for different CSR</li>
                        <li>Wrong certificate downloaded from CA</li>
                        <li>Mixed up files from different domains</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-success mb-0">
                    <strong><i class="fas fa-check-circle me-1"></i> Solutions:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>Generate new CSR from existing private key</li>
                        <li>Request certificate reissuance from CA</li>
                        <li>Verify file names and organize properly</li>
                        <li>Keep backup of original key pair</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
$(document).ready(function() {
    // Form submission
    $('#verifyForm').submit(function(event) {
        event.preventDefault();

        var input1 = $('#publickeyparama').val().trim();
        var input2 = $('#privatekeyparama').val().trim();

        if (!input1) {
            showError('Please provide Input 1 (certificate, CSR, or private key)');
            return;
        }
        if (!input2) {
            showError('Please provide Input 2 (certificate, CSR, or private key)');
            return;
        }

        // Show loading state
        $('#resultPlaceholder').hide();
        $('#resultContent').hide();
        $('#loadingSpinner').show();
        $('#verifyBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Verifying...');

        $.ajax({
            type: "POST",
            url: "CipherFunctionality",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loadingSpinner').hide();
                $('#verifyBtn').prop('disabled', false).html('<i class="fas fa-check-double me-2"></i>Verify Match');

                if (response.success !== undefined) {
                    if (response.matchResult) {
                        displayResult(response);
                    } else if (response.errorMessage) {
                        showError(response.errorMessage);
                    }
                } else {
                    showError(response.errorMessage || 'Verification failed');
                }
            },
            error: function(xhr, status, error) {
                $('#loadingSpinner').hide();
                $('#verifyBtn').prop('disabled', false).html('<i class="fas fa-check-double me-2"></i>Verify Match');
                showError('Request failed: ' + error);
            }
        });
    });
});

function displayResult(data) {
    var isMatch = data.matchResult === 'match';
    var html = '<div class="match-result">';

    if (isMatch) {
        html += '<div class="match-icon match-success"><i class="fas fa-check-circle"></i></div>';
        html += '<h4 class="text-success">Keys Match!</h4>';
        html += '<p class="text-muted">Both inputs derive from the same key pair</p>';
    } else {
        html += '<div class="match-icon match-fail"><i class="fas fa-times-circle"></i></div>';
        html += '<h4 class="text-danger">Keys Do NOT Match</h4>';
        html += '<p class="text-muted">The inputs derive from different key pairs</p>';
    }

    html += '</div>';

    // Hash details
    html += '<div class="hash-display">';
    html += '<h6 class="mb-3"><i class="fas fa-fingerprint me-2"></i>Public Key Fingerprints (SHA-1)</h6>';

    html += '<div class="hash-row">';
    html += '<div><span class="hash-label">Input 1</span>';
    if (data.input1Type) {
        html += ' <span class="type-badge ' + getTypeBadgeClass(data.input1Type) + '">' + escapeHtml(data.input1Type) + '</span>';
    }
    html += '</div>';
    html += '<div class="hash-value">' + escapeHtml(data.hash1 || 'N/A') + '</div>';
    html += '</div>';

    html += '<div class="hash-row">';
    html += '<div><span class="hash-label">Input 2</span>';
    if (data.input2Type) {
        html += ' <span class="type-badge ' + getTypeBadgeClass(data.input2Type) + '">' + escapeHtml(data.input2Type) + '</span>';
    }
    html += '</div>';
    html += '<div class="hash-value">' + escapeHtml(data.hash2 || 'N/A') + '</div>';
    html += '</div>';

    html += '</div>';

    // Result summary
    if (isMatch) {
        html += '<div class="alert alert-success mt-3"><i class="fas fa-check me-2"></i>' + escapeHtml(data.message) + '</div>';
    } else {
        html += '<div class="alert alert-danger mt-3"><i class="fas fa-exclamation-triangle me-2"></i>' + escapeHtml(data.message) + '</div>';
    }

    $('#resultContent').html(html).show();
}

function getTypeBadgeClass(type) {
    if (type.toLowerCase().includes('certificate')) return 'type-cert';
    if (type.toLowerCase().includes('csr')) return 'type-csr';
    if (type.toLowerCase().includes('key')) return 'type-key';
    return 'type-cert';
}

function showError(message) {
    var html = '<div class="error-message">';
    html += '<i class="fas fa-exclamation-circle me-2"></i>';
    html += '<strong>Error:</strong> ' + escapeHtml(message);
    html += '</div>';

    $('#resultPlaceholder').hide();
    $('#resultContent').html(html).show();
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
        '<div class="toast-body text-white rounded" style="background: #11998e;">' +
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
