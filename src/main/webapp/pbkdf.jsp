<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PBKDF2 Key Derivation Online – Free | 8gwifi.org</title>
    <meta name="description" content="Derive cryptographic keys from passwords using PBKDF2 (Password-Based Key Derivation Function 2). Supports HMAC-SHA1, SHA256, SHA384, SHA512. RFC 2898 / PKCS#5 compliant." />
    <meta name="keywords" content="PBKDF2 online, password key derivation, PBKDF2 generator, derive key from password, HMAC-SHA256, PKCS5, RFC 2898, key derivation function" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/pbkdf.jsp" />

    <%
        String[] validList = {"PBKDF2WithHmacSHA256", "PBKDF2WithHmacSHA224", "PBKDF2WithHmacSHA512", "PBKDF2WithHmacSHA384"};
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        String defaultSalt = new String(Base64.encodeBase64(salt));
    %>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "PBKDF2 Key Derivation Tool",
            "description": "Derive cryptographic keys from passwords using PBKDF2. Supports multiple hash algorithms including SHA-256 and SHA-512. RFC 2898 compliant.",
            "url": "https://8gwifi.org/pbkdf.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "datePublished": "2018-11-29",
            "dateModified": "2025-01-28"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is PBKDF2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "PBKDF2 (Password-Based Key Derivation Function 2) is a key derivation function specified in RFC 2898 and PKCS#5. It applies a pseudorandom function (like HMAC-SHA256) to a password along with a salt, repeating the process many times to produce a derived key suitable for cryptographic operations."
                    }
                },
                {
                    "@type": "Question",
                    "name": "How many iterations should I use for PBKDF2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "OWASP recommends at least 600,000 iterations for PBKDF2-HMAC-SHA256 as of 2023. For older systems, minimum 310,000 iterations for SHA-256 or 120,000 for SHA-512. Higher iterations increase security but also computation time."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What is the difference between PBKDF2 and bcrypt/Argon2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "PBKDF2 is CPU-intensive but not memory-hard, making it vulnerable to GPU attacks. Bcrypt uses 4KB of memory, while Argon2 uses configurable memory (typically 64MB+). For new applications, Argon2id is recommended over PBKDF2. However, PBKDF2 remains widely used for compatibility."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What key length should I use with PBKDF2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "The key length depends on your use case: 128 bits (16 bytes) for AES-128, 256 bits (32 bytes) for AES-256, or 512 bits (64 bytes) for HMAC-SHA512. Never derive more bits than the hash function outputs without careful consideration."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #059669;
            --theme-secondary: #10b981;
            --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --theme-light: #ecfdf5;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(5, 150, 105, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.25);
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
            min-height: 200px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 150px;
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
        .algo-checkbox {
            flex: 1;
            min-width: 80px;
            cursor: pointer;
        }
        .algo-checkbox input[type="checkbox"] {
            display: none;
        }
        .algo-checkbox .algo-label {
            display: block;
            padding: 0.5rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            text-align: center;
            transition: all 0.2s;
        }
        .algo-checkbox:hover .algo-label {
            border-color: var(--theme-primary);
        }
        .algo-checkbox input[type="checkbox"]:checked + .algo-label {
            background: var(--theme-gradient);
            color: white;
            border-color: var(--theme-primary);
        }
        .algo-checkbox .algo-label strong {
            display: block;
            font-size: 0.8rem;
        }
        .algo-checkbox .algo-label small {
            font-size: 0.65rem;
            opacity: 0.8;
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
        .param-slider {
            margin-bottom: 0.75rem;
        }
        .param-slider label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        .param-slider .value {
            color: var(--theme-primary);
            font-weight: 700;
        }
        .param-slider input[type="range"] {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: #e9ecef;
            outline: none;
            -webkit-appearance: none;
        }
        .param-slider input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: var(--theme-gradient);
            cursor: pointer;
        }
        .key-output {
            background: #f8f9fa;
            border: 2px solid var(--theme-primary);
            border-radius: 8px;
            padding: 0.75rem;
            font-family: monospace;
            font-size: 0.75rem;
            word-break: break-all;
            position: relative;
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
            box-shadow: 0 2px 8px rgba(5, 150, 105, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        .related-tool-card p {
            font-size: 0.75rem;
            color: #6c757d;
            margin: 0;
        }
        .output-format-btn {
            padding: 0.25rem 0.5rem;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            background: white;
            cursor: pointer;
            font-size: 0.7rem;
            transition: all 0.2s;
        }
        .output-format-btn:hover {
            border-color: var(--theme-primary);
        }
        .output-format-btn.active {
            background: var(--theme-primary);
            color: white;
            border-color: var(--theme-primary);
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
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">PBKDF2 Key Derivation</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-file-contract"></i> RFC 2898</span>
            <span class="info-badge"><i class="fas fa-lock"></i> PKCS#5</span>
            <span class="info-badge"><i class="fas fa-fingerprint"></i> HMAC-based</span>
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
                <h5><i class="fas fa-key me-2"></i>Derive Key from Password</h5>
            </div>
            <div class="card-body">
                <form id="pbkdfForm">
                    <input type="hidden" name="methodName" value="PBKDFDERIVEKEY">

                    <!-- Algorithm Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-code-branch me-1"></i>Hash Algorithms <small class="text-muted">(select one or more)</small></div>
                        <div class="d-flex gap-2 flex-wrap">
                            <label class="algo-checkbox">
                                <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA1">
                                <span class="algo-label">
                                    <strong>SHA-1</strong>
                                    <small>Legacy</small>
                                </span>
                            </label>
                            <label class="algo-checkbox">
                                <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA256" checked>
                                <span class="algo-label">
                                    <strong>SHA-256</strong>
                                    <small>Recommended</small>
                                </span>
                            </label>
                            <label class="algo-checkbox">
                                <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA384">
                                <span class="algo-label">
                                    <strong>SHA-384</strong>
                                    <small>Strong</small>
                                </span>
                            </label>
                            <label class="algo-checkbox">
                                <input type="checkbox" name="cipherparameternew" value="PBKDF2WithHmacSHA512">
                                <span class="algo-label">
                                    <strong>SHA-512</strong>
                                    <small>Strongest</small>
                                </span>
                            </label>
                        </div>
                    </div>

                    <!-- Password Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-key me-1"></i>Password</div>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter password to derive key from" required>
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password', 'toggleIcon1')">
                                <i class="fas fa-eye" id="toggleIcon1"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Salt -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-random me-1"></i>Salt (Base64)</div>
                        <div class="input-group">
                            <input type="text" class="form-control" id="salt" name="salt" value="<%=defaultSalt%>" placeholder="Enter salt (Base64)">
                            <button class="btn btn-outline-secondary" type="button" onclick="generateSalt()">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                        </div>
                        <small class="text-muted">Minimum 16 bytes recommended. Click refresh for random salt.</small>
                    </div>

                    <!-- Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i>Security Presets</div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('fast')">
                                <i class="fas fa-bolt"></i> Fast (10K)
                            </button>
                            <button type="button" class="preset-btn" onclick="applyPreset('moderate')">
                                <i class="fas fa-balance-scale"></i> Moderate (100K)
                            </button>
                            <button type="button" class="preset-btn" onclick="applyPreset('owasp')">
                                <i class="fas fa-shield-alt"></i> OWASP (600K)
                            </button>
                        </div>
                    </div>

                    <!-- Parameters -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-1"></i>Parameters</div>

                        <div class="param-slider">
                            <label>
                                <span>Iterations</span>
                                <span class="value" id="iterationsValue">100,000</span>
                            </label>
                            <input type="range" id="iterationsSlider" min="1000" max="1000000" step="1000" value="100000" oninput="updateParam('iterations')">
                            <input type="hidden" name="rounds" id="rounds" value="100000">
                            <small class="text-muted">OWASP recommends 600,000+ for SHA-256</small>
                        </div>

                        <div class="param-slider">
                            <label>
                                <span>Key Length (bytes)</span>
                                <span class="value" id="keyLengthValue">32</span>
                            </label>
                            <input type="range" id="keyLengthSlider" min="16" max="128" step="8" value="32" oninput="updateParam('keyLength')">
                            <input type="hidden" name="keylength" id="keylength" value="32">
                            <small class="text-muted">32 bytes = 256 bits (AES-256)</small>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="generateBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-cogs me-2"></i>Derive Key
                    </button>
                </form>

                <!-- Security Warning -->
                <div class="alert alert-warning mt-3 mb-0" style="font-size: 0.8rem;">
                    <i class="fas fa-exclamation-triangle me-1"></i>
                    <strong>Security Note:</strong> Key derivation is performed server-side. For production use, always derive keys locally.
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-fingerprint me-2"></i>Derived Key Output</h5>
                <button class="btn btn-sm btn-light" onclick="copyResult()" id="copyBtn" style="display: none;">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-key fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Derived key will appear here</p>
                        <small class="text-muted">Enter a password and click Derive Key</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- Parameter Guide -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-book me-2"></i>OWASP Recommendations (2023)</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Algorithm</th>
                            <th>Min Iterations</th>
                            <th>Notes</th>
                        </tr>
                        </thead>
                        <tbody class="small">
                        <tr>
                            <td>PBKDF2-HMAC-SHA1</td>
                            <td>1,300,000</td>
                            <td>Legacy, avoid for new apps</td>
                        </tr>
                        <tr class="table-success">
                            <td><strong>PBKDF2-HMAC-SHA256</strong></td>
                            <td><strong>600,000</strong></td>
                            <td><strong>Recommended default</strong></td>
                        </tr>
                        <tr>
                            <td>PBKDF2-HMAC-SHA512</td>
                            <td>210,000</td>
                            <td>Faster on 64-bit systems</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- OpenSSL Commands -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL Commands</h6>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block mb-0">
                    <div class="terminal-header">
                        <span>Derive Key with PBKDF2 (OpenSSL 3.0+)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl kdf -keylen 32 -kdfopt digest:SHA256 -kdfopt pass:password -kdfopt salt:hex:0102030405060708 -kdfopt iter:100000 PBKDF2">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Derive 256-bit key using PBKDF2-HMAC-SHA256</div>
                        <div>$ openssl kdf -keylen <code>32</code> -kdfopt digest:<code>SHA256</code> \<br>  -kdfopt pass:<code>password</code> -kdfopt salt:hex:<code>0102030405060708</code> \<br>  -kdfopt iter:<code>100000</code> PBKDF2</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Key Derivation & Hashing Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="argon2.jsp" class="related-tool-card">
                <h6><i class="fas fa-trophy me-1"></i>Argon2</h6>
                <p>PHC winner, memory-hard KDF</p>
            </a>
            <a href="scrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                <p>Memory-hard key derivation</p>
            </a>
            <a href="bccrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>BCrypt</h6>
                <p>Blowfish-based password hashing</p>
            </a>
            <a href="pbe.jsp" class="related-tool-card">
                <h6><i class="fas fa-user-lock me-1"></i>PBE Encryption</h6>
                <p>Password-based encryption</p>
            </a>
            <a href="hmacgen.jsp" class="related-tool-card">
                <h6><i class="fas fa-fingerprint me-1"></i>HMAC Generator</h6>
                <p>Generate HMAC signatures</p>
            </a>
            <a href="hkdf.jsp" class="related-tool-card">
                <h6><i class="fas fa-expand-arrows-alt me-1"></i>HKDF</h6>
                <p>HMAC-based key derivation</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding PBKDF2</h5>
    </div>
    <div class="card-body">
        <h6>What is PBKDF2?</h6>
        <p>PBKDF2 (Password-Based Key Derivation Function 2) is defined in RFC 2898 and PKCS#5. It derives a cryptographic key from a password by applying a pseudorandom function (typically HMAC) with a salt value, repeating this process many times (iterations) to increase the computational cost of brute-force attacks.</p>

        <h6 class="mt-4">How PBKDF2 Works</h6>
        <div class="row mb-4">
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-key fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>1. Password</strong></div>
                    <small class="text-muted">User's secret input</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-plus fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>2. Salt</strong></div>
                    <small class="text-muted">Random value to prevent rainbow tables</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-redo fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>3. Iterate</strong></div>
                    <small class="text-muted">Repeat HMAC many times</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-fingerprint fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>4. Derived Key</strong></div>
                    <small class="text-muted">Cryptographic key output</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">PBKDF2 Formula</h6>
        <div class="alert alert-secondary">
            <code>DK = PBKDF2(PRF, Password, Salt, c, dkLen)</code>
            <ul class="mb-0 mt-2 small">
                <li><strong>PRF</strong> - Pseudorandom function (e.g., HMAC-SHA256)</li>
                <li><strong>Password</strong> - Master password</li>
                <li><strong>Salt</strong> - Random salt (min 16 bytes recommended)</li>
                <li><strong>c</strong> - Iteration count</li>
                <li><strong>dkLen</strong> - Desired key length in bytes</li>
            </ul>
        </div>

        <h6 class="mt-4">PBKDF2 vs Other KDFs</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Algorithm</th>
                    <th>Memory-Hard</th>
                    <th>GPU Resistant</th>
                    <th>Standard</th>
                    <th>Recommendation</th>
                </tr>
                </thead>
                <tbody class="small">
                <tr>
                    <td>PBKDF2</td>
                    <td><span class="badge bg-danger">No</span></td>
                    <td><span class="badge bg-danger">Low</span></td>
                    <td><span class="badge bg-success">RFC 2898</span></td>
                    <td>Legacy compatibility only</td>
                </tr>
                <tr>
                    <td>BCrypt</td>
                    <td><span class="badge bg-warning text-dark">4KB</span></td>
                    <td><span class="badge bg-warning text-dark">Medium</span></td>
                    <td><span class="badge bg-secondary">De facto</span></td>
                    <td>Still acceptable</td>
                </tr>
                <tr>
                    <td>Scrypt</td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-success">RFC 7914</span></td>
                    <td>Good choice</td>
                </tr>
                <tr class="table-success">
                    <td><strong>Argon2id</strong></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-success">RFC 9106</span></td>
                    <td><strong>Best for new apps</strong></td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python (hashlib)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import hashlib
import os

password = b"secret"
salt = os.urandom(16)
key = hashlib.pbkdf2_hmac(
    'sha256', password, salt,
    iterations=600000, dklen=32
)</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Node.js (crypto)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>const crypto = require('crypto');

const key = crypto.pbkdf2Sync(
    'password', salt,
    600000, 32, 'sha256'
);</code></pre>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Java</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>SecretKeyFactory f = SecretKeyFactory
    .getInstance("PBKDF2WithHmacSHA256");
KeySpec spec = new PBEKeySpec(
    password, salt, 600000, 256);
SecretKey key = f.generateSecret(spec);</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Go</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import "golang.org/x/crypto/pbkdf2"

key := pbkdf2.Key(
    []byte("password"), salt,
    600000, 32, sha256.New,
)</code></pre>
            </div>
        </div>

        <div class="alert alert-info mt-4">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>When to use PBKDF2:</strong> Use PBKDF2 when you need compatibility with older systems, standards compliance (FIPS 140-2), or when memory-hard functions aren't available. For new applications, prefer Argon2id.
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt"></i> Share PBKDF2 Parameters
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

                <small class="text-muted">
                    <i class="fas fa-lightbulb"></i> <strong>Tip:</strong> Use a URL shortener if the link is too long.
                </small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    var lastDerivedKey = '';
    var lastResults = [];
    var lastParams = {};

    $(document).ready(function() {
        loadFromUrl();

        // Form submission
        $('#pbkdfForm').submit(function(e) {
            e.preventDefault();
            deriveKey();
        });

        // Copy Share URL handler
        $('#copyShareUrl').click(function() {
            var url = $('#shareUrlText').val();
            var btn = $(this);
            navigator.clipboard.writeText(url).then(function() {
                btn.html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() {
                    btn.html('<i class="fas fa-copy"></i> Copy');
                }, 1500);
            });
        });
    });

    function updateParam(param) {
        if (param === 'iterations') {
            var value = $('#iterationsSlider').val();
            $('#iterationsValue').text(parseInt(value).toLocaleString());
            $('#rounds').val(value);
        } else if (param === 'keyLength') {
            var bytes = $('#keyLengthSlider').val();
            $('#keyLengthValue').text(bytes);
            $('#keylength').val(bytes);
        }
    }

    function generateSalt() {
        var array = new Uint8Array(16);
        crypto.getRandomValues(array);
        var base64 = btoa(String.fromCharCode.apply(null, array));
        $('#salt').val(base64);
        showToast('Random salt generated (16 bytes)');
    }

    function applyPreset(preset) {
        var presets = {
            'fast': { iterations: 10000 },
            'moderate': { iterations: 100000 },
            'owasp': { iterations: 600000 }
        };
        var config = presets[preset];
        $('#iterationsSlider').val(config.iterations);
        $('#iterationsValue').text(parseInt(config.iterations).toLocaleString());
        $('#rounds').val(config.iterations);
        showToast('Applied ' + preset + ' preset');
    }

    function togglePassword(inputId, iconId) {
        var input = $('#' + inputId);
        var icon = $('#' + iconId);
        if (input.attr('type') === 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    }

    function deriveKey() {
        var password = $('#password').val();
        if (!password) {
            showToast('Please enter a password');
            return;
        }

        var salt = $('#salt').val().trim();
        if (!salt) {
            generateSalt();
            salt = $('#salt').val();
        }

        $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Deriving...');

        var startTime = performance.now();

        $.ajax({
            type: "POST",
            url: "PBEFunctionality",
            data: $('#pbkdfForm').serialize(),
            dataType: "json",
            success: function(response) {
                var duration = (performance.now() - startTime).toFixed(0);
                $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Derive Key');

                if (response.success) {
                    // Store all results
                    lastResults = response.results;
                    lastParams = {
                        salt: response.salt,
                        iterations: response.iterations,
                        keyLength: response.keyLengthBytes
                    };
                    // Store first key for backward compatibility
                    lastDerivedKey = response.results[0].derivedKey;

                    var html = renderKeyResults(response.results, duration, response);

                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#copyBtn').show();
                } else {
                    showError(response.errorMessage || 'Key derivation failed');
                }
            },
            error: function(xhr, status, error) {
                $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Derive Key');
                // Try to parse error response
                try {
                    var errResponse = JSON.parse(xhr.responseText);
                    showError(errResponse.errorMessage || 'Request failed');
                } catch (e) {
                    showError('Request failed: ' + error);
                }
            }
        });
    }

    function renderKeyResults(results, duration, response) {
        var html = '';

        // Success banner
        html += '<div class="alert alert-success mb-3">';
        html += '<i class="fas fa-check-circle me-2"></i>';
        html += '<strong>' + results.length + ' Key' + (results.length > 1 ? 's' : '') + ' Derived!</strong> Computed in ' + duration + 'ms';
        html += '</div>';

        // Render each algorithm result
        for (var i = 0; i < results.length; i++) {
            var result = results[i];
            var algoId = 'algo_' + i;

            html += '<div class="mb-3 p-3 border rounded" style="background: #f8f9fa;">';
            html += '<div class="d-flex justify-content-between align-items-center mb-2">';
            html += '<span class="badge" style="background: var(--theme-gradient);">' + getAlgoDisplayName(result.algorithm) + '</span>';
            html += '<button class="btn btn-sm btn-outline-secondary" onclick="copyKeyByIndex(' + i + ')">';
            html += '<i class="fas fa-copy"></i></button>';
            html += '</div>';

            html += '<div class="key-output mb-2" style="font-size: 0.7rem;">';
            html += '<span id="derivedKey_' + i + '" data-base64="' + escapeHtml(result.derivedKey) + '">' + escapeHtml(result.derivedKey) + '</span>';
            html += '</div>';

            // IV if available
            if (result.iv && result.iv !== 'null') {
                html += '<small class="text-muted">IV: ' + escapeHtml(result.iv) + '</small>';
            }

            html += '</div>';
        }

        // Format toggle (applies to all)
        html += '<div class="mb-3">';
        html += '<small class="text-muted me-2">Output Format:</small>';
        html += '<button class="output-format-btn active" onclick="formatAllOutputs(\'base64\')">Base64</button> ';
        html += '<button class="output-format-btn" onclick="formatAllOutputs(\'hex\')">Hex</button>';
        html += '</div>';

        // Action buttons
        html += '<div class="d-flex gap-2 mb-3">';
        html += '<button class="btn btn-sm btn-outline-info" onclick="shareUrl()">';
        html += '<i class="fas fa-share-alt me-1"></i>Share URL</button>';
        html += '<button class="btn btn-sm btn-outline-secondary" onclick="downloadKey()">';
        html += '<i class="fas fa-download me-1"></i>Download All</button>';
        html += '</div>';

        // Parameters used
        html += '<div class="row small text-muted">';
        html += '<div class="col-6 mb-1">';
        html += '<strong>Iterations:</strong> ' + parseInt(lastParams.iterations).toLocaleString();
        html += '</div>';
        html += '<div class="col-6 mb-1">';
        html += '<strong>Key Length:</strong> ' + lastParams.keyLength + ' bytes';
        html += '</div>';
        html += '</div>';

        return html;
    }

    function formatAllOutputs(format) {
        $('.output-format-btn').removeClass('active');
        event.target.classList.add('active');

        for (var i = 0; i < lastResults.length; i++) {
            var base64 = lastResults[i].derivedKey;
            var elem = $('#derivedKey_' + i);
            if (format === 'hex') {
                try {
                    var binary = atob(base64);
                    var hex = '';
                    for (var j = 0; j < binary.length; j++) {
                        hex += ('0' + binary.charCodeAt(j).toString(16)).slice(-2);
                    }
                    elem.text(hex);
                } catch (e) {
                    showToast('Error converting to hex');
                }
            } else {
                elem.text(base64);
            }
        }
    }

    function copyKeyByIndex(index) {
        var key = $('#derivedKey_' + index).text();
        navigator.clipboard.writeText(key).then(function() {
            showToast('Key copied to clipboard!');
        });
    }

    function getAlgoDisplayName(algo) {
        var names = {
            'PBKDF2WithHmacSHA1': 'HMAC-SHA1',
            'PBKDF2WithHmacSHA256': 'HMAC-SHA256',
            'PBKDF2WithHmacSHA384': 'HMAC-SHA384',
            'PBKDF2WithHmacSHA512': 'HMAC-SHA512'
        };
        return names[algo] || algo;
    }

    function copyResult() {
        if (lastResults && lastResults.length > 0) {
            navigator.clipboard.writeText(lastResults[0].derivedKey).then(function() {
                showToast('Key copied!');
            });
        }
    }

    function shareUrl() {
        if (!lastResults || lastResults.length === 0) {
            showToast('Derive a key first');
            return;
        }

        // Get selected algorithms
        var algos = lastResults.map(function(r) { return r.algorithm; }).join(',');

        // Create URL parameters
        var params = new URLSearchParams();
        params.set('salt', lastParams.salt || '');
        params.set('iter', lastParams.iterations);
        params.set('len', lastParams.keyLength);
        params.set('algos', algos);

        var shareUrlStr = window.location.origin + window.location.pathname + '?' + params.toString();

        // Update modal content
        var warningHtml = '<div class="alert alert-info mb-3">';
        warningHtml += '<strong><i class="fas fa-shield-alt"></i> What\'s Being Shared:</strong>';
        warningHtml += '<ul class="mb-0 mt-2">';
        warningHtml += '<li><strong>Salt:</strong> ' + (lastParams.salt ? lastParams.salt.substring(0, 20) + '...' : 'N/A') + '</li>';
        warningHtml += '<li><strong>Iterations:</strong> ' + parseInt(lastParams.iterations).toLocaleString() + '</li>';
        warningHtml += '<li><strong>Key Length:</strong> ' + lastParams.keyLength + ' bytes</li>';
        warningHtml += '<li><strong>Algorithms:</strong> ' + lastResults.map(function(r) { return getAlgoDisplayName(r.algorithm); }).join(', ') + '</li>';
        warningHtml += '<li class="text-success"><strong>NOT Included:</strong> Your password (kept secure)</li>';
        warningHtml += '<li class="text-success"><strong>NOT Included:</strong> Derived keys (must re-derive)</li>';
        warningHtml += '</ul>';
        warningHtml += '</div>';
        warningHtml += '<div class="alert alert-success mb-3">';
        warningHtml += '<strong><i class="fas fa-check-circle"></i> Safe to Share:</strong>';
        warningHtml += '<p class="mb-0">This URL only contains derivation parameters. The recipient must know the password to derive the same keys.</p>';
        warningHtml += '</div>';

        $('#shareWarningContent').html(warningHtml);
        $('#shareUrlText').val(shareUrlStr);
        $('#shareUrlModal').modal('show');
    }

    function downloadKey() {
        if (!lastResults || lastResults.length === 0) {
            showToast('Derive a key first');
            return;
        }

        var content = {
            results: lastResults.map(function(r) {
                return {
                    algorithm: r.algorithm,
                    derivedKey: r.derivedKey,
                    iv: r.iv
                };
            }),
            salt: lastParams.salt,
            iterations: parseInt(lastParams.iterations),
            keyLengthBytes: parseInt(lastParams.keyLength),
            timestamp: new Date().toISOString()
        };

        var blob = new Blob([JSON.stringify(content, null, 2)], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'pbkdf2-keys-' + Date.now() + '.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showToast('Key file downloaded');
    }

    function showError(message) {
        var html = '<div class="alert alert-danger">';
        html += '<i class="fas fa-exclamation-circle me-2"></i>';
        html += '<strong>Error:</strong> ' + escapeHtml(message);
        html += '</div>';
        $('#resultPlaceholder').hide();
        $('#resultContent').html(html).show();
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function loadFromUrl() {
        // Load parameters from URL if present (for bookmarking/sharing)
        var params = new URLSearchParams(window.location.search);
        var salt = params.get('salt');
        var iter = params.get('iter');
        var len = params.get('len');
        var algos = params.get('algos');

        if (salt) $('#salt').val(salt);
        if (iter) {
            $('#iterationsSlider').val(iter);
            $('#iterationsValue').text(parseInt(iter).toLocaleString());
            $('#rounds').val(iter);
        }
        if (len) {
            $('#keyLengthSlider').val(len);
            $('#keyLengthValue').text(len);
            $('#keylength').val(len);
        }
        if (algos) {
            // Uncheck all, then check only the specified algorithms
            $('input[name="cipherparameternew"]').prop('checked', false);
            var algoList = algos.split(',');
            algoList.forEach(function(algo) {
                $('input[name="cipherparameternew"][value="' + algo + '"]').prop('checked', true);
            });
            showToast('Shared parameters loaded - enter password to derive');
        }
    }

    function copyCommand(btn) {
        var cmd = $(btn).data('cmd');
        navigator.clipboard.writeText(cmd).then(function() {
            showToast('Command copied!');
        });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
