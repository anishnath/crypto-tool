<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PBE Encryption Decryption Online - Free | 8gwifi.org</title>
    <meta name="description" content="Password-Based Encryption (PBE) tool online. Encrypt and decrypt messages using PBKDF algorithms like PBEWITHHMACSHA256ANDAES, PBEWITHMD5ANDDES, and more. Free PBE encryption tool." />
    <meta name="keywords" content="PBE encryption, password based encryption, PBKDF2, PKCS5, encrypt message online, decrypt message online, PBEWITHHMACSHA256ANDAES, PBEWITHMD5ANDDES, Java PBE, Jasypt encryption" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/pbe.jsp" />

    <%
        String[] validList = { "PBEWITHHMACSHA1ANDAES_256", "PBEWITHHMACSHA224ANDAES_128",
                "PBEWITHHMACSHA224ANDAES_256", "PBEWITHHMACSHA256ANDAES_128", "PBEWITHHMACSHA256ANDAES_256",
                "PBEWITHHMACSHA384ANDAES_128", "PBEWITHHMACSHA384ANDAES_256", "PBEWITHHMACSHA512ANDAES_128",
                "PBEWITHHMACSHA512ANDAES_256", "PBEWITHMD5AND128BITAES-CBC-OPENSSL",
                "PBEWITHMD5AND192BITAES-CBC-OPENSSL", "PBEWITHMD5AND256BITAES-CBC-OPENSSL", "PBEWITHMD5ANDDES",
                "PBEWITHMD5ANDRC2", "PBEWITHMD5ANDTRIPLEDES", "PBEWITHSHA1ANDDES", "PBEWITHSHA1ANDDESEDE",
                "PBEWITHSHA1ANDRC2", "PBEWITHSHA1ANDRC2_128", "PBEWITHSHA1ANDRC2_40", "PBEWITHSHA1ANDRC4_128",
                "PBEWITHSHA1ANDRC4_40", "PBEWITHSHA256AND128BITAES-CBC-BC", "PBEWITHSHA256AND192BITAES-CBC-BC",
                "PBEWITHSHA256AND256BITAES-CBC-BC", "PBEWITHSHAAND128BITAES-CBC-BC", "PBEWITHSHAAND128BITRC2-CBC",
                "PBEWITHSHAAND128BITRC4", "PBEWITHSHAAND192BITAES-CBC-BC", "PBEWITHSHAAND2-KEYTRIPLEDES-CBC",
                "PBEWITHSHAAND256BITAES-CBC-BC", "PBEWITHSHAAND3-KEYTRIPLEDES-CBC", "PBEWITHSHAAND40BITRC2-CBC",
                "PBEWITHSHAAND40BITRC4", "PBEWITHSHAANDIDEA-CBC", "PBEWITHSHAANDTWOFISH-CBC" };
    %>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "PBE Encryption/Decryption Tool",
        "description": "Password-Based Encryption (PBE) tool for encrypting and decrypting messages using various PBKDF algorithms. Supports 36+ cipher algorithms.",
        "url": "https://8gwifi.org/pbe.jsp",
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
        "datePublished": "2018-01-17",
        "dateModified": "2025-01-15"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt a Message Using PBE",
        "description": "Step-by-step guide to encrypt messages using Password-Based Encryption",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Your Message",
                "text": "Type or paste the message you want to encrypt"
            },
            {
                "@type": "HowToStep",
                "name": "Set a Password",
                "text": "Enter a strong password that will be used to derive the encryption key"
            },
            {
                "@type": "HowToStep",
                "name": "Configure Rounds",
                "text": "Set the number of iterations (higher = more secure but slower)"
            },
            {
                "@type": "HowToStep",
                "name": "Select Algorithm",
                "text": "Choose one or more PBE cipher algorithms from the list"
            },
            {
                "@type": "HowToStep",
                "name": "Encrypt",
                "text": "Click Encrypt to generate the encrypted Base64 output"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org PBE Encryption Tool"
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
                "name": "What is Password-Based Encryption (PBE)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "PBE is a method of encrypting data using a password. The password is combined with a random salt and processed through a key derivation function (like PBKDF1 or PBKDF2) to generate the actual encryption key. This makes it suitable for user-friendly encryption without managing complex keys."
                }
            },
            {
                "@type": "Question",
                "name": "What are iteration rounds in PBE?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Iteration rounds (or iterations) determine how many times the key derivation function processes the password. Higher iterations make brute-force attacks slower but also increase encryption/decryption time. Common recommendations are 10,000+ iterations for PBKDF2."
                }
            },
            {
                "@type": "Question",
                "name": "Which PBE algorithm should I use?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "For modern applications, use algorithms with SHA-256 or SHA-512 and AES-256, such as PBEWITHHMACSHA256ANDAES_256 or PBEWITHSHA256AND256BITAES-CBC-BC. Avoid older algorithms like PBEWITHMD5ANDDES which use weak hashing and encryption."
                }
            },
            {
                "@type": "Question",
                "name": "Is PBE the same as PBKDF2?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "No, but they're related. PBKDF2 (Password-Based Key Derivation Function 2) is the key derivation algorithm used by PBE. PBE combines PBKDF2 with a symmetric cipher (like AES or DES) to provide complete encryption functionality."
                }
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #6366f1;
            --theme-secondary: #8b5cf6;
            --theme-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #a855f7 100%);
            --theme-light: #eef2ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(99, 102, 241, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.25);
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
        .form-control-sm, .btn-sm {
            font-size: 0.85rem;
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
        .cipher-select {
            max-height: 120px;
            overflow-y: auto;
            font-size: 0.8rem;
        }
        .cipher-select option {
            padding: 0.35rem;
        }
        .cipher-select option:checked {
            background: var(--theme-gradient);
            color: white;
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
            background: var(--theme-gradient);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
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
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.2);
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
        .result-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .result-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }
        .algo-badge {
            background: var(--theme-gradient);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .result-block {
            background: #1e1e1e;
            color: #d4d4d4;
            border-radius: 8px;
            padding: 1rem;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
            word-break: break-all;
            margin-bottom: 0.5rem;
        }
        .param-row {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
            flex-wrap: wrap;
        }
        .param-item {
            background: #e9ecef;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
        }
        .param-label {
            color: #6c757d;
        }
        .param-value {
            color: #495057;
            font-family: monospace;
        }
        .mode-toggle {
            display: flex;
            gap: 0;
            margin-bottom: 1rem;
        }
        .mode-toggle .btn {
            flex: 1;
            border-radius: 0;
        }
        .mode-toggle .btn:first-child {
            border-radius: 8px 0 0 8px;
        }
        .mode-toggle .btn:last-child {
            border-radius: 0 8px 8px 0;
        }
        .mode-toggle .btn.active {
            background: var(--theme-gradient);
            border-color: transparent;
            color: white;
        }
        .algo-category {
            font-size: 0.7rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 0.5rem;
            padding-left: 0.5rem;
        }
        .pwd-option {
            cursor: pointer;
            transition: all 0.2s ease;
            user-select: none;
        }
        .pwd-option:hover {
            opacity: 0.8;
        }
        .pwd-option.active {
            background: var(--theme-gradient) !important;
        }
        .password-options {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 0.75rem;
        }
        .password-strength {
            height: 4px;
            border-radius: 2px;
            margin-top: 0.5rem;
            transition: all 0.3s ease;
        }
        .strength-weak { background: #e53e3e; width: 25%; }
        .strength-fair { background: #dd6b20; width: 50%; }
        .strength-good { background: #38a169; width: 75%; }
        .strength-strong { background: #2b6cb0; width: 100%; }
        .char-counter {
            font-size: 0.7rem;
            color: #6c757d;
            text-align: right;
        }
        .mode-toggle .btn {
            padding: 0.35rem 0.75rem;
            font-size: 0.85rem;
        }
        .compact-input {
            padding: 0.35rem 0.5rem;
            font-size: 0.85rem;
        }
        /* Code Samples Styles */
        .code-block {
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #dee2e6;
        }
        .code-header {
            background: #2d3748;
            color: #e2e8f0;
            padding: 0.5rem 1rem;
            font-size: 0.8rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .code-content {
            background: #1a202c;
            color: #e2e8f0;
            margin: 0;
            padding: 1rem;
            font-size: 0.75rem;
            line-height: 1.5;
            overflow-x: auto;
            max-height: 400px;
        }
        .code-content::-webkit-scrollbar {
            height: 8px;
            width: 8px;
        }
        .code-content::-webkit-scrollbar-track {
            background: #2d3748;
        }
        .code-content::-webkit-scrollbar-thumb {
            background: #4a5568;
            border-radius: 4px;
        }
        #codeTab .nav-link {
            color: #6c757d;
            font-size: 0.85rem;
            padding: 0.5rem 1rem;
        }
        #codeTab .nav-link.active {
            color: var(--theme-primary);
            border-color: var(--theme-primary);
            border-bottom-color: transparent;
        }
        #codeSamplesBody .card-header[aria-expanded="true"] #codeSamplesIcon {
            transform: rotate(180deg);
        }
        #codeSamplesIcon {
            transition: transform 0.3s ease;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">PBE Encryption/Decryption</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-lock"></i> 36+ Algos</span>
            <span class="info-badge"><i class="fas fa-key"></i> PBKDF2</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> AES/DES</span>
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
                <h5><i class="fas fa-user-lock me-2"></i>PBE Encrypt/Decrypt</h5>
            </div>
            <div class="card-body">
                <form id="pbeForm">
                    <input type="hidden" name="methodName" value="PBEMESSAGE">

                    <!-- Mode Toggle -->
                    <div class="mode-toggle">
                        <button type="button" class="btn btn-outline-secondary active" id="encryptMode" onclick="setMode('encrypt')">
                            <i class="fas fa-lock me-1"></i>Encrypt
                        </button>
                        <button type="button" class="btn btn-outline-secondary" id="decryptMode" onclick="setMode('decrypt')">
                            <i class="fas fa-unlock me-1"></i>Decrypt
                        </button>
                    </div>
                    <input type="hidden" name="encryptdecryptparameter" id="encryptdecryptparameter" value="encrypt">

                    <!-- Message Input -->
                    <div class="form-section">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="form-section-title mb-0"><i class="fas fa-comment-alt me-1"></i>Message</div>
                            <div class="char-counter"><span id="charCount">35</span> chars | <span id="wordCount">6</span> words</div>
                        </div>
                        <textarea class="form-control compact-input" rows="2" id="message" name="message" required
                                  placeholder="Enter message to encrypt/decrypt">Hello World - Test PBE Encryption</textarea>
                    </div>

                    <!-- Password & Rounds Row -->
                    <div class="row g-2 mb-2">
                        <div class="col-8">
                            <div class="form-section mb-0">
                                <div class="form-section-title"><i class="fas fa-key me-1"></i>Password</div>
                                <div class="input-group input-group-sm">
                                    <input type="password" class="form-control" id="password" name="password" required placeholder="Password">
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword" title="Show/Hide">
                                        <i class="fas fa-eye" id="toggleIcon"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary" type="button" id="copyPassword" title="Copy">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                    <button class="btn btn-outline-primary" type="button" onclick="generatePassword()" title="Generate">
                                        <i class="fas fa-random"></i>
                                    </button>
                                </div>
                                <div class="password-options mt-2" style="display: none;" id="passwordOptions">
                                    <div class="d-flex align-items-center gap-2">
                                        <input type="number" class="form-control form-control-sm" id="pwdLength" value="16" min="8" max="64" style="width: 60px;">
                                        <span class="badge bg-secondary pwd-option active" data-option="uppercase" title="A-Z">ABC</span>
                                        <span class="badge bg-secondary pwd-option active" data-option="lowercase" title="a-z">abc</span>
                                        <span class="badge bg-secondary pwd-option active" data-option="numbers" title="0-9">123</span>
                                        <span class="badge bg-secondary pwd-option active" data-option="symbols" title="!@#$%">!@#</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-section mb-0">
                                <div class="form-section-title"><i class="fas fa-sync-alt me-1"></i>Rounds</div>
                                <input type="number" class="form-control form-control-sm" id="rounds" name="rounds" value="1000" min="1" max="20000">
                            </div>
                        </div>
                    </div>

                    <!-- Algorithm Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cogs me-1"></i>Algorithm <small class="text-muted">(Ctrl+click for multiple)</small></div>
                        <select class="form-control cipher-select" multiple name="cipherparameternew" id="cipherparameternew" size="5">
                            <option selected value="PBEWITHHMACSHA1ANDAES_128">PBEWITHHMACSHA1ANDAES_128</option>
                            <% for (int i = 0; i < validList.length; i++) {
                                String param = validList[i];
                            %>
                            <option value="<%=param%>"><%=param%></option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn w-100" id="submitBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-lock me-2"></i>Encrypt
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-file-alt me-2"></i>Result</h5>
            </div>
            <div class="card-body" style="overflow-y: auto;">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-user-lock fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Encryption result will appear here</p>
                        <small class="text-muted">Enter a message and password, then click Encrypt</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: var(--theme-primary);" role="status">
                        <span class="visually-hidden">Processing...</span>
                    </div>
                    <p class="mt-2 mb-0">Processing...</p>
                </div>

                <div class="result-content" id="resultContent">
                    <!-- Results will be dynamically inserted here -->
                </div>
            </div>
        </div>

        <!-- OpenSSL Commands Reference (inside right column) -->
        <div class="card tool-card mt-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL PBE Commands</h5>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Encrypt with PBE (AES-256-CBC)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl enc -aes-256-cbc -salt -pbkdf2 -iter 10000 -in plaintext.txt -out encrypted.enc">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Encrypt file using PBKDF2 with 10000 iterations</div>
                        <div>$ openssl enc -aes-256-cbc -salt -pbkdf2 -iter <code>10000</code> \<br>  -in <code>plaintext.txt</code> -out <code>encrypted.enc</code></div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Decrypt with PBE (AES-256-CBC)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl enc -aes-256-cbc -d -pbkdf2 -iter 10000 -in encrypted.enc -out decrypted.txt">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Decrypt file using same parameters</div>
                        <div>$ openssl enc -aes-256-cbc -d -pbkdf2 -iter <code>10000</code> \<br>  -in <code>encrypted.enc</code> -out <code>decrypted.txt</code></div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Encrypt with Base64 Output</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl enc -aes-256-cbc -salt -pbkdf2 -base64 -in plaintext.txt -out encrypted.b64">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Encrypt with Base64 encoded output</div>
                        <div>$ openssl enc -aes-256-cbc -salt -pbkdf2 -base64 \<br>  -in <code>plaintext.txt</code> -out <code>encrypted.b64</code></div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>PBKDF2 Key Derivation</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl kdf -keylen 32 -kdfopt digest:SHA256 -kdfopt pass:password -kdfopt salt:hex:0102030405060708 -kdfopt iter:10000 PBKDF2">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Derive key using PBKDF2 (OpenSSL 3.0+)</div>
                        <div>$ openssl kdf -keylen 32 -kdfopt digest:SHA256 \<br>  -kdfopt pass:<code>password</code> -kdfopt salt:hex:<code>0102030405060708</code> \<br>  -kdfopt iter:<code>10000</code> PBKDF2</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related Encryption Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="CipherFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>AES Encryption</h6>
                <p>Encrypt/decrypt with AES cipher modes</p>
            </a>
            <a href="pbkdf.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>PBKDF2 Key Derivation</h6>
                <p>Derive encryption keys from passwords</p>
            </a>
            <a href="redirect-pbefile.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-lock me-1"></i>PBE File Encryption</h6>
                <p>Encrypt/decrypt files with PBE</p>
            </a>
            <a href="hmacgen.jsp" class="related-tool-card">
                <h6><i class="fas fa-fingerprint me-1"></i>HMAC Generator</h6>
                <p>Generate HMAC signatures</p>
            </a>
        </div>
    </div>
</div>

<!-- Code Samples Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light d-flex justify-content-between align-items-center"
         style="cursor: pointer;" onclick="$('#codeSamplesBody').collapse('toggle');">
        <h5 class="mb-0"><i class="fas fa-code me-2"></i>Code Samples</h5>
        <i class="fas fa-chevron-down" id="codeSamplesIcon"></i>
    </div>
    <div class="collapse" id="codeSamplesBody">
        <div class="card-body">
            <!-- Language Tabs -->
            <ul class="nav nav-tabs" id="codeTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="java-tab" data-toggle="tab" href="#java-code" role="tab">
                        <i class="fab fa-java me-1"></i>Java
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="python-tab" data-toggle="tab" href="#python-code" role="tab">
                        <i class="fab fa-python me-1"></i>Python
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="nodejs-tab" data-toggle="tab" href="#nodejs-code" role="tab">
                        <i class="fab fa-node-js me-1"></i>Node.js
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="csharp-tab" data-toggle="tab" href="#csharp-code" role="tab">
                        <i class="fas fa-code me-1"></i>C#
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="go-tab" data-toggle="tab" href="#go-code" role="tab">
                        <i class="fas fa-code me-1"></i>Go
                    </a>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="codeTabContent">
                <!-- Java -->
                <div class="tab-pane fade show active" id="java-code" role="tabpanel">
                    <div class="code-block mt-3">
                        <div class="code-header">
                            <span>PBE Encryption/Decryption - Java (Jasypt)</span>
                            <button class="btn btn-sm btn-outline-light" onclick="copyCode('java-code-content')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
<pre class="code-content" id="java-code-content">import org.jasypt.util.text.AES256TextEncryptor;

public class PBEExample {
    public static void main(String[] args) {
        // Using Jasypt for simple PBE
        AES256TextEncryptor encryptor = new AES256TextEncryptor();
        encryptor.setPassword("mySecretPassword");

        // Encrypt
        String plainText = "Hello, World!";
        String encrypted = encryptor.encrypt(plainText);
        System.out.println("Encrypted: " + encrypted);

        // Decrypt
        String decrypted = encryptor.decrypt(encrypted);
        System.out.println("Decrypted: " + decrypted);
    }
}

// Using standard Java Crypto API
import javax.crypto.*;
import javax.crypto.spec.*;
import java.security.spec.*;

public class PBEStandard {
    public static byte[] encrypt(String password, String plainText,
                                  int iterations) throws Exception {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);

        SecretKeyFactory factory = SecretKeyFactory
            .getInstance("PBKDF2WithHmacSHA256");
        KeySpec spec = new PBEKeySpec(password.toCharArray(),
                                       salt, iterations, 256);
        SecretKey tmp = factory.generateSecret(spec);
        SecretKey secret = new SecretKeySpec(tmp.getEncoded(), "AES");

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, secret);
        byte[] iv = cipher.getIV();
        byte[] cipherText = cipher.doFinal(plainText.getBytes("UTF-8"));

        // Combine salt + iv + ciphertext
        ByteBuffer buffer = ByteBuffer.allocate(
            salt.length + iv.length + cipherText.length);
        buffer.put(salt).put(iv).put(cipherText);
        return buffer.array();
    }
}</pre>
                    </div>
                </div>

                <!-- Python -->
                <div class="tab-pane fade" id="python-code" role="tabpanel">
                    <div class="code-block mt-3">
                        <div class="code-header">
                            <span>PBE Encryption/Decryption - Python</span>
                            <button class="btn btn-sm btn-outline-light" onclick="copyCode('python-code-content')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
<pre class="code-content" id="python-code-content">from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import os
import base64

def pbe_encrypt(password: str, plaintext: str, iterations: int = 10000) -> str:
    """Encrypt plaintext using password-based encryption."""
    # Generate random salt and IV
    salt = os.urandom(16)
    iv = os.urandom(16)

    # Derive key using PBKDF2
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=iterations,
        backend=default_backend()
    )
    key = kdf.derive(password.encode())

    # Encrypt using AES-256-CBC
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv),
                    backend=default_backend())
    encryptor = cipher.encryptor()

    # Pad plaintext to block size
    padded = _pad(plaintext.encode())
    ciphertext = encryptor.update(padded) + encryptor.finalize()

    # Combine salt + iv + ciphertext and encode
    result = salt + iv + ciphertext
    return base64.b64encode(result).decode()

