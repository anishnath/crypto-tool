<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>HMAC Generator Online – Free | 8gwifi.org</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online HMAC generator. Compute keyed hashes (HMAC) with SHA-256, SHA-512, RIPEMD, TIGER and more. Keys never leave your browser. Great for API signing and message authentication.">
    <meta name="keywords" content="online hmac generator, hmac online, HMAC SHA-256, HMAC SHA-512, HMAC RIPEMD160, HMAC TIGER, message authentication, keyed hash, API signing, MAC generator">

    <!-- Open Graph -->
    <meta property="og:title" content="HMAC Generator Online – Free | 8gwifi.org">
    <meta property="og:description" content="Generate HMACs (keyed hashes) with SHA-2, SHA-3, RIPEMD, TIGER and more. All computation happens in your browser – keys are never uploaded.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/hmacgen.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/hmac.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="HMAC Generator Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Generate secure HMACs for API signing and integrity protection. SHA-256, SHA-512, RIPEMD, TIGER and more. Keys never leave your browser.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/hmac.png">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/hmacgen.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD EEAT / WebApplication + FAQ + Breadcrumbs -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@graph": [
        {
          "@type": "WebApplication",
          "@id": "https://8gwifi.org/hmacgen.jsp#app",
          "name": "Online HMAC Generator",
          "alternateName": "HMAC Calculator, Message Authentication Code Generator, API Signing Helper",
          "applicationCategory": "SecurityApplication",
          "operatingSystem": "Any",
          "url": "https://8gwifi.org/hmacgen.jsp",
          "image": "https://8gwifi.org/images/site/hmac.png",
          "description": "Free online HMAC generator to compute keyed hashes using SHA-256, SHA-512, RIPEMD, TIGER and more. Ideal for API request signing and integrity checks. Keys are processed only in the browser and never logged on the server.",
          "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good"
          },
          "creator": {
            "@type": "Person",
            "name": "Anish Nath"
          },
          "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
          },
          "datePublished": "2017-09-25",
          "dateModified": "2025-01-28",
          "softwareVersion": "v3.0",
          "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
          },
          "keywords": [
            "online hmac generate",
            "generate hmac online",
            "HMAC SHA-256",
            "message authentication code",
            "API signing helper"
          ]
        },
        {
          "@type": "FAQPage",
          "@id": "https://8gwifi.org/hmacgen.jsp#faq",
          "mainEntity": [
            {
              "@type": "Question",
              "name": "What is an HMAC?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "HMAC (Hash-based Message Authentication Code) combines a cryptographic hash function with a secret key to provide both integrity and authentication for a message. If the HMAC verifies, you know the message has not been modified and that it was created by someone who knows the shared secret key."
              }
            },
            {
              "@type": "Question",
              "name": "Which HMAC algorithms should I use?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "For modern systems, HMAC-SHA-256 or HMAC-SHA-512 are generally recommended. Legacy hashes such as MD5, MD4, MD2 or SHA-1 are kept mainly for interoperability and testing and should be avoided in new designs."
              }
            },
            {
              "@type": "Question",
              "name": "Are my keys or messages uploaded to the server?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "This HMAC generator is designed so that computation happens on the server but keys are not stored or logged on disk. You should still avoid using production secrets from untrusted or shared environments."
              }
            },
            {
              "@type": "Question",
              "name": "How strong should my HMAC key be?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Your HMAC key should be at least as strong as the hash output. For HMAC-SHA-256, a randomly generated 128-256 bit key (16-32 bytes) is sufficient. Avoid short, guessable keys; use a cryptographic random generator instead."
              }
            }
          ]
        },
        {
          "@type": "BreadcrumbList",
          "@id": "https://8gwifi.org/hmacgen.jsp#breadcrumb",
          "itemListElement": [
            {
              "@type": "ListItem",
              "position": 1,
              "name": "8gwifi.org",
              "item": "https://8gwifi.org/"
            },
            {
              "@type": "ListItem",
              "position": 2,
              "name": "HMAC Generator",
              "item": "https://8gwifi.org/hmacgen.jsp"
            }
          ]
        }
      ]
    }
    </script>

    <style>
        :root {
            --theme-primary: #0ea5e9;
            --theme-secondary: #38bdf8;
            --theme-gradient: linear-gradient(135deg, #0ea5e9 0%, #38bdf8 100%);
            --theme-light: #f0f9ff;
        }

        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: box-shadow 0.2s;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }

        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
        }

        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
        }

        .result-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem 1rem;
            color: #6c757d;
        }
        .result-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        .result-content {
            display: none;
        }

        .hash-output {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 0.75rem;
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
            font-size: 0.85rem;
            word-break: break-all;
        }

        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }

        .info-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-right: 0.5rem;
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

        .algo-group {
            margin-bottom: 1rem;
        }
        .algo-group-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .algo-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            padding: 0.25rem 0.65rem;
            margin: 0.2rem 0.3rem 0.2rem 0;
            background: #fff;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.15s;
        }
        .algo-chip:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .algo-chip input[type="checkbox"] {
            margin: 0;
        }
        .algo-chip.recommended {
            border-color: #22c55e;
            background: rgba(34, 197, 94, 0.05);
        }
        .algo-chip.legacy {
            border-color: #f97316;
            background: rgba(249, 115, 22, 0.03);
        }
        .algo-chip.weak {
            border-color: #ef4444;
            background: rgba(239, 68, 68, 0.03);
        }

        .result-item {
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            padding: 1rem;
            margin-bottom: 1rem;
            background: #fff;
        }
        .result-item:last-child {
            margin-bottom: 0;
        }
        .result-algo-name {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
        }
        .result-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }

        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            display: block;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
            border: 1px solid transparent;
        }
        .related-tool-card:hover {
            background: var(--theme-light);
            border-color: var(--theme-primary);
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

        .btn-theme {
            background: var(--theme-gradient);
            border: none;
            color: white;
        }
        .btn-theme:hover {
            opacity: 0.9;
            color: white;
        }

        .copy-feedback {
            font-size: 0.75rem;
            color: #16a34a;
            margin-left: 0.5rem;
        }

        @media (max-width: 991.98px) {
            .row > .col-lg-5,
            .row > .col-lg-7 {
                margin-bottom: 1.5rem;
            }
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
    <%@ include file="pgp-menu-nav.jsp"%>
    <%@ include file="footer_adsense.jsp"%>
<div class="container mt-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <div>
            <h1 class="h4 mb-1">HMAC Generator</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-key"></i> Keyed Hash</span>
                <span class="info-badge"><i class="fas fa-shield-alt"></i> Integrity + Auth</span>
                <span class="info-badge"><i class="fas fa-code"></i> API Signing</span>
            </div>
        </div>
        <div class="eeat-badge mt-2 mt-md-0">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <div class="row">
        <!-- Left Column: Input Form -->
        <div class="col-lg-5 mb-4">
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-calculator me-2"></i>Generate HMAC</h5>
                </div>
                <div class="card-body">
                    <form id="hmacForm" method="POST">
                        <input type="hidden" name="methodName" id="methodName" value="GENERATE_HMAC">

                        <!-- Message Input -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-file-alt me-1"></i> Message</div>
                            <textarea class="form-control" id="inputtext" name="text" rows="3" placeholder="Enter message to authenticate..."></textarea>
                            <small class="text-muted mt-1 d-block">The message you will later verify with the same key and algorithm.</small>
                        </div>

                        <!-- Secret Key -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-key me-1"></i> Secret Key</div>
                            <div class="input-group">
                                <input class="form-control" id="passphrase" type="password" name="passphrase" autocomplete="off" placeholder="Enter or generate a secret key">
                                <div class="input-group-append">
                                    <button type="button" id="btnGenKey" class="btn btn-outline-secondary">
                                        <i class="fas fa-random"></i> Generate
                                    </button>
                                    <button type="button" id="btnToggleKey" class="btn btn-outline-secondary">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <small class="text-muted mt-1 d-block">Use a high-entropy key. Keys are never stored on disk.</small>
                        </div>

                        <!-- Algorithm Selection -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-cog me-1"></i> Algorithms</div>

                            <div class="algo-group">
                                <div class="algo-group-title"><i class="fas fa-check-circle text-success me-1"></i> Recommended</div>
                                <label class="algo-chip recommended">
                                    <input type="checkbox" id="HmacSHA256" value="HmacSHA256" name="HmacSHA256" checked>
                                    <span>HMAC-SHA-256</span>
                                </label>
                                <label class="algo-chip recommended">
                                    <input type="checkbox" id="HmacSHA512" value="HmacSHA512" name="HmacSHA512">
                                    <span>HMAC-SHA-512</span>
                                </label>
                                <label class="algo-chip recommended">
                                    <input type="checkbox" id="HmacSHA224" value="HmacSHA224" name="HmacSHA224">
                                    <span>HMAC-SHA-224</span>
                                </label>
                                <label class="algo-chip recommended">
                                    <input type="checkbox" id="HmacSHA384" value="HmacSHA384" name="HmacSHA384">
                                    <span>HMAC-SHA-384</span>
                                </label>
                            </div>

                            <div class="algo-group">
                                <div class="algo-group-title"><i class="fas fa-history text-muted me-1"></i> Other Algorithms</div>
                                <label class="algo-chip">
                                    <input type="checkbox" id="HmacSHA1" value="HmacSHA1" name="HmacSHA1">
                                    <span>HMAC-SHA-1</span>
                                </label>
                                <label class="algo-chip">
                                    <input type="checkbox" id="HMACTIGER" value="HMACTIGER" name="HMACTIGER">
                                    <span>HMAC-TIGER</span>
                                </label>
                                <label class="algo-chip">
                                    <input type="checkbox" id="HMACRIPEMD128" value="HMACRIPEMD128" name="HMACRIPEMD128">
                                    <span>HMAC-RIPEMD-128</span>
                                </label>
                                <label class="algo-chip">
                                    <input type="checkbox" id="HMACRIPEMD160" value="HMACRIPEMD160" name="HMACRIPEMD160">
                                    <span>HMAC-RIPEMD-160</span>
                                </label>
                            </div>

                            <div class="algo-group">
                                <div class="algo-group-title"><i class="fas fa-exclamation-triangle text-warning me-1"></i> Legacy (Testing Only)</div>
                                <label class="algo-chip legacy">
                                    <input type="checkbox" id="RC2MAC" value="RC2MAC" name="RC2MAC">
                                    <span>RC2-MAC</span>
                                </label>
                                <label class="algo-chip legacy">
                                    <input type="checkbox" id="RC5MAC" value="RC5MAC" name="RC5MAC">
                                    <span>RC5-MAC</span>
                                </label>
                                <label class="algo-chip legacy">
                                    <input type="checkbox" id="IDEAMAC" value="IDEAMAC" name="IDEAMAC">
                                    <span>IDEA-MAC</span>
                                </label>
                                <label class="algo-chip legacy">
                                    <input type="checkbox" id="DES" value="DES" name="DES">
                                    <span>DES-MAC</span>
                                </label>
                                <label class="algo-chip legacy">
                                    <input type="checkbox" id="DESEDEMAC" value="DESEDEMAC" name="DESEDEMAC">
                                    <span>3DES-MAC</span>
                                </label>
                                <label class="algo-chip weak">
                                    <input type="checkbox" id="HMACMD5" value="HMACMD5" name="HMACMD5">
                                    <span>HMAC-MD5</span>
                                </label>
                                <label class="algo-chip weak">
                                    <input type="checkbox" id="HMACMD4" value="HMACMD4" name="HMACMD4">
                                    <span>HMAC-MD4</span>
                                </label>
                                <label class="algo-chip weak">
                                    <input type="checkbox" id="HMACMD2" value="HMACMD2" name="HMACMD2">
                                    <span>HMAC-MD2</span>
                                </label>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-theme">
                                <i class="fas fa-calculator me-1"></i> Compute HMAC
                            </button>
                            <button type="button" id="btnClear" class="btn btn-outline-secondary">
                                <i class="fas fa-eraser me-1"></i> Clear
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- OpenSSL Commands -->
            <div class="card tool-card mt-3">
                <div class="card-header bg-dark text-white py-2">
                    <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Commands</h6>
                </div>
                <div class="card-body">
                    <p class="small text-muted mb-2">Generate HMAC-SHA-256 from command line:</p>
                    <pre class="bg-light p-2 rounded small mb-2"><code>echo -n "message" | openssl dgst -sha256 -hmac "secret-key"</code></pre>
                    <p class="small text-muted mb-2">Using a key file:</p>
                    <pre class="bg-light p-2 rounded small mb-0"><code>openssl dgst -sha256 -hmac "$(cat keyfile)" -binary message.txt | base64</code></pre>
                </div>
            </div>
        </div>

        <!-- Right Column: Results -->
        <div class="col-lg-7 mb-4">
            <!-- Results Card -->
            <div class="card tool-card mb-3">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-shield-alt me-2"></i>HMAC Results</h5>
                </div>
                <div class="card-body">
                    <!-- Error Alert -->
                    <div id="hmacError" class="alert alert-danger" style="display:none" role="alert">
                        <i class="fas fa-exclamation-triangle me-1"></i><span id="hmacErrorText"></span>
                    </div>

                    <!-- Placeholder -->
                    <div id="resultsPlaceholder" class="result-placeholder">
                        <i class="fas fa-shield-alt"></i>
                        <h6>HMAC Results Will Appear Here</h6>
                        <p class="text-muted small mb-0">Enter a message, secret key, select algorithms, then click Compute HMAC</p>
                    </div>

                    <!-- Results Container -->
                    <div id="hmacResults" class="result-content"></div>

                    <!-- Share Button -->
                    <div id="shareButtonContainer" class="mt-3" style="display:none">
                        <button type="button" id="btnShare" class="btn btn-outline-info btn-sm">
                            <i class="fas fa-share-alt me-1"></i> Share Results
                        </button>
                    </div>
                </div>
            </div>

            <!-- Algorithm Guide -->
            <div class="card tool-card">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Algorithm Guide</h6>
                </div>
                <div class="card-body">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Algorithm</th>
                                <th>Output Size</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="table-success">
                                <td><strong>HMAC-SHA-256</strong></td>
                                <td>256 bits (32 bytes)</td>
                                <td><span class="badge bg-success">Recommended</span></td>
                            </tr>
                            <tr class="table-success">
                                <td><strong>HMAC-SHA-512</strong></td>
                                <td>512 bits (64 bytes)</td>
                                <td><span class="badge bg-success">Recommended</span></td>
                            </tr>
                            <tr>
                                <td>HMAC-SHA-1</td>
                                <td>160 bits (20 bytes)</td>
                                <td><span class="badge bg-warning text-dark">Legacy</span></td>
                            </tr>
                            <tr>
                                <td>HMAC-MD5</td>
                                <td>128 bits (16 bytes)</td>
                                <td><span class="badge bg-danger">Weak</span></td>
                            </tr>
                            <tr>
                                <td>HMAC-RIPEMD-160</td>
                                <td>160 bits (20 bytes)</td>
                                <td><span class="badge bg-secondary">Niche</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Educational Content -->
    <div class="row mt-2">
        <div class="col-12">
            <div class="card tool-card mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding HMAC</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>What is HMAC?</h6>
                            <p>HMAC (Hash-based Message Authentication Code) is a construction that combines a cryptographic hash function with a secret key. It provides two properties:</p>
                            <ul>
                                <li><strong>Integrity:</strong> Confirms the message hasn't been modified</li>
                                <li><strong>Authentication:</strong> Proves the sender knows the shared secret</li>
                            </ul>
                            <p>The HMAC formula: <code>HMAC(K, m) = H((K ⊕ opad) || H((K ⊕ ipad) || m))</code></p>

                            <h6 class="mt-4">Why Use HMAC Instead of Plain Hash?</h6>
                            <p>A plain hash like SHA-256(message) only detects accidental changes. Anyone can recompute it. HMAC adds a secret key so only authorized parties can generate or verify the MAC.</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Common Use Cases</h6>
                            <ul>
                                <li><strong>API Request Signing:</strong> AWS Signature V4, Stripe webhooks</li>
                                <li><strong>JWT Tokens:</strong> HS256 algorithm uses HMAC-SHA-256</li>
                                <li><strong>Webhook Verification:</strong> GitHub, Slack webhook signatures</li>
                                <li><strong>Key Derivation:</strong> HKDF uses HMAC internally</li>
                                <li><strong>VPN/IPsec:</strong> Integrity protection in network protocols</li>
                            </ul>

                            <h6 class="mt-4">Key Strength Recommendations</h6>
                            <ul>
                                <li>HMAC-SHA-256: Use 256-bit (32 byte) keys</li>
                                <li>HMAC-SHA-512: Use 512-bit (64 byte) keys</li>
                                <li>Minimum: 128-bit (16 byte) random key</li>
                                <li>Always use cryptographic random generator</li>
                            </ul>
                        </div>
                    </div>

                    <h6 class="mt-4">Code Examples</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <p class="small mb-1"><strong>Python</strong></p>
                            <pre class="bg-dark text-light p-2 rounded small"><code>import hmac
import hashlib

key = b'secret-key'
message = b'Hello, World!'
signature = hmac.new(key, message, hashlib.sha256).hexdigest()
print(signature)</code></pre>
                        </div>
                        <div class="col-md-6">
                            <p class="small mb-1"><strong>Node.js</strong></p>
                            <pre class="bg-dark text-light p-2 rounded small"><code>const crypto = require('crypto');

const key = 'secret-key';
const message = 'Hello, World!';
const hmac = crypto.createHmac('sha256', key)
                   .update(message).digest('hex');
console.log(hmac);</code></pre>
                        </div>
                    </div>

                    <h6 class="mt-4">Security Standards & References</h6>
                    <ul class="mb-0">
                        <li><a href="https://datatracker.ietf.org/doc/html/rfc2104" target="_blank" rel="noopener">RFC 2104: HMAC: Keyed-Hashing for Message Authentication</a></li>
                        <li><a href="https://datatracker.ietf.org/doc/html/rfc4868" target="_blank" rel="noopener">RFC 4868: HMAC-SHA-256/384/512 for IPsec</a></li>
                        <li><a href="https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.198-1.pdf" target="_blank" rel="noopener">NIST FIPS 198-1: The Keyed-Hash Message Authentication Code</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="row">
        <div class="col-12">
            <div class="card tool-card mb-4">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
                </div>
                <div class="card-body">
                    <div class="related-tools">
                        <a href="HashFunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-hashtag me-1"></i>Hash Generator</h6>
                            <p>SHA-256, SHA-512, MD5 and more</p>
                        </a>
                        <a href="bccrypt.jsp" class="related-tool-card">
                            <h6><i class="fas fa-lock me-1"></i>BCrypt</h6>
                            <p>Password hashing with Blowfish</p>
                        </a>
                        <a href="scrypt.jsp" class="related-tool-card">
                            <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                            <p>Memory-hard key derivation</p>
                        </a>
                        <a href="argon2.jsp" class="related-tool-card">
                            <h6><i class="fas fa-trophy me-1"></i>Argon2</h6>
                            <p>PHC winner, modern password hashing</p>
                        </a>
                        <a href="jwttoken.jsp" class="related-tool-card">
                            <h6><i class="fas fa-ticket-alt me-1"></i>JWT Decoder</h6>
                            <p>Decode and verify JWT tokens</p>
                        </a>
                        <a href="CipherFunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-key me-1"></i>Encryption</h6>
                            <p>AES, DES, and other ciphers</p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt"></i> Share HMAC Results
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div id="shareWarningContent"></div>

                <label class="font-weight-bold mb-2">Share URL:</label>
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="shareUrlText" readonly style="font-size: 11px; font-family: monospace;">
                    <div class="input-group-append">
                        <button class="btn btn-success" type="button" id="copyShareUrl">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    var lastResults = null;

    // Show toast notification
    function showToast(message, isError) {
        var bgColor = isError ? '#dc3545' : 'var(--theme-gradient)';
        var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: ' + bgColor + ';">' +
            '<i class="fas ' + (isError ? 'fa-exclamation-circle' : 'fa-check-circle') + ' me-2"></i>' + message +
            '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2500);
    }

    // Clear error
    function clearError() {
        $('#hmacError').hide();
        $('#hmacErrorText').text('');
    }

    // Show error
    function showError(msg) {
        $('#hmacErrorText').text(msg);
        $('#hmacError').show();
    }

    // Generate random key
    $('#btnGenKey').click(function() {
        try {
            var arr = new Uint8Array(32);
            if (window.crypto && window.crypto.getRandomValues) {
                window.crypto.getRandomValues(arr);
            } else {
                for (var i = 0; i < 32; i++) {
                    arr[i] = Math.floor(Math.random() * 256);
                }
            }
            var hex = Array.from(arr).map(function(b) {
                return ('0' + b.toString(16)).slice(-2);
            }).join('');
            $('#passphrase').val(hex).attr('type', 'text');
            $('#btnToggleKey i').removeClass('fa-eye').addClass('fa-eye-slash');
            showToast('256-bit key generated');
        } catch (e) {
            showToast('Failed to generate key', true);
        }
    });

    // Toggle key visibility
    $('#btnToggleKey').click(function() {
        var input = $('#passphrase');
        var icon = $(this).find('i');
        if (input.attr('type') === 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });

    // Clear form
    $('#btnClear').click(function() {
        $('#hmacForm')[0].reset();
        $('#HmacSHA256').prop('checked', true);
        clearError();
        $('#resultsPlaceholder').show();
        $('#hmacResults').hide().empty();
        $('#shareButtonContainer').hide();
        lastResults = null;
    });

    // Render results
    function renderResults(data) {
        var container = $('#hmacResults');
        container.empty();

        if (!data || !data.results || !data.results.length) {
            $('#resultsPlaceholder').show();
            container.hide();
            return;
        }

        $('#resultsPlaceholder').hide();
        container.show();

        data.results.forEach(function(r) {
            var item = $('<div class="result-item"></div>');

            var header = $('<div class="d-flex justify-content-between align-items-center mb-2"></div>');
            header.append('<div class="result-algo-name">' + escapeHtml(r.algorithm || 'HMAC') + '</div>');
            if (r.hexEncoded) {
                var byteLen = r.hexEncoded.length / 2;
                header.append('<span class="badge bg-secondary">' + byteLen + ' bytes</span>');
            }
            item.append(header);

            // Base64 output
            item.append('<div class="result-label">Base64</div>');
            var b64Group = $('<div class="input-group input-group-sm mb-2"></div>');
            var b64Input = $('<input type="text" class="form-control hash-output" readonly>').val(r.base64Encoded || '');
            var b64Btn = $('<button type="button" class="btn btn-outline-secondary"><i class="fas fa-copy"></i></button>');
            b64Btn.click(function() {
                copyToClipboard(b64Input.val());
                showToast('Base64 copied!');
            });
            b64Group.append(b64Input).append($('<div class="input-group-append"></div>').append(b64Btn));
            item.append(b64Group);

            // Hex output
            item.append('<div class="result-label">Hex</div>');
            var hexGroup = $('<div class="input-group input-group-sm"></div>');
            var hexInput = $('<input type="text" class="form-control hash-output" readonly>').val(r.hexEncoded || '');
            var hexBtn = $('<button type="button" class="btn btn-outline-secondary"><i class="fas fa-copy"></i></button>');
            hexBtn.click(function() {
                copyToClipboard(hexInput.val());
                showToast('Hex copied!');
            });
            hexGroup.append(hexInput).append($('<div class="input-group-append"></div>').append(hexBtn));
            item.append(hexGroup);

            container.append(item);
        });

        $('#shareButtonContainer').show();
    }

    // Copy to clipboard
    function copyToClipboard(text) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text);
        } else {
            var ta = document.createElement('textarea');
            ta.value = text;
            ta.style.position = 'fixed';
            ta.style.opacity = '0';
            document.body.appendChild(ta);
            ta.select();
            try { document.execCommand('copy'); } catch (e) {}
            document.body.removeChild(ta);
        }
    }

    // Escape HTML
    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Form submission
    $('#hmacForm').submit(function(e) {
        e.preventDefault();
        clearError();

        var msg = $('#inputtext').val().trim();
        var key = $('#passphrase').val();

        if (!msg) {
            showError('Please enter a message to authenticate.');
            return;
        }
        if (!key) {
            showError('Please enter a secret key.');
            return;
        }
        if (key.length < 8) {
            showError('Key is too short. Use at least 8 characters.');
            return;
        }

        var hasAlgo = false;
        $('#hmacForm input[type="checkbox"]').each(function() {
            if ($(this).is(':checked')) hasAlgo = true;
        });
        if (!hasAlgo) {
            showError('Please select at least one algorithm.');
            return;
        }

        $('#resultsPlaceholder').hide();
        $('#hmacResults').html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i><p class="mt-2 text-muted">Computing HMAC...</p></div>').show();
        $('#shareButtonContainer').hide();

        $.ajax({
            type: 'POST',
            url: 'MDFunctionality',
            data: $(this).serialize(),
            dataType: 'json',
            success: function(data) {
                if (!data || data.success === false) {
                    showError(data && data.errorMessage ? data.errorMessage : 'Failed to compute HMAC.');
                    $('#hmacResults').hide();
                    $('#resultsPlaceholder').show();
                    return;
                }
                lastResults = data;
                renderResults(data);
            },
            error: function(xhr, status, error) {
                showError('Server error: ' + (error || 'Unknown error'));
                $('#hmacResults').hide();
                $('#resultsPlaceholder').show();
            }
        });
    });

    // Share URL
    $('#btnShare').click(function() {
        var msg = $('#inputtext').val().trim();
        var key = $('#passphrase').val();

        if (!msg || !lastResults) {
            showToast('Compute HMAC first before sharing.', true);
            return;
        }

        var selected = [];
        $('#hmacForm input[type="checkbox"]:checked').each(function() {
            selected.push($(this).attr('id'));
        });

        var params = new URLSearchParams();
        params.set('msg', msg);
        if (selected.length) {
            params.set('algos', selected.join(','));
        }

        var includesKey = false;
        if (key) {
            params.set('key', key);
            includesKey = true;
        }

        var url = window.location.origin + window.location.pathname + '?' + params.toString();

        // Build warning content
        var warningHtml = '';
        var algoText = selected.length ? selected.join(', ') : 'Default selection';

        if (includesKey) {
            warningHtml =
                '<div class="alert alert-danger mb-3">' +
                    '<strong><i class="fas fa-exclamation-triangle"></i> DANGER: Secret Key Included!</strong>' +
                    '<ul class="mb-0 mt-2">' +
                        '<li><strong>Message:</strong> Included in URL</li>' +
                        '<li><strong>Algorithms:</strong> ' + escapeHtml(algoText) + '</li>' +
                        '<li><strong class="text-danger">Secret Key:</strong> INCLUDED in URL</li>' +
                    '</ul>' +
                '</div>' +
                '<div class="alert alert-danger mb-0">' +
                    '<strong><i class="fas fa-skull-crossbones"></i> CRITICAL WARNING:</strong>' +
                    '<p class="mb-2">You are sharing your HMAC secret key!</p>' +
                    '<ul class="mb-0">' +
                        '<li>Anyone with this URL can verify or forge HMACs</li>' +
                        '<li>Only use for demos or throwaway keys</li>' +
                        '<li>Never share production secrets via URL</li>' +
                    '</ul>' +
                '</div>';
        } else {
            warningHtml =
                '<div class="alert alert-info mb-3">' +
                    '<strong><i class="fas fa-shield-alt"></i> What\'s Being Shared:</strong>' +
                    '<ul class="mb-0 mt-2">' +
                        '<li><strong>Message:</strong> Included in URL</li>' +
                        '<li><strong>Algorithms:</strong> ' + escapeHtml(algoText) + '</li>' +
                        '<li><strong class="text-success">Secret Key:</strong> NOT included</li>' +
                    '</ul>' +
                '</div>' +
                '<div class="alert alert-success mb-0">' +
                    '<i class="fas fa-check-circle"></i> ' +
                    'The secret key is not in this URL. Recipient will need the key to verify the HMAC.' +
                '</div>';
        }

        $('#shareWarningContent').html(warningHtml);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    });

    // Copy share URL
    $('#copyShareUrl').click(function() {
        var url = $('#shareUrlText').val();
        if (!url) return;
        copyToClipboard(url);
        var btn = $(this);
        var oldHtml = btn.html();
        btn.html('<i class="fas fa-check"></i> Copied!');
        setTimeout(function() { btn.html(oldHtml); }, 1500);
    });

    // Load from URL
    function loadFromUrl() {
        try {
            var params = new URLSearchParams(window.location.search);
            var msg = params.get('msg') || params.get('text');
            var algos = params.get('algos');
            var key = params.get('key');

            if (msg) {
                $('#inputtext').val(msg);
            }
            if (algos) {
                // Uncheck all first
                $('#hmacForm input[type="checkbox"]').prop('checked', false);
                algos.split(',').forEach(function(a) {
                    $('#' + a).prop('checked', true);
                });
            }
            if (key) {
                $('#passphrase').val(key);
            }

            // Auto-compute if we have message and key
            if (msg && key) {
                $('#hmacForm').submit();
            }
        } catch (e) {
            console.error('Error loading from URL:', e);
        }
    }

    loadFromUrl();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
