<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>JWS Signature Verification Online – Free | 8gwifi.org</title>

    <!-- JSON-LD markup -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "JWS Signature Verification Online – Verify JWT/JWS Signatures",
  "alternativeName": "Online JSON Web Signature Verification Tool",
  "description": "Free online JWS (JSON Web Signature) verification tool. Verify JWT and JWS signatures using HMAC shared secrets or RSA/ECDSA public keys. Validate token integrity and authenticity instantly.",
  "url": "https://8gwifi.org/jwsverify.jsp",
  "image": "https://8gwifi.org/images/site/jwsverify.png",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Cryptographic Verification Tool",
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
    "HMAC signature verification (HS256, HS384, HS512)",
    "RSA signature verification (RS256, RS384, RS512, PS256, PS384, PS512)",
    "ECDSA signature verification (ES256, ES384, ES512)",
    "Shared secret key verification",
    "Public key verification (PEM format)",
    "Real-time validation results",
    "JWT token verification",
    "No registration or login required",
    "Free forever with no limits"
  ],
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://8gwifi.org",
    "jobTitle": "Security Engineer & Cryptography Specialist",
    "sameAs": "https://twitter.com/anish2good"
  },
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org",
    "logo": "https://8gwifi.org/images/logo.png"
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
      "name": "How do I verify a JWS signature?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To verify a JWS signature: 1) Paste the JWS token (header.payload.signature format) in the input field. 2) For HMAC-signed tokens (HS256/384/512), enter the shared secret key. 3) For RSA or ECDSA-signed tokens, paste the public key in PEM format. 4) Click 'Verify JWS' to validate the signature."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between HMAC and RSA/ECDSA verification?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "HMAC (HS256/384/512) uses symmetric cryptography - the same secret key is used for both signing and verification. RSA (RS/PS256/384/512) and ECDSA (ES256/384/512) use asymmetric cryptography - tokens are signed with a private key and verified with the corresponding public key. Use the 'Shared Secret' field for HMAC and the 'Public Key' field for RSA/ECDSA."
      }
    },
    {
      "@type": "Question",
      "name": "Why is my JWS signature showing as invalid?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Common reasons for invalid signatures: 1) Wrong key - ensure you're using the correct shared secret or public key. 2) Token modified - any change to header or payload invalidates the signature. 3) Algorithm mismatch - the key type must match the algorithm in the header. 4) Encoding issues - ensure the key is in the correct format (Base64 for secrets, PEM for public keys)."
      }
    },
    {
      "@type": "Question",
      "name": "Can I verify JWT tokens with this tool?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! JWT (JSON Web Token) is built on JWS. Any JWT token in compact serialization format (header.payload.signature) can be verified using this tool. Simply paste the JWT and provide the appropriate key for verification."
      }
    },
    {
      "@type": "Question",
      "name": "Is this JWS verification tool free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, completely free with no registration, login, or payment required. Verify unlimited JWS/JWT tokens using HMAC, RSA, or ECDSA signatures at no cost."
      }
    }
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Verify JWS/JWT Signatures Online",
  "description": "Step-by-step guide to verify JWS and JWT signatures using HMAC secrets or RSA/ECDSA public keys",
  "totalTime": "PT1M",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Paste JWS Token",
      "text": "Paste your JWS or JWT token in the 'JWS Signature Verification' field. The token should be in compact serialization format: header.payload.signature",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Provide Verification Key",
      "text": "For HMAC (HS256/384/512): Enter the shared secret in the 'Shared Secret' field. For RSA/ECDSA: Paste the public key in PEM format in the 'Public Key' field",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Verify Signature",
      "text": "Click 'Verify JWS' button. The tool will validate the signature and display whether it's VALID or INVALID",
      "position": 3
    }
  ]
}
</script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free online JWS signature verification tool. Verify JWT and JWS signatures using HMAC shared secrets or RSA/ECDSA public keys. Validate token integrity instantly."/>
    <meta name="keywords" content="jws verification online, verify jws signature, jwt signature verification, validate jwt, jws validator, hmac verification, rsa signature verify, ecdsa verify, jwt validator free"/>
    <meta name="author" content="Anish Nath"/>
    <meta name="robots" content="index,follow"/>
    <meta name="googlebot" content="index,follow"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>


    <script type="text/javascript">
        $(document).ready(function() {

            // Form submission handler
            $('#form').submit(function (event) {
                event.preventDefault();
                $('#output').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Verifying JWS signature...</div>');

                $.ajax({
                    type: "POST",
                    url: "JWSFunctionality",
                    data: $("#form").serialize(),
                    dataType: 'json',
                    success: function(response) {
                        $('#output').empty();

                        if (response.success) {
                            var isValid = response.message === 'VALID';
                            var html = '';

                            if (isValid) {
                                html = '<div class="alert alert-success">';
                                html += '<h4 class="alert-heading"><i class="fas fa-check-circle fa-2x"></i> SIGNATURE VALID</h4>';
                                html += '<hr>';
                                html += '<p class="mb-0"><i class="fas fa-shield-alt"></i> ' + response.jwsState + '</p>';
                                html += '<p class="small text-muted mt-2 mb-0">The JWS signature has been cryptographically verified. The token integrity is confirmed.</p>';
                                html += '</div>';

                                // Show verification details
                                html += '<div class="card border-success mt-3">';
                                html += '<div class="card-header bg-success text-white"><i class="fas fa-info-circle"></i> Verification Details</div>';
                                html += '<div class="card-body">';
                                html += '<p><strong>Status:</strong> <span class="badge badge-success">Valid</span></p>';
                                html += '<p><strong>Token:</strong></p>';
                                html += '<textarea readonly class="form-control" rows="3" style="font-family: monospace; font-size: 11px;">' + response.jwsSerialize + '</textarea>';
                                html += '</div>';
                                html += '</div>';
                            } else {
                                html = '<div class="alert alert-danger">';
                                html += '<h4 class="alert-heading"><i class="fas fa-times-circle fa-2x"></i> SIGNATURE INVALID</h4>';
                                html += '<hr>';
                                html += '<p class="mb-0"><i class="fas fa-exclamation-triangle"></i> ' + response.jwsState + '</p>';
                                html += '<p class="small mt-2 mb-0">The signature does not match. Possible reasons:</p>';
                                html += '<ul class="small mb-0">';
                                html += '<li>Wrong key (shared secret or public key)</li>';
                                html += '<li>Token has been modified/tampered</li>';
                                html += '<li>Algorithm mismatch</li>';
                                html += '<li>Key encoding issues</li>';
                                html += '</ul>';
                                html += '</div>';
                            }

                            $('#output').html(html);

                        } else {
                            // Error case
                            var html = '<div class="alert alert-danger">';
                            html += '<h5><i class="fas fa-exclamation-triangle"></i> Verification Error</h5>';
                            html += '<p>' + response.errorMessage + '</p>';
                            html += '</div>';
                            $('#output').html(html);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});
                        $('#output').empty();

                        var errorMessage = 'An error occurred during JWS verification.';
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

            // Check for shared JWS from URL parameter
            var urlParams = new URLSearchParams(window.location.search);
            var shareParam = urlParams.get('share');
            if (shareParam) {
                try {
                    var shareData = JSON.parse(atob(decodeURIComponent(shareParam)));
                    if (shareData.jws) {
                        $('#serialized').val(shareData.jws);
                    }
                    if (shareData.pub) {
                        $('#publickey').val(atob(shareData.pub));
                    }
                    // Show info that data was loaded from shared URL
                    $('#output').html('<div class="alert alert-info"><i class="fas fa-share-alt"></i> JWS loaded from shared URL. Click "Verify JWS" to validate the signature.</div>');
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

<h1 class="mt-4">JWS Signature Verification Online</h1>

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
        <span class="badge badge-success"><i class="fas fa-check-circle"></i> HMAC/RSA/ECDSA</span>
        <span class="badge badge-info"><i class="fas fa-lock"></i> No Data Stored</span>
        <span class="badge badge-primary"><i class="fas fa-gift"></i> 100% Free</span>
    </div>
</div>

<hr>

<div class="alert alert-info" role="alert">
    <strong><i class="fas fa-info-circle"></i> How to Verify:</strong>
    Paste your JWS/JWT token below. For <strong>HMAC</strong> tokens (HS256/384/512), enter the shared secret.
    For <strong>RSA/ECDSA</strong> tokens, paste the public key in PEM format. Click "Verify JWS" to validate.
</div>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="Loading" />Loading!
</div>

<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="VERIFY_JWS">

    <div class="row">
        <!-- Left Column: JWS Input -->
        <div class="col-lg-6 col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-code"></i> JWS Token Input</h5>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label for="serialized"><strong>JWS Compact Serialization</strong> <span class="text-danger">*</span></label>
                        <small class="form-text text-muted mb-2">Paste your JWS/JWT token (header.payload.signature)</small>
                        <textarea class="form-control" name="serialized" id="serialized" rows="6" style="font-family: monospace; font-size: 12px;" placeholder="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U">eyJhbGciOiJIUzI1NiJ9.ew0KICAic3ViIjogIjEyMzQ1Njc4OTAiLA0KICAibmFtZSI6ICJBbmlzaCBOYXRoIiwNCiAgImlhdCI6IDE1MTYyMzkwMjINCn0.9tFLrurxXWKBDh317ly24fP03We-uzSZtPf7Yqy_oSw</textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg btn-block">
                        <i class="fas fa-check-double"></i> Verify JWS Signature
                    </button>
                </div>
            </div>
        </div>

        <!-- Right Column: Key Input -->
        <div class="col-lg-6 col-md-6 mb-4">
            <div class="card mb-3">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-key"></i> HMAC Shared Secret</h5>
                </div>
                <div class="card-body">
                    <small class="form-text text-muted mb-2">For HS256, HS384, HS512 algorithms</small>
                    <input type="text" class="form-control" name="sharedsecret" id="sharedsecret"
                           value="03234110-bf8e-455b-9b5b-fae990d5dc9"
                           placeholder="Enter shared secret key"
                           style="font-family: monospace;">
                    <small class="form-text text-muted mt-2"><i class="fas fa-info-circle"></i> The same secret used for signing</small>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0"><i class="fas fa-unlock"></i> RSA/ECDSA Public Key</h5>
                </div>
                <div class="card-body">
                    <small class="form-text text-muted mb-2">For RS256/384/512, PS256/384/512, ES256/384/512</small>
                    <textarea class="form-control" name="publickey" id="publickey" rows="6"
                              style="font-family: monospace; font-size: 11px;"
                              placeholder="-----BEGIN PUBLIC KEY-----
MIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQAUv/w4x...
-----END PUBLIC KEY-----"></textarea>
                    <small class="form-text text-muted mt-2"><i class="fas fa-info-circle"></i> PEM format public key for verification</small>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- Output Section -->
<div class="card mb-4">
    <div class="card-header bg-dark text-white">
        <h5 class="mb-0"><i class="fas fa-terminal"></i> Verification Result</h5>
    </div>
    <div class="card-body">
        <div id="output">
            <div class="text-center text-muted py-4">
                <i class="fas fa-check-double fa-4x mb-3 opacity-25"></i>
                <p class="lead">Verification result will appear here</p>
                <p class="small">Paste a JWS token and click "Verify JWS Signature"</p>
            </div>
        </div>
    </div>
</div>

<hr>

<!-- Related Tools -->
<div class="card mb-4">
    <div class="card-body">
        <h5 class="card-title mb-3"><i class="fas fa-tools text-primary"></i> Related JWS/JWT Tools</h5>
        <div class="row">
            <div class="col-md-6">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="jwsgen.jsp" class="text-decoration-none"><i class="fas fa-signature text-success"></i> JWS Generator</a> - Generate keys & sign payloads</li>
                    <li class="mb-2"><a href="jwsparse.jsp" class="text-decoration-none"><i class="fas fa-search text-info"></i> JWS Parser</a> - Decode and inspect JWS tokens</li>
                    <li class="mb-2"><a href="jwssign.jsp" class="text-decoration-none"><i class="fas fa-pen text-primary"></i> JWS Sign</a> - Sign with custom keys</li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="jwkfunctions.jsp" class="text-decoration-none"><i class="fas fa-key text-warning"></i> JWK Generator</a> - Generate JSON Web Keys</li>
                    <li class="mb-2"><a href="jwkconvertfunctions.jsp" class="text-decoration-none"><i class="fas fa-exchange-alt text-info"></i> JWK to PEM</a> - Convert key formats</li>
                    <li class="mb-2"><a href="jwtparser.jsp" class="text-decoration-none"><i class="fas fa-id-card text-success"></i> JWT Parser</a> - Decode JWT tokens</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

<!-- JWS Verification Guide -->
<div class="card mb-4 mt-4">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-book"></i> JWS Signature Verification Guide</h2>
    </div>
    <div class="card-body">
        <p class="lead">
            <strong>JWS Signature Verification</strong> is the process of cryptographically validating that a JSON Web Signature token has not been tampered with and was signed by a trusted party.
        </p>

        <!-- How Verification Works -->
        <h5 class="mt-4"><i class="fas fa-cogs text-primary"></i> How JWS Verification Works</h5>
        <div class="row">
            <div class="col-md-6">
                <div class="card border-success mb-3">
                    <div class="card-header bg-success text-white"><i class="fas fa-key"></i> HMAC Verification (Symmetric)</div>
                    <div class="card-body">
                        <ol class="small mb-0">
                            <li>Extract the algorithm from the header</li>
                            <li>Compute HMAC over <code>header.payload</code> using the shared secret</li>
                            <li>Compare computed signature with the token's signature</li>
                            <li>If they match, signature is <strong>VALID</strong></li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-primary mb-3">
                    <div class="card-header bg-primary text-white"><i class="fas fa-lock"></i> RSA/ECDSA Verification (Asymmetric)</div>
                    <div class="card-body">
                        <ol class="small mb-0">
                            <li>Extract the algorithm from the header</li>
                            <li>Decode the signature from Base64URL</li>
                            <li>Use the public key to verify the signature over <code>header.payload</code></li>
                            <li>If verification succeeds, signature is <strong>VALID</strong></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <!-- Common Verification Errors -->
        <h5 class="mt-4"><i class="fas fa-exclamation-triangle text-warning"></i> Common Verification Errors</h5>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="thead-light">
                    <tr>
                        <th>Error</th>
                        <th>Cause</th>
                        <th>Solution</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Signature Invalid</td>
                        <td>Wrong key or modified token</td>
                        <td>Verify you're using the correct key that matches the signing key</td>
                    </tr>
                    <tr>
                        <td>Algorithm Mismatch</td>
                        <td>Using HMAC key with RSA algorithm or vice versa</td>
                        <td>Check the <code>alg</code> header and use the appropriate key type</td>
                    </tr>
                    <tr>
                        <td>Key Format Error</td>
                        <td>Invalid PEM format or encoding</td>
                        <td>Ensure public keys include BEGIN/END markers and proper Base64 encoding</td>
                    </tr>
                    <tr>
                        <td>Invalid JWS Format</td>
                        <td>Token doesn't have three parts</td>
                        <td>JWS must be in format: header.payload.signature</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Security Best Practices -->
        <h5 class="mt-4"><i class="fas fa-shield-alt text-danger"></i> Verification Security Best Practices</h5>
        <div class="alert alert-warning">
            <ul class="mb-0">
                <li><strong>Always verify signatures</strong> - Never trust a JWS/JWT without cryptographic verification</li>
                <li><strong>Whitelist algorithms</strong> - Only accept expected algorithms, reject <code>alg: none</code></li>
                <li><strong>Validate claims after verification</strong> - Check <code>exp</code>, <code>nbf</code>, <code>iss</code>, <code>aud</code></li>
                <li><strong>Use constant-time comparison</strong> - Prevent timing attacks (handled by crypto libraries)</li>
                <li><strong>Protect your keys</strong> - Keep shared secrets and private keys secure</li>
            </ul>
        </div>

        <!-- JWS Structure Reference -->
        <h5 class="mt-4"><i class="fas fa-layer-group text-info"></i> JWS Structure Reference</h5>
        <div class="bg-dark text-white p-3 rounded mb-3" style="font-family: monospace; word-break: break-all;">
            <span class="text-info">eyJhbGciOiJIUzI1NiJ9</span>.<span class="text-warning">eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkFuaXNoIE5hdGgiLCJpYXQiOjE1MTYyMzkwMjJ9</span>.<span class="text-success">9tFLrurxXWKBDh317ly24fP03We-uzSZtPf7Yqy_oSw</span>
        </div>
        <div class="row">
            <div class="col-md-4">
                <p class="small"><span class="badge badge-info">Header</span> - Contains <code>alg</code> (algorithm) and optionally <code>typ</code>, <code>kid</code></p>
            </div>
            <div class="col-md-4">
                <p class="small"><span class="badge badge-warning">Payload</span> - Contains claims (<code>sub</code>, <code>name</code>, <code>iat</code>, <code>exp</code>, etc.)</p>
            </div>
            <div class="col-md-4">
                <p class="small"><span class="badge badge-success">Signature</span> - Cryptographic signature over header.payload</p>
            </div>
        </div>
    </div>
</div>

<!-- EEAT: About Section -->
<div class="card border-primary mb-4">
    <div class="card-header bg-primary text-white">
        <h3 class="h5 mb-0"><i class="fas fa-user-shield"></i> About This Tool</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-8">
                <p>
                    This JWS verification tool is developed by <strong>Anish Nath</strong>
                    (<a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer"><i class="fab fa-x-twitter"></i> @anish2good</a>),
                    a Security Engineer specializing in cryptography and web security.
                </p>
                <ul>
                    <li><strong>Privacy-First:</strong> Your tokens and keys are processed server-side and not stored</li>
                    <li><strong>Standards Compliant:</strong> Implements RFC 7515 (JWS) verification</li>
                    <li><strong>All Algorithms:</strong> Supports HMAC, RSA PKCS#1, RSA PSS, and ECDSA</li>
                </ul>
            </div>
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body text-center">
                        <h6><i class="fas fa-book-open text-primary"></i> Learn More</h6>
                        <ul class="list-unstyled small">
                            <li><a href="https://datatracker.ietf.org/doc/html/rfc7515" target="_blank" rel="noopener">RFC 7515 (JWS)</a></li>
                            <li><a href="https://datatracker.ietf.org/doc/html/rfc7519" target="_blank" rel="noopener">RFC 7519 (JWT)</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.opacity-25 { opacity: 0.25; }
</style>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
