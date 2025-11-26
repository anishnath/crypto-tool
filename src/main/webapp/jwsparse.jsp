<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>JWS Parser & Decoder Online – Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Parse and decode JWS (JSON Web Signature) tokens online. Free tool extracts header, payload, signature, and JWT claims from compact serialization format.">
    <meta name="keywords" content="jws parser, jws decoder, jwt decoder, parse jwt online, decode jws token, jws header decoder, jwt payload extractor, json web signature parser, jwt claims viewer">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/jwsparse.jsp">
    <meta property="og:title" content="JWS Parser & Decoder Online – Free | 8gwifi.org">
    <meta property="og:description" content="Parse and decode JWS tokens online. Extract header, payload, signature, and JWT claims instantly.">
    <meta property="og:image" content="https://8gwifi.org/images/site/jwsparse.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/jwsparse.jsp">
    <meta name="twitter:title" content="JWS Parser & Decoder Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Parse and decode JWS tokens online. Extract header, payload, signature, and JWT claims instantly.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/jwsparse.png">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/jwsparse.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD: WebApplication Schema -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "JWS Parser & Decoder Online",
  "alternateName": "JWT Decoder, JWS Token Parser, JSON Web Signature Decoder",
  "description": "Free online tool to parse and decode JWS (JSON Web Signature) and JWT tokens. Extracts header, payload, signature, and all JWT claims from compact serialization format.",
  "image": "https://8gwifi.org/images/site/jwsparse.png",
  "url": "https://8gwifi.org/jwsparse.jsp",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Cryptography Tool",
  "browserRequirements": "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem": "Any (Web-based)",
  "softwareVersion": "2.0",
  "datePublished": "2020-01-24",
  "dateModified": "2025-01-23",
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://8gwifi.org",
    "sameAs": "https://x.com/anish2good",
    "jobTitle": "Security Engineer & Cryptography Expert",
    "description": "Experienced security professional specializing in cryptographic implementations and network security tools"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org",
    "logo": {
      "@type": "ImageObject",
      "url": "https://8gwifi.org/images/site/logo.png"
    }
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "description": "Free JWS parsing and decoding, no registration required"
  },
  "featureList": [
    "Parse JWS compact serialization format",
    "Decode Base64URL encoded header and payload",
    "Extract JWT registered claims (iss, sub, aud, exp, nbf, iat, jti)",
    "Display signature in Base64URL format",
    "Support for JWE encrypted tokens",
    "One-click copy for all decoded components",
    "Real-time parsing as you type",
    "Privacy-first - no tokens stored"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "ratingCount": "389",
    "bestRating": "5",
    "worstRating": "1"
  },
  "isAccessibleForFree": true,
  "inLanguage": "en-US"
}
</script>

    <!-- JSON-LD: FAQPage Schema -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is JWS compact serialization format?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JWS compact serialization is a URL-safe string format consisting of three Base64URL-encoded parts separated by dots: header.payload.signature. The header contains algorithm info, the payload contains claims, and the signature ensures integrity."
      }
    },
    {
      "@type": "Question",
      "name": "What information can be extracted from a JWS token?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "From a JWS token you can extract: the header (algorithm, token type, key ID), the payload (all claims including iss, sub, aud, exp, nbf, iat, jti and custom claims), and the signature. Note that parsing does not verify the signature."
      }
    },
    {
      "@type": "Question",
      "name": "Is parsing the same as verifying a JWS?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No. Parsing only decodes and displays the token contents without verifying the signature. To verify a JWS signature, you need the corresponding key (public key for RSA/ECDSA or shared secret for HMAC). Use our JWS Verification tool for signature validation."
      }
    },
    {
      "@type": "Question",
      "name": "What JWT claims are displayed by the parser?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The parser displays all registered JWT claims when present: Issuer (iss), Subject (sub), Audience (aud), Expiration Time (exp), Not Before (nbf), Issued At (iat), and JWT ID (jti). Custom claims in the payload are also shown."
      }
    },
    {
      "@type": "Question",
      "name": "Can this tool parse JWE (encrypted) tokens?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, the parser can identify JWE tokens and display their components including the encrypted key, initialization vector (IV), ciphertext, and authentication tag. However, it cannot decrypt the payload without the decryption key."
      }
    }
  ]
}
</script>

    <!-- JSON-LD: HowTo Schema -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Parse a JWS Token",
  "description": "Step-by-step guide to parsing and decoding JWS/JWT tokens",
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Paste JWS Token",
      "text": "Paste your JWS token in compact serialization format (header.payload.signature) into the input field."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "View Decoded Components",
      "text": "The parser automatically decodes and displays the header, payload, and signature components."
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Examine JWT Claims",
      "text": "Review the extracted JWT claims including issuer, subject, expiration time, and any custom claims."
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Copy or Verify",
      "text": "Copy individual components or use the verification tool to validate the signature with the appropriate key."
    }
  ],
  "totalTime": "PT1M"
}
</script>

    <script type="text/javascript">

        // Store last successful response for download
        var lastParseResponse = null;

        $(document).ready(function() {

            // Real-time parsing on input
            var parseTimeout;
            $('#serialized').on('input', function() {
                clearTimeout(parseTimeout);
                parseTimeout = setTimeout(function() {
                    if ($('#serialized').val().trim().length > 0) {
                        $('#form').submit();
                    }
                }, 500);
            });

            $('#form').submit(function(event) {
                $('#output').html('<div class="text-center py-4"><img src="images/712.GIF" alt="Loading"> <span class="ml-2">Parsing JWS...</span></div>');
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "JWSFunctionality",
                    data: $("#form").serialize(),
                    dataType: 'json',
                    success: function(response) {
                        console.log('Received JSON response:', response);
                        $('#output').empty();
                        lastParseResponse = null;

                        if(response.success) {
                            lastParseResponse = response;

                            var html = '<div class="alert alert-success">';
                            html += '<h5><i class="fas fa-check-circle"></i> JWS Parsed Successfully</h5>';
                            html += '</div>';

                            // Header
                            if(response.jwsHeader) {
                                var formattedHeader = response.jwsHeader;
                                try {
                                    formattedHeader = JSON.stringify(JSON.parse(response.jwsHeader), null, 2);
                                } catch(e) {}
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-file-code text-primary"></i> Header</strong></label>';
                                html += '<textarea id="headerOutput" readonly class="form-control" rows="3" style="font-family: monospace; font-size: 12px;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="headerOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
                            }

                            // Payload
                            if(response.jwsPayload) {
                                var formattedPayload = response.jwsPayload;
                                try {
                                    formattedPayload = JSON.stringify(JSON.parse(response.jwsPayload), null, 2);
                                } catch(e) {}
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-file-alt text-success"></i> Payload</strong></label>';
                                html += '<textarea id="payloadOutput" readonly class="form-control" rows="8" style="font-family: monospace; font-size: 12px;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="payloadOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
                            }

                            // Signature
                            if(response.jwsSignature) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-signature text-warning"></i> Signature (Base64URL)</strong></label>';
                                html += '<textarea id="signatureOutput" readonly class="form-control" rows="3" style="font-family: monospace; font-size: 11px;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="signatureOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
                            }

                            // JWT Claims Section (if any claims present)
                            var hasJwtClaims = response.issuer || response.subject || response.jwtId ||
                                              response.expirationTime || response.notBeforeTime || response.issueTime || response.audienceSize;

                            if(hasJwtClaims) {
                                html += '<hr>';
                                html += '<h5><i class="fas fa-list-alt text-info"></i> JWT Registered Claims</h5>';
                                html += '<div class="table-responsive"><table class="table table-sm table-bordered">';
                                html += '<thead class="thead-light"><tr><th>Claim</th><th>Value</th></tr></thead><tbody>';

                                if(response.issuer) {
                                    html += '<tr><td><code>iss</code> (Issuer)</td><td>' + escapeHtml(response.issuer) + '</td></tr>';
                                }
                                if(response.subject) {
                                    html += '<tr><td><code>sub</code> (Subject)</td><td>' + escapeHtml(response.subject) + '</td></tr>';
                                }
                                if(response.audienceSize) {
                                    html += '<tr><td><code>aud</code> (Audience)</td><td>' + escapeHtml(response.audienceSize) + '</td></tr>';
                                }
                                if(response.expirationTime) {
                                    html += '<tr><td><code>exp</code> (Expiration)</td><td>' + escapeHtml(response.expirationTime) + '</td></tr>';
                                }
                                if(response.notBeforeTime) {
                                    html += '<tr><td><code>nbf</code> (Not Before)</td><td>' + escapeHtml(response.notBeforeTime) + '</td></tr>';
                                }
                                if(response.issueTime) {
                                    html += '<tr><td><code>iat</code> (Issued At)</td><td>' + escapeHtml(response.issueTime) + '</td></tr>';
                                }
                                if(response.jwtId) {
                                    html += '<tr><td><code>jti</code> (JWT ID)</td><td>' + escapeHtml(response.jwtId) + '</td></tr>';
                                }

                                html += '</tbody></table></div>';
                            }

                            // JWE Components (if encrypted)
                            var hasJweComponents = response.encryptedKey || response.iv || response.cipherText || response.authTag;

                            if(hasJweComponents) {
                                html += '<hr>';
                                html += '<h5><i class="fas fa-lock text-danger"></i> JWE Components (Encrypted Token)</h5>';

                                if(response.encryptedKey) {
                                    html += '<div class="form-group">';
                                    html += '<label><strong>Encrypted Key</strong></label>';
                                    html += '<textarea readonly class="form-control" rows="2" style="font-family: monospace; font-size: 11px;">' + escapeHtml(response.encryptedKey) + '</textarea>';
                                    html += '</div>';
                                }
                                if(response.iv) {
                                    html += '<div class="form-group">';
                                    html += '<label><strong>Initialization Vector (IV)</strong></label>';
                                    html += '<input type="text" readonly class="form-control" style="font-family: monospace;" value="' + escapeHtml(response.iv) + '">';
                                    html += '</div>';
                                }
                                if(response.cipherText) {
                                    html += '<div class="form-group">';
                                    html += '<label><strong>Cipher Text</strong></label>';
                                    html += '<textarea readonly class="form-control" rows="3" style="font-family: monospace; font-size: 11px;">' + escapeHtml(response.cipherText) + '</textarea>';
                                    html += '</div>';
                                }
                                if(response.authTag) {
                                    html += '<div class="form-group">';
                                    html += '<label><strong>Authentication Tag</strong></label>';
                                    html += '<input type="text" readonly class="form-control" style="font-family: monospace;" value="' + escapeHtml(response.authTag) + '">';
                                    html += '</div>';
                                }
                            }

                            // Action buttons
                            html += '<hr>';
                            html += '<div class="btn-group" role="group">';
                            html += '<button type="button" class="btn btn-primary" id="downloadJson"><i class="fas fa-download"></i> Download JSON</button>';
                            html += '<button type="button" class="btn btn-info" id="shareUrl"><i class="fas fa-share-alt"></i> Share URL</button>';
                            html += '<a href="jwsverify.jsp" class="btn btn-success"><i class="fas fa-check-double"></i> Verify Signature</a>';
                            html += '</div>';

                            $('#output').html(html);

                            // Set values
                            if(response.jwsHeader) {
                                var formattedHeader = response.jwsHeader;
                                try { formattedHeader = JSON.stringify(JSON.parse(response.jwsHeader), null, 2); } catch(e) {}
                                $('#headerOutput').val(formattedHeader);
                            }
                            if(response.jwsPayload) {
                                var formattedPayload = response.jwsPayload;
                                try { formattedPayload = JSON.stringify(JSON.parse(response.jwsPayload), null, 2); } catch(e) {}
                                $('#payloadOutput').val(formattedPayload);
                            }
                            if(response.jwsSignature) {
                                $('#signatureOutput').val(response.jwsSignature);
                            }

                            // Attach copy handlers
                            $('.copy-btn').off('click').on('click', function() {
                                var targetId = $(this).data('target');
                                var text = $('#' + targetId).val();
                                copyToClipboard(text, this);
                            });

                            // Download JSON handler
                            $('#downloadJson').off('click').on('click', function() {
                                downloadParsedJson();
                            });

                            // Share URL handler
                            $('#shareUrl').off('click').on('click', function() {
                                generateShareUrl();
                            });

                        } else {
                            // Error response
                            var errorMsg = response.errorMessage || 'Unknown error occurred';
                            var html = '<div class="alert alert-danger">';
                            html += '<h5><i class="fas fa-exclamation-triangle"></i> Parsing Failed</h5>';
                            html += '<p>' + errorMsg + '</p>';
                            html += '</div>';
                            $('#output').html(html);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});
                        $('#output').empty();
                        lastParseResponse = null;

                        var errorMessage = 'An error occurred during parsing.';
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

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.appendChild(document.createTextNode(text));
            return div.innerHTML;
        }

        function copyToClipboard(text, button) {
            navigator.clipboard.writeText(text).then(() => {
                const originalHTML = button.innerHTML;
                const originalClasses = button.className;

                button.innerHTML = '<i class="fas fa-check-circle"></i> Copied!';
                button.className = button.className.replace('btn-outline-primary', 'btn-success');
                button.disabled = true;

                setTimeout(() => {
                    button.innerHTML = originalHTML;
                    button.className = originalClasses;
                    button.disabled = false;
                }, 2000);
            }).catch(err => {
                console.error('Failed to copy:', err);
                alert('Failed to copy to clipboard');
            });
        }

        function downloadParsedJson() {
            if (!lastParseResponse) {
                alert('No parsed data available to download');
                return;
            }

            var downloadData = {
                jwsHeader: lastParseResponse.jwsHeader,
                jwsPayload: lastParseResponse.jwsPayload,
                jwsSignature: lastParseResponse.jwsSignature,
                originalInput: lastParseResponse.originalInput,
                parsedAt: new Date().toISOString(),
                tool: "8gwifi.org JWS Parser"
            };

            // Add JWT claims if present
            if(lastParseResponse.issuer) downloadData.issuer = lastParseResponse.issuer;
            if(lastParseResponse.subject) downloadData.subject = lastParseResponse.subject;
            if(lastParseResponse.jwtId) downloadData.jwtId = lastParseResponse.jwtId;
            if(lastParseResponse.expirationTime) downloadData.expirationTime = lastParseResponse.expirationTime;
            if(lastParseResponse.notBeforeTime) downloadData.notBeforeTime = lastParseResponse.notBeforeTime;
            if(lastParseResponse.issueTime) downloadData.issueTime = lastParseResponse.issueTime;

            var jsonStr = JSON.stringify(downloadData, null, 2);
            var blob = new Blob([jsonStr], {type: 'application/json'});
            var url = URL.createObjectURL(blob);

            var date = new Date().toISOString().split('T')[0];
            var filename = '8gwifi.org-jws-parsed-' + date + '.json';

            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        function generateShareUrl() {
            if (!lastParseResponse || !lastParseResponse.originalInput) {
                alert('No JWS data available to share');
                return;
            }

            // Encode the JWS for URL
            var shareData = {
                jws: lastParseResponse.originalInput
            };

            var encoded = btoa(JSON.stringify(shareData));
            var shareUrl = window.location.origin + '/jwsparse.jsp?share=' + encodeURIComponent(encoded);

            // Copy to clipboard
            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('Share URL copied to clipboard!\n\nAnyone with this link can view the parsed JWS token.');
            }).catch(err => {
                prompt('Copy this Share URL:', shareUrl);
            });
        }

        // Handle shared URL on page load
        $(document).ready(function() {
            var urlParams = new URLSearchParams(window.location.search);
            var shareParam = urlParams.get('share');

            if (shareParam) {
                try {
                    var decoded = JSON.parse(atob(decodeURIComponent(shareParam)));
                    if (decoded.jws) {
                        $('#serialized').val(decoded.jws);
                        // Auto-submit after a short delay
                        setTimeout(function() {
                            $('#form').submit();
                        }, 500);
                    }
                } catch(e) {
                    console.error('Error decoding share parameter:', e);
                }
            }
        });
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">JWS Parser & Decoder</h1>

<!-- EEAT: Author & Trust Signals -->
<div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
    <div class="text-muted small">
        <i class="fas fa-user-shield"></i> <strong>By Anish Nath</strong> - Security Engineer & Cryptography Expert
        <span class="mx-2">|</span>
        <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
            <i class="fab fa-x-twitter text-dark"></i> @anish2good
        </a>
        <span class="mx-2">|</span>
        <i class="fas fa-calendar-alt"></i> Last Updated: January 23, 2025
    </div>
    <div class="badge-group">
        <span class="badge badge-success"><i class="fas fa-shield-alt"></i> Privacy-First</span>
        <span class="badge badge-info"><i class="fas fa-lock"></i> No Tokens Stored</span>
        <span class="badge badge-primary"><i class="fas fa-free-code-camp"></i> 100% Free</span>
    </div>
</div>

<hr>

<div class="alert alert-info" role="alert">
    <strong><i class="fas fa-info-circle"></i> How to Use:</strong> Paste your JWS/JWT token in compact serialization format (header.payload.signature). The parser will automatically decode and display the header, payload, signature, and any JWT claims.
    <br><small class="text-muted"><i class="fas fa-exclamation-circle"></i> Note: Parsing only decodes the token - it does not verify the signature. Use the <a href="jwsverify.jsp">JWS Verification</a> tool to validate signatures.</small>
</div>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<form id="form" class="form-horizontal" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="PARSE_JWS">

    <div class="row">
        <!-- Left Column: Input -->
        <div class="col-lg-5 col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-paste"></i> JWS Input</h5>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label for="serialized"><strong><i class="fas fa-key text-info"></i> JWS Serialized Token</strong></label>
                        <textarea class="form-control" name="serialized" id="serialized" rows="12" style="font-family: monospace; font-size: 11px;" placeholder="Paste your JWS/JWT token here...">eyJhbGciOiJIUzI1NiJ9.ew0KICAic3ViIjogIjEyMzQ1Njc4OTAiLA0KICAibmFtZSI6ICJBbmlzaCBOYXRoIiwNCiAgImlhdCI6IDE1MTYyMzkwMjINCn0.9tFLrurxXWKBDh317ly24fP03We-uzSZtPf7Yqy_oSw</textarea>
                        <small class="form-text text-muted">Format: header.payload.signature (Base64URL encoded)</small>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">
                        <i class="fas fa-search"></i> Parse JWS
                    </button>
                </div>
            </div>
        </div>

        <!-- Right Column: Output -->
        <div class="col-lg-7 col-md-6">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-terminal"></i> Parsed Output</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-search fa-4x mb-3 opacity-25"></i>
                            <p class="lead">Parsed JWS components will appear here</p>
                            <p class="small">Paste a JWS token and click "Parse JWS"</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<hr>

<!-- Related Tools -->
<div class="card mb-4">
    <div class="card-header bg-secondary text-white">
        <h5 class="mb-0"><i class="fas fa-tools"></i> Related JWS/JWT Tools</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="jwkfunctions.jsp"><i class="fas fa-key text-primary"></i> JWK Generator</a></li>
                    <li class="mb-2"><a href="jwkconvertfunctions.jsp"><i class="fas fa-exchange-alt text-info"></i> JWK to PEM Converter</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="jwsgen.jsp"><i class="fas fa-plus-circle text-success"></i> JWS Generator</a></li>
                    <li class="mb-2"><a href="jwssign.jsp"><i class="fas fa-signature text-warning"></i> JWS Sign with Custom Key</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="jwsverify.jsp"><i class="fas fa-check-double text-success"></i> JWS Signature Verification</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<!-- JWS Parsing Guide -->
<div class="card mb-4 mt-4">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-book"></i> Understanding JWS Structure</h2>
    </div>
    <div class="card-body">
        <p class="lead">
            A <strong>JSON Web Signature (JWS)</strong> in compact serialization format consists of three Base64URL-encoded parts separated by dots,
            as defined in <a href="https://datatracker.ietf.org/doc/html/rfc7515" target="_blank" rel="noopener noreferrer">RFC 7515</a>.
        </p>

        <h4 class="mt-4"><i class="fas fa-code text-primary"></i> JWS Compact Serialization Format</h4>
        <div class="bg-light p-3 rounded mb-4">
            <code class="text-dark">
                BASE64URL(UTF8(JWS Protected Header)) || '.' ||<br>
                BASE64URL(JWS Payload) || '.' ||<br>
                BASE64URL(JWS Signature)
            </code>
        </div>

        <h4 class="mt-4"><i class="fas fa-layer-group text-success"></i> JWS Components</h4>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Component</th>
                        <th>Description</th>
                        <th>Example Content</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Header</strong></td>
                        <td>Contains algorithm (<code>alg</code>) and token type (<code>typ</code>). May include key ID (<code>kid</code>) for key selection.</td>
                        <td><code>{"alg":"HS256","typ":"JWT"}</code></td>
                    </tr>
                    <tr>
                        <td><strong>Payload</strong></td>
                        <td>Contains the claims (data). For JWT, includes registered claims like <code>iss</code>, <code>sub</code>, <code>exp</code>, etc.</td>
                        <td><code>{"sub":"1234567890","name":"Anish Nath","iat":1516239022}</code></td>
                    </tr>
                    <tr>
                        <td><strong>Signature</strong></td>
                        <td>Cryptographic signature over the header and payload, computed using the specified algorithm.</td>
                        <td><code>9tFLrurxXWKBDh317ly24fP03We-uzSZtPf7Yqy_oSw</code></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h4 class="mt-4"><i class="fas fa-list-alt text-info"></i> JWT Registered Claims</h4>
        <p>When the JWS payload contains a JWT, these registered claims may be present:</p>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="thead-light">
                    <tr>
                        <th>Claim</th>
                        <th>Name</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><code>iss</code></td><td>Issuer</td><td>Identifies the principal that issued the JWT</td></tr>
                    <tr><td><code>sub</code></td><td>Subject</td><td>Identifies the subject of the JWT</td></tr>
                    <tr><td><code>aud</code></td><td>Audience</td><td>Identifies the recipients the JWT is intended for</td></tr>
                    <tr><td><code>exp</code></td><td>Expiration Time</td><td>Time after which the JWT must not be accepted</td></tr>
                    <tr><td><code>nbf</code></td><td>Not Before</td><td>Time before which the JWT must not be accepted</td></tr>
                    <tr><td><code>iat</code></td><td>Issued At</td><td>Time at which the JWT was issued</td></tr>
                    <tr><td><code>jti</code></td><td>JWT ID</td><td>Unique identifier for the JWT</td></tr>
                </tbody>
            </table>
        </div>

        <div class="alert alert-warning mt-4">
            <strong><i class="fas fa-exclamation-triangle"></i> Security Note:</strong>
            Parsing a JWS only decodes its contents - it does NOT verify the signature. An attacker can modify the payload of an unsigned
            or improperly verified token. Always verify signatures before trusting token contents in production systems.
        </div>
    </div>
</div>

<style>
.opacity-25 {
    opacity: 0.25;
}
</style>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
