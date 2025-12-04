<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Libsodium SecretBox Online Tool - NaCl crypto_secretbox XSalsa20-Poly1305 Encryption</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Libsodium SecretBox Encryption Tool",
        "alternateName": ["NaCl crypto_secretbox", "XSalsa20-Poly1305 Encryption", "NaCl AEAD Tool"],
        "description": "Free online libsodium secretbox (crypto_secretbox) encryption and decryption tool. Uses XSalsa20-Poly1305 authenticated encryption - the same algorithm used in NaCl, PyNaCl, and libsodium libraries.",
        "url": "https://8gwifi.org/naclaead.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "XSalsa20-Poly1305 authenticated encryption",
            "Compatible with libsodium crypto_secretbox",
            "Additional authenticated data (AAD) support",
            "32-byte key / 24-byte nonce",
            "Poly1305 message authentication",
            "Real-time browser-based encryption"
        ],
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://twitter.com/anish2good"
        },
        "datePublished": "2018-12-19",
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
                "name": "What is libsodium secretbox (crypto_secretbox)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Libsodium secretbox (crypto_secretbox) is a high-level authenticated encryption function that combines XSalsa20 stream cipher with Poly1305 MAC. It provides both confidentiality and integrity in a single operation, making it easy to use correctly."
                }
            },
            {
                "@type": "Question",
                "name": "What is XSalsa20-Poly1305?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "XSalsa20-Poly1305 combines the XSalsa20 stream cipher (extended nonce variant of Salsa20) with Poly1305 one-time authenticator. It's the algorithm behind NaCl's crypto_secretbox and provides authenticated encryption with a 32-byte key and 24-byte nonce."
                }
            },
            {
                "@type": "Question",
                "name": "What key and nonce size does crypto_secretbox use?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "crypto_secretbox requires a 32-byte (256-bit) secret key and a 24-byte (192-bit) nonce. The nonce should be unique for each message but doesn't need to be secret. Never reuse a nonce with the same key."
                }
            },
            {
                "@type": "Question",
                "name": "Is this compatible with PyNaCl and libsodium?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, this tool uses the same XSalsa20-Poly1305 algorithm as PyNaCl's SecretBox, libsodium's crypto_secretbox, and NaCl's secretbox. Output can be decrypted using any compatible library."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between NaCl and libsodium?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Libsodium is a portable, cross-platform fork of NaCl with the same API. While NaCl (by Daniel J. Bernstein) is the original, libsodium adds better packaging, additional algorithms, and wider platform support. Both use the same crypto_secretbox implementation."
                }
            },
            {
                "@type": "Question",
                "name": "How does Poly1305 authentication work?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Poly1305 is a one-time authenticator that creates a 16-byte MAC (message authentication code). The first 32 bytes of XSalsa20 keystream are used as the Poly1305 key. Any modification to the ciphertext will cause authentication to fail during decryption."
                }
            }
        ]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt with Libsodium SecretBox Online",
        "description": "Step-by-step guide to encrypt messages using XSalsa20-Poly1305 authenticated encryption",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter your message",
                "text": "Type or paste the plaintext message you want to encrypt"
            },
            {
                "@type": "HowToStep",
                "name": "Set the secret key",
                "text": "Enter a 32-character secret key (or use the default for testing)"
            },
            {
                "@type": "HowToStep",
                "name": "Generate nonce",
                "text": "Use a unique nonce for each encryption (auto-generated or custom)"
            },
            {
                "@type": "HowToStep",
                "name": "Encrypt",
                "text": "Click Encrypt to get the authenticated ciphertext in hex format"
            }
        ]
    }
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online libsodium secretbox encryption tool. Encrypt & decrypt with crypto_secretbox using XSalsa20-Poly1305. Compatible with NaCl, PyNaCl, sodium libraries. No installation required.">
    <meta name="keywords" content="libsodium secretbox online, crypto_secretbox tool, XSalsa20-Poly1305 encryption, NaCl secretbox, libsodium encryption online, Salsa20 Poly1305, PyNaCl SecretBox, authenticated encryption tool, nacl crypto online, secret key encryption, libsodium online generator">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">

    <!-- Open Graph -->
    <meta property="og:title" content="Libsodium SecretBox Online - crypto_secretbox XSalsa20-Poly1305 Tool">
    <meta property="og:description" content="Free online tool for libsodium secretbox encryption. Compatible with NaCl, PyNaCl, and sodium libraries. Encrypt messages with XSalsa20-Poly1305.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/naclaead.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/nacl2.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Libsodium SecretBox Online - XSalsa20-Poly1305 Encryption">
    <meta name="twitter:description" content="Free online crypto_secretbox tool. Encrypt with NaCl/libsodium XSalsa20-Poly1305 authenticated encryption.">
    <meta name="twitter:creator" content="@anish2good">

    <%@ include file="header-script.jsp"%>

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

        .form-control:focus {
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
    </style>
</head>

<%@ include file="body-script.jsp"%>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1>Libsodium SecretBox Online Tool</h1>
        <p>NaCl crypto_secretbox - XSalsa20-Poly1305 Authenticated Encryption</p>
        <div>
            <span class="info-badge">crypto_secretbox</span>
            <span class="info-badge">XSalsa20-Poly1305</span>
            <span class="info-badge">PyNaCl Compatible</span>
        </div>
        <div class="eeat-badge">
            Created by <a href="https://twitter.com/anish2good" class="text-white" style="text-decoration: underline;">@anish2good</a> - Cryptography Engineer
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <!-- Input Column -->
        <div class="col-lg-5 mb-4">
            <form id="form" method="POST">
                <input type="hidden" name="methodName" id="methodName" value="AEAD_MESSAGE">

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
                        <input type="hidden" name="encryptorDecrypt" id="encryptorDecrypt" value="encrypt">
                    </div>
                </div>

                <!-- Message Input -->
                <div class="card">
                    <div class="card-header">Message</div>
                    <div class="card-body">
                        <textarea class="form-control" rows="4" name="plaintext" id="plaintext" placeholder="Enter your message to encrypt or decrypt..."></textarea>
                    </div>
                </div>

                <!-- AEAD (Additional Authenticated Data) -->
                <div class="card">
                    <div class="card-header">Additional Authenticated Data (AAD)</div>
                    <div class="card-body">
                        <input type="text" class="form-control" name="aead" id="aead" placeholder="Enter additional data to authenticate..." value="Non Encrypted data">
                        <small class="text-muted mt-2 d-block">This data is authenticated but NOT encrypted. Use for headers or metadata.</small>
                    </div>
                </div>

                <!-- Key & Nonce (Collapsible) -->
                <%
                    String hex = Utils.toHexEncoded(Utils.getIV(8));
                %>
                <div class="card">
                    <div class="card-header key-toggle" data-toggle="collapse" data-target="#keySection">
                        Secret Key & Nonce
                        <span class="float-end">
                            <small class="text-muted">click to expand</small>
                        </span>
                    </div>
                    <div id="keySection" class="collapse">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Secret Key (32 characters)</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" name="secretkey" id="secretkey" placeholder="Enter 32-character secret key" value="thisismystrongpasswordof32bitkey">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleKeyVisibility()">Show</button>
                                </div>
                            </div>
                            <div class="mb-0">
                                <label class="form-label fw-semibold">Nonce (Hex)</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" name="nonce" id="nonce" placeholder="Public nonce in hex" value="<%=hex%>">
                                    <button class="btn btn-outline-secondary" type="button" onclick="generateNonce()">Generate</button>
                                </div>
                                <small class="text-muted">8-byte nonce in hexadecimal format</small>
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
                    <div class="card-header">About crypto_secretbox (XSalsa20-Poly1305)</div>
                    <div class="card-body">
                        <p class="mb-2"><strong>Libsodium's crypto_secretbox</strong> is the same as NaCl's secretbox - authenticated encryption in one function.</p>
                        <ul class="mb-0 small">
                            <li><strong>XSalsa20:</strong> Extended-nonce Salsa20 stream cipher (192-bit nonce)</li>
                            <li><strong>Poly1305:</strong> One-time MAC for authentication (16-byte tag)</li>
                            <li><strong>32-byte key:</strong> 256-bit secret key for encryption</li>
                            <li><strong>Compatible:</strong> Works with PyNaCl, libsodium, TweetNaCl</li>
                        </ul>
                    </div>
                </div>

                <!-- Related Tools -->
                <div class="card related-tools-card">
                    <div class="card-header">Related NaCl Tools</div>
                    <div class="card-body">
                        <a href="naclencdec.jsp" class="related-tool-link">NaCl XSalsa20 Encryption</a>
                        <a href="naclaead.jsp" class="related-tool-link active">NaCl AEAD Encryption (This Tool)</a>
                        <a href="naclboxenc.jsp" class="related-tool-link">NaCl Box Encryption</a>
                        <a href="naclsealboxenc.jsp" class="related-tool-link">NaCl SealedBox Encryption</a>
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
    <div class="row mt-4">
        <div class="col-12">
            <h2 class="h4 mb-3">Libsodium crypto_secretbox: Secret-key Authenticated Encryption</h2>
            <p>The <code>crypto_secretbox</code> function (also known as <strong>secretbox</strong> in NaCl) encrypts and authenticates a message using a single secret key and a nonce. It combines XSalsa20 encryption with Poly1305 authentication in a single operation.</p>

            <h3 class="h5 mt-4">Key Parameters</h3>
            <ul>
                <li><strong>Key size:</strong> 32 bytes (256 bits) - <code>crypto_secretbox_KEYBYTES</code></li>
                <li><strong>Nonce size:</strong> 24 bytes (192 bits) - <code>crypto_secretbox_NONCEBYTES</code></li>
                <li><strong>MAC size:</strong> 16 bytes (128 bits) - Poly1305 authentication tag</li>
            </ul>

            <h3 class="h5 mt-4">Library Compatibility</h3>
            <p>This tool produces output compatible with:</p>
            <ul>
                <li><strong>PyNaCl:</strong> <code>nacl.secret.SecretBox</code></li>
                <li><strong>libsodium:</strong> <code>crypto_secretbox_easy()</code></li>
                <li><strong>TweetNaCl.js:</strong> <code>nacl.secretbox()</code></li>
                <li><strong>Go:</strong> <code>golang.org/x/crypto/nacl/secretbox</code></li>
            </ul>

            <h3 class="h5 mt-4">Security Notes</h3>
            <p>The nonce must be unique for each message encrypted with the same key. Never reuse a nonce - this would compromise security. The nonce doesn't need to be secret, only unique.</p>

            <h2 class="h4 mt-4 mb-3"><a href="https://8gwifi.org/docs/go-nacl.jsp" class="text-decoration-none" style="color: var(--theme-color);">Learn more about NaCl Cryptography</a></h2>
        </div>
    </div>

    <%-- Common NaCl Information Section --%>
    <%@ include file="nacl-info.jsp"%>

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
                <div class="alert alert-warning mb-0" id="shareWarning" style="display: none;">
                    <strong>Note:</strong> The secret key is included in this URL. Only share with trusted recipients!
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
        document.getElementById('encryptorDecrypt').value = mode;
        document.getElementById('encryptBtn').classList.toggle('active', mode === 'encrypt');
        document.getElementById('decryptBtn').classList.toggle('active', mode === 'decrypt');
        document.getElementById('submitBtnText').textContent = mode === 'encrypt' ? 'Encrypt Message' : 'Decrypt Message';
    }

    function toggleKeyVisibility() {
        var keyInput = document.getElementById('secretkey');
        var btn = event.target;
        if (keyInput.type === 'password') {
            keyInput.type = 'text';
            btn.textContent = 'Hide';
        } else {
            keyInput.type = 'password';
            btn.textContent = 'Show';
        }
    }

    function generateNonce() {
        var hex = '';
        for (var i = 0; i < 16; i++) {
            hex += Math.floor(Math.random() * 16).toString(16);
        }
        document.getElementById('nonce').value = hex;
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

            var html = '<div class="mb-3"><div class="result-label">Algorithm</div><div class="result-value">' + data.algorithm + '</div></div>';

            if (data.operation === 'encrypt') {
                html += '<div class="mb-3"><div class="result-label">Ciphertext (Hex)</div><div class="result-value">' + data.ciphertext + '</div></div>';
            } else {
                html += '<div class="mb-3"><div class="result-label">Plaintext</div><div class="result-value">' + data.plaintext + '</div></div>';
            }

            if (data.nonce) {
                html += '<div class="mb-3"><div class="result-label">Nonce</div><div class="result-value">' + data.nonce + '</div></div>';
            }

            if (data.aead) {
                html += '<div class="mb-0"><div class="result-label">Additional Authenticated Data</div><div class="result-value">' + data.aead + '</div></div>';
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
        var filename = 'nacl-aead-' + currentResult.operation + '-result.txt';
        var blob = new Blob([text], { type: 'text/plain' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.click();
        URL.revokeObjectURL(url);
    }

    function openShareModal() {
        var params = {
            mode: currentOperation,
            nonce: document.getElementById('nonce').value,
            aead: document.getElementById('aead').value,
            key: document.getElementById('secretkey').value
        };

        if (currentResult && currentResult.success) {
            if (currentOperation === 'encrypt') {
                params.ciphertext = currentResult.ciphertext;
            } else {
                params.plaintext = document.getElementById('plaintext').value;
            }
        }

        var shareUrl = window.location.origin + window.location.pathname + '?data=' + btoa(JSON.stringify(params));
        document.getElementById('shareUrl').value = shareUrl;
        document.getElementById('shareWarning').style.display = 'block';

        var tweetText = 'Check out this NaCl AEAD encryption tool! XSalsa20-Poly1305 authenticated encryption with associated data. @anish2good';
        document.getElementById('tweetBtn').href = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText) + '&url=' + encodeURIComponent('https://8gwifi.org/naclaead.jsp');

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
                if (params.nonce) document.getElementById('nonce').value = params.nonce;
                if (params.aead) document.getElementById('aead').value = params.aead;
                if (params.key) document.getElementById('secretkey').value = params.key;
                if (params.ciphertext) document.getElementById('plaintext').value = params.ciphertext;
                if (params.plaintext) document.getElementById('plaintext').value = params.plaintext;
            } catch (e) {
                console.error('Failed to parse URL data');
            }
        }
    }

    $(document).ready(function() {
        loadFromUrl();

        $('#form').submit(function(event) {
            event.preventDefault();
            $('#output').html('<div class="text-center py-3"><div class="spinner-border text-primary" role="status"></div><div class="mt-2">Processing...</div></div>');
            document.getElementById('resultCard').style.display = 'block';
            document.getElementById('actionButtons').style.display = 'none';

            $.ajax({
                type: "POST",
                url: "NaclFunctionality",
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
