<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>Extract Public Key from Private Key Online - RSA, DSA, EC Free | 8gwifi.org</title>
    <meta charset="UTF-8">
    <meta name="description" content="Extract public key from private key online. Supports RSA, DSA, and EC (Elliptic Curve) private keys in PEM format. Free tool with OpenSSL equivalent commands.">
    <meta name="keywords" content="extract public key from private key, openssl public key from private key, rsa private key to public key, ec public key extract, dsa public key extract, pem public key extractor">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>

    <!-- Enhanced JSON-LD Structured Data -->
    <script type="application/ld+json">
    [
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Extract Public Key from Private Key",
            "description": "Online tool to extract public key from RSA, DSA, or EC private keys in PEM format",
            "url": "https://8gwifi.org/pempublic.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "featureList": [
                "RSA public key extraction",
                "DSA public key extraction",
                "EC/ECDSA public key extraction",
                "Encrypted private key support",
                "PEM format output"
            ]
        },
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Extract Public Key from Private Key",
            "description": "Extract the public key component from an RSA, DSA, or EC private key",
            "step": [
                {
                    "@type": "HowToStep",
                    "position": 1,
                    "name": "Paste Private Key",
                    "text": "Paste your private key in PEM format into the input field"
                },
                {
                    "@type": "HowToStep",
                    "position": 2,
                    "name": "Enter Password (if encrypted)",
                    "text": "If your private key is encrypted, enter the password"
                },
                {
                    "@type": "HowToStep",
                    "position": 3,
                    "name": "Extract Public Key",
                    "text": "Click Extract Public Key to get the public key in PEM format"
                }
            ]
        },
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "Can I extract a public key from any private key?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes, every asymmetric private key (RSA, DSA, EC) contains the mathematical components needed to derive its corresponding public key. This tool supports RSA, DSA, and Elliptic Curve private keys in PEM format."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What if my private key is encrypted?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "If your private key is encrypted (contains 'ENCRYPTED' in the header), enter the decryption password in the password field. The tool will decrypt it first, then extract the public key."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What is the OpenSSL command to extract public key?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "For RSA: openssl rsa -in private.pem -pubout -out public.pem. For EC: openssl ec -in private.pem -pubout -out public.pem. For DSA: openssl dsa -in private.pem -pubout -out public.pem"
                    }
                }
            ]
        }
    ]
    </script>

    <style>
        .key-type-badge {
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 500;
        }
        .command-box {
            background: #1e1e1e;
            color: #d4d4d4;
            border-radius: 8px;
            padding: 12px 16px;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
            margin: 8px 0;
            position: relative;
        }
        .command-box code {
            color: #9cdcfe;
        }
        .command-box .cmd-prefix {
            color: #6a9955;
        }
        .copy-cmd-btn {
            position: absolute;
            right: 8px;
            top: 8px;
            font-size: 0.75rem;
            padding: 2px 8px;
        }
        .algo-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .algo-card:hover {
            transform: translateX(4px);
        }
        .algo-card.rsa { border-left-color: #007bff; }
        .algo-card.dsa { border-left-color: #28a745; }
        .algo-card.ec { border-left-color: #6f42c1; }
        .result-placeholder {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            background: #f8f9fa;
        }
        .related-tool-card {
            transition: all 0.2s ease;
            border: 1px solid #e9ecef;
        }
        .related-tool-card:hover {
            border-color: #007bff;
            box-shadow: 0 4px 12px rgba(0,123,255,0.15);
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function() {
            var typingTimer;
            var doneTypingInterval = 500;

            $('#pem').on('keyup', function() {
                clearTimeout(typingTimer);
                typingTimer = setTimeout(function() {
                    $('#form').submit();
                }, doneTypingInterval);
            });

            $('#form').submit(function(event) {
                event.preventDefault();
                $('#result-placeholder').hide();
                $('#output').html('<div class="text-center py-4"><img src="images/712.GIF" alt="Loading..."><p class="mt-2 text-muted">Extracting public key...</p></div>');

                $.ajax({
                    type: "POST",
                    url: "CipherFunctionality",
                    data: $("#form").serialize(),
                    dataType: "json",
                    success: function(response) {
                        if (response.success) {
                            displayPublicKey(response);
                        } else {
                            $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ' + escapeHtml(response.errorMessage) + '</div>');
                        }
                    },
                    error: function() {
                        $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Error processing request. Please try again.</div>');
                    }
                });
            });

            function displayPublicKey(data) {
                var keyTypeClass = 'primary';
                var keyTypeIcon = 'fa-key';
                if (data.algorithm === 'RSA') {
                    keyTypeClass = 'primary';
                } else if (data.algorithm === 'EC') {
                    keyTypeClass = 'purple';
                } else if (data.algorithm === 'DSA') {
                    keyTypeClass = 'success';
                }

                var html = '<div class="card shadow-sm mb-4">';
                html += '<div class="card-header bg-success text-white d-flex justify-content-between align-items-center">';
                html += '<span><i class="fas fa-check-circle"></i> Public Key Extracted Successfully</span>';
                html += '<span class="badge badge-light">' + escapeHtml(data.algorithm) + '</span>';
                html += '</div>';
                html += '<div class="card-body">';

                // Public Key textarea
                html += '<div class="form-group">';
                html += '<label><i class="fas fa-unlock"></i> Public Key (PEM Format)</label>';
                html += '<div class="position-relative">';
                html += '<textarea class="form-control" id="publicKeyOutput" rows="12" readonly style="font-family: monospace; font-size: 0.85rem;">' + escapeHtml(data.publicKey) + '</textarea>';
                html += '<button class="btn btn-sm btn-outline-secondary position-absolute" style="top: 8px; right: 8px;" onclick="copyPublicKey()"><i class="fas fa-copy"></i> Copy</button>';
                html += '</div>';
                html += '</div>';

                // Action buttons
                html += '<div class="d-flex flex-wrap gap-2" style="gap: 8px;">';
                html += '<button class="btn btn-primary" onclick="downloadPublicKey()"><i class="fas fa-download"></i> Download .pem</button>';
                html += '<a href="PemParserFunctions.jsp?pem=' + encodeURIComponent(data.publicKey) + '" target="_blank" class="btn btn-outline-primary"><i class="fas fa-search"></i> Parse Public Key</a>';
                html += '</div>';

                html += '</div></div>';

                $('#output').html(html);
            }

            function escapeHtml(text) {
                if (!text) return '';
                var div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            // Copy command to clipboard
            $(document).on('click', '.copy-cmd-btn', function() {
                var cmd = $(this).data('cmd');
                navigator.clipboard.writeText(cmd).then(function() {
                    var btn = event.target;
                    var original = btn.innerHTML;
                    btn.innerHTML = 'Copied!';
                    setTimeout(function() { btn.innerHTML = original; }, 1500);
                });
            });
        });

        var lastPublicKey = '';

        function copyPublicKey() {
            var textarea = document.getElementById('publicKeyOutput');
            textarea.select();
            document.execCommand('copy');

            var btn = event.target.closest('button');
            var original = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
            setTimeout(function() { btn.innerHTML = original; }, 2000);
        }

        function downloadPublicKey() {
            var publicKey = document.getElementById('publicKeyOutput').value;
            var blob = new Blob([publicKey], { type: 'text/plain' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = 'public_key.pem';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="container-fluid">
    <h1 class="mt-4">Extract Public Key from Private Key</h1>
    <p class="lead">Derive the public key from RSA, DSA, or EC private keys in PEM format</p>

    <!-- EEAT: Author & Trust Signals -->
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
        <div class="text-muted small">
            <i class="fas fa-user-shield"></i> <strong>By Anish Nath</strong> - Security Engineer
            <span class="mx-2">|</span>
            <a href="https://x.com/anish2good" target="_blank" rel="noopener" class="text-decoration-none">
                <i class="fab fa-x-twitter"></i> @anish2good
            </a>
        </div>
        <div>
            <span class="badge badge-success"><i class="fas fa-shield-alt"></i> Privacy-First</span>
            <span class="badge badge-info"><i class="fas fa-lock"></i> No Data Stored</span>
        </div>
    </div>

    <div class="row">
        <!-- Left Column - Input -->
        <div class="col-lg-5">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <i class="fas fa-key"></i> Private Key Input
                </div>
                <div class="card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" value="EXTRACT_PUBLICKEY">

                        <div class="form-group">
                            <label for="pem">
                                <i class="fas fa-file-code"></i> PEM Private Key
                                <span class="badge badge-secondary ml-2">RSA / DSA / EC</span>
                            </label>
                            <textarea class="form-control" name="pem" id="pem" rows="14" placeholder="-----BEGIN RSA PRIVATE KEY-----
Paste your private key here...
-----END RSA PRIVATE KEY-----">-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAk9zv6gtOlFLueEhjN4WcunNIqVyMQsY6kt0Rheau/lBTMI4w
s1x6032eiu78YhGGaOevzo16XdfSt+0sLBa5YB1KVwUXs9hf3bIMvKb7dLmsy+Xl
KhmBO/bqjekYV9CYjKaGOqrH5TT3nmQSTse7PvmJ8kL0v5mGTB7bHxr2PJYit5U9
3zbc2bRrBdLmNyZQYJMakO73ZeqIS9xyk23+54kVfHakGRsg8Tn5ARHYn+ujJD3M
i30NxdrPArSq7xncDw4rY1vXMZR/JLb/YMQAgxbQFp68vIswqYEDTSEhwyP0mfEX
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
                        </div>

                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i> Password <span class="text-muted">(if encrypted)</span>
                            </label>
                            <input type="password" class="form-control" name="password" id="password" placeholder="Enter password for encrypted keys">
                            <small class="form-text text-muted">Only required if your private key is encrypted</small>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-unlock-alt"></i> Extract Public Key
                        </button>
                    </form>
                </div>
            </div>

            <!-- Supported Key Types -->
            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <i class="fas fa-check-circle text-success"></i> Supported Key Types
                </div>
                <div class="card-body p-2">
                    <div class="d-flex flex-wrap justify-content-around">
                        <span class="badge badge-primary m-1 p-2">RSA (1024-8192 bit)</span>
                        <span class="badge badge-success m-1 p-2">DSA (1024-3072 bit)</span>
                        <span class="badge badge-purple m-1 p-2" style="background:#6f42c1;color:#fff;">EC/ECDSA</span>
                        <span class="badge badge-warning m-1 p-2">Ed25519</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Output -->
        <div class="col-lg-7">
            <!-- Result Placeholder -->
            <div id="result-placeholder" class="result-placeholder mb-4">
                <i class="fas fa-key fa-3x text-muted mb-3"></i>
                <h5 class="text-muted">Public Key Output</h5>
                <p class="text-muted mb-0">Paste a private key and click "Extract Public Key" to see the result</p>
            </div>

            <!-- Output Area -->
            <div id="output"></div>

            <!-- OpenSSL Commands Reference -->
            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <i class="fas fa-terminal"></i> OpenSSL Commands Reference
                </div>
                <div class="card-body">
                    <!-- RSA -->
                    <div class="algo-card rsa card mb-3">
                        <div class="card-body py-2">
                            <h6 class="mb-2"><span class="badge badge-primary">RSA</span> Extract Public Key</h6>
                            <div class="command-box">
                                <span class="cmd-prefix">$</span> <code>openssl rsa -in private.pem -pubout -out public.pem</code>
                                <button class="btn btn-sm btn-outline-light copy-cmd-btn" data-cmd="openssl rsa -in private.pem -pubout -out public.pem">Copy</button>
                            </div>
                        </div>
                    </div>

                    <!-- DSA -->
                    <div class="algo-card dsa card mb-3">
                        <div class="card-body py-2">
                            <h6 class="mb-2"><span class="badge badge-success">DSA</span> Extract Public Key</h6>
                            <div class="command-box">
                                <span class="cmd-prefix">$</span> <code>openssl dsa -in private.pem -pubout -out public.pem</code>
                                <button class="btn btn-sm btn-outline-light copy-cmd-btn" data-cmd="openssl dsa -in private.pem -pubout -out public.pem">Copy</button>
                            </div>
                        </div>
                    </div>

                    <!-- EC -->
                    <div class="algo-card ec card mb-3">
                        <div class="card-body py-2">
                            <h6 class="mb-2"><span class="badge" style="background:#6f42c1;color:#fff;">EC</span> Extract Public Key</h6>
                            <div class="command-box">
                                <span class="cmd-prefix">$</span> <code>openssl ec -in private.pem -pubout -out public.pem</code>
                                <button class="btn btn-sm btn-outline-light copy-cmd-btn" data-cmd="openssl ec -in private.pem -pubout -out public.pem">Copy</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Related Tools -->
            <div class="card shadow-sm">
                <div class="card-header">
                    <i class="fas fa-tools"></i> Related Tools
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <a href="PemParserFunctions.jsp" class="card related-tool-card text-decoration-none h-100">
                                <div class="card-body py-2">
                                    <i class="fas fa-file-alt text-primary"></i>
                                    <strong class="d-block">PEM Parser</strong>
                                    <small class="text-muted">Decode certificates & keys</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="rsasignverifyfunctions.jsp" class="card related-tool-card text-decoration-none h-100">
                                <div class="card-body py-2">
                                    <i class="fas fa-signature text-success"></i>
                                    <strong class="d-block">RSA Sign/Verify</strong>
                                    <small class="text-muted">Digital signatures</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="dsafunctions.jsp" class="card related-tool-card text-decoration-none h-100">
                                <div class="card-body py-2">
                                    <i class="fas fa-key text-warning"></i>
                                    <strong class="d-block">DSA Tools</strong>
                                    <small class="text-muted">Keygen, sign, verify</small>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6 mb-2">
                            <a href="ecfunctions.jsp" class="card related-tool-card text-decoration-none h-100">
                                <div class="card-body py-2">
                                    <i class="fas fa-ellipsis-h text-purple" style="color:#6f42c1;"></i>
                                    <strong class="d-block">EC Encryption</strong>
                                    <small class="text-muted">Elliptic curve tools</small>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>
    <%@ include file="thanks.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
</div>
<%@ include file="body-close.jsp"%>