def pbe_decrypt(password: str, encrypted: str, iterations: int = 10000) -> str:
    """Decrypt ciphertext using password-based encryption."""
    data = base64.b64decode(encrypted)
    salt, iv, ciphertext = data[:16], data[16:32], data[32:]

    # Derive key using PBKDF2
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=iterations,
        backend=default_backend()
    )
    key = kdf.derive(password.encode())

    # Decrypt
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv),
                    backend=default_backend())
    decryptor = cipher.decryptor()
    padded = decryptor.update(ciphertext) + decryptor.finalize()

    return _unpad(padded).decode()

def _pad(data: bytes) -> bytes:
    padding_len = 16 - (len(data) % 16)
    return data + bytes([padding_len] * padding_len)

def _unpad(data: bytes) -> bytes:
    return data[:-data[-1]]

# Usage
encrypted = pbe_encrypt("myPassword", "Hello, World!")
print(f"Encrypted: {encrypted}")

decrypted = pbe_decrypt("myPassword", encrypted)
print(f"Decrypted: {decrypted}")</pre>
                    </div>
                </div>

                <!-- Node.js -->
                <div class="tab-pane fade" id="nodejs-code" role="tabpanel">
                    <div class="code-block mt-3">
                        <div class="code-header">
                            <span>PBE Encryption/Decryption - Node.js</span>
                            <button class="btn btn-sm btn-outline-light" onclick="copyCode('nodejs-code-content')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
