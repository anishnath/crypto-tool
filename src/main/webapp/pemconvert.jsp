<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PKCS#8 PKCS#1 Key Converter Online - Free | 8gwifi.org</title>
    <meta name="description" content="Convert private keys between PKCS#8 and PKCS#1 formats online. Support for RSA, DSA, and EC keys. Free PEM key format conversion tool for developers." />
    <meta name="keywords" content="PKCS8 to PKCS1, PKCS1 to PKCS8, PEM converter, RSA key conversion, EC key conversion, DSA key conversion, openssl key format, private key converter" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/pemconvert.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "PKCS#8/PKCS#1 Key Converter",
        "description": "Convert private keys between PKCS#8 and PKCS#1 (traditional) formats. Supports RSA, DSA, and EC keys with encrypted key support.",
        "url": "https://8gwifi.org/pemconvert.jsp",
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
        "datePublished": "2020-01-29",
        "dateModified": "2025-01-15"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Convert Private Keys Between PKCS#8 and PKCS#1 Formats",
        "description": "Step-by-step guide to convert private keys between different PEM formats",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Paste Your Private Key",
                "text": "Paste your private key in PEM format (PKCS#1 or PKCS#8)"
            },
            {
                "@type": "HowToStep",
                "name": "Enter Password (if encrypted)",
                "text": "If your private key is encrypted, enter the password to decrypt it"
            },
            {
                "@type": "HowToStep",
                "name": "Click Convert",
                "text": "Click the Convert button to transform your key to the alternate format"
            },
            {
                "@type": "HowToStep",
                "name": "Download Result",
                "text": "Copy or download the converted key in PEM format"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org PEM Key Converter"
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
                "name": "What is the difference between PKCS#1 and PKCS#8?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "PKCS#1 is an RSA-specific format that stores only RSA private keys. PKCS#8 is a more general format that can store any type of private key (RSA, DSA, EC) and includes algorithm identification. PKCS#8 is the recommended modern format."
                }
            },
            {
                "@type": "Question",
                "name": "How do I identify if my key is PKCS#1 or PKCS#8?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "PKCS#1 keys have headers like 'BEGIN RSA PRIVATE KEY' or 'BEGIN EC PRIVATE KEY'. PKCS#8 keys have the header 'BEGIN PRIVATE KEY' (unencrypted) or 'BEGIN ENCRYPTED PRIVATE KEY' (encrypted)."
                }
            },
            {
                "@type": "Question",
                "name": "Can I convert encrypted private keys?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, you can convert encrypted private keys by providing the password. The tool will decrypt the key, convert it to the target format, and output it in unencrypted PEM format."
                }
            },
            {
                "@type": "Question",
                "name": "What key types are supported?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "This tool supports RSA, DSA, and EC (Elliptic Curve) private keys. It can convert between traditional algorithm-specific formats and the generic PKCS#8 format."
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        .key-block {
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
        .key-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .key-title {
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
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.15);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: #667eea;
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }
        .info-badge {
            display: inline-block;
            background: #eef2ff;
            color: #667eea;
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
        .pem-textarea {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
        }
        .format-indicator {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }
        .format-pkcs1 {
            background: #fff3e0;
            color: #e65100;
        }
        .format-pkcs8 {
            background: #e3f2fd;
            color: #1565c0;
        }
        .conversion-arrow {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem;
            color: #667eea;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 mb-1">PKCS#8/PKCS#1 Key Converter</h1>
        <p class="text-muted mb-0">Convert private keys between PKCS#8 and PKCS#1 (traditional) formats</p>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-shield-alt"></i>
        <span>By Anish Nath</span>
    </div>
</div>

<!-- Trust Indicators -->
<div class="mb-4">
    <span class="info-badge"><i class="fas fa-exchange-alt"></i> PKCS#8 &#8596; PKCS#1</span>
    <span class="info-badge"><i class="fas fa-key"></i> RSA Keys</span>
    <span class="info-badge"><i class="fas fa-fingerprint"></i> EC Keys</span>
    <span class="info-badge"><i class="fas fa-lock"></i> DSA Keys</span>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-exchange-alt me-2"></i>Convert Key</h5>
            </div>
            <div class="card-body">
                <form id="convertForm">
                    <input type="hidden" name="methodName" value="CONVERT_PKCS8">

                    <!-- Key Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-key me-2"></i>Private Key (PEM)</div>
                        <textarea class="form-control pem-textarea" rows="12" id="pem" name="pem" required
                                  placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;Paste your private key here&#10;-----END RSA PRIVATE KEY-----">-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAk9zv6gtOlFLueEhjN4WcunNIqVyMQsY6kt0Rheau/lBTMI4w
s1x6032eiu78YhGGaOevzo16XdfSt+0sLBa5YB1KVwUXs9hf3bIMvKb7dLmsy+Xl
KhmBO/bqjekYV9CYjKaGOqrH5TT3nmQSTse7PvmJ8kL0v5mGTB7bHxr2PJYit5U9
3zbc2bRrBdLmNyZQYJMakO73ZeqIS9xyk23+54kVfHakGRsg8Tn5ARHYn+ujJD3M
i30NxdrPArSq7xncDw4rY1vXMZR/JLb/YMQAgxbQFp68vIJwqYEDTSEhwyP0mfEX
/NBtKpdwbD8xeunF+QUlacJjT9JEhPuA4IH8OwIDAQABAoIBACh/lP6Hhkg9xq8P
NI2afOjcdoRcotYPMS/UeN4x5rAlFAPyjggyRjny6B+pgVri7euBubdbLK7TVBWo
UjbpKnDW1Ousq2dI1kkEYVSyb6Dy0g8usmurfKgN4wRnWZGDwqSTX6Rl7kYrEb9C
LXmCXxjKhCvkhuCLjir/MIj+e37wPZHHrBbM7/eACywf04xJK+MERNAIlOuVvlxb
4LIHiPG6+xWpzQheFdetdK94X0W45Gt1+SbFLM10Fk58WL+bRvEi8Y0wIxe3bAxP
esA16WeNXumWW9ZOutbQvvN8pLsZcw/cGj9cru8XmEhQ+vd25Cn5fQl1UZzZ+VE/
QUuIdqECgYEAw7grYCnXnmiKV8qMZUwWQ0m2/t2OBt3FJFYxb4XMB77VZpnXoAy7
E6hFmqZxNFg0RgVc+G3xXYtWeV0xDnJGL7COhGgVtwaNZKA3zVzcU9oR4ZtnyFST
qBF751y5se2tiGz+Mcndwh4dAo8fWQDDgqpk7qkD0dVQdBJmz6hLH/MCgYEAwWdz
QJCXI647wA3Z+cV8nBq1UYVDt70iMlO1CYeKImIBzEFkiEgdydRyApvRSuK2Kepj
mdS4VYOq35t+M+RWwqPl/EP06izCpm4VgADfPKfIHMpDoJ9hXltT1nsI709QK4Wy
qZC4cnYCIA1s7UO6ct9Nia+uowSnNNVg8U0RjJkCgYAHwjdF+qKnjvFdBZSHN3ry
c+ujMtk8gHIePKR9DUrHS9Nd299mYtrPrq4DsXFvZ8e6tt+2oXUeBjYJXZ5iOjl6
Dn+31AB4XvQf9xH/PB0n3c8zqFt235Ny6C6HP2/FE+z7KYbyJlR6K4Nu5ImTl6oo
deTGaUDTgqdL0qbsuHkx7QKBgDf2Cggtjj35xTouB9tYxFSa+coLyGta45EyXVjT
iimmuCR063TvgQcMXKzajzWe4dzBAG7beTbtMT0gTeUP9fa92+chdrVnnC7x/XCb
T/zKA4IpGGZal57oyBpwYUZ1aZoeRnL/+A7OjJDfsZv5k/J3IIVtexeaWhNUhodr
qF9JAoGBALn+X2C8k8OPLp1ztYchbnwQf/kGaX6iKmcZsHicQ9M19+XRjtBds7NR
9Dm+30T9M+Haq188kTgszaT6uVSRvMOizn2j1O/eWsUCw1X2tB8afqdWqp9OB22r
Unj2w7Fr9rT9tWSWUS3MZ2DJWiT0riohJSjlQJjC5UcYnuMVjUdd
-----END RSA PRIVATE KEY-----</textarea>
                        <small class="text-muted mt-2 d-block">
                            <i class="fas fa-info-circle me-1"></i>
                            Supports RSA, DSA, and EC keys in PKCS#1 or PKCS#8 format
                        </small>
                    </div>

                    <!-- Password (for encrypted keys) -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-lock me-2"></i>Password (Optional)</div>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Enter password for encrypted keys">
                        <small class="text-muted">Only required if the private key is encrypted</small>
                    </div>

                    <button type="submit" class="btn btn-lg w-100" id="convertBtn" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                        <i class="fas fa-exchange-alt me-2"></i>Convert Key
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-key me-2"></i>Converted Key</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-exchange-alt fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Your converted key will appear here</p>
                        <small class="text-muted">Paste a key and click Convert</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: #667eea;" role="status">
                        <span class="visually-hidden">Converting...</span>
                    </div>
                    <p class="mt-2 mb-0">Converting key...</p>
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
        <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Key Conversion Commands</h5>
    </div>
    <div class="card-body p-0">
        <div class="terminal-block">
            <div class="terminal-header">
                <span>PKCS#1 to PKCS#8 (RSA)</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in private.pem -out private_pkcs8.pem">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Convert traditional RSA key to PKCS#8 format</div>
                <div>$ openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \<br>  -in <code>private.pem</code> -out <code>private_pkcs8.pem</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>PKCS#8 to PKCS#1 (RSA)</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl rsa -in private_pkcs8.pem -out private_pkcs1.pem">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Convert PKCS#8 to traditional RSA format</div>
                <div>$ openssl rsa -in <code>private_pkcs8.pem</code> -out <code>private_pkcs1.pem</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>EC Key to PKCS#8</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl pkcs8 -topk8 -nocrypt -in ec_private.pem -out ec_pkcs8.pem">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Convert EC private key to PKCS#8 format</div>
                <div>$ openssl pkcs8 -topk8 -nocrypt -in <code>ec_private.pem</code> -out <code>ec_pkcs8.pem</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Decrypt Encrypted PKCS#8 Key</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl pkcs8 -in encrypted.pem -out decrypted.pem">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Decrypt an encrypted PKCS#8 private key</div>
                <div>$ openssl pkcs8 -in <code>encrypted.pem</code> -out <code>decrypted.pem</code></div>
            </div>
        </div>

        <div class="terminal-block">
            <div class="terminal-header">
                <span>Encrypt PKCS#8 Key with AES-256</span>
                <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl pkcs8 -topk8 -v2 aes-256-cbc -in private.pem -out encrypted_pkcs8.pem">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="terminal-body">
                <div class="cmd-description"># Convert to encrypted PKCS#8 with AES-256-CBC</div>
                <div>$ openssl pkcs8 -topk8 -v2 aes-256-cbc -in <code>private.pem</code> -out <code>encrypted_pkcs8.pem</code></div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related Key Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="PemParserFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>PEM Parser</h6>
                <p>Decode and analyze PEM certificates and keys</p>
            </a>
            <a href="pempublic.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>Extract Public Key</h6>
                <p>Extract public key from private key</p>
            </a>
            <a href="pempasswordfinder.jsp" class="related-tool-card">
                <h6><i class="fas fa-unlock me-1"></i>PEM Password Finder</h6>
                <p>Find password for encrypted PEM files</p>
            </a>
            <a href="rsafunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-cogs me-1"></i>RSA Key Generator</h6>
                <p>Generate RSA key pairs online</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Key Formats</h5>
    </div>
    <div class="card-body">
        <h6>PKCS#1 vs PKCS#8: What's the Difference?</h6>
        <p>Both PKCS#1 and PKCS#8 are standards for storing private keys, but they serve different purposes:</p>

        <div class="row mb-4">
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong class="d-flex align-items-center">
                        <span class="format-indicator format-pkcs1 me-2">PKCS#1</span>
                        Traditional Format
                    </strong>
                    <ul class="mt-2 mb-0 small">
                        <li>RSA-specific format (RSA Cryptography Standard)</li>
                        <li>Header: <code>BEGIN RSA PRIVATE KEY</code></li>
                        <li>Contains only RSA key parameters</li>
                        <li>Simpler structure, no algorithm OID</li>
                        <li>Commonly used by older applications</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 border rounded h-100">
                    <strong class="d-flex align-items-center">
                        <span class="format-indicator format-pkcs8 me-2">PKCS#8</span>
                        Generic Format
                    </strong>
                    <ul class="mt-2 mb-0 small">
                        <li>Algorithm-agnostic (works with RSA, EC, DSA, etc.)</li>
                        <li>Header: <code>BEGIN PRIVATE KEY</code></li>
                        <li>Includes algorithm identifier (OID)</li>
                        <li>Supports encryption (PKCS#5/PBES2)</li>
                        <li>Recommended modern format</li>
                    </ul>
                </div>
            </div>
        </div>

        <h6 class="mt-4">PEM Headers by Key Type</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Key Type</th>
                        <th>Traditional Format</th>
                        <th>PKCS#8 Format</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>RSA</td>
                        <td><code>BEGIN RSA PRIVATE KEY</code></td>
                        <td><code>BEGIN PRIVATE KEY</code></td>
                    </tr>
                    <tr>
                        <td>EC (Elliptic Curve)</td>
                        <td><code>BEGIN EC PRIVATE KEY</code></td>
                        <td><code>BEGIN PRIVATE KEY</code></td>
                    </tr>
                    <tr>
                        <td>DSA</td>
                        <td><code>BEGIN DSA PRIVATE KEY</code></td>
                        <td><code>BEGIN PRIVATE KEY</code></td>
                    </tr>
                    <tr>
                        <td>Encrypted (any)</td>
                        <td><code>BEGIN ENCRYPTED PRIVATE KEY</code></td>
                        <td><code>BEGIN ENCRYPTED PRIVATE KEY</code></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">When to Use Which Format?</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-info mb-0">
                    <strong><i class="fas fa-check-circle me-1"></i> Use PKCS#8 when:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>Working with modern applications (Java, .NET)</li>
                        <li>Need algorithm-independent key storage</li>
                        <li>Want to encrypt the private key</li>
                        <li>Using non-RSA algorithms (EC, EdDSA)</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning mb-0">
                    <strong><i class="fas fa-exclamation-circle me-1"></i> Use PKCS#1 when:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>Legacy application compatibility required</li>
                        <li>Working with older OpenSSL versions</li>
                        <li>Specific tool requires traditional format</li>
                        <li>RSA-only environment</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="alert alert-success mb-0 mt-4">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Tip:</strong> When in doubt, use PKCS#8. It's the more modern and versatile format that works with all key types and most modern cryptographic libraries.
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
$(document).ready(function() {
    // Form submission
    $('#convertForm').submit(function(event) {
        event.preventDefault();

        var pem = $('#pem').val().trim();
        if (!pem) {
            showError('Please provide a private key in PEM format');
            return;
        }

        // Show loading state
        $('#resultPlaceholder').hide();
        $('#resultContent').hide();
        $('#loadingSpinner').show();
        $('#convertBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Converting...');

        $.ajax({
            type: "POST",
            url: "CipherFunctionality",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loadingSpinner').hide();
                $('#convertBtn').prop('disabled', false).html('<i class="fas fa-exchange-alt me-2"></i>Convert Key');

                if (response.success) {
                    displayConvertedKey(response);
                } else {
                    showError(response.errorMessage || 'Failed to convert key');
                }
            },
            error: function(xhr, status, error) {
                $('#loadingSpinner').hide();
                $('#convertBtn').prop('disabled', false).html('<i class="fas fa-exchange-alt me-2"></i>Convert Key');
                showError('Request failed: ' + error);
            }
        });
    });
});

function displayConvertedKey(data) {
    var html = '<div class="mb-3">';
    html += '<span class="success-badge"><i class="fas fa-check-circle me-1"></i>Key Converted Successfully</span>';

    // Conversion info badges
    html += '<div class="mt-2">';
    if (data.inputFormat) {
        html += '<span class="info-badge"><i class="fas fa-arrow-right me-1"></i>From: ' + escapeHtml(data.inputFormat) + '</span>';
    }
    if (data.outputFormat) {
        html += '<span class="info-badge"><i class="fas fa-arrow-left me-1"></i>To: ' + escapeHtml(data.outputFormat) + '</span>';
    }
    if (data.algorithm) {
        html += '<span class="info-badge"><i class="fas fa-key me-1"></i>' + escapeHtml(data.algorithm) + '</span>';
    }
    html += '</div>';
    html += '</div>';

    // Converted key
    html += '<div class="key-header">';
    html += '<span class="key-title"><i class="fas fa-key me-2"></i>Converted Private Key (PEM)</span>';
    html += '<div class="btn-group btn-group-sm">';
    html += '<button class="btn btn-outline-secondary" onclick="copyToClipboard(\'convertedKey\')"><i class="fas fa-copy"></i> Copy</button>';
    html += '<button class="btn btn-outline-secondary" onclick="downloadFile(\'convertedKey\', \'converted_key.pem\')"><i class="fas fa-download"></i> Download</button>';
    html += '<a class="btn btn-outline-success" href="PemParserFunctions.jsp?pem=' + encodeURIComponent(data.convertedKey) + '" target="_blank"><i class="fas fa-search"></i> Parse</a>';
    html += '</div></div>';
    html += '<div class="key-block" id="convertedKey">' + escapeHtml(data.convertedKey) + '</div>';

    // Format comparison info
    html += '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>';
    html += '<strong>Conversion Details:</strong> ';
    if (data.inputFormat && data.outputFormat) {
        html += 'Your key was converted from <strong>' + escapeHtml(data.inputFormat) + '</strong> to <strong>' + escapeHtml(data.outputFormat) + '</strong> format.';
    }
    html += '</div>';

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
        '<div class="toast-body text-white rounded" style="background: #667eea;">' +
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
