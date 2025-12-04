<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>NTRU Key Generator Online - Free Quantum-Resistant NTRUEncrypt Tool | Post-Quantum Cryptography</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "NTRU Key Generator Online",
        "alternateName": ["NTRUEncrypt Tool", "NTRU Encryption Online", "Quantum-Resistant Encryption Tool", "Post-Quantum Key Generator", "Lattice Crypto Tool"],
        "description": "Free online NTRU key generator and encryption tool. Generate quantum-resistant key pairs with NTRUEncrypt - the lattice-based cryptography used in OpenSSH 9.0+. NIST post-quantum finalist, IEEE 1363.1 compliant.",
        "url": "https://8gwifi.org/ntrufunctions.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "NTRU key pair generation",
            "APR2011 and EES parameter sets",
            "Post-quantum secure encryption",
            "Deterministic key derivation with password+salt",
            "Base64 encoded ciphertext output"
        ],
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://twitter.com/anish2good"
        },
        "datePublished": "2017-11-07",
        "dateModified": "<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "Is NTRU considered post-quantum secure?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, NTRU is a lattice-based cryptosystem believed to be resistant to quantum attacks including Shor's algorithm. It's one of the oldest post-quantum cryptographic schemes, proposed in 1996."
                }
            },
            {
                "@type": "Question",
                "name": "Which NTRU parameter sets are supported?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "This tool supports APR2011 parameter sets (439, 743, FAST variants) and EES families (EES1087EP2, EES1171EP1, EES1499EP1). APR2011_743_FAST is recommended for general use."
                }
            },
            {
                "@type": "Question",
                "name": "Are generated keys deterministic?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, if you use the same Password + Salt combination, the tool derives the same key pair deterministically. This is useful for key recovery scenarios."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between NTRUEncrypt and NTRU-HRSS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "NTRUEncrypt is the original NTRU encryption scheme. NTRU-HRSS is a newer variant with better security proofs. This tool implements NTRUEncrypt with various parameter sets."
                }
            },
            {
                "@type": "Question",
                "name": "Why is lattice-based cryptography important?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Lattice-based cryptography is resistant to quantum computer attacks unlike RSA and ECC. NIST is standardizing lattice-based schemes for post-quantum security, making NTRU and similar schemes crucial for future-proof encryption."
                }
            },
            {
                "@type": "Question",
                "name": "Does OpenSSH use NTRU?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes! Since OpenSSH 9.0 (August 2022), NTRU is used by default combined with X25519 ECDH for hybrid key exchange. This provides quantum resistance while maintaining compatibility with current systems."
                }
            },
            {
                "@type": "Question",
                "name": "Is NTRU faster than RSA?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, NTRU private-key operations are significantly faster than RSA at equivalent security levels. RSA complexity grows as the cube of key size, while NTRU grows quadratically. This makes NTRU more efficient for high-security applications."
                }
            },
            {
                "@type": "Question",
                "name": "Was NTRU selected by NIST for post-quantum standardization?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "NTRU was a finalist in NIST's Post-Quantum Cryptography Standardization Round 3. While CRYSTALS-Kyber was ultimately selected as the primary KEM standard, NTRU remains widely deployed and is still considered secure for post-quantum encryption."
                }
            }
        ]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt with NTRU Online",
        "description": "Step-by-step guide to encrypt messages using NTRU lattice-based encryption",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Generate key pair",
                "text": "Select a parameter set and click Generate to create NTRU public and private keys"
            },
            {
                "@type": "HowToStep",
                "name": "Enter your message",
                "text": "Type or paste the plaintext message you want to encrypt"
            },
            {
                "@type": "HowToStep",
                "name": "Encrypt with public key",
                "text": "Select Encrypt mode and click Run to encrypt using the public key"
            },
            {
                "@type": "HowToStep",
                "name": "Decrypt with private key",
                "text": "To decrypt, paste the ciphertext, select Decrypt mode, and use the private key"
            }
        ]
    }
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online NTRU key generator and encryption tool. Generate quantum-resistant key pairs and encrypt/decrypt with NTRUEncrypt - the lattice-based cryptography used in OpenSSH. NIST post-quantum finalist, IEEE 1363.1 standard compliant.">
    <meta name="keywords" content="NTRU key generator online, NTRUEncrypt online tool, quantum resistant encryption, post-quantum cryptography, lattice-based encryption free, NTRU encrypt decrypt, APR2011 NTRU, EES1087EP2, NIST post-quantum, OpenSSH NTRU, IEEE 1363.1, quantum-proof encryption, NTRU Prime, libntru online">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">

    <!-- Open Graph -->
    <meta property="og:title" content="NTRU Key Generator Online - Quantum-Resistant NTRUEncrypt Tool">
    <meta property="og:description" content="Free online NTRU key generator. Encrypt/decrypt with NTRUEncrypt lattice cryptography - used in OpenSSH, NIST post-quantum finalist.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/ntrufunctions.jsp">
    <meta property="og:image" content="https://github.com/anishnath/crypto-tool/raw/master/ntru.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="NTRU Key Generator - Free Quantum-Resistant Encryption Tool">
    <meta name="twitter:description" content="Generate NTRU key pairs online. NTRUEncrypt - faster than RSA, quantum-proof, used in OpenSSH 9.0+">
    <meta name="twitter:image" content="https://github.com/anishnath/crypto-tool/raw/master/ntru.png">
    <meta name="twitter:creator" content="@anish2good">

    <%@ include file="header-script.jsp"%>

    <%
        String pubKey = "";
        String privKey = "";
        String errorMsg = "";
        String ntru = "APR2011_743_FAST";
        if (request.getSession().getAttribute("pubkey") != null) {
            pubKey = (String) request.getSession().getAttribute("pubkey");
            privKey = (String) request.getSession().getAttribute("privKey");
            ntru = (String) request.getSession().getAttribute("ntru");
            errorMsg = (String) request.getSession().getAttribute("errorMsg");
        }
    %>

    <style>
        :root {
            --theme-color: #7c3aed;
            --theme-color-dark: #6d28d9;
            --theme-color-light: #a78bfa;
            --theme-bg-light: #f5f3ff;
        }

        .page-header {
            background: linear-gradient(135deg, var(--theme-color) 0%, var(--theme-color-dark) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            opacity: 0.9;
            margin-bottom: 0;
        }

        .info-badge {
            display: inline-flex;
            align-items: center;
            background: rgba(255,255,255,0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-right: 0.5rem;
            margin-top: 0.5rem;
        }

        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border-radius: 12px;
            margin-bottom: 1.5rem;
        }

        .card-header {
            background: var(--theme-bg-light);
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            color: var(--theme-color-dark);
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--theme-color);
            box-shadow: 0 0 0 0.2rem rgba(124, 58, 237, 0.15);
        }

        .btn-theme {
            background: var(--theme-color);
            border-color: var(--theme-color);
            color: white;
        }

        .btn-theme:hover {
            background: var(--theme-color-dark);
            border-color: var(--theme-color-dark);
            color: white;
        }

        .btn-outline-theme {
            color: var(--theme-color);
            border-color: var(--theme-color);
        }

        .btn-outline-theme:hover {
            background: var(--theme-color);
            color: white;
        }

        .mode-toggle {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .mode-toggle .btn {
            flex: 1;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .mode-toggle .btn.active {
            background: var(--theme-color);
            color: white;
            border-color: var(--theme-color);
        }

        .result-card {
            background: white;
            border-left: 4px solid var(--theme-color);
        }

        .result-success {
            border-left-color: #10b981;
        }

        .result-error {
            border-left-color: #ef4444;
        }

        .result-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #6b7280;
            font-weight: 600;
        }

        .result-value {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.9rem;
            background: #f9fafb;
            padding: 0.75rem;
            border-radius: 6px;
            word-break: break-all;
            margin-top: 0.25rem;
        }

        .key-toggle {
            cursor: pointer;
            user-select: none;
        }

        .key-toggle:hover {
            color: var(--theme-color);
        }

        .eeat-badge {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            display: inline-block;
            margin-top: 1rem;
        }

        .related-tools-card .card-body {
            padding: 1rem;
        }

        .related-tool-link {
            display: block;
            padding: 0.5rem 0.75rem;
            color: #374151;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.2s;
            font-size: 0.9rem;
        }

        .related-tool-link:hover {
            background: var(--theme-bg-light);
            color: var(--theme-color);
        }

        .related-tool-link.active {
            background: var(--theme-color);
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .action-buttons .btn {
            flex: 1;
            min-width: 100px;
        }

        .keygen-card {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #f59e0b;
        }

        .keygen-card .card-header {
            background: rgba(245, 158, 11, 0.2);
            color: #92400e;
        }

        @media (min-width: 992px) {
            .sticky-result {
                position: sticky;
                top: 80px;
            }
        }

        @media (max-width: 991px) {
            .page-header h1 {
                font-size: 1.5rem;
            }
        }

        /* Share Modal Styles */
        .share-modal .modal-header {
            background: var(--theme-bg-light);
            border-bottom: 1px solid #e9ecef;
        }

        .share-modal .modal-title {
            color: var(--theme-color-dark);
            font-weight: 600;
        }

        .share-url-input {
            font-family: monospace;
            font-size: 0.85rem;
        }

        .social-support {
            background: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .social-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .twitter-follow {
            background: #1da1f2;
            color: white;
        }

        .twitter-follow:hover {
            background: #0c85d0;
            color: white;
        }

        .twitter-tweet {
            background: #14171a;
            color: white;
        }

        .twitter-tweet:hover {
            background: #000;
            color: white;
        }

        .quantum-badge {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1>NTRU Encryption Online</h1>
        <p>Post-Quantum Lattice-based Public Key Cryptography</p>
        <div>
            <span class="info-badge">Lattice-based</span>
            <span class="info-badge">APR2011 / EES</span>
            <span class="quantum-badge">Quantum Resistant</span>
        </div>
        <div class="eeat-badge">
            Created by <a href="https://twitter.com/anish2good" class="text-white" style="text-decoration: underline;">@anish2good</a> - Cryptography Engineer
        </div>
    </div>
</div>

<div class="container">
    <% if (errorMsg != null && !"".equals(errorMsg)) { %>
    <div class="alert alert-danger alert-dismissible fade show">
        <%= errorMsg %>
        <button type="button" class="btn-close" data-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row">
        <!-- Input Column -->
        <div class="col-lg-5 mb-4">
            <!-- Key Generation Card -->
            <div class="card keygen-card">
                <div class="card-header">Generate NTRU Key Pair</div>
                <div class="card-body">
                    <form id="form1" method="POST" action="NTRUFunctionality">
                        <input type="hidden" name="methodName" value="GENERATE_KEYS">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Parameter Set</label>
                            <select class="form-select" name="ntruparam" id="ntruparam">
                                <option value="APR2011_743_FAST" selected>APR2011_743_FAST (Recommended)</option>
                                <option value="APR2011_743">APR2011_743</option>
                                <option value="APR2011_439_FAST">APR2011_439_FAST</option>
                                <option value="APR2011_439">APR2011_439</option>
                                <option value="EES1087EP2">EES1087EP2</option>
                                <option value="EES1087EP2_FAST">EES1087EP2_FAST</option>
                                <option value="EES1171EP1">EES1171EP1</option>
                                <option value="EES1171EP1_FAST">EES1171EP1_FAST</option>
                                <option value="EES1499EP1">EES1499EP1</option>
                                <option value="EES1499EP1_FAST">EES1499EP1_FAST</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Password (Optional)</label>
                                <input type="text" class="form-control" name="password" placeholder="For deterministic keys">
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Salt (Optional)</label>
                                <input type="text" class="form-control" name="salt" placeholder="Salt for KDF">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 fw-semibold">Generate Key Pair</button>
                    </form>
                    <small class="text-muted d-block mt-2">Password + Salt derives deterministic keys for recovery.</small>
                </div>
            </div>

            <!-- Encrypt/Decrypt Form -->
            <form id="form" method="POST">
                <input type="hidden" name="methodName" value="CALCULATE_NTRU">
                <input type="hidden" name="p_ntru" id="p_ntru" value="<%= ntru %>">

                <!-- Mode Selection -->
                <div class="card">
                    <div class="card-header">Operation Mode</div>
                    <div class="card-body">
                        <div class="mode-toggle">
                            <button type="button" class="btn btn-outline-secondary active" id="encryptBtn" onclick="setMode('encrypt')">
                                Encrypt
                            </button>
                            <button type="button" class="btn btn-outline-secondary" id="decryptBtn" onclick="setMode('decrypt')">
                                Decrypt
                            </button>
                        </div>
                        <input type="hidden" name="encryptdecryptparameter" id="encryptdecryptparameter" value="encrypt">
                    </div>
                </div>

                <!-- Message Input -->
                <div class="card">
                    <div class="card-header">Message</div>
                    <div class="card-body">
                        <textarea class="form-control" rows="4" name="message" id="message" placeholder="Enter plaintext to encrypt, or Base64 ciphertext to decrypt..."></textarea>
                    </div>
                </div>

                <!-- Keys (Collapsible) -->
                <div class="card">
                    <div class="card-header key-toggle" data-toggle="collapse" data-target="#keySection">
                        NTRU Keys
                        <span class="float-end">
                            <small class="text-muted">click to <span id="toggleText"><%= (pubKey != null && !pubKey.isEmpty()) ? "collapse" : "expand" %></span></small>
                        </span>
                    </div>
                    <div id="keySection" class="collapse <%= (pubKey != null && !pubKey.isEmpty()) ? "show" : "" %>">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Public Key</label>
                                <textarea class="form-control" rows="4" name="publickeyparam" id="publickeyparam" placeholder="NTRU public key..."><%= pubKey %></textarea>
                            </div>
                            <div class="mb-0">
                                <label class="form-label fw-semibold">Private Key</label>
                                <textarea class="form-control" rows="4" name="privatekeyparam" id="privatekeyparam" placeholder="NTRU private key (required for decryption)..."><%= privKey %></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-theme btn-lg w-100">
                    <span id="submitBtnText">Encrypt Message</span>
                </button>
            </form>
        </div>

        <!-- Result Column -->
        <div class="col-lg-7">
            <div class="sticky-result">
                <div class="card result-card" id="resultCard" style="display: none;">
                    <div class="card-header">
                        <span id="resultTitle">Result</span>
                    </div>
                    <div class="card-body">
                        <div id="output"></div>
                        <div class="action-buttons" id="actionButtons" style="display: none;">
                            <button class="btn btn-outline-theme" onclick="copyResult()">Copy</button>
                            <button class="btn btn-outline-theme" onclick="downloadResult()">Download</button>
                            <button class="btn btn-outline-theme" onclick="openShareModal()">Share URL</button>
                        </div>
                    </div>
                </div>

                <!-- Algorithm Info -->
                <div class="card">
                    <div class="card-header">About NTRU Encryption</div>
                    <div class="card-body">
                        <p class="mb-2"><strong>NTRU</strong> is a lattice-based public key cryptosystem that's resistant to quantum computer attacks.</p>
                        <ul class="mb-0 small">
                            <li><strong>Post-Quantum:</strong> Secure against Shor's algorithm</li>
                            <li><strong>Fast:</strong> Faster than RSA for similar security levels</li>
                            <li><strong>APR2011:</strong> Parameter sets from 2011 IEEE paper</li>
                            <li><strong>EES:</strong> Encryption parameter sets for different security levels</li>
                        </ul>
                    </div>
                </div>

                <!-- Related Tools -->
                <div class="card related-tools-card">
                    <div class="card-header">Related Post-Quantum Tools</div>
                    <div class="card-body">
                        <a href="ntrufunctions.jsp" class="related-tool-link active">NTRU Encryption (This Tool)</a>
                        <a href="rsafunctions.jsp" class="related-tool-link">RSA Encryption</a>
                        <a href="elgamalfunctions.jsp" class="related-tool-link">ElGamal Encryption</a>
                        <a href="ecfunctions.jsp" class="related-tool-link">Elliptic Curve Cryptography</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr class="my-4">
    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    <%@ include file="footer_adsense.jsp"%>

    <!-- Educational Content -->
    <div class="ntru-education-section mt-4">
        <!-- Section Header -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h2 class="h5 mb-0">What is NTRU?</h2>
            </div>
            <div class="card-body">
                <p><strong>NTRU</strong> (N-th degree Truncated polynomial Ring Units) is one of the oldest and most studied post-quantum cryptographic algorithms, first proposed in 1996 by mathematicians Jeffrey Hoffstein, Jill Pipher, and Joseph H. Silverman.</p>
                <p class="mb-0">Unlike RSA and ECC which can be broken by quantum computers using Shor's algorithm, NTRU's security is based on the hardness of the <strong>Shortest Vector Problem (SVP)</strong> in lattices - a problem believed to be resistant to quantum attacks.</p>
            </div>
        </div>

        <!-- Quantum Threat Comparison -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h2 class="h5 mb-0">Quantum Threat Comparison</h2>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Algorithm</th>
                                <th>Type</th>
                                <th>Quantum Safe?</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="table-danger">
                                <td><strong>RSA</strong></td>
                                <td>Integer Factorization</td>
                                <td><span class="badge bg-danger">Broken by Shor's</span></td>
                                <td>Migrate away</td>
                            </tr>
                            <tr class="table-danger">
                                <td><strong>ECC / ECDSA</strong></td>
                                <td>Discrete Log (Curves)</td>
                                <td><span class="badge bg-danger">Broken by Shor's</span></td>
                                <td>Migrate away</td>
                            </tr>
                            <tr class="table-success">
                                <td><strong>NTRU</strong></td>
                                <td>Lattice (SVP)</td>
                                <td><span class="badge bg-success">Quantum Resistant</span></td>
                                <td>Safe to use</td>
                            </tr>
                            <tr class="table-success">
                                <td><strong>CRYSTALS-Kyber</strong></td>
                                <td>Lattice (MLWE)</td>
                                <td><span class="badge bg-success">Quantum Resistant</span></td>
                                <td>NIST Standard</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Collapsible Educational Sections -->
        <!-- Parameter Sets -->
        <div class="card mb-3">
            <div class="card-header key-toggle" data-toggle="collapse" data-target="#parameterSets" style="cursor: pointer;">
                <h2 class="h5 mb-0">
                    NTRU Parameter Sets
                    <span class="float-end"><small class="text-muted">click to expand</small></span>
                </h2>
            </div>
            <div id="parameterSets" class="collapse show">
                <div class="card-body">
                    <p>NTRU supports multiple parameter sets for different security/performance trade-offs:</p>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="border rounded p-3 h-100">
                                <h6 class="text-primary">APR2011 Family</h6>
                                <p class="small text-muted mb-2">From 2011 IEEE paper - recommended for most uses</p>
                                <ul class="small mb-0">
                                    <li><code>APR2011_743_FAST</code> - 256-bit security (recommended)</li>
                                    <li><code>APR2011_743</code> - 256-bit (non-optimized)</li>
                                    <li><code>APR2011_439_FAST</code> - 128-bit security</li>
                                    <li><code>APR2011_439</code> - 128-bit (smaller keys)</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="border rounded p-3 h-100">
                                <h6 class="text-primary">EES Family (IEEE 1363.1)</h6>
                                <p class="small text-muted mb-2">Standardized parameter sets</p>
                                <ul class="small mb-0">
                                    <li><code>EES1499EP1</code> - 256-bit (highest security)</li>
                                    <li><code>EES1171EP1</code> - 192-bit security</li>
                                    <li><code>EES1087EP2</code> - 112-bit security</li>
                                    <li>All have <code>_FAST</code> optimized variants</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Real-World Adoption -->
        <div class="card mb-3">
            <div class="card-header key-toggle" data-toggle="collapse" data-target="#realWorldAdoption" style="cursor: pointer;">
                <h2 class="h5 mb-0">
                    Real-World Adoption
                    <span class="float-end"><small class="text-muted">click to expand</small></span>
                </h2>
            </div>
            <div id="realWorldAdoption" class="collapse">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 border-primary">
                                <div class="card-body text-center">
                                    <h6 class="card-title text-primary">OpenSSH 9.0+</h6>
                                    <p class="small mb-0">Uses NTRU + X25519 hybrid key exchange by default since August 2022</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 border-success">
                                <div class="card-body text-center">
                                    <h6 class="card-title text-success">Google Chrome</h6>
                                    <p class="small mb-0">CECPQ2 experiment tested NTRU for post-quantum TLS</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 border-info">
                                <div class="card-body text-center">
                                    <h6 class="card-title text-info">IEEE 1363.1</h6>
                                    <p class="small mb-0">Standardized in 2008 for lattice-based public-key cryptography</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-success mb-0">
                        <strong>Fun Fact:</strong> NTRU was patented but released to the public domain in 2017, making it freely available for any use.
                    </div>
                </div>
            </div>
        </div>

        <!-- NIST Standardization -->
        <div class="card mb-3">
            <div class="card-header key-toggle" data-toggle="collapse" data-target="#nistStandards" style="cursor: pointer;">
                <h2 class="h5 mb-0">
                    NIST Post-Quantum Standardization
                    <span class="float-end"><small class="text-muted">click to expand</small></span>
                </h2>
            </div>
            <div id="nistStandards" class="collapse">
                <div class="card-body">
                    <p>NIST's Post-Quantum Cryptography Standardization project evaluated algorithms resistant to quantum attacks:</p>
                    <div class="table-responsive">
                        <table class="table table-bordered table-sm">
                            <thead class="table-light">
                                <tr>
                                    <th>Algorithm</th>
                                    <th>Type</th>
                                    <th>NIST Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>CRYSTALS-Kyber</strong></td>
                                    <td>KEM (Lattice/MLWE)</td>
                                    <td><span class="badge badge-primary bg-primary">Selected Standard</span></td>
                                </tr>
                                <tr>
                                    <td><strong>NTRU</strong></td>
                                    <td>KEM (Lattice/SVP)</td>
                                    <td><span class="badge badge-secondary bg-secondary">Round 3 Finalist</span></td>
                                </tr>
                                <tr>
                                    <td><strong>NTRU Prime</strong></td>
                                    <td>KEM (Lattice)</td>
                                    <td><span class="badge badge-secondary bg-secondary">Round 3 Alternate</span></td>
                                </tr>
                                <tr>
                                    <td><strong>CRYSTALS-Dilithium</strong></td>
                                    <td>Signature</td>
                                    <td><span class="badge badge-primary bg-primary">Selected Standard</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p class="mb-0 small text-muted">While Kyber was selected as the primary KEM standard, NTRU remains widely deployed and is considered secure.</p>
                </div>
            </div>
        </div>

        <!-- Code Examples -->
        <div class="card mb-3">
            <div class="card-header key-toggle" data-toggle="collapse" data-target="#codeExamples" style="cursor: pointer;">
                <h2 class="h5 mb-0">
                    Code Examples
                    <span class="float-end"><small class="text-muted">click to expand</small></span>
                </h2>
            </div>
            <div id="codeExamples" class="collapse">
                <div class="card-body">
                    <ul class="nav nav-tabs" id="codeTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-toggle="tab" href="#javaCode" role="tab">Java</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#pythonCode" role="tab">Python</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#cCode" role="tab">C</a>
                        </li>
                    </ul>
                    <div class="tab-content border border-top-0 rounded-bottom p-3">
                        <div class="tab-pane fade show active" id="javaCode" role="tabpanel">
<pre class="mb-0"><code class="java">// Java - Using BouncyCastle NTRU
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.NTRUParameterSpec;

Security.addProvider(new BouncyCastlePQCProvider());

// Generate key pair
KeyPairGenerator kpg = KeyPairGenerator.getInstance("NTRU", "BCPQC");
kpg.initialize(NTRUParameterSpec.ntruhrss701);
KeyPair kp = kpg.generateKeyPair();

// Encrypt
Cipher cipher = Cipher.getInstance("NTRU", "BCPQC");
cipher.init(Cipher.ENCRYPT_MODE, kp.getPublic());
byte[] ciphertext = cipher.doFinal(plaintext);</code></pre>
                        </div>
                        <div class="tab-pane fade" id="pythonCode" role="tabpanel">
<pre class="mb-0"><code class="python"># Python - Using ntru library
from ntru import NTRUEncrypt

# Initialize with parameter set
ntru = NTRUEncrypt(N=743, p=3, q=2048)

# Generate keys
public_key, private_key = ntru.generate_keypair()

# Encrypt message
ciphertext = ntru.encrypt(message, public_key)

# Decrypt message
plaintext = ntru.decrypt(ciphertext, private_key)</code></pre>
                        </div>
                        <div class="tab-pane fade" id="cCode" role="tabpanel">
<pre class="mb-0"><code class="c">// C - Using libntru
#include "ntru.h"

// Generate key pair
NtruEncKeyPair kp;
NtruRandGen rng = NTRU_RNG_DEFAULT;
ntru_gen_key_pair(&amp;NTRU_DEFAULT_PARAMS_128_BITS, &amp;kp, &amp;rng);

// Encrypt
uint8_t enc[NTRU_MAX_ENC_LEN];
uint16_t enc_len;
ntru_encrypt(msg, msg_len, &amp;kp.pub, &amp;NTRU_DEFAULT_PARAMS_128_BITS,
             &amp;rng, enc, &amp;enc_len);

// Decrypt
uint8_t dec[NTRU_MAX_MSG_LEN];
uint16_t dec_len;
ntru_decrypt(enc, &amp;kp, &amp;NTRU_DEFAULT_PARAMS_128_BITS, dec, &amp;dec_len);</code></pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Performance -->
        <div class="card mb-3">
            <div class="card-header key-toggle" data-toggle="collapse" data-target="#performance" style="cursor: pointer;">
                <h2 class="h5 mb-0">
                    Performance vs RSA
                    <span class="float-end"><small class="text-muted">click to expand</small></span>
                </h2>
            </div>
            <div id="performance" class="collapse">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h6>Why NTRU is faster:</h6>
                            <ul class="small">
                                <li><strong>RSA:</strong> Private key operations scale as O(n<sup>3</sup>) with key size</li>
                                <li><strong>NTRU:</strong> Operations scale as O(n<sup>2</sup>) - quadratic vs cubic</li>
                                <li>At 256-bit security, NTRU is significantly faster for decryption</li>
                                <li>Key sizes are comparable to RSA at equivalent security</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body text-center">
                                    <h6 class="text-muted mb-2">Relative Speed (Decryption)</h6>
                                    <div class="mb-2">
                                        <span class="d-block small">NTRU</span>
                                        <div class="progress" style="height: 25px;">
                                            <div class="progress-bar bg-success" style="width: 90%;">Fast</div>
                                        </div>
                                    </div>
                                    <div>
                                        <span class="d-block small">RSA-2048</span>
                                        <div class="progress" style="height: 25px;">
                                            <div class="progress-bar bg-warning" style="width: 40%;">Slower</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Learn More -->
        <div class="card mt-4">
            <div class="card-header bg-light">
                <h2 class="h5 mb-0">Learn More</h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>Official Resources</h6>
                        <ul class="small">
                            <li><a href="https://ntru.org/" target="_blank" rel="noopener">NTRU Official Site</a></li>
                            <li><a href="https://github.com/tbuktu/ntru" target="_blank" rel="noopener">tbuktu/ntru (Java Implementation)</a></li>
                            <li><a href="https://github.com/tbuktu/libntru" target="_blank" rel="noopener">libntru (C Implementation)</a></li>
                            <li><a href="https://ntruprime.cr.yp.to/" target="_blank" rel="noopener">NTRU Prime Project</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <h6>Related 8gwifi.org Tools</h6>
                        <ul class="small mb-0">
                            <li><a href="rsafunctions.jsp">RSA Encryption/Decryption</a></li>
                            <li><a href="ecfunctions.jsp">Elliptic Curve Cryptography</a></li>
                            <li><a href="elgamalfunctions.jsp">ElGamal Encryption</a></li>
                            <li><a href="dsafunctions.jsp">DSA Digital Signatures</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade share-modal" id="shareModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Share This Encryption</h5>
                <button type="button" class="btn-close" data-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="social-support">
                    <p class="mb-2 fw-semibold">Support this free tool!</p>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="https://twitter.com/intent/follow?screen_name=anish2good" target="_blank" class="social-btn twitter-follow">
                            Follow @anish2good
                        </a>
                        <a href="#" id="tweetBtn" target="_blank" class="social-btn twitter-tweet">
                            Tweet This Tool
                        </a>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Shareable URL</label>
                    <div class="input-group">
                        <input type="text" class="form-control share-url-input" id="shareUrl" readonly>
                        <button class="btn btn-theme" onclick="copyShareUrl()">Copy</button>
                    </div>
                </div>
                <div class="alert alert-danger mb-0" id="shareWarningPrivate" style="display: none;">
                    <strong>Warning:</strong> The private key is included in this URL. NEVER share publicly!
                </div>
                <div class="alert alert-warning mb-0" id="shareWarningPublic" style="display: none;">
                    <strong>Note:</strong> The public key is included. Only share with intended recipients.
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var currentResult = null;
    var currentOperation = 'encrypt';

    function setMode(mode) {
        currentOperation = mode;
        document.getElementById('encryptdecryptparameter').value = mode;
        document.getElementById('encryptBtn').classList.toggle('active', mode === 'encrypt');
        document.getElementById('decryptBtn').classList.toggle('active', mode === 'decrypt');
        document.getElementById('submitBtnText').textContent = mode === 'encrypt' ? 'Encrypt Message' : 'Decrypt Message';
    }

    function displayResult(data) {
        currentResult = data;
        var resultCard = document.getElementById('resultCard');
        var output = document.getElementById('output');
        var actionButtons = document.getElementById('actionButtons');
        var resultTitle = document.getElementById('resultTitle');

        resultCard.style.display = 'block';
        resultCard.classList.remove('result-success', 'result-error');

        if (data.success) {
            resultCard.classList.add('result-success');
            resultTitle.textContent = data.operation === 'encrypt' ? 'Encryption Result' : 'Decryption Result';

            var html = '<div class="mb-3"><div class="result-label">Algorithm</div><div class="result-value">NTRU (' + (data.parameterSet || 'APR2011') + ')</div></div>';

            if (data.operation === 'encrypt') {
                html += '<div class="mb-3"><div class="result-label">Ciphertext (Base64)</div><div class="result-value">' + data.ciphertext + '</div></div>';
            } else {
                html += '<div class="mb-3"><div class="result-label">Plaintext</div><div class="result-value">' + data.plaintext + '</div></div>';
            }

            output.innerHTML = html;
            actionButtons.style.display = 'flex';
        } else {
            resultCard.classList.add('result-error');
            resultTitle.textContent = 'Error';
            output.innerHTML = '<div class="alert alert-danger mb-0">' + data.errorMessage + '</div>';
            actionButtons.style.display = 'none';
        }
    }

    function copyResult() {
        if (!currentResult || !currentResult.success) return;
        var text = currentResult.operation === 'encrypt' ? currentResult.ciphertext : currentResult.plaintext;
        navigator.clipboard.writeText(text).then(function() {
            alert('Copied to clipboard!');
        });
    }

    function downloadResult() {
        if (!currentResult || !currentResult.success) return;
        var text = currentResult.operation === 'encrypt' ? currentResult.ciphertext : currentResult.plaintext;
        var filename = 'ntru-' + currentResult.operation + '-result.txt';
        var blob = new Blob([text], { type: 'text/plain' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.click();
        URL.revokeObjectURL(url);
    }

    function openShareModal() {
        var publicKey = document.getElementById('publickeyparam').value;
        var privateKey = document.getElementById('privatekeyparam').value;

        var params = {
            mode: currentOperation,
            paramSet: document.getElementById('p_ntru').value
        };

        // Only include public key for sharing
        if (publicKey) {
            params.pubKey = publicKey;
        }

        if (currentResult && currentResult.success) {
            if (currentOperation === 'encrypt') {
                params.ciphertext = currentResult.ciphertext;
            }
        }

        var shareUrl = window.location.origin + window.location.pathname + '?data=' + btoa(JSON.stringify(params));
        document.getElementById('shareUrl').value = shareUrl;

        // Show appropriate warning
        document.getElementById('shareWarningPrivate').style.display = 'none';
        document.getElementById('shareWarningPublic').style.display = publicKey ? 'block' : 'none';

        var tweetText = 'Check out this NTRU post-quantum encryption tool! Lattice-based quantum-resistant cryptography. @anish2good';
        document.getElementById('tweetBtn').href = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText) + '&url=' + encodeURIComponent('https://8gwifi.org/ntrufunctions.jsp');

        $('#shareModal').modal('show');
    }

    function copyShareUrl() {
        var shareUrl = document.getElementById('shareUrl').value;
        navigator.clipboard.writeText(shareUrl).then(function() {
            alert('URL copied to clipboard!');
        });
    }

    function loadFromUrl() {
        var urlParams = new URLSearchParams(window.location.search);
        var data = urlParams.get('data');
        if (data) {
            try {
                var params = JSON.parse(atob(data));
                if (params.mode) setMode(params.mode);
                if (params.paramSet) document.getElementById('p_ntru').value = params.paramSet;
                if (params.pubKey) document.getElementById('publickeyparam').value = params.pubKey;
                if (params.ciphertext) document.getElementById('message').value = params.ciphertext;
            } catch (e) {
                console.error('Failed to parse URL data');
            }
        }
    }

    // Update toggle text on collapse events
    $('#keySection').on('shown.bs.collapse', function() {
        $('#toggleText').text('collapse');
    });
    $('#keySection').on('hidden.bs.collapse', function() {
        $('#toggleText').text('expand');
    });

    $(document).ready(function() {
        loadFromUrl();

        $('#form').submit(function(event) {
            event.preventDefault();
            $('#output').html('<div class="text-center py-3"><div class="spinner-border text-primary" role="status"></div><div class="mt-2">Processing...</div></div>');
            document.getElementById('resultCard').style.display = 'block';
            document.getElementById('actionButtons').style.display = 'none';

            $.ajax({
                type: "POST",
                url: "NTRUFunctionality",
                data: $("#form").serialize(),
                dataType: "json",
                success: function(data) {
                    displayResult(data);
                },
                error: function(xhr, status, error) {
                    displayResult({
                        success: false,
                        errorMessage: 'Request failed: ' + error
                    });
                }
            });
        });
    });
</script>
</div>
<%@ include file="body-close.jsp"%>
