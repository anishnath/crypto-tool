<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>NaCl Box Encryption & Decryption (Curve25519-XSalsa20-Poly1305) - Public Key Crypto Tool</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "NaCl Box Public Key Encryption Tool",
        "description": "Free online tool for NaCl Box public-key authenticated encryption using Curve25519-XSalsa20-Poly1305 (crypto_box). Encrypt and decrypt messages between two parties with key exchange.",
        "url": "https://8gwifi.org/naclboxenc.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Curve25519 key exchange",
            "XSalsa20-Poly1305 authenticated encryption",
            "Public-key cryptography",
            "Real-time encryption/decryption",
            "Hex-encoded key support"
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
                "name": "What is NaCl Box encryption?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "NaCl Box (crypto_box) provides public-key authenticated encryption using Curve25519 for key exchange, XSalsa20 for encryption, and Poly1305 for authentication. It allows two parties to securely exchange encrypted messages."
                }
            },
            {
                "@type": "Question",
                "name": "How does crypto_box work?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "crypto_box uses the sender's private key and receiver's public key to derive a shared secret via Curve25519 Diffie-Hellman. This shared secret encrypts the message with XSalsa20 and authenticates it with Poly1305."
                }
            },
            {
                "@type": "Question",
                "name": "What key sizes does NaCl Box use?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "NaCl Box uses 32-byte (256-bit) keys for both public and private keys. The nonce must be 24 bytes (192 bits) and should be unique for each message."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between Box and SealedBox?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Box requires both sender and receiver keys and a nonce, providing mutual authentication. SealedBox only requires the receiver's public key and generates an ephemeral key pair, providing anonymous sender encryption."
                }
            }
        ]
    }
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online NaCl Box encryption and decryption tool using Curve25519-XSalsa20-Poly1305 (crypto_box). Public-key authenticated encryption for secure message exchange between two parties.">
    <meta name="keywords" content="NaCl Box, crypto_box, Curve25519, XSalsa20-Poly1305, public key encryption, libsodium box, authenticated encryption, key exchange, NaCl online, asymmetric encryption">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">

    <!-- Open Graph -->
    <meta property="og:title" content="NaCl Box Encryption & Decryption - Curve25519-XSalsa20-Poly1305 Tool">
    <meta property="og:description" content="Public-key authenticated encryption using NaCl Box (crypto_box). Secure message exchange with Curve25519 key exchange.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/naclboxenc.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/nacl3.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="NaCl Box Encryption Tool - Public Key Cryptography">
    <meta name="twitter:description" content="Free online public-key authenticated encryption with NaCl Box (crypto_box).">
    <meta name="twitter:creator" content="@anish2good">

    <%@ include file="header-script.jsp"%>

    <%
        String pubKey = Utils.toHexEncoded(Utils.getIV(32));
        String privKey = Utils.toHexEncoded(Utils.getIV(32));
        String hex = Utils.toHexEncoded(Utils.getIV(24));
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

        .key-card {
            background: #fefce8;
            border: 1px solid #fef08a;
        }

        .key-card.private {
            background: #fef2f2;
            border: 1px solid #fecaca;
        }

        .key-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .key-label.public {
            color: #ca8a04;
        }

        .key-label.private {
            color: #dc2626;
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
        <h1>NaCl Box Public Key Encryption</h1>
        <p>Curve25519-XSalsa20-Poly1305 public-key authenticated encryption (crypto_box)</p>
        <div>
            <span class="info-badge">Curve25519</span>
            <span class="info-badge">XSalsa20-Poly1305</span>
            <span class="info-badge">32-byte Keys</span>
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
                <input type="hidden" name="methodName" id="methodName" value="NACL_BOX_ENCRYPT">

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
                        <textarea class="form-control" rows="4" name="message" id="message" placeholder="Enter your message to encrypt or decrypt..."></textarea>
                    </div>
                </div>

                <!-- Keys (Collapsible) -->
                <div class="card">
                    <div class="card-header key-toggle" data-bs-toggle="collapse" data-bs-target="#keySection">
                        Public & Private Keys
                        <span class="float-end">
                            <small class="text-muted">click to expand</small>
                        </span>
                    </div>
                    <div id="keySection" class="collapse">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="key-label public">Recipient's Public Key (32 bytes hex)</div>
                                <textarea class="form-control" rows="2" name="publickeyparam" id="publickeyparam" placeholder="Enter recipient's public key in hex"><%= pubKey %></textarea>
                                <small class="text-muted">Used for encryption</small>
                            </div>
                            <div class="mb-3">
                                <div class="key-label private">Sender's Private Key (32 bytes hex)</div>
                                <textarea class="form-control" rows="2" name="privatekeyparam" id="privatekeyparam" placeholder="Enter sender's private key in hex"><%= privKey %></textarea>
                                <small class="text-muted">Used for signing/authentication</small>
                            </div>
                            <div class="mb-0">
                                <label class="form-label fw-semibold">Nonce (24 bytes hex)</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" name="nonce" id="nonce" placeholder="48-character nonce in hex" value="<%=hex%>">
                                    <button class="btn btn-outline-secondary" type="button" onclick="generateNonce()">Generate</button>
                                </div>
                                <small class="text-muted">Must be unique for each message</small>
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
                    <div class="card-header">About NaCl Box (crypto_box)</div>
                    <div class="card-body">
                        <p class="mb-2"><strong>crypto_box</strong> combines Curve25519 ECDH with XSalsa20-Poly1305 for public-key authenticated encryption.</p>
                        <ul class="mb-0 small">
                            <li><strong>Curve25519:</strong> Elliptic curve Diffie-Hellman key exchange</li>
                            <li><strong>XSalsa20:</strong> Stream cipher for encryption</li>
                            <li><strong>Poly1305:</strong> Message authentication code (MAC)</li>
                            <li>Provides confidentiality, integrity, and authentication</li>
                        </ul>
                    </div>
                </div>

                <!-- Related Tools -->
                <div class="card related-tools-card">
                    <div class="card-header">Related NaCl Tools</div>
                    <div class="card-body">
                        <a href="naclencdec.jsp" class="related-tool-link">NaCl XSalsa20 Encryption</a>
                        <a href="naclaead.jsp" class="related-tool-link">NaCl AEAD Encryption</a>
                        <a href="naclboxenc.jsp" class="related-tool-link active">NaCl Box Encryption (This Tool)</a>
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
            <h2 class="h4 mb-3">Public-key Authenticated Encryption: crypto_box</h2>
            <p>The <code>crypto_box_keypair</code> function randomly generates a secret key and a corresponding public key. It puts the secret key into sk and returns the public key.</p>
            <p>The <code>crypto_box</code> function encrypts and authenticates a message using the sender's secret key, the receiver's public key, and a nonce. The function returns the resulting ciphertext.</p>
            <p>The <code>crypto_box_open</code> function verifies and decrypts a ciphertext using the receiver's secret key, the sender's public key, and a nonce. The function returns the resulting plaintext.</p>

            <h2 class="h4 mt-4 mb-3">How to Perform NaCl Cryptography</h2>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th><a href="/docs/go-nacl.jsp">Go Lang Tutorial</a></th>
                    </tr>
                </thead>
            </table>
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
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
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
                <div class="alert alert-danger mb-0" id="shareWarning" style="display: none;">
                    <strong>Warning:</strong> Private key is included in this URL. Only share with trusted recipients who need to decrypt!
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

    function generateNonce() {
        var hex = '';
        for (var i = 0; i < 48; i++) {
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
                html += '<div class="mb-0"><div class="result-label">Nonce</div><div class="result-value">' + data.nonce + '</div></div>';
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
        var filename = 'nacl-box-' + currentResult.operation + '-result.txt';
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
            pubkey: document.getElementById('publickeyparam').value,
            privkey: document.getElementById('privatekeyparam').value
        };

        if (currentResult && currentResult.success) {
            if (currentOperation === 'encrypt') {
                params.ciphertext = currentResult.ciphertext;
            } else {
                params.plaintext = document.getElementById('message').value;
            }
        }

        var shareUrl = window.location.origin + window.location.pathname + '?data=' + btoa(JSON.stringify(params));
        document.getElementById('shareUrl').value = shareUrl;
        document.getElementById('shareWarning').style.display = 'block';

        var tweetText = 'Check out this NaCl Box encryption tool! Curve25519-XSalsa20-Poly1305 public-key authenticated encryption. @anish2good';
        document.getElementById('tweetBtn').href = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText) + '&url=' + encodeURIComponent('https://8gwifi.org/naclboxenc.jsp');

        new bootstrap.Modal(document.getElementById('shareModal')).show();
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
                if (params.pubkey) document.getElementById('publickeyparam').value = params.pubkey;
                if (params.privkey) document.getElementById('privatekeyparam').value = params.privkey;
                if (params.ciphertext) document.getElementById('message').value = params.ciphertext;
                if (params.plaintext) document.getElementById('message').value = params.plaintext;
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
