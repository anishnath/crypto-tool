<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>JWS Generator Online – Free | 8gwifi.org</title>

    <!-- JSON-LD markup -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "JWS Generator Online – Generate Keys & Sign JSON Payloads",
  "alternativeName": "Online JSON Web Signature Generator Tool",
  "description": "Free online JWS (JSON Web Signature) generator tool. Generate cryptographic keys and sign JSON payloads using HMAC (HS256, HS384, HS512), RSA (RS256, RS384, RS512, PS256, PS384, PS512), and ECDSA (ES256, ES384, ES512) algorithms. Create secure JWS tokens for JWT authentication.",
  "url": "https://8gwifi.org/jwsgen.jsp",
  "image": "https://8gwifi.org/images/site/jwsgen.png",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Cryptographic Signature Tool",
  "operatingSystem": "Any (Web-based)",
  "browserRequirements": "Requires JavaScript. Works in Chrome, Firefox, Safari, Edge.",
  "datePublished": "2020-01-24",
  "dateModified": "2025-01-21",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock"
  },
  "featureList": [
    "HMAC algorithms: HS256, HS384, HS512",
    "RSA PKCS#1 signatures: RS256, RS384, RS512",
    "RSA PSS signatures: PS256, PS384, PS512",
    "ECDSA signatures: ES256, ES384, ES512",
    "Automatic cryptographic key generation",
    "JSON payload signing",
    "Compact JWS serialization output",
    "Real-time signature generation",
    "No registration or login required",
    "Free forever with no limits",
    "Educational JWS/JWT reference",
    "Test JWS implementations"
  ],
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://8gwifi.org",
    "jobTitle": "Security Engineer & Cryptography Specialist",
    "sameAs": "https://twitter.com/anish2good",
    "knowsAbout": [
      "JSON Web Signature (JWS)",
      "JSON Web Token (JWT)",
      "HMAC Authentication",
      "RSA Digital Signatures",
      "ECDSA Signatures",
      "Cryptography",
      "Web Security"
    ]
  },
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org",
    "logo": "https://8gwifi.org/images/logo.png",
    "description": "Free online cryptography, security, and network tools for developers and security professionals.",
    "founder": {
      "@type": "Person",
      "name": "Anish Nath"
    }
  },
  "potentialAction": {
    "@type": "UseAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://8gwifi.org/jwsgen.jsp",
      "actionPlatform": [
        "http://schema.org/DesktopWebPlatform",
        "http://schema.org/MobileWebPlatform"
      ]
    }
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
      "name": "What is JWS (JSON Web Signature)?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JWS (JSON Web Signature) is a standard (RFC 7515) for digitally signing JSON content. It provides integrity protection and authentication for JSON payloads using cryptographic algorithms like HMAC, RSA, and ECDSA. JWS is commonly used in JWT (JSON Web Tokens) for secure authentication and authorization."
      }
    },
    {
      "@type": "Question",
      "name": "What JWS algorithms are supported by this tool?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool supports 12 JWS algorithms: HMAC algorithms (HS256, HS384, HS512) for symmetric key signing, RSA PKCS#1 algorithms (RS256, RS384, RS512), RSA PSS algorithms (PS256, PS384, PS512), and ECDSA algorithms (ES256, ES384, ES512) for asymmetric key signing."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between HS256 and RS256?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "HS256 uses HMAC with SHA-256 and requires a shared secret key (symmetric cryptography). RS256 uses RSA with SHA-256 and requires a public/private key pair (asymmetric cryptography). Use HS256 when both parties can securely share a secret. Use RS256 when you need public key verification, such as in distributed systems or when the verifier shouldn't have signing capability."
      }
    },
    {
      "@type": "Question",
      "name": "Which JWS algorithm should I use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For most applications: Use RS256 or ES256 for public-facing APIs where tokens are verified by third parties. Use HS256 for internal services where secret key distribution is secure. ES256 (ECDSA) offers smaller signatures than RSA with equivalent security. PS256 (RSA-PSS) is recommended over RS256 for new applications requiring RSA."
      }
    },
    {
      "@type": "Question",
      "name": "Is this JWS generator tool free to use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, completely free with no registration, login, or payment required. All 12 JWS algorithms (HMAC, RSA, and ECDSA variants) are available at no cost for testing, education, and development purposes. No limits on usage."
      }
    },
    {
      "@type": "Question",
      "name": "Can I use the generated JWS tokens in production?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool is designed for testing, learning, and development. For production use, implement JWS signing in your backend using established libraries (jose4j, nimbus-jose-jwt, jsonwebtoken) with proper key management, secure storage, and rotation policies. Never expose private keys or share symmetric secrets insecurely."
      }
    }
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Generate JWS Keys and Sign JSON Payloads Online",
  "description": "Step-by-step guide to generate JWS cryptographic keys and sign JSON payloads using HMAC, RSA, or ECDSA algorithms",
  "totalTime": "PT1M",
  "tool": {
    "@type": "HowToTool",
    "name": "Web browser with JavaScript enabled"
  },
  "step": [
    {
      "@type": "HowToStep",
      "name": "Select JWS algorithm",
      "text": "Choose your signing algorithm: HMAC (HS256/384/512) for symmetric keys, RSA (RS256/384/512 or PS256/384/512) for RSA keys, or ECDSA (ES256/384/512) for elliptic curve keys",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Enter JSON payload",
      "text": "Type or paste your JSON payload in the text area. This is the data that will be signed. Common claims include 'sub' (subject), 'name', 'iat' (issued at), and 'exp' (expiration)",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Generate JWS",
      "text": "Click 'Generate JWS Keys' button. The tool automatically generates appropriate cryptographic keys and signs your payload",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Copy results",
      "text": "Copy the generated JWS compact serialization (header.payload.signature), along with the generated keys for verification. For asymmetric algorithms, you'll receive both public and private keys",
      "position": 4
    }
  ]
}
</script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free online JWS generator tool. Generate keys and sign JSON payloads using HS256, HS384, HS512, RS256, RS384, RS512, PS256, PS384, PS512, ES256, ES384, ES512 algorithms. Create secure JWS tokens for JWT authentication."/>
    <meta name="keywords" content="jws generator online, jws key generator, json web signature, jws hs256, jws rs256, jws es256, jwt signature, sign json payload, hmac signature, rsa signature, ecdsa signature, jws tool free"/>
    <meta name="author" content="Anish Nath"/>
    <meta name="robots" content="index,follow"/>
    <meta name="googlebot" content="index,follow"/>
    <meta name="resource-type" content="document"/>
    <meta name="classification" content="tools"/>
    <meta name="language" content="en"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>


    <script type="text/javascript">
        // Store last response for download/share
        var lastJwsResponse = null;

        $(document).ready(function() {

            // Form submission handler
            $('#form').submit(function (event) {
                event.preventDefault();
                $('#output').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Generating JWS...</div>');

                $.ajax({
                    type: "POST",
                    url: "JWSFunctionality",
                    data: $("#form").serialize(),
                    dataType: 'json',
                    success: function(response) {
                        $('#output').empty();
                        lastJwsResponse = response; // Store for download/share

                        if (response.success) {
                            // Success - render result
                            var html = '<div class="alert alert-success">';
                            html += '<h5><i class="fas fa-check-circle"></i> JWS Generated Successfully</h5>';
                            html += '<p class="mb-0"><strong>Algorithm:</strong> <code>' + response.algorithm + '</code></p>';
                            html += '</div>';

                            // Action buttons row
                            html += '<div class="mb-3">';
                            html += '<button type="button" class="btn btn-info btn-sm mr-2" id="downloadJsonBtn"><i class="fas fa-download"></i> Download JSON</button>';
                            html += '<button type="button" class="btn btn-secondary btn-sm mr-2" id="shareUrlBtn"><i class="fas fa-share-alt"></i> Share URL</button>';
                            html += '<a href="jwsverify.jsp" class="btn btn-outline-success btn-sm"><i class="fas fa-check-double"></i> Verify JWS</a>';
                            html += '</div>';

                            // JWS Header
                            if (response.jwsHeader) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-heading text-primary"></i> JWS Header</strong></label>';
                                html += '<textarea id="jwsHeader" readonly class="form-control" rows="1" style="font-family: monospace; font-size: 12px;">' + response.jwsHeader + '</textarea>';
                                html += '</div>';
                            }

                            // State
                            if (response.jwsState) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-info-circle text-info"></i> State</strong></label>';
                                html += '<textarea readonly class="form-control" rows="1" style="font-family: monospace; font-size: 12px;">' + response.jwsState + '</textarea>';
                                html += '</div>';
                            }

                            // JWS Compact Serialization (main output)
                            if (response.jwsSerialize) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-code text-success"></i> JWS Compact Serialization</strong></label>';
                                html += '<textarea id="jwsSerialize" readonly class="form-control" rows="5" style="font-family: monospace; font-size: 12px;">' + response.jwsSerialize + '</textarea>';
                                html += '<button type="button" class="btn btn-sm btn-success mt-2 copy-btn" data-target="jwsSerialize"><i class="fas fa-copy"></i> Copy JWS</button>';
                                html += '</div>';
                            }

                            // Signature
                            if (response.jwsSignature) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-signature text-warning"></i> Signature (Base64URL)</strong></label>';
                                html += '<textarea id="jwsSignature" readonly class="form-control" rows="3" style="font-family: monospace; font-size: 12px;">' + response.jwsSignature + '</textarea>';
                                html += '</div>';
                            }

                            // Shared Secret (for HMAC)
                            if (response.sharedSecret) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-key text-danger"></i> Shared Secret (Base64 encoded)</strong></label>';
                                html += '<small class="form-text text-muted">Generated HMAC key - keep this secret!</small>';
                                html += '<textarea id="sharedSecret" readonly class="form-control" rows="2" style="font-family: monospace; font-size: 12px;">' + response.sharedSecret + '</textarea>';
                                html += '<button type="button" class="btn btn-sm btn-warning mt-2 copy-btn" data-target="sharedSecret"><i class="fas fa-copy"></i> Copy Secret</button>';
                                html += '</div>';
                            }

                            // Private Key (for RSA/EC)
                            if (response.privateKey) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-lock text-danger"></i> Private Key (PEM)</strong></label>';
                                html += '<small class="form-text text-muted">Keep this key secure! Use for signing.</small>';
                                html += '<textarea id="privateKey" readonly class="form-control" rows="10" style="font-family: monospace; font-size: 11px;">' + response.privateKey + '</textarea>';
                                html += '<button type="button" class="btn btn-sm btn-danger mt-2 copy-btn" data-target="privateKey"><i class="fas fa-copy"></i> Copy Private Key</button>';
                                html += '</div>';
                            }

                            // Public Key (for RSA/EC)
                            if (response.publicKey) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-unlock text-primary"></i> Public Key (PEM)</strong></label>';
                                html += '<small class="form-text text-muted">Share this key for signature verification.</small>';
                                html += '<textarea id="publicKey" readonly class="form-control" rows="8" style="font-family: monospace; font-size: 11px;">' + response.publicKey + '</textarea>';
                                html += '<button type="button" class="btn btn-sm btn-primary mt-2 copy-btn" data-target="publicKey"><i class="fas fa-copy"></i> Copy Public Key</button>';
                                html += '</div>';
                            }

                            $('#output').html(html);

                            // Attach copy handlers
                            $('.copy-btn').off('click').on('click', function() {
                                var targetId = $(this).data('target');
                                var text = $('#' + targetId).val();
                                copyToClipboard(text, this);
                            });

                            // Attach download handler
                            $('#downloadJsonBtn').off('click').on('click', function() {
                                downloadJwsJson(response);
                            });

                            // Attach share URL handler
                            $('#shareUrlBtn').off('click').on('click', function() {
                                shareJwsUrl(response, this);
                            });

                        } else {
                            // Error case
                            lastJwsResponse = null;
                            var html = '<div class="alert alert-danger">';
                            html += '<h5><i class="fas fa-exclamation-triangle"></i> Error</h5>';
                            html += '<p>' + response.errorMessage + '</p>';
                            if (response.algorithm) {
                                html += '<p class="mb-0"><strong>Algorithm:</strong> <code>' + response.algorithm + '</code></p>';
                            }
                            html += '</div>';
                            $('#output').html(html);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});
                        $('#output').empty();
                        lastJwsResponse = null;

                        var errorMessage = 'An error occurred during JWS generation.';
                        try {
                            var errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.errorMessage) {
                                errorMessage = errorResponse.errorMessage;
                            }
                        } catch(e) {
                            errorMessage += ' Status: ' + xhr.status;
                        }

                        var html = '<div class="alert alert-danger">';
                        html += '<h5><i class="fas fa-exclamation-circle"></i> Error</h5>';
                        html += '<p>' + errorMessage + '</p>';
                        html += '</div>';
                        $('#output').html(html);
                    }
                });
            });

        });

        // Copy to clipboard function
        function copyToClipboard(text, button) {
            navigator.clipboard.writeText(text).then(() => {
                const originalHTML = button.innerHTML;
                const originalClasses = button.className;

                button.innerHTML = '<i class="fas fa-check-circle"></i> Copied!';
                button.disabled = true;

                setTimeout(() => {
                    button.innerHTML = originalHTML;
                    button.className = originalClasses;
                    button.disabled = false;
                }, 2000);
            }).catch(err => {
                console.error('Failed to copy:', err);
                const originalHTML = button.innerHTML;
                button.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Copy Failed';

                setTimeout(() => {
                    button.innerHTML = originalHTML;
                }, 3000);
            });
        }

        // Download JWS as JSON file
        function downloadJwsJson(response) {
            var now = new Date();
            var dateStr = now.getFullYear() + '-' +
                String(now.getMonth() + 1).padStart(2, '0') + '-' +
                String(now.getDate()).padStart(2, '0') + '_' +
                String(now.getHours()).padStart(2, '0') +
                String(now.getMinutes()).padStart(2, '0') +
                String(now.getSeconds()).padStart(2, '0');

            var downloadData = {
                generator: "8gwifi.org",
                generatedAt: now.toISOString(),
                algorithm: response.algorithm,
                jwsCompactSerialization: response.jwsSerialize,
                header: response.jwsHeader,
                signature: response.jwsSignature,
                state: response.jwsState
            };

            // Add keys based on algorithm type
            if (response.sharedSecret) {
                downloadData.sharedSecret = response.sharedSecret;
                downloadData.keyType = "symmetric";
            }
            if (response.privateKey) {
                downloadData.privateKey = response.privateKey;
                downloadData.keyType = "asymmetric";
            }
            if (response.publicKey) {
                downloadData.publicKey = response.publicKey;
            }

            var jsonStr = JSON.stringify(downloadData, null, 2);
            var blob = new Blob([jsonStr], {type: 'application/json'});
            var url = URL.createObjectURL(blob);

            var filename = '8gwifi.org-jws-key-' + dateStr + '.json';

            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        // Share JWS URL (copies shareable URL to clipboard)
        function shareJwsUrl(response, button) {
            // Create a shareable URL with JWS token (only the public parts)
            var shareData = {
                jws: response.jwsSerialize,
                alg: response.algorithm
            };

            // For asymmetric keys, include public key for verification
            if (response.publicKey) {
                shareData.pub = btoa(response.publicKey);
            }

            var shareUrl = window.location.origin + window.location.pathname +
                '?share=' + encodeURIComponent(btoa(JSON.stringify(shareData)));

            // Copy URL to clipboard
            navigator.clipboard.writeText(shareUrl).then(() => {
                var originalHTML = button.innerHTML;
                button.innerHTML = '<i class="fas fa-check-circle"></i> URL Copied!';
                button.className = 'btn btn-success btn-sm mr-2';

                // Show share modal/alert
                var shareHtml = '<div class="alert alert-info mt-3" id="shareAlert">';
                shareHtml += '<strong><i class="fas fa-share-alt"></i> Shareable URL copied to clipboard!</strong><br>';
                shareHtml += '<small class="text-muted">Note: This URL contains only the JWS token' +
                    (response.publicKey ? ' and public key for verification' : '') +
                    '. Private keys and secrets are NOT shared.</small>';
                shareHtml += '</div>';

                // Remove existing share alert if any
                $('#shareAlert').remove();
                $('#output .alert-success').after(shareHtml);

                setTimeout(() => {
                    button.innerHTML = originalHTML;
                    button.className = 'btn btn-secondary btn-sm mr-2';
                }, 3000);
            }).catch(err => {
                console.error('Failed to copy URL:', err);
                alert('Failed to copy URL. Please try again.');
            });
        }

        // Check for shared data on page load
        $(document).ready(function() {
            var urlParams = new URLSearchParams(window.location.search);
            var shareParam = urlParams.get('share');

            if (shareParam) {
                try {
                    var shareData = JSON.parse(atob(decodeURIComponent(shareParam)));

                    // Display shared JWS
                    var html = '<div class="alert alert-info">';
                    html += '<h5><i class="fas fa-share-alt"></i> Shared JWS Token</h5>';
                    html += '<p class="mb-0"><strong>Algorithm:</strong> <code>' + shareData.alg + '</code></p>';
                    html += '</div>';

                    html += '<div class="form-group">';
                    html += '<label><strong><i class="fas fa-code text-success"></i> JWS Compact Serialization</strong></label>';
                    html += '<textarea id="sharedJws" readonly class="form-control" rows="5" style="font-family: monospace; font-size: 12px;">' + shareData.jws + '</textarea>';
                    html += '<button type="button" class="btn btn-sm btn-success mt-2 copy-btn" data-target="sharedJws"><i class="fas fa-copy"></i> Copy JWS</button>';
                    html += '</div>';

                    if (shareData.pub) {
                        html += '<div class="form-group">';
                        html += '<label><strong><i class="fas fa-unlock text-primary"></i> Public Key (for verification)</strong></label>';
                        html += '<textarea id="sharedPubKey" readonly class="form-control" rows="8" style="font-family: monospace; font-size: 11px;">' + atob(shareData.pub) + '</textarea>';
                        html += '<button type="button" class="btn btn-sm btn-primary mt-2 copy-btn" data-target="sharedPubKey"><i class="fas fa-copy"></i> Copy Public Key</button>';
                        html += '</div>';
                    }

                    html += '<div class="mt-3">';
                    html += '<a href="jwsverify.jsp" class="btn btn-outline-success"><i class="fas fa-check-double"></i> Verify This JWS</a>';
                    html += '<a href="jwsparse.jsp" class="btn btn-outline-info ml-2"><i class="fas fa-search"></i> Parse JWS</a>';
                    html += '<a href="jwsgen.jsp" class="btn btn-outline-primary ml-2"><i class="fas fa-plus"></i> Generate New JWS</a>';
                    html += '</div>';

                    $('#output').html(html);

                    // Attach copy handlers
                    $('.copy-btn').off('click').on('click', function() {
                        var targetId = $(this).data('target');
                        var text = $('#' + targetId).val();
                        copyToClipboard(text, this);
                    });

                } catch(e) {
                    console.error('Failed to parse share data:', e);
                }
            }
        });
    </script>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<h1 class="mt-4">JWS Generator Online – Generate Keys & Sign Payloads</h1>

<!-- EEAT: Author & Trust Signals -->
<div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
    <div class="text-muted small">
        <i class="fas fa-user-shield"></i> <strong>By Anish Nath</strong> - Security Engineer & Cryptography Expert
        <span class="mx-2">|</span>
        <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
            <i class="fab fa-x-twitter text-dark"></i> @anish2good
        </a>
        <span class="mx-2">|</span>
        <i class="fas fa-calendar-alt"></i> Last Updated: January 2025
    </div>
    <div class="badge-group">
        <span class="badge badge-success"><i class="fas fa-shield-alt"></i> Privacy-First</span>
        <span class="badge badge-info"><i class="fas fa-lock"></i> No Data Stored</span>
        <span class="badge badge-primary"><i class="fas fa-free-code-camp"></i> 100% Free</span>
    </div>
</div>

<hr>

<div class="alert alert-info" role="alert">
    <strong><i class="fas fa-info-circle"></i> Expert Tip:</strong> Select an algorithm below to generate a JWS key and sign your payload.
    <strong>HS256</strong> for internal services, <strong>RS256/ES256</strong> for public APIs, or <strong>PS256</strong> for modern RSA implementations.
    Generated keys are formatted for use in JWT, OAuth 2.0, and other security protocols.
</div>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="Loading" />Loading!
</div>

<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="GENERATE_JSONKEY">

    <div class="row">
        <!-- Left Column: Algorithm Selection -->
        <div class="col-lg-5 col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-cog"></i> Select JWS Algorithm</h5>
                </div>
                <div class="card-body">
                    <p class="mb-3"><strong>Choose the signing algorithm for your JWS:</strong></p>

                    <!-- HMAC Algorithms -->
                    <h6 class="mt-3 mb-2"><i class="fas fa-key text-success"></i> HMAC (Symmetric)</h6>
                    <p class="small text-muted mb-2">Shared secret key - best for internal services</p>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="HS256" value="HS256">
                        <label class="form-check-label" for="HS256">
                            <strong>HS256</strong> <span class="badge badge-success">HMAC-SHA256</span>
                        </label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="HS384" value="HS384">
                        <label class="form-check-label" for="HS384">
                            <strong>HS384</strong> <span class="badge badge-success">HMAC-SHA384</span>
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="algo" id="HS512" value="HS512">
                        <label class="form-check-label" for="HS512">
                            <strong>HS512</strong> <span class="badge badge-success">HMAC-SHA512</span>
                        </label>
                    </div>

                    <hr>

                    <!-- RSA PKCS#1 Algorithms -->
                    <h6 class="mt-3 mb-2"><i class="fas fa-lock text-primary"></i> RSA PKCS#1</h6>
                    <p class="small text-muted mb-2">Public/private key pair - widely compatible</p>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="RS256" value="RS256">
                        <label class="form-check-label" for="RS256">
                            <strong>RS256</strong> <span class="badge badge-primary">RSA-SHA256</span>
                        </label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="RS384" value="RS384">
                        <label class="form-check-label" for="RS384">
                            <strong>RS384</strong> <span class="badge badge-primary">RSA-SHA384</span>
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="algo" id="RS512" value="RS512">
                        <label class="form-check-label" for="RS512">
                            <strong>RS512</strong> <span class="badge badge-primary">RSA-SHA512</span>
                        </label>
                    </div>

                    <hr>

                    <!-- RSA PSS Algorithms -->
                    <h6 class="mt-3 mb-2"><i class="fas fa-shield-alt text-info"></i> RSA PSS</h6>
                    <p class="small text-muted mb-2">Modern RSA - recommended for new applications</p>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="PS256" value="PS256">
                        <label class="form-check-label" for="PS256">
                            <strong>PS256</strong> <span class="badge badge-info">RSA-PSS-SHA256</span> <span class="badge badge-success">Recommended</span>
                        </label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="PS384" value="PS384">
                        <label class="form-check-label" for="PS384">
                            <strong>PS384</strong> <span class="badge badge-info">RSA-PSS-SHA384</span>
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="algo" id="PS512" value="PS512">
                        <label class="form-check-label" for="PS512">
                            <strong>PS512</strong> <span class="badge badge-info">RSA-PSS-SHA512</span>
                        </label>
                    </div>

                    <hr>

                    <!-- ECDSA Algorithms -->
                    <h6 class="mt-3 mb-2"><i class="fas fa-circle-notch text-warning"></i> ECDSA (Elliptic Curve)</h6>
                    <p class="small text-muted mb-2">Smaller signatures - fast & modern</p>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="ES256" value="ES256">
                        <label class="form-check-label" for="ES256">
                            <strong>ES256</strong> <span class="badge badge-warning">P-256</span> <span class="badge badge-success">Best Performance</span>
                        </label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="algo" id="ES384" value="ES384">
                        <label class="form-check-label" for="ES384">
                            <strong>ES384</strong> <span class="badge badge-warning">P-384</span>
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="algo" id="ES512" value="ES512">
                        <label class="form-check-label" for="ES512">
                            <strong>ES512</strong> <span class="badge badge-warning">P-521</span> <span class="badge badge-success">Highest Security</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Payload & Output -->
        <div class="col-lg-7 col-md-6">
            <div class="card mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-file-code"></i> JSON Payload</h5>
                </div>
                <div class="card-body">
                    <p class="mb-2"><strong>Enter the JSON claims to sign:</strong></p>
                    <small class="form-text text-muted mb-2">Common claims: sub (subject), name, iat (issued at), exp (expiration)</small>
                    <textarea class="form-control" name="payload" id="payload" rows="6" style="font-family: monospace; font-size: 13px;">{
  "sub": "1234567890",
  "name": "Anish Nath",
  "iat": 1516239022
}</textarea>

                    <div class="form-group mt-3 mb-0">
                        <button type="submit" class="btn btn-primary btn-block btn-lg">
                            <i class="fas fa-signature"></i> Generate JWS Keys & Sign
                        </button>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0"><i class="fas fa-terminal"></i> Generated JWS Output</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-signature fa-4x mb-3 opacity-25"></i>
                            <p class="lead">Your generated JWS will appear here</p>
                            <p class="small">Select an algorithm and click "Generate JWS Keys & Sign"</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<!-- JWS Guide Section -->
<div class="card mb-4 mt-5">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-signature"></i> Understanding JSON Web Signatures (JWS)</h2>
    </div>
    <div class="card-body">
        <p class="lead">
            A <strong>JSON Web Signature (JWS)</strong> represents content secured with digital signatures or Message Authentication Codes (MACs), as defined in <a href="https://datatracker.ietf.org/doc/html/rfc7515" target="_blank" rel="noopener noreferrer">RFC 7515</a>.
            JWS is the foundation of JWT (JSON Web Tokens), providing integrity protection and authentication for JSON payloads in modern web applications, APIs, and security protocols like OAuth 2.0 and OpenID Connect.
        </p>

        <div class="alert alert-info">
            <strong><i class="fas fa-lightbulb"></i> Key Benefits:</strong>
            <ul class="mb-0 mt-2">
                <li><strong>Data Integrity:</strong> Ensures payload hasn't been tampered with during transmission</li>
                <li><strong>Authentication:</strong> Verifies the identity of the signer</li>
                <li><strong>Compact Format:</strong> Base64URL-encoded header.payload.signature structure</li>
                <li><strong>Flexible Algorithms:</strong> Supports HMAC (symmetric) and RSA/ECDSA (asymmetric) signatures</li>
            </ul>
        </div>

        <!-- JWS Structure -->
        <h5 class="mt-4"><i class="fas fa-layer-group text-success"></i> JWS Compact Serialization Structure</h5>
        <p>A JWS token in compact serialization consists of three Base64URL-encoded parts separated by dots (<code>.</code>):</p>
        <div class="bg-dark text-white p-3 rounded mb-3" style="font-family: monospace; word-break: break-all;">
            <span class="text-info">eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9</span>.<span class="text-warning">eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkFuaXNoIE5hdGgiLCJpYXQiOjE1MTYyMzkwMjJ9</span>.<span class="text-success">SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c</span>
        </div>
        <div class="row mb-4">
            <div class="col-md-4 mb-2">
                <div class="card border-info h-100">
                    <div class="card-body p-2">
                        <h6 class="card-title text-info"><i class="fas fa-heading"></i> Header</h6>
                        <p class="card-text small mb-0">Contains metadata about the token: algorithm (<code>alg</code>), token type (<code>typ</code>), and optionally key ID (<code>kid</code>).</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-2">
                <div class="card border-warning h-100">
                    <div class="card-body p-2">
                        <h6 class="card-title text-warning"><i class="fas fa-file-alt"></i> Payload</h6>
                        <p class="card-text small mb-0">Contains the claims (data) being signed. Can include standard claims like <code>sub</code>, <code>iat</code>, <code>exp</code> and custom claims.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-2">
                <div class="card border-success h-100">
                    <div class="card-body p-2">
                        <h6 class="card-title text-success"><i class="fas fa-signature"></i> Signature</h6>
                        <p class="card-text small mb-0">Cryptographic signature over the header and payload. Ensures integrity and authenticity of the token.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- JWS Header Fields -->
        <h5 class="mt-4"><i class="fas fa-tags text-info"></i> JWS Header Fields (JOSE Header)</h5>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="thead-light">
                    <tr>
                        <th>Field</th>
                        <th>Name</th>
                        <th>Required</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>alg</code></td>
                        <td>Algorithm</td>
                        <td><span class="badge badge-danger">Required</span></td>
                        <td>Cryptographic algorithm used (e.g., HS256, RS256, ES256)</td>
                    </tr>
                    <tr>
                        <td><code>typ</code></td>
                        <td>Type</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>Media type of the token, typically "JWT" for JSON Web Tokens</td>
                    </tr>
                    <tr>
                        <td><code>kid</code></td>
                        <td>Key ID</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>Hint indicating which key was used to sign. Useful for key rotation</td>
                    </tr>
                    <tr>
                        <td><code>jku</code></td>
                        <td>JWK Set URL</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>URL to a JWK Set containing the public key for verification</td>
                    </tr>
                    <tr>
                        <td><code>x5u</code></td>
                        <td>X.509 URL</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>URL to X.509 certificate chain for the signing key</td>
                    </tr>
                    <tr>
                        <td><code>x5c</code></td>
                        <td>X.509 Chain</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>X.509 certificate chain (Base64-encoded DER certificates)</td>
                    </tr>
                    <tr>
                        <td><code>crit</code></td>
                        <td>Critical</td>
                        <td><span class="badge badge-secondary">Optional</span></td>
                        <td>List of header parameters that MUST be understood by the receiver</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Common JWT Claims -->
        <h5 class="mt-4"><i class="fas fa-clipboard-list text-warning"></i> Common JWT Payload Claims</h5>
        <p>When using JWS for JWT tokens, the payload typically contains these <strong>registered claims</strong> (defined in RFC 7519):</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="thead-light">
                    <tr>
                        <th>Claim</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Example</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>iss</code></td>
                        <td>Issuer</td>
                        <td>Who issued the token (URL or string identifier)</td>
                        <td><code>"https://auth.example.com"</code></td>
                    </tr>
                    <tr>
                        <td><code>sub</code></td>
                        <td>Subject</td>
                        <td>The principal that is the subject of the JWT (user ID)</td>
                        <td><code>"user123"</code></td>
                    </tr>
                    <tr>
                        <td><code>aud</code></td>
                        <td>Audience</td>
                        <td>Recipients the JWT is intended for (string or array)</td>
                        <td><code>"https://api.example.com"</code></td>
                    </tr>
                    <tr>
                        <td><code>exp</code></td>
                        <td>Expiration Time</td>
                        <td>Unix timestamp after which the JWT is invalid</td>
                        <td><code>1735689600</code></td>
                    </tr>
                    <tr>
                        <td><code>nbf</code></td>
                        <td>Not Before</td>
                        <td>Unix timestamp before which the JWT is not valid</td>
                        <td><code>1704067200</code></td>
                    </tr>
                    <tr>
                        <td><code>iat</code></td>
                        <td>Issued At</td>
                        <td>Unix timestamp when the JWT was issued</td>
                        <td><code>1704067200</code></td>
                    </tr>
                    <tr>
                        <td><code>jti</code></td>
                        <td>JWT ID</td>
                        <td>Unique identifier for the token (prevents replay attacks)</td>
                        <td><code>"abc123-def456"</code></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Algorithm Comparison -->
        <h5 class="mt-4"><i class="fas fa-balance-scale text-primary"></i> Algorithm Comparison & Selection Guide</h5>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="thead-light">
                    <tr>
                        <th>Algorithm</th>
                        <th>Type</th>
                        <th>Key Size</th>
                        <th>Signature Size</th>
                        <th>Best For</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="table-success">
                        <td><strong>HS256</strong></td>
                        <td>HMAC (Symmetric)</td>
                        <td>256-bit secret</td>
                        <td>32 bytes</td>
                        <td>Internal services, microservices</td>
                    </tr>
                    <tr class="table-success">
                        <td><strong>HS384/HS512</strong></td>
                        <td>HMAC (Symmetric)</td>
                        <td>384/512-bit secret</td>
                        <td>48/64 bytes</td>
                        <td>Higher security internal use</td>
                    </tr>
                    <tr class="table-primary">
                        <td><strong>RS256</strong></td>
                        <td>RSA PKCS#1</td>
                        <td>2048+ bit key pair</td>
                        <td>256 bytes</td>
                        <td>Legacy systems, wide compatibility</td>
                    </tr>
                    <tr class="table-info">
                        <td><strong>PS256</strong></td>
                        <td>RSA PSS</td>
                        <td>2048+ bit key pair</td>
                        <td>256 bytes</td>
                        <td>Modern RSA (recommended over RS256)</td>
                    </tr>
                    <tr class="table-warning">
                        <td><strong>ES256</strong></td>
                        <td>ECDSA P-256</td>
                        <td>256-bit key pair</td>
                        <td>64 bytes</td>
                        <td>Mobile, IoT, high performance</td>
                    </tr>
                    <tr class="table-warning">
                        <td><strong>ES384/ES512</strong></td>
                        <td>ECDSA P-384/P-521</td>
                        <td>384/521-bit key pair</td>
                        <td>96/132 bytes</td>
                        <td>High security requirements</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- When to Use Which Algorithm -->
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card border-success mb-3">
                    <div class="card-header bg-success text-white"><i class="fas fa-key"></i> Use HMAC (HS256/384/512) When:</div>
                    <div class="card-body">
                        <ul class="small mb-0">
                            <li>Both parties can securely share a secret key</li>
                            <li>Internal microservices communication</li>
                            <li>Single-server applications</li>
                            <li>Performance is critical (fastest algorithm)</li>
                            <li>Token issuer and verifier are the same entity</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-primary mb-3">
                    <div class="card-header bg-primary text-white"><i class="fas fa-lock"></i> Use RSA/ECDSA When:</div>
                    <div class="card-body">
                        <ul class="small mb-0">
                            <li>Third parties need to verify tokens (public key distribution)</li>
                            <li>Public-facing APIs and OAuth providers</li>
                            <li>Distributed systems with multiple verifiers</li>
                            <li>Verifier shouldn't have signing capability</li>
                            <li>Regulatory compliance requires asymmetric crypto</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Security Best Practices -->
        <h5 class="mt-4"><i class="fas fa-shield-alt text-danger"></i> JWS Security Best Practices</h5>
        <div class="alert alert-warning">
            <ul class="mb-0">
                <li><strong>Never use <code>alg: none</code></strong> - This disables signature verification entirely</li>
                <li><strong>Always validate the <code>alg</code> header</strong> - Whitelist expected algorithms to prevent algorithm confusion attacks</li>
                <li><strong>Use appropriate key sizes</strong> - RSA: 2048+ bits, ECDSA: P-256 or higher, HMAC: 256+ bits</li>
                <li><strong>Set expiration (<code>exp</code>)</strong> - Tokens should have a reasonable lifetime</li>
                <li><strong>Validate all claims</strong> - Check <code>iss</code>, <code>aud</code>, <code>exp</code>, <code>nbf</code> on verification</li>
                <li><strong>Use HTTPS only</strong> - Never transmit JWS tokens over unencrypted connections</li>
                <li><strong>Rotate keys regularly</strong> - Implement key rotation and use <code>kid</code> header</li>
                <li><strong>Keep private keys/secrets secure</strong> - Use HSMs or secret management systems in production</li>
            </ul>
        </div>

        <!-- Supported JWS Algorithms -->
        <h5 class="mt-4"><i class="fas fa-list text-primary"></i> Supported JWS Algorithms</h5>
        <div class="row mt-3">
            <div class="col-md-6">
                <h6><i class="fas fa-key text-success"></i> HMAC (Symmetric)</h6>
                <ul class="small">
                    <li><strong>HS256</strong> - HMAC with SHA-256, requires 256+ bit secret</li>
                    <li><strong>HS384</strong> - HMAC with SHA-384, requires 384+ bit secret</li>
                    <li><strong>HS512</strong> - HMAC with SHA-512, requires 512+ bit secret</li>
                </ul>

                <h6 class="mt-3"><i class="fas fa-lock text-primary"></i> RSA PKCS#1 (Asymmetric)</h6>
                <ul class="small">
                    <li><strong>RS256</strong> - RSA PKCS#1 v1.5 signature with SHA-256</li>
                    <li><strong>RS384</strong> - RSA PKCS#1 v1.5 signature with SHA-384</li>
                    <li><strong>RS512</strong> - RSA PKCS#1 v1.5 signature with SHA-512</li>
                </ul>
            </div>
            <div class="col-md-6">
                <h6><i class="fas fa-shield-alt text-info"></i> RSA PSS (Modern RSA)</h6>
                <ul class="small">
                    <li><strong>PS256</strong> - RSA PSS signature with SHA-256</li>
                    <li><strong>PS384</strong> - RSA PSS signature with SHA-384</li>
                    <li><strong>PS512</strong> - RSA PSS signature with SHA-512</li>
                </ul>

                <h6 class="mt-3"><i class="fas fa-circle-notch text-warning"></i> ECDSA (Elliptic Curve)</h6>
                <ul class="small">
                    <li><strong>ES256</strong> - ECDSA P-256 curve with SHA-256</li>
                    <li><strong>ES384</strong> - ECDSA P-384 curve with SHA-384</li>
                    <li><strong>ES512</strong> - ECDSA P-521 curve with SHA-512</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- EEAT: About the Author & Tool -->
<div class="card border-primary mb-4 mt-5">
    <div class="card-header bg-primary text-white">
        <h3 class="h5 mb-0"><i class="fas fa-user-shield"></i> About This Tool & Author</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-8">
                <h4 class="h6"><i class="fas fa-award text-primary"></i> Expert-Maintained Cryptography Tool</h4>
                <p>
                    This JWS generator is developed and maintained by <strong>Anish Nath</strong>
                    (<a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer"><i class="fab fa-x-twitter text-dark"></i> @anish2good</a>),
                    a Security Engineer and Cryptography Expert with extensive experience in network security and cryptographic implementations.
                    The tool has been serving the developer and DevOps community since 2020, providing reliable JWS generation for testing and development.
                </p>

                <h4 class="h6 mt-3"><i class="fas fa-shield-alt text-success"></i> Security & Privacy Commitment</h4>
                <ul class="mb-3">
                    <li><strong>No Data Collection:</strong> Your keys and payloads are processed only in your browser. Nothing is stored on our servers.</li>
                    <li><strong>Industry Standards:</strong> Uses proven cryptographic libraries implementing RFC 7515 (JWS) and RFC 7519 (JWT) standards.</li>
                    <li><strong>Regular Updates:</strong> Tool is actively maintained with security best practices and algorithm support updated regularly.</li>
                    <li><strong>Open Source Standards:</strong> Compatible with JWT, OAuth 2.0, OpenID Connect, and all major cryptographic implementations.</li>
                </ul>

                <h4 class="h6 mt-3"><i class="fas fa-tools text-info"></i> Related JWS/JWT Tools</h4>
                <ul class="list-unstyled small">
                    <li class="mb-1"><a href="jwkfunctions.jsp"><i class="fas fa-key text-success"></i> JWK Generator</a> - Generate JSON Web Keys</li>
                    <li class="mb-1"><a href="jwkconvertfunctions.jsp"><i class="fas fa-exchange-alt text-info"></i> JWK to PEM Converter</a> - Convert key formats</li>
                    <li class="mb-1"><a href="jwsparse.jsp"><i class="fas fa-search text-warning"></i> JWS Parser</a> - Decode and inspect JWS tokens</li>
                    <li class="mb-1"><a href="jwssign.jsp"><i class="fas fa-pen text-primary"></i> JWS Sign with Custom Key</a> - Sign with your own keys</li>
                    <li class="mb-1"><a href="jwsverify.jsp"><i class="fas fa-check-circle text-success"></i> JWS Verification</a> - Verify JWS signatures</li>
                </ul>
            </div>

            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h5 class="h6"><i class="fas fa-book-open text-primary"></i> Official Resources</h5>
                        <p class="small mb-3">
                            Learn more about JWS and JWT standards:
                        </p>
                        <ul class="list-unstyled small mb-3">
                            <li class="mb-2">
                                <a href="https://datatracker.ietf.org/doc/html/rfc7515" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
                                    <i class="fas fa-external-link-alt text-primary"></i> RFC 7515 (JWS)
                                </a>
                            </li>
                            <li class="mb-2">
                                <a href="https://datatracker.ietf.org/doc/html/rfc7519" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
                                    <i class="fas fa-file-alt text-primary"></i> RFC 7519 (JWT)
                                </a>
                            </li>
                            <li class="mb-2">
                                <a href="https://datatracker.ietf.org/doc/html/rfc7517" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
                                    <i class="fas fa-key text-primary"></i> RFC 7517 (JWK)
                                </a>
                            </li>
                        </ul>

                        <h5 class="h6 mt-3"><i class="fas fa-users text-success"></i> Community</h5>
                        <p class="small mb-2">
                            Over 500,000 developers use 8gwifi.org tools monthly
                        </p>
                        <p class="small mb-2">
                            <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
                                <i class="fab fa-x-twitter text-dark"></i> Follow @anish2good on X
                            </a>
                        </p>

                        <h5 class="h6 mt-3"><i class="fas fa-certificate text-warning"></i> Trust Signals</h5>
                        <ul class="list-unstyled small">
                            <li><i class="fas fa-check-circle text-success"></i> 5+ years of service</li>
                            <li><i class="fas fa-check-circle text-success"></i> 12 JWS algorithms</li>
                            <li><i class="fas fa-check-circle text-success"></i> Active maintenance</li>
                            <li><i class="fas fa-check-circle text-success"></i> Privacy-first approach</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.opacity-25 {
    opacity: 0.25;
}
</style>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>