<pre class="code-content" id="nodejs-code-content">const crypto = require('crypto');

class PBECrypto {
    constructor(iterations = 10000) {
        this.iterations = iterations;
        this.keyLength = 32;
        this.algorithm = 'aes-256-cbc';
    }

    encrypt(password, plaintext) {
        // Generate random salt and IV
        const salt = crypto.randomBytes(16);
        const iv = crypto.randomBytes(16);

        // Derive key using PBKDF2
        const key = crypto.pbkdf2Sync(
            password, salt, this.iterations, this.keyLength, 'sha256'
        );

        // Encrypt
        const cipher = crypto.createCipheriv(this.algorithm, key, iv);
        let encrypted = cipher.update(plaintext, 'utf8', 'base64');
        encrypted += cipher.final('base64');

        // Combine salt + iv + ciphertext
        const result = Buffer.concat([
            salt, iv, Buffer.from(encrypted, 'base64')
        ]);

        return result.toString('base64');
    }

    decrypt(password, encryptedData) {
        const data = Buffer.from(encryptedData, 'base64');

        // Extract salt, iv, and ciphertext
        const salt = data.slice(0, 16);
        const iv = data.slice(16, 32);
        const ciphertext = data.slice(32);

        // Derive key using PBKDF2
        const key = crypto.pbkdf2Sync(
            password, salt, this.iterations, this.keyLength, 'sha256'
        );

        // Decrypt
        const decipher = crypto.createDecipheriv(this.algorithm, key, iv);
        let decrypted = decipher.update(ciphertext, 'base64', 'utf8');
        decrypted += decipher.final('utf8');

        return decrypted;
    }
}

