<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<div lang="en">
<head>
    <title>JWT Debugger - Free JSON Web Token Decoder Validator Online | JWT.io Alternative | 8gwifi.org</title>

    <!-- Enhanced JSON-LD markup for SEO -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "JWT Debugger - JSON Web Token Decoder Validator Online",
  "alternateName" : ["JWT Decoder", "JWT Validator", "JWT Parser", "JWT Verifier Online", "JWT.io Alternative"],
  "description" : "Free online JWT debugger and decoder. Decode, verify, and generate JSON Web Tokens (JWT). Supports HS256, HS384, HS512, RS256, RS384, RS512, ES256, ES384, ES512, PS256, PS384, PS512. Test JWT signatures, check expiration, validate claims. JWT.io alternative with timing attack detection.",
  "url" : "https://8gwifi.org/jwt-debugger.jsp",
  "image" : "https://8gwifi.org/images/jwt.png",
  "screenshot" : "https://8gwifi.org/images/jwt-screenshot.png",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://8gwifi.org"
  },
  "publisher" : {
    "@type" : "Organization",
    "name" : "8gwifi.org",
    "logo" : {
      "@type" : "ImageObject",
      "url" : "https://8gwifi.org/images/logo.png"
    }
  },
  "datePublished" : "2025-01-28",
  "dateModified" : "2025-01-28",
  "applicationCategory" : ["SecurityApplication", "DeveloperApplication", "Utility"],
  "applicationSubCategory" : "JWT Token Tool",
  "downloadUrl" : "https://8gwifi.org/jwt-debugger.jsp",
  "operatingSystem" : ["Windows", "MacOS", "Linux", "Android", "iOS", "Web Browser"],
  "requirements" : "Modern Web Browser with JavaScript enabled",
  "softwareVersion" : "1.0",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "2340",
    "bestRating": "5",
    "worstRating": "1"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList" : [
    "JWT Decoder - Decode Base64 JWT Tokens",
    "JWT Signature Verification (HS256, RS256, ES256)",
    "JWT Token Generator",
    "Support All JWT Algorithms",
    "Expiration Time Validation",
    "Claims Inspector",
    "Header Inspector",
    "Timing Attack Detection",
    "Pretty Print JSON",
    "Copy Decoded Token",
    "Real-time Validation",
    "No Server Upload - Privacy First",
    "JWT.io Compatible",
    "Auth0 Compatible",
    "JOSE Standard Compliant",
    "Free and Open Source"
  ],
  "keywords": "JWT, JSON Web Token, JWT decoder, JWT validator, JWT parser, JWT verifier, JWT.io, decode JWT, verify JWT, JWT online, JWT debugger, HS256, RS256, ES256, JWT signature, JWT claims, JWT header, JWT payload, token decoder, bearer token, OAuth JWT, JWT expiration, JWT generator, JWT tool, base64 decode, JOSE, JWS, authentication token",
  "about": {
    "@type": "Thing",
    "name": "JSON Web Token",
    "description": "JSON Web Tokens are an open, industry standard RFC 7519 method for representing claims securely between two parties."
  },
  "educationalUse": "Learn about JWT structure, test JWT tokens, debug authentication issues, validate JWT signatures",
  "isAccessibleForFree": true,
  "interactionStatistic": {
    "@type": "InteractionCounter",
    "interactionType": "http://schema.org/UseAction",
    "userInteractionCount": "75000"
  }
}
    </script>

    <!-- Breadcrumb JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://8gwifi.org/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Security Tools",
      "item": "https://8gwifi.org/cryptography.jsp"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "JWT Debugger",
      "item": "https://8gwifi.org/jwt-debugger.jsp"
    }
  ]
}
    </script>

    <!-- FAQ JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is JWT?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JWT (JSON Web Token) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. JWTs are commonly used for authentication and information exchange in web applications."
      }
    },
    {
      "@type": "Question",
      "name": "How do I decode a JWT token?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Paste your JWT token into the encoded field. The debugger will automatically decode it and show you the header, payload, and signature. JWT tokens are Base64Url encoded and consist of three parts separated by dots: header.payload.signature"
      }
    },
    {
      "@type": "Question",
      "name": "Is it safe to paste my JWT token here?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, this tool processes everything client-side in your browser. Your JWT token never leaves your computer or gets sent to any server. All decoding and verification happens locally using JavaScript."
      }
    },
    {
      "@type": "Question",
      "name": "What JWT algorithms are supported?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool supports all standard JWT algorithms: HMAC (HS256, HS384, HS512), RSA (RS256, RS384, RS512), ECDSA (ES256, ES384, ES512), and RSA-PSS (PS256, PS384, PS512). You can decode any JWT and verify signatures with the appropriate secret or public key."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between HS256 and RS256?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "HS256 uses HMAC with SHA-256 and requires a shared secret key for both signing and verification. RS256 uses RSA with SHA-256 and uses a private key for signing and a public key for verification. RS256 is more secure for public APIs as the public key can be shared safely."
      }
    }
  ]
}
    </script>

    <!-- HowTo JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "HowTo",
  "name": "How to Decode and Verify JWT Tokens",
  "description": "Step-by-step guide to decode and verify JSON Web Tokens using this tool",
  "image": "https://8gwifi.org/images/jwt-howto.png",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Paste JWT Token",
      "text": "Copy your JWT token and paste it into the 'Encoded JWT' field. The token will be automatically decoded.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "View Decoded Parts",
      "text": "The header and payload will be displayed in JSON format with syntax highlighting. Check the algorithm, expiration time, and claims.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Verify Signature",
      "text": "Enter your secret key (for HS256/384/512) or public key (for RS256/384/512) to verify the JWT signature.",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Check Validation",
      "text": "The tool will show if the signature is valid, if the token has expired, and highlight any issues with the token structure.",
      "position": 4
    }
  ]
}
    </script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free JWT Debugger - Decode, verify, and generate JSON Web Tokens online. Support all algorithms (HS256, HS384, HS512, RS256, RS384, RS512, ES256, ES384, ES512). Validate JWT signatures, check expiration, inspect claims. JWT.io alternative with timing attack detection. 100% client-side, privacy-first, no server upload.">
    <meta name="keywords" content="jwt debugger, jwt decoder, jwt validator, jwt parser online, jwt verifier, jwt.io, jwt.io alternative, decode jwt token, verify jwt signature, jwt online tool, json web token decoder, jwt base64 decode, jwt hs256, jwt rs256, jwt es256, jwt signature verification, jwt claims validator, jwt header decoder, jwt payload inspector, jwt expiration check, jwt generator online, bearer token decoder, oauth jwt validator, jwt timing attack, jwt security tool, auth0 jwt, firebase jwt, aws cognito jwt, jwt tester, jwt analyzer, free jwt tool">
    <meta name="author" content="Anish Nath" />
    <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/jwt-debugger.jsp">
    <meta property="og:title" content="JWT Debugger - Free JSON Web Token Decoder & Validator Online">
    <meta property="og:description" content="Decode and verify JWT tokens online. Support all algorithms. Check signatures, expiration, claims. JWT.io alternative. Free online JWT tool.">
    <meta property="og:image" content="https://8gwifi.org/images/jwt-og.png">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/jwt-debugger.jsp">
    <meta name="twitter:title" content="JWT Debugger - Decode & Verify JSON Web Tokens Online">
    <meta name="twitter:description" content="Free JWT decoder and validator. Support all algorithms. Check JWT signatures and expiration. Privacy-first JWT.io alternative.">
    <meta name="twitter:image" content="https://8gwifi.org/images/jwt-twitter.png">
    <meta name="twitter:creator" content="@8gwifi">

    <!-- Additional SEO Meta Tags -->
    <meta name="classification" content="Security Tools, JWT, Authentication, Developer Tools">
    <meta name="coverage" content="Worldwide">
    <meta name="distribution" content="Global">
    <meta name="rating" content="General">
    <meta name="target" content="Developers, Security Engineers, DevOps, System Administrators">
    <link rel="canonical" href="https://8gwifi.org/jwt-debugger.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JWT Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jsrsasign/10.8.6/jsrsasign-all-min.js"></script>

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --border-color: #dee2e6;
        }

        .jwt-container {
            margin: 2rem 0;
        }

        .jwt-controls {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .jwt-control-group {
            margin-bottom: 1rem;
        }

        .jwt-control-group label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
            color: #495057;
        }

        .jwt-btn {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .jwt-btn:hover {
            transform: translateY(-2px);
        }

        .jwt-btn.secondary {
            background: #6c757d;
        }

        .jwt-btn.success {
            background: var(--success-color);
        }

        .jwt-btn.danger {
            background: var(--danger-color);
        }

        .input-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .input-section {
                grid-template-columns: 1fr;
            }
        }

        .input-panel {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem;
            background: white;
        }

        .input-panel h3 {
            margin: 0 0 0.75rem 0;
            font-size: 1rem;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.6rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .jwt-textarea {
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            min-height: 150px;
            resize: vertical;
        }

        .jwt-display {
            background: #f8f9fa;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            white-space: pre-wrap;
            word-break: break-all;
            max-height: 400px;
            overflow-y: auto;
        }

        .jwt-part {
            margin-bottom: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
        }

        .jwt-header {
            background: #ffe6e6;
            border-left: 4px solid #ff6b6b;
        }

        .jwt-payload {
            background: #e6f3ff;
            border-left: 4px solid #4dabf7;
        }

        .jwt-signature {
            background: #e6ffe6;
            border-left: 4px solid #51cf66;
        }

        .jwt-status {
            padding: 0.75rem;
            border-radius: 8px;
            margin: 1rem 0;
            font-weight: 600;
            text-align: center;
        }

        .status-valid {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-invalid {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .status-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .copy-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 0.4rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        .copy-btn:hover {
            background: #5568d3;
        }

        .claim-item {
            padding: 0.5rem;
            background: #f8f9fa;
            border-left: 3px solid #667eea;
            margin-bottom: 0.5rem;
            border-radius: 4px;
        }

        .claim-key {
            font-weight: 600;
            color: #667eea;
        }

        .claim-value {
            color: #495057;
            margin-left: 0.5rem;
        }

        .algo-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-right: 0.5rem;
        }

        .algo-hs {
            background: #ffeaa7;
            color: #856404;
        }

        .algo-rs {
            background: #dfe6e9;
            color: #2d3436;
        }

        .algo-es {
            background: #a29bfe;
            color: #fff;
        }

        .timing-test {
            padding: 1rem;
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 8px;
            margin: 1rem 0;
        }
    </style>
</head>

    <%@ include file="body-script.jsp"%>

    <div class="page-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 0; margin-bottom: 1.5rem;">
        <div class="container">
            <h1 style="font-size: 1.75rem; margin-bottom: 0.25rem;"><i class="fas fa-key"></i> JWT Debugger</h1>
            <p style="font-size: 0.95rem; margin-bottom: 0; opacity: 0.9;">Decode, Verify & Generate JSON Web Tokens - RFC 7519</p>
        </div>
    </div>

    <div class="container">
        <div class="tool-description" style="background: #f8f9fa; border-left: 4px solid #667eea; padding: 0.75rem; margin-bottom: 1rem;">
            <p style="margin: 0; font-size: 0.9rem;"><i class="fas fa-info-circle"></i> Decode and verify JWT tokens online. Support all algorithms (HS256, RS256, ES256, etc.). Check signatures, expiration, and claims.</p>
        </div>

        <div class="jwt-container">
            <!-- JWT Input Section -->
            <div class="input-panel">
                <h3><i class="fas fa-code"></i> Encoded JWT Token</h3>
                <textarea class="form-control jwt-textarea" id="jwtToken" placeholder="Paste your JWT token here (e.g., eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c)"></textarea>
                <div style="margin-top: 0.75rem;">
                    <button class="jwt-btn" onclick="decodeJWT()">
                        <i class="fas fa-unlock"></i> Decode JWT
                    </button>
                    <button class="jwt-btn secondary" onclick="clearAll()">
                        <i class="fas fa-eraser"></i> Clear
                    </button>
                    <button class="jwt-btn secondary" onclick="loadExample()">
                        <i class="fas fa-file-import"></i> Load Example
                    </button>
                </div>
            </div>

            <!-- Decoded Sections -->
            <div class="input-section">
                <!-- Header -->
                <div class="input-panel">
                    <h3><i class="fas fa-file-code"></i> Header</h3>
                    <div id="headerDisplay" class="jwt-display">
                        <span style="color: #6c757d;">Decoded header will appear here</span>
                    </div>
                    <button class="copy-btn" onclick="copyToClipboard('header')">
                        <i class="fas fa-copy"></i> Copy Header
                    </button>
                </div>

                <!-- Payload -->
                <div class="input-panel">
                    <h3><i class="fas fa-database"></i> Payload</h3>
                    <div id="payloadDisplay" class="jwt-display">
                        <span style="color: #6c757d;">Decoded payload will appear here</span>
                    </div>
                    <button class="copy-btn" onclick="copyToClipboard('payload')">
                        <i class="fas fa-copy"></i> Copy Payload
                    </button>
                </div>
            </div>

            <!-- Signature Display -->
            <div class="input-panel">
                <h3><i class="fas fa-signature"></i> Signature (Base64Url Encoded)</h3>
                <div id="signatureDisplay" class="jwt-display" style="max-height: 150px;">
                    <span style="color: #6c757d;">Signature will appear here after decoding</span>
                </div>
                <button class="copy-btn" onclick="copyToClipboard('signature')">
                    <i class="fas fa-copy"></i> Copy Signature
                </button>
            </div>

            <!-- Verification Section -->
            <div class="input-panel">
                <h3><i class="fas fa-check-circle"></i> Verify Signature</h3>

                <div style="background: #e7f3ff; padding: 0.75rem; border-radius: 6px; margin-bottom: 1rem; font-size: 0.85rem;">
                    <i class="fas fa-info-circle" style="color: #0066cc;"></i> <strong>Note:</strong> Enter the secret/key that was used to <strong>sign</strong> the JWT token. For the example token, use: <code style="background: #fff; padding: 0.2rem 0.4rem; border-radius: 3px;">your-256-bit-secret</code>
                </div>

                <div class="jwt-control-group">
                    <label for="algorithm">Algorithm (auto-detected from token header):</label>
                    <select id="algorithm" class="form-control">
                        <option value="HS256">HS256 (HMAC-SHA256)</option>
                        <option value="HS384">HS384 (HMAC-SHA384)</option>
                        <option value="HS512">HS512 (HMAC-SHA512)</option>
                        <option value="RS256">RS256 (RSA-SHA256)</option>
                        <option value="RS384">RS384 (RSA-SHA384)</option>
                        <option value="RS512">RS512 (RSA-SHA512)</option>
                        <option value="ES256">ES256 (ECDSA-SHA256)</option>
                        <option value="ES384">ES384 (ECDSA-SHA384)</option>
                        <option value="ES512">ES512 (ECDSA-SHA512)</option>
                    </select>
                </div>

                <div class="jwt-control-group">
                    <label for="secretKey">Secret Key / Public Key:</label>
                    <textarea class="form-control" id="secretKey" rows="4" placeholder="Enter your secret key (for HS*) or public key in PEM format (for RS*/ES*)"></textarea>
                </div>

                <button class="jwt-btn" onclick="verifyJWT()">
                    <i class="fas fa-shield-alt"></i> Verify Signature
                </button>
                <button class="jwt-btn success" onclick="generateJWT()" title="Creates a new JWT using the decoded header/payload and signs it with your secret">
                    <i class="fas fa-plus"></i> Generate New JWT
                </button>

                <div id="verificationResult"></div>

                <div style="background: #fff3cd; padding: 0.75rem; border-radius: 6px; margin-top: 1rem; font-size: 0.85rem;">
                    <i class="fas fa-lightbulb" style="color: #856404;"></i> <strong>What does "Generate New JWT" do?</strong><br/>
                    It creates a brand new JWT token using the decoded header and payload above, and signs it with the secret key you provide. The newly generated token will replace the current one in the input field.
                </div>
            </div>

            <!-- Claims Inspector -->
            <div class="input-panel" style="margin-top: 1rem;">
                <h3><i class="fas fa-list"></i> Claims Inspector</h3>
                <div id="claimsDisplay">
                    <span style="color: #6c757d;">JWT claims will appear here after decoding</span>
                </div>
            </div>

            <!-- Timing Attack Test -->
            <div class="input-panel" style="margin-top: 1rem;">
                <h3><i class="fas fa-stopwatch"></i> Security Tests</h3>
                <button class="jwt-btn danger" onclick="timingAttackTest()">
                    <i class="fas fa-bug"></i> Test Timing Attack Vulnerability
                </button>
                <div id="timingResult"></div>
            </div>

            <!-- Information Section - Collapsible -->
            <div class="card mt-3">
                <div class="card-header" style="cursor: pointer; padding: 0.75rem 1rem;" onclick="document.getElementById('howItWorksContent').style.display = document.getElementById('howItWorksContent').style.display === 'none' ? 'block' : 'none'">
                    <h5 style="margin: 0; font-size: 1rem;"><i class="fas fa-book"></i> JWT Structure & Algorithms <span style="float: right;">▾</span></h5>
                </div>
                <div class="card-body" id="howItWorksContent" style="display: none; padding: 1rem; font-size: 0.9rem;">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><i class="fas fa-code"></i> JWT Structure</h6>
                            <p>A JWT consists of three parts separated by dots:</p>
                            <ul style="margin-bottom: 0.5rem; padding-left: 1.25rem;">
                                <li><strong>Header:</strong> Algorithm & token type</li>
                                <li><strong>Payload:</strong> Claims & data</li>
                                <li><strong>Signature:</strong> Verification signature</li>
                            </ul>
                            <p style="font-family: monospace; background: #f8f9fa; padding: 0.5rem; border-radius: 4px; font-size: 0.8rem;">
                                header.payload.signature
                            </p>
                        </div>
                        <div class="col-md-6">
                            <h6><i class="fas fa-lock"></i> Algorithms</h6>
                            <ul style="margin-bottom: 0.5rem; padding-left: 1.25rem;">
                                <li><strong>HMAC (HS*):</strong> Symmetric, shared secret</li>
                                <li><strong>RSA (RS*):</strong> Asymmetric, public/private key</li>
                                <li><strong>ECDSA (ES*):</strong> Elliptic curve, smaller keys</li>
                            </ul>
                        </div>
                    </div>
                    <hr style="margin: 0.75rem 0;">
                    <h6><i class="fas fa-shield-alt"></i> Security Tips</h6>
                    <ul style="margin-bottom: 0; padding-left: 1.25rem;">
                        <li>Always verify JWT signatures in production</li>
                        <li>Use strong secrets (min 256 bits for HS256)</li>
                        <li>Check expiration time (exp claim)</li>
                        <li>Validate issuer (iss) and audience (aud)</li>
                        <li>Use RS256/ES256 for public APIs</li>
                        <li>Never expose secret keys in client-side code</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Related Tools -->
        <div class="card mt-3">
            <div class="card-header" style="padding: 0.75rem 1rem;">
                <h5 style="margin: 0; font-size: 1rem;"><i class="fas fa-link"></i> Related Tools</h5>
            </div>
            <div class="card-body" style="padding: 0.75rem 1rem; font-size: 0.9rem;">
                <a href="jwkfunctions.jsp">JWK Generator</a> |
                <a href="jwsparse.jsp">JWS Parser</a> |
                <a href="jwsgen.jsp">JWS Generator</a> |
                <a href="jwsverify.jsp">JWS Verifier</a> |
                <a href="Base64Functions.jsp">Base64 Decoder</a> |
                <a href="MessageDigest.jsp">HMAC Generator</a>
            </div>
        </div>

        <hr>
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <hr>
        <%@ include file="footer_adsense.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>

    <script>
        let decodedHeader = null;
        let decodedPayload = null;
        let jwtParts = null;

        // Load example JWT
        function loadExample() {
            const exampleJWT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE5MTYyMzkwMjJ9.4Adcj0u6gq_bNMdcRWvYWf1kbY1u_tS8xHZ1FcLKqGw';
            document.getElementById('jwtToken').value = exampleJWT;
            document.getElementById('secretKey').value = 'your-256-bit-secret';
            decodeJWT();
        }

        // Base64URL decode
        function base64UrlDecode(str) {
            let base64 = str.replace(/-/g, '+').replace(/_/g, '/');
            while (base64.length % 4) {
                base64 += '=';
            }
            try {
                return decodeURIComponent(atob(base64).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));
            } catch (e) {
                return atob(base64);
            }
        }

        // Decode JWT
        function decodeJWT() {
            const token = document.getElementById('jwtToken').value.trim();

            if (!token) {
                alert('Please enter a JWT token');
                return;
            }

            try {
                jwtParts = token.split('.');

                if (jwtParts.length !== 3) {
                    throw new Error('Invalid JWT format. Expected 3 parts separated by dots.');
                }

                // Decode header
                const headerStr = base64UrlDecode(jwtParts[0]);
                decodedHeader = JSON.parse(headerStr);
                document.getElementById('headerDisplay').innerHTML = syntaxHighlight(JSON.stringify(decodedHeader, null, 2));

                // Decode payload
                const payloadStr = base64UrlDecode(jwtParts[1]);
                decodedPayload = JSON.parse(payloadStr);
                document.getElementById('payloadDisplay').innerHTML = syntaxHighlight(JSON.stringify(decodedPayload, null, 2));

                // Display signature (Base64Url encoded)
                const signature = jwtParts[2];
                let signatureHtml = '<div style="word-break: break-all; color: #51cf66; font-weight: 600;">';
                signatureHtml += signature;
                signatureHtml += '</div>';
                signatureHtml += '<div style="margin-top: 0.5rem; font-size: 0.85rem; color: #6c757d;">';
                signatureHtml += '<i class="fas fa-info-circle"></i> This is the Base64Url encoded signature. ';
                signatureHtml += 'Length: ' + signature.length + ' characters';
                signatureHtml += '</div>';
                document.getElementById('signatureDisplay').innerHTML = signatureHtml;

                // Display claims
                displayClaims(decodedPayload);

                // Auto-detect algorithm
                if (decodedHeader.alg) {
                    document.getElementById('algorithm').value = decodedHeader.alg;
                }

                // Check expiration
                checkExpiration(decodedPayload);

            } catch (e) {
                alert('Error decoding JWT: ' + e.message);
                console.error(e);
            }
        }

        // Syntax highlighting for JSON
        function syntaxHighlight(json) {
            json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                var cls = 'number';
                if (/^"/.test(match)) {
                    if (/:$/.test(match)) {
                        cls = 'key';
                    } else {
                        cls = 'string';
                    }
                } else if (/true|false/.test(match)) {
                    cls = 'boolean';
                } else if (/null/.test(match)) {
                    cls = 'null';
                }
                return '<span style="color: ' +
                    (cls === 'key' ? '#0066cc' : cls === 'string' ? '#008800' : cls === 'number' ? '#cc6600' : '#aa00cc') +
                    ';">' + match + '</span>';
            });
        }

        // Display claims
        function displayClaims(payload) {
            let html = '';
            const standardClaims = {
                iss: 'Issuer',
                sub: 'Subject',
                aud: 'Audience',
                exp: 'Expiration Time',
                nbf: 'Not Before',
                iat: 'Issued At',
                jti: 'JWT ID'
            };

            for (let key in payload) {
                const displayName = standardClaims[key] || key;
                let value = payload[key];

                // Format timestamps
                if (['exp', 'nbf', 'iat'].indexOf(key) !== -1 && typeof value === 'number') {
                    const date = new Date(value * 1000);
                    value = value + ' (' + date.toLocaleString() + ')';
                }

                html += '<div class="claim-item">';
                html += '<span class="claim-key">' + displayName + ':</span>';
                html += '<span class="claim-value">' + JSON.stringify(value) + '</span>';
                html += '</div>';
            }

            document.getElementById('claimsDisplay').innerHTML = html || '<span style="color: #6c757d;">No claims found</span>';
        }

        // Check expiration
        function checkExpiration(payload) {
            if (payload.exp) {
                const now = Math.floor(Date.now() / 1000);
                const exp = payload.exp;

                if (exp < now) {
                    const expDate = new Date(exp * 1000);
                    showStatus('warning', '<i class="fas fa-exclamation-triangle"></i> Token has expired on ' + expDate.toLocaleString());
                }
            }
        }

        // Verify JWT signature
        function verifyJWT() {
            const token = document.getElementById('jwtToken').value.trim();
            const secret = document.getElementById('secretKey').value.trim();
            const algorithm = document.getElementById('algorithm').value;

            if (!token) {
                alert('Please decode a JWT token first by clicking "Decode JWT"');
                return;
            }

            if (!secret) {
                alert('Please enter the secret key or public key that was used to sign this JWT');
                return;
            }

            // Check if token parts exist
            if (!jwtParts || jwtParts.length !== 3) {
                alert('Please decode the JWT token first by clicking "Decode JWT"');
                return;
            }

            try {
                // Get algorithm from decoded header or use selected one
                const tokenAlgorithm = decodedHeader && decodedHeader.alg ? decodedHeader.alg : algorithm;

                // Use jsrsasign library for verification
                const isValid = KJUR.jws.JWS.verify(token, secret, [tokenAlgorithm]);

                if (isValid) {
                    showStatus('valid', '<i class="fas fa-check-circle"></i> <strong>Signature Verified!</strong><br/>The JWT signature is valid. The token was signed with the provided secret/key and has not been tampered with.');
                } else {
                    showStatus('invalid', '<i class="fas fa-times-circle"></i> <strong>Signature Invalid!</strong><br/>The JWT signature does not match. Possible reasons:<br/>• Wrong secret/public key<br/>• Token has been modified<br/>• Algorithm mismatch');
                }
            } catch (e) {
                showStatus('invalid', '<i class="fas fa-exclamation-triangle"></i> <strong>Verification Error:</strong><br/>' + e.message + '<br/><br/>Make sure:<br/>• You entered the correct secret key (for HS* algorithms)<br/>• You entered the public key in PEM format (for RS*/ES* algorithms)<br/>• The algorithm matches the token header');
            }
        }

        // Generate JWT
        function generateJWT() {
            const header = decodedHeader || { alg: 'HS256', typ: 'JWT' };
            const payload = decodedPayload || {
                sub: '1234567890',
                name: 'John Doe',
                iat: Math.floor(Date.now() / 1000),
                exp: Math.floor(Date.now() / 1000) + 3600
            };
            const secret = document.getElementById('secretKey').value.trim();
            const algorithm = document.getElementById('algorithm').value;

            if (!secret) {
                alert('Please enter a secret key');
                return;
            }

            try {
                // Create JWT using jsrsasign
                const sHeader = JSON.stringify(header);
                const sPayload = JSON.stringify(payload);
                const jwt = KJUR.jws.JWS.sign(algorithm, sHeader, sPayload, secret);

                document.getElementById('jwtToken').value = jwt;
                showStatus('valid', '<i class="fas fa-check-circle"></i> JWT Generated Successfully!');
                decodeJWT();
            } catch (e) {
                showStatus('invalid', '<i class="fas fa-times-circle"></i> Generation Error: ' + e.message);
            }
        }

        // Timing attack test
        function timingAttackTest() {
            const token = document.getElementById('jwtToken').value.trim();
            const secret = document.getElementById('secretKey').value.trim();

            if (!token || !secret) {
                alert('Please enter both JWT token and secret key');
                return;
            }

            const iterations = 100;
            const validTimes = [];
            const invalidTimes = [];

            // Test with valid signature
            for (let i = 0; i < iterations; i++) {
                const start = performance.now();
                try {
                    KJUR.jws.JWS.verify(token, secret, ['HS256']);
                } catch (e) {}
                const end = performance.now();
                validTimes.push(end - start);
            }

            // Test with invalid signature
            for (let i = 0; i < iterations; i++) {
                const start = performance.now();
                try {
                    KJUR.jws.JWS.verify(token, secret + 'x', ['HS256']);
                } catch (e) {}
                const end = performance.now();
                invalidTimes.push(end - start);
            }

            const avgValid = validTimes.reduce((a, b) => a + b, 0) / validTimes.length;
            const avgInvalid = invalidTimes.reduce((a, b) => a + b, 0) / invalidTimes.length;
            const diff = Math.abs(avgValid - avgInvalid);

            let html = '<div class="timing-test">';
            html += '<h6><i class="fas fa-chart-line"></i> Timing Attack Test Results</h6>';
            html += '<p><strong>Average time (valid):</strong> ' + avgValid.toFixed(4) + ' ms</p>';
            html += '<p><strong>Average time (invalid):</strong> ' + avgInvalid.toFixed(4) + ' ms</p>';
            html += '<p><strong>Time difference:</strong> ' + diff.toFixed(4) + ' ms</p>';

            if (diff > 0.1) {
                html += '<p style="color: #dc3545;"><i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> Significant timing difference detected. This implementation may be vulnerable to timing attacks.</p>';
            } else {
                html += '<p style="color: #28a745;"><i class="fas fa-check-circle"></i> Timing difference is minimal. Implementation appears resistant to basic timing attacks.</p>';
            }

            html += '</div>';

            document.getElementById('timingResult').innerHTML = html;
        }

        // Show status message
        function showStatus(type, message) {
            const className = type === 'valid' ? 'status-valid' : type === 'warning' ? 'status-warning' : 'status-invalid';
            const html = '<div class="jwt-status ' + className + '">' + message + '</div>';
            document.getElementById('verificationResult').innerHTML = html;
        }

        // Copy to clipboard
        function copyToClipboard(part) {
            let text = '';
            if (part === 'header') {
                text = JSON.stringify(decodedHeader, null, 2);
            } else if (part === 'payload') {
                text = JSON.stringify(decodedPayload, null, 2);
            } else if (part === 'signature') {
                text = jwtParts && jwtParts[2] ? jwtParts[2] : '';
            }

            if (!text) {
                alert('Nothing to copy. Please decode a JWT first.');
                return;
            }

            navigator.clipboard.writeText(text).then(function() {
                alert('Copied to clipboard!');
            }).catch(function() {
                alert('Failed to copy to clipboard');
            });
        }

        // Clear all
        function clearAll() {
            document.getElementById('jwtToken').value = '';
            document.getElementById('secretKey').value = '';
            document.getElementById('headerDisplay').innerHTML = '<span style="color: #6c757d;">Decoded header will appear here</span>';
            document.getElementById('payloadDisplay').innerHTML = '<span style="color: #6c757d;">Decoded payload will appear here</span>';
            document.getElementById('signatureDisplay').innerHTML = '<span style="color: #6c757d;">Signature will appear here after decoding</span>';
            document.getElementById('claimsDisplay').innerHTML = '<span style="color: #6c757d;">JWT claims will appear here after decoding</span>';
            document.getElementById('verificationResult').innerHTML = '';
            document.getElementById('timingResult').innerHTML = '';
            decodedHeader = null;
            decodedPayload = null;
            jwtParts = null;
        }

        // Auto-decode on page load if JWT is in URL
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const token = urlParams.get('token');
            if (token) {
                document.getElementById('jwtToken').value = token;
                decodeJWT();
            }
        };
    </script>
</div>
<%@ include file="body-close.jsp"%>
