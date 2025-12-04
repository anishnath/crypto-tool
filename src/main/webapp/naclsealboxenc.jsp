<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>NaCl SealedBox Encryption & Decryption (X25519-XSalsa20-Poly1305) - Anonymous Encryption Tool</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "NaCl SealedBox Anonymous Encryption Tool",
        "description": "Free online tool for NaCl SealedBox anonymous encryption using X25519-XSalsa20-Poly1305. Send encrypted messages anonymously with only the recipient's public key.",
        "url": "https://8gwifi.org/naclsealboxenc.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Anonymous sender encryption",
            "X25519 ephemeral key exchange",
            "XSalsa20-Poly1305 authenticated encryption",
            "No nonce required",
            "Recipient-only decryption"
        ],
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://twitter.com/anish2good"
        },
        "datePublished": "2018-12-20",
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
                "name": "What is NaCl SealedBox encryption?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "NaCl SealedBox provides anonymous encryption where the sender's identity is hidden. It uses an ephemeral key pair so only the recipient can decrypt the message, but cannot identify who sent it."
                }
            },
            {
                "@type": "Question",
                "name": "How does SealedBox differ from Box?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Box provides mutual authentication - both sender and recipient are identified. SealedBox provides anonymous sending - the recipient can verify integrity but not sender identity. SealedBox also doesn't require a nonce."
                }
            },
            {
                "@type": "Question",
                "name": "When should I use SealedBox?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Use SealedBox when you need anonymous submissions like anonymous tip lines, feedback systems, or when sender anonymity is required. Use Box when sender authentication is needed."
                }
            },
            {
                "@type": "Question",
                "name": "Why doesn't SealedBox need a nonce?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "SealedBox generates a fresh ephemeral key pair for each message. The nonce is derived from the ephemeral public key and recipient's public key, ensuring uniqueness without manual nonce management."
                }
            }
        ]
    }
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online NaCl SealedBox encryption tool for anonymous message encryption. Send encrypted messages using only the recipient's public key with X25519-XSalsa20-Poly1305.">
    <meta name="keywords" content="NaCl SealedBox, anonymous encryption, X25519, XSalsa20-Poly1305, crypto_box_seal, libsodium sealed box, anonymous messaging, public key encryption, ephemeral keys, NaCl online">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">

    <!-- Open Graph -->
    <meta property="og:title" content="NaCl SealedBox Encryption - Anonymous Public Key Encryption Tool">
    <meta property="og:description" content="Anonymous encryption using NaCl SealedBox. Send encrypted messages without revealing sender identity.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/naclsealboxenc.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/nacl4.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="NaCl SealedBox - Anonymous Encryption Tool">
    <meta name="twitter:description" content="Free online anonymous encryption with NaCl SealedBox (crypto_box_seal).">
    <meta name="twitter:creator" content="@anish2good">

    <%@ include file="header-script.jsp"%>

    <%
        String pubKey = "2bfb3554e563470f076d91b2dfbc58944ac0aea4d0ee9ec80ce2df22398bb545";
        String privKey = "6cf6a2fb7faf47aa2cbd090ba2f2cfd81cce75ed7fa41f4dc88bd7d3a2374643";
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

        .anonymous-badge {
            background: #fef3c7;
            color: #92400e;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            display: inline-block;
            margin-top: 0.5rem;
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
        <h1>NaCl SealedBox Anonymous Encryption</h1>
        <p>X25519-XSalsa20-Poly1305 anonymous public-key encryption (crypto_box_seal)</p>
        <div>
            <span class="info-badge">X25519</span>
            <span class="info-badge">XSalsa20-Poly1305</span>
            <span class="info-badge">No Nonce Required</span>
        </div>
        <div class="anonymous-badge">
            Anonymous Sender - Recipient cannot identify who sent the message
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
                <input type="hidden" name="methodName" id="methodName" value="NACL_SEALBOX_ENCRYPT">

                <!-- Mode Selection -->
                <div class="card">
                    <div class="card-header">Operation Mode</div>
                    <div class="card-body">
                        <div class="mode-toggle">
                            <button type="button" class="btn btn-outline-secondary active" id="encryptBtn" onclick="setMode('encrypt')">
                                Encrypt (Seal)
                            </button>
                            <button type="button" class="btn btn-outline-secondary" id="decryptBtn" onclick="setMode('decrypt')">
                                Decrypt (Open)
                            </button>
                        </div>
                        <input type="hidden" name="encryptdecryptparameter" id="encryptdecryptparameter" value="encrypt">
                        <small class="text-muted" id="modeHint">Only recipient's public key needed for encryption</small>
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
                    <div class="card-header key-toggle" data-toggle="collapse" data-target="#keySection">
                        Recipient's Keys
                        <span class="float-end">
                            <small class="text-muted">click to expand</small>
                        </span>
                    </div>
                    <div id="keySection" class="collapse">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="key-label public">Recipient's Public Key (32 bytes hex)</div>
                                <textarea class="form-control" rows="2" name="publickeyparam" id="publickeyparam" placeholder="Enter recipient's public key in hex"><%= pubKey %></textarea>
                                <small class="text-muted">Required for encryption</small>
                            </div>
                            <div class="mb-0" id="privateKeySection">
                                <div class="key-label private">Recipient's Private Key (32 bytes hex)</div>
                                <textarea class="form-control" rows="2" name="privatekeyparam" id="privatekeyparam" placeholder="Enter recipient's private key in hex"><%= privKey %></textarea>
                                <small class="text-muted">Required only for decryption</small>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-theme btn-lg w-100">
                    <span id="submitBtnText">Encrypt Message (Seal)</span>
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
                    <div class="card-header">About NaCl SealedBox (crypto_box_seal)</div>
                    <div class="card-body">
                        <p class="mb-2"><strong>SealedBox</strong> provides anonymous encryption using ephemeral keys.</p>
                        <ul class="mb-0 small">
                            <li><strong>Anonymous:</strong> Recipient cannot identify the sender</li>
                            <li><strong>Ephemeral keys:</strong> Fresh key pair generated per message</li>
                            <li><strong>No nonce:</strong> Nonce derived from keys automatically</li>
                            <li><strong>Integrity:</strong> Message tampering is detected</li>
                        </ul>
                    </div>
                </div>

                <!-- Use Case Info -->
                <div class="card">
                    <div class="card-header">Box vs SealedBox</div>
                    <div class="card-body small">
                        <p class="mb-2"><strong>Box:</strong> Alice and Bob know each other. Bob can verify the message came from Alice.</p>
                        <p class="mb-0"><strong>SealedBox:</strong> Bob has an anonymous dropbox. Anyone can send Bob a message, but Bob cannot identify the sender - it could be Alice, Charlie, or anyone.</p>
                    </div>
                </div>

                <!-- Related Tools -->
                <div class="card related-tools-card">
                    <div class="card-header">Related NaCl Tools</div>
                    <div class="card-body">
                        <a href="naclencdec.jsp" class="related-tool-link">NaCl XSalsa20 Encryption</a>
                        <a href="naclaead.jsp" class="related-tool-link">NaCl AEAD Encryption</a>
                        <a href="naclboxenc.jsp" class="related-tool-link">NaCl Box Encryption</a>
                        <a href="naclsealboxenc.jsp" class="related-tool-link active">NaCl SealedBox Encryption (This Tool)</a>
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
            <h2 class="h4 mb-3">Anonymous Encryption: crypto_box_seal</h2>
            <p>Sealed boxes leverage the crypto_box construction (X25519, XSalsa20-Poly1305) but with anonymous sender functionality.</p>
            <p>The premise of <strong>boxes</strong> is that Alice and Bob know each other. Alice can use a box to send a message to Bob. On receipt, Bob knows (a) it came from Alice, and (b) nobody else could have read or tampered with it.</p>
            <p>The premise of <strong>sealed boxes</strong> is that Bob has an anonymous dropbox. Alice can use a sealed box to send a message to Bob. On receipt, Bob knows nobody but the sender could have read or tampered with it. But he knows nothing about who the sender was - it could have been Alice, Charlie, or Dominique.</p>

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
        document.getElementById('submitBtnText').textContent = mode === 'encrypt' ? 'Encrypt Message (Seal)' : 'Decrypt Message (Open)';
        document.getElementById('modeHint').textContent = mode === 'encrypt'
            ? "Only recipient's public key needed for encryption"
            : "Both public and private keys needed for decryption";
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
            resultTitle.textContent = data.operation === 'encrypt' ? 'Sealed Message' : 'Decryption Result';

            var html = '<div class="mb-3"><div class="result-label">Algorithm</div><div class="result-value">' + data.algorithm + '</div></div>';

            if (data.operation === 'encrypt') {
                html += '<div class="mb-0"><div class="result-label">Sealed Ciphertext (Hex)</div><div class="result-value">' + data.ciphertext + '</div></div>';
            } else {
                html += '<div class="mb-0"><div class="result-label">Plaintext</div><div class="result-value">' + data.plaintext + '</div></div>';
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
        var filename = 'nacl-sealedbox-' + currentResult.operation + '-result.txt';
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
            pubkey: document.getElementById('publickeyparam').value
        };

        // Only include private key for decrypt mode
        if (currentOperation === 'decrypt') {
            params.privkey = document.getElementById('privatekeyparam').value;
        }

        if (currentResult && currentResult.success) {
            if (currentOperation === 'encrypt') {
                params.ciphertext = currentResult.ciphertext;
            } else {
                params.plaintext = document.getElementById('message').value;
            }
        }

        var shareUrl = window.location.origin + window.location.pathname + '?data=' + btoa(JSON.stringify(params));
        document.getElementById('shareUrl').value = shareUrl;

        // Show warning only if private key is included
        document.getElementById('shareWarning').style.display = currentOperation === 'decrypt' ? 'block' : 'none';

        var tweetText = 'Check out this NaCl SealedBox encryption tool! Anonymous public-key encryption for secure messaging. @anish2good';
        document.getElementById('tweetBtn').href = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText) + '&url=' + encodeURIComponent('https://8gwifi.org/naclsealboxenc.jsp');

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