// Usage
const pbe = new PBECrypto(10000);

const encrypted = pbe.encrypt('myPassword', 'Hello, World!');
console.log('Encrypted:', encrypted);

const decrypted = pbe.decrypt('myPassword', encrypted);
console.log('Decrypted:', decrypted);</pre>
                    </div>
                </div>

                <!-- C# -->
                <div class="tab-pane fade" id="csharp-code" role="tabpanel">
                    <div class="code-block mt-3">
                        <div class="code-header">
                            <span>PBE Encryption/Decryption - C#</span>
                            <button class="btn btn-sm btn-outline-light" onclick="copyCode('csharp-code-content')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
<pre class="code-content" id="csharp-code-content">using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public class PBECrypto
{
    private readonly int _iterations;

    public PBECrypto(int iterations = 10000)
    {
        _iterations = iterations;
    }

    public string Encrypt(string password, string plaintext)
    {
        byte[] salt = new byte[16];
        byte[] iv = new byte[16];

        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
            rng.GetBytes(iv);
        }

        // Derive key using PBKDF2
        using var keyDerive = new Rfc2898DeriveBytes(
            password, salt, _iterations, HashAlgorithmName.SHA256);
        byte[] key = keyDerive.GetBytes(32);

        // Encrypt using AES
        using var aes = Aes.Create();
        aes.Key = key;
        aes.IV = iv;
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;

        using var encryptor = aes.CreateEncryptor();
        byte[] plainBytes = Encoding.UTF8.GetBytes(plaintext);
        byte[] cipherBytes = encryptor.TransformFinalBlock(
            plainBytes, 0, plainBytes.Length);

        // Combine salt + iv + ciphertext
        byte[] result = new byte[salt.Length + iv.Length + cipherBytes.Length];
        Buffer.BlockCopy(salt, 0, result, 0, salt.Length);
        Buffer.BlockCopy(iv, 0, result, salt.Length, iv.Length);
        Buffer.BlockCopy(cipherBytes, 0, result,
                         salt.Length + iv.Length, cipherBytes.Length);

        return Convert.ToBase64String(result);
    }

    public string Decrypt(string password, string encrypted)
    {
        byte[] data = Convert.FromBase64String(encrypted);

        byte[] salt = new byte[16];
        byte[] iv = new byte[16];
        byte[] cipherBytes = new byte[data.Length - 32];

        Buffer.BlockCopy(data, 0, salt, 0, 16);
        Buffer.BlockCopy(data, 16, iv, 0, 16);
        Buffer.BlockCopy(data, 32, cipherBytes, 0, cipherBytes.Length);

        using var keyDerive = new Rfc2898DeriveBytes(
            password, salt, _iterations, HashAlgorithmName.SHA256);
        byte[] key = keyDerive.GetBytes(32);

        using var aes = Aes.Create();
        aes.Key = key;
        aes.IV = iv;
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;

        using var decryptor = aes.CreateDecryptor();
        byte[] plainBytes = decryptor.TransformFinalBlock(
            cipherBytes, 0, cipherBytes.Length);

        return Encoding.UTF8.GetString(plainBytes);
    }
}

// Usage
var pbe = new PBECrypto(10000);
string encrypted = pbe.Encrypt("myPassword", "Hello, World!");
Console.WriteLine($"Encrypted: {encrypted}");

string decrypted = pbe.Decrypt("myPassword", encrypted);
Console.WriteLine($"Decrypted: {decrypted}");</pre>
                    </div>
                </div>

                <!-- Go -->
                <div class="tab-pane fade" id="go-code" role="tabpanel">
                    <div class="code-block mt-3">
                        <div class="code-header">
                            <span>PBE Encryption/Decryption - Go</span>
                            <button class="btn btn-sm btn-outline-light" onclick="copyCode('go-code-content')">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
<pre class="code-content" id="go-code-content">package main

import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "crypto/sha256"
    "encoding/base64"
    "fmt"
    "golang.org/x/crypto/pbkdf2"
)

const (
    saltSize   = 16
    ivSize     = 16
    keySize    = 32
    iterations = 10000
)

func Encrypt(password, plaintext string) (string, error) {
    // Generate random salt and IV
    salt := make([]byte, saltSize)
    if _, err := rand.Read(salt); err != nil {
        return "", err
    }

    iv := make([]byte, ivSize)
    if _, err := rand.Read(iv); err != nil {
        return "", err
    }

    // Derive key using PBKDF2
    key := pbkdf2.Key([]byte(password), salt, iterations, keySize, sha256.New)

    // Create AES cipher
    block, err := aes.NewCipher(key)
    if err != nil {
        return "", err
    }

    // Pad plaintext
    plainBytes := pad([]byte(plaintext), aes.BlockSize)

    // Encrypt
    ciphertext := make([]byte, len(plainBytes))
    mode := cipher.NewCBCEncrypter(block, iv)
    mode.CryptBlocks(ciphertext, plainBytes)

    // Combine salt + iv + ciphertext
    result := append(salt, iv...)
    result = append(result, ciphertext...)

    return base64.StdEncoding.EncodeToString(result), nil
}

func Decrypt(password, encrypted string) (string, error) {
    data, err := base64.StdEncoding.DecodeString(encrypted)
    if err != nil {
        return "", err
    }

    salt := data[:saltSize]
    iv := data[saltSize : saltSize+ivSize]
    ciphertext := data[saltSize+ivSize:]

    // Derive key using PBKDF2
    key := pbkdf2.Key([]byte(password), salt, iterations, keySize, sha256.New)

    // Create AES cipher
    block, err := aes.NewCipher(key)
    if err != nil {
        return "", err
    }

    // Decrypt
    plaintext := make([]byte, len(ciphertext))
    mode := cipher.NewCBCDecrypter(block, iv)
    mode.CryptBlocks(plaintext, ciphertext)

    // Unpad
    plaintext = unpad(plaintext)

    return string(plaintext), nil
}

func pad(data []byte, blockSize int) []byte {
    padding := blockSize - (len(data) % blockSize)
    padBytes := make([]byte, padding)
    for i := range padBytes {
        padBytes[i] = byte(padding)
    }
    return append(data, padBytes...)
}

func unpad(data []byte) []byte {
    padding := int(data[len(data)-1])
    return data[:len(data)-padding]
}

func main() {
    encrypted, _ := Encrypt("myPassword", "Hello, World!")
    fmt.Println("Encrypted:", encrypted)

    decrypted, _ := Decrypt("myPassword", encrypted)
    fmt.Println("Decrypted:", decrypted)
}</pre>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Password-Based Encryption</h5>
    </div>
    <div class="card-body">
        <h6>What is PBE?</h6>
        <p>Password-Based Encryption (PBE) is specified in PKCS#5 (RFC 2898). It allows encryption using a password instead of a cryptographic key, making it user-friendly while maintaining security.</p>

        <h6 class="mt-4">How PBE Works</h6>
        <div class="row mb-4">
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-key fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>1. Password</strong></div>
                    <small class="text-muted">User provides a memorable password</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-random fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>2. Salt</strong></div>
                    <small class="text-muted">Random salt prevents rainbow table attacks</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-sync-alt fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>3. Iterations</strong></div>
                    <small class="text-muted">Multiple rounds slow brute-force attacks</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-lock fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>4. Encryption</strong></div>
                    <small class="text-muted">Derived key encrypts the message</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Algorithm Naming Convention</h6>
        <p>PBE algorithm names follow a pattern: <code>PBEWith[HMAC][Hash]And[Cipher]</code></p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Component</th>
                        <th>Options</th>
                        <th>Recommendation</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Hash Function</strong></td>
                        <td>MD5, SHA1, SHA256, SHA384, SHA512</td>
                        <td><span class="badge bg-success">SHA256+</span></td>
                    </tr>
                    <tr>
                        <td><strong>Cipher</strong></td>
                        <td>DES, 3DES, AES-128, AES-192, AES-256, RC2, RC4, Twofish, IDEA</td>
                        <td><span class="badge bg-success">AES-256</span></td>
                    </tr>
                    <tr>
                        <td><strong>Mode</strong></td>
                        <td>CBC (Cipher Block Chaining)</td>
                        <td><span class="badge bg-success">CBC</span></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Security Recommendations</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-success mb-0">
                    <strong><i class="fas fa-check-circle me-1"></i> Recommended:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>PBEWITHHMACSHA256ANDAES_256</li>
                        <li>PBEWITHHMACSHA512ANDAES_256</li>
                        <li>PBEWITHSHA256AND256BITAES-CBC-BC</li>
                        <li>Use 10,000+ iterations minimum</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning mb-0">
                    <strong><i class="fas fa-exclamation-triangle me-1"></i> Avoid (Legacy):</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>PBEWITHMD5ANDDES (weak hash + cipher)</li>
                        <li>PBEWITHSHA1ANDRC4_40 (weak cipher)</li>
                        <li>Any algorithm with DES or MD5</li>
                        <li>Low iteration counts (&lt;1000)</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="alert alert-info mt-4">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Tip:</strong> For new applications, consider using Argon2 or scrypt instead of PBKDF2, as they provide better resistance against GPU-based attacks.
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt me-2"></i>Share Encrypted Message
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning mb-3">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Security Notice:</strong> This URL contains encrypted data. Anyone with this link can attempt to decrypt it if they know the password. Do not share the password in the same channel as this URL.
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Shareable URL:</label>
                    <div class="input-group">
                        <input type="text" class="form-control font-monospace" id="shareUrlText" readonly style="font-size: 11px;">
                        <button class="btn btn-success" type="button" id="copyShareUrl">
                            <i class="fas fa-copy me-1"></i>Copy
                        </button>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="p-2 bg-light rounded">
                            <small class="text-muted">Algorithm:</small>
                            <div class="fw-bold" id="shareAlgorithm">-</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="p-2 bg-light rounded">
                            <small class="text-muted">Iterations:</small>
                            <div class="fw-bold" id="shareRounds">-</div>
                        </div>
                    </div>
                </div>

                <small class="text-muted">
                    <i class="fas fa-lightbulb me-1"></i><strong>Tip:</strong> The recipient will need the password and can use the "Use for Decryption" feature to decrypt the message.
                </small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

</div>

<script>
var currentMode = 'encrypt';
var pwdOptions = {
    uppercase: true,
    lowercase: true,
    numbers: true,
    symbols: true
};

function setMode(mode) {
    currentMode = mode;
    $('#encryptdecryptparameter').val(mode === 'encrypt' ? 'encrypt' : 'decryprt');

    if (mode === 'encrypt') {
        $('#encryptMode').addClass('active');
        $('#decryptMode').removeClass('active');
        $('#submitBtn').html('<i class="fas fa-lock me-2"></i>Encrypt');
        $('#messageHint').html('<i class="fas fa-info-circle me-1"></i>Enter plaintext to encrypt');
    } else {
        $('#decryptMode').addClass('active');
        $('#encryptMode').removeClass('active');
        $('#submitBtn').html('<i class="fas fa-unlock me-2"></i>Decrypt');
        $('#messageHint').html('<i class="fas fa-info-circle me-1"></i>Enter Base64 encrypted message to decrypt');
    }
}

// Password Generator Functions
function generatePassword() {
    var length = parseInt($('#pwdLength').val()) || 16;
    if (length < 8) length = 8;
    if (length > 64) length = 64;

    var charset = '';
    if (pwdOptions.uppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (pwdOptions.lowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (pwdOptions.numbers) charset += '0123456789';
    if (pwdOptions.symbols) charset += '!@#$%^&*()_+-=[]{}|;:,.<>?';

    if (charset === '') {
        charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    }

    var password = '';
    var array = new Uint32Array(length);
    window.crypto.getRandomValues(array);

    for (var i = 0; i < length; i++) {
        password += charset[array[i] % charset.length];
    }

    $('#password').val(password).attr('type', 'text');
    $('#toggleIcon').removeClass('fa-eye').addClass('fa-eye-slash');
    $('#passwordOptions').slideDown();

    showToast('Password generated!');
}

function togglePasswordVisibility() {
    var input = $('#password');
    var icon = $('#toggleIcon');

    if (input.attr('type') === 'password') {
        input.attr('type', 'text');
        icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
        input.attr('type', 'password');
        icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
}

function copyPasswordToClipboard() {
    var password = $('#password').val();
    if (!password) {
        showToast('No password to copy');
        return;
    }
    navigator.clipboard.writeText(password).then(function() {
        showToast('Password copied!');
    });
}

$(document).ready(function() {
    // Password toggle visibility
    $('#togglePassword').click(function() {
        togglePasswordVisibility();
    });

    // Password copy button
    $('#copyPassword').click(function() {
        copyPasswordToClipboard();
    });

    // Password option badges
    $('.pwd-option').click(function() {
        var option = $(this).data('option');
        pwdOptions[option] = !pwdOptions[option];
        $(this).toggleClass('active');

        // Regenerate password with new options
        if ($('#password').val()) {
            generatePassword();
        }
    });

    // Password length change
    $('#pwdLength').on('change', function() {
        if ($('#password').val()) {
            generatePassword();
        }
    });

    // Character/word counter
    $('#message').on('input', function() {
        updateCharCount();
    });
    updateCharCount(); // Initial count

    // Copy share URL from modal
    $('#copyShareUrl').click(function() {
        var shareUrl = $('#shareUrlText').val();
        navigator.clipboard.writeText(shareUrl).then(function() {
            showToast('Share URL copied!');
        });
    });

    // Handle URL parameters (from shared links)
    handleUrlParameters();

    $('#pbeForm').submit(function(event) {
        event.preventDefault();

        var message = $('#message').val().trim();
        var password = $('#password').val();

        if (!message) {
            showError('Please enter a message');
            return;
        }
        if (!password) {
            showError('Please enter a password');
            return;
        }

        // Show loading state
        $('#resultPlaceholder').hide();
        $('#resultContent').hide();
        $('#loadingSpinner').show();
        $('#submitBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

        $.ajax({
            type: "POST",
            url: "PBEFunctionality",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loadingSpinner').hide();
                $('#submitBtn').prop('disabled', false);
                updateButtonText();

                if (response.success) {
                    displayResults(response);
                } else {
                    showError(response.errorMessage || 'Operation failed');
                }
            },
            error: function(xhr, status, error) {
                $('#loadingSpinner').hide();
                $('#submitBtn').prop('disabled', false);
                updateButtonText();
                showError('Request failed: ' + error);
            }
        });
    });
});

function updateButtonText() {
    if (currentMode === 'encrypt') {
        $('#submitBtn').html('<i class="fas fa-lock me-2"></i>Encrypt');
    } else {
        $('#submitBtn').html('<i class="fas fa-unlock me-2"></i>Decrypt');
    }
}

// Store last encryption result for share/download
var lastEncryptionResult = null;

function displayResults(data) {
    var isDecrypt = data.operation === 'pbe_decrypt';
    var html = '<div class="mb-3">';
    html += '<span class="success-badge"><i class="fas fa-check-circle me-1"></i>' +
            (isDecrypt ? 'Decryption Successful' : 'Encryption Successful') + '</span>';
    html += '<span class="info-badge ms-2"><i class="fas fa-sync-alt me-1"></i>' + data.rounds + ' rounds</span>';
    html += '</div>';

    // Store result for share/download (only for encryption)
    if (!isDecrypt) {
        lastEncryptionResult = data;
    }

    // Display results for each algorithm
    if (data.results && data.results.length > 0) {
        data.results.forEach(function(result, index) {
            html += '<div class="result-item">';
            html += '<div class="result-item-header">';
            html += '<span class="algo-badge">' + escapeHtml(result.algorithm) + '</span>';
            html += '<div class="btn-group btn-group-sm">';
            html += '<button class="btn btn-outline-secondary btn-sm" onclick="copyResult(' + index + ')" title="Copy"><i class="fas fa-copy"></i></button>';

            // Add action buttons for encryption results
            if (!isDecrypt) {
                html += '<button class="btn btn-outline-primary btn-sm" onclick="useForDecryption(' + index + ')" title="Use for Decryption"><i class="fas fa-unlock"></i></button>';
                html += '<button class="btn btn-outline-info btn-sm" onclick="openShareModal(' + index + ')" title="Share URL"><i class="fas fa-share-alt"></i></button>';
                html += '<button class="btn btn-outline-success btn-sm" onclick="downloadResult(' + index + ')" title="Download"><i class="fas fa-download"></i></button>';
            }

            html += '</div>';
            html += '</div>';

            if (isDecrypt) {
                html += '<div class="result-block" id="result-' + index + '">' + escapeHtml(result.decryptedMessage) + '</div>';
            } else {
                html += '<div class="result-block" id="result-' + index + '">' + escapeHtml(result.encryptedMessage) + '</div>';
                html += '<div class="param-row">';
                html += '<div class="param-item"><span class="param-label">Salt (8-bit): </span><span class="param-value">' + escapeHtml(result.salt) + '</span></div>';
                html += '<div class="param-item"><span class="param-label">IV (16-bit): </span><span class="param-value">' + escapeHtml(result.iv) + '</span></div>';
                html += '</div>';
            }

            html += '</div>';
        });
    }

    $('#resultContent').html(html).show();
}

// Use encrypted result for decryption
function useForDecryption(index) {
    if (!lastEncryptionResult || !lastEncryptionResult.results[index]) return;

    var result = lastEncryptionResult.results[index];
    var encryptedMessage = result.encryptedMessage;

    // Set message to encrypted text
    $('#message').val(encryptedMessage);

    // Switch to decrypt mode
    setMode('decrypt');

    // Select the same algorithm
    $('#cipherparameternew').val([result.algorithm]);

    // Set the rounds
    $('#rounds').val(lastEncryptionResult.rounds);

    showToast('Ready for decryption - enter password and click Decrypt');

    // Scroll to form
    $('html, body').animate({
        scrollTop: $('#pbeForm').offset().top - 100
    }, 500);
}

// Open share URL modal
function openShareModal(index) {
    if (!lastEncryptionResult || !lastEncryptionResult.results[index]) return;

    var result = lastEncryptionResult.results[index];
    var encryptedMessage = result.encryptedMessage;

    // Build share URL
    var params = new URLSearchParams();
    params.set('msg', encryptedMessage);
    params.set('algo', result.algorithm);
    params.set('rounds', lastEncryptionResult.rounds);
    params.set('mode', 'decrypt');

    var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

    // Update modal
    $('#shareUrlText').val(shareUrl);
    $('#shareAlgorithm').text(result.algorithm);
    $('#shareRounds').text(lastEncryptionResult.rounds);

    // Show modal
    var modal = new bootstrap.Modal(document.getElementById('shareUrlModal'));
    modal.show();
}

// Download encrypted result
function downloadResult(index) {
    if (!lastEncryptionResult || !lastEncryptionResult.results[index]) return;

    var result = lastEncryptionResult.results[index];
    var content = {
        algorithm: result.algorithm,
        encryptedMessage: result.encryptedMessage,
        salt: result.salt,
        iv: result.iv,
        rounds: lastEncryptionResult.rounds,
        timestamp: new Date().toISOString()
    };

    var blob = new Blob([JSON.stringify(content, null, 2)], { type: 'application/json' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = 'pbe-encrypted-' + result.algorithm + '.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    showToast('Downloaded encrypted data');
}

// Handle URL parameters from shared links
function handleUrlParameters() {
    var params = new URLSearchParams(window.location.search);

    var msg = params.get('msg');
    var algo = params.get('algo');
    var rounds = params.get('rounds');
    var mode = params.get('mode');

    if (msg) {
        // Populate the message field
        $('#message').val(msg);

        // Set algorithm if provided
        if (algo) {
            $('#cipherparameternew').val([algo]);
        }

        // Set rounds if provided
        if (rounds) {
            $('#rounds').val(rounds);
        }

        // Set mode (default to decrypt for shared encrypted messages)
        if (mode === 'decrypt') {
            setMode('decrypt');
        }

        // Show info toast
        showToast('Shared encrypted message loaded - enter password to decrypt');

        // Clear URL parameters without reloading
        window.history.replaceState({}, document.title, window.location.pathname);
    }
}

function showError(message) {
    var html = '<div class="error-message">';
    html += '<i class="fas fa-exclamation-circle me-2"></i>';
    html += '<strong>Error:</strong> ' + escapeHtml(message);
    html += '</div>';

    $('#resultPlaceholder').hide();
    $('#resultContent').html(html).show();
}

function copyResult(index) {
    var text = document.getElementById('result-' + index).innerText;
    navigator.clipboard.writeText(text).then(function() {
        showToast('Copied to clipboard!');
    });
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
        '<div class="toast-body text-white rounded" style="background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);">' +
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

function updateCharCount() {
    var text = $('#message').val();
    var charCount = text.length;
    var wordCount = text.trim() ? text.trim().split(/\s+/).length : 0;
    $('#charCount').text(charCount);
    $('#wordCount').text(wordCount);
}

// Copy code from code samples
function copyCode(elementId) {
    var code = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(code).then(function() {
        showToast('Code copied to clipboard!');
    });
}

// Toggle chevron icon on collapse
$('#codeSamplesBody').on('show.bs.collapse shown.bs.collapse', function() {
    $('#codeSamplesIcon').css('transform', 'rotate(180deg)');
}).on('hide.bs.collapse hidden.bs.collapse', function() {
    $('#codeSamplesIcon').css('transform', 'rotate(0deg)');
});
</script>

<%@ include file="body-close.jsp"%>
