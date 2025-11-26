<%@ page import="java.util.UUID" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>JWS Sign Payload with Custom Key Online – Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Sign JSON payloads with custom keys using JWS (RFC 7515). Free online tool supporting HMAC (HS256/384/512), RSA (RS/PS256/384/512), and ECDSA (ES256/384/512) algorithms.">
    <meta name="keywords" content="jws sign payload, jws custom key signing, sign jwt with custom key, hmac jwt signing, rsa jwt signing, ecdsa jwt signing, jws hs256, jws rs256, jws es256, json web signature online">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/jwssign.jsp">
    <meta property="og:title" content="JWS Sign Payload with Custom Key Online – Free | 8gwifi.org">
    <meta property="og:description" content="Sign JSON payloads with custom keys using JWS. Supports HMAC, RSA PKCS#1, RSA-PSS, and ECDSA algorithms.">
    <meta property="og:image" content="https://8gwifi.org/images/site/jwssign.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/jwssign.jsp">
    <meta name="twitter:title" content="JWS Sign Payload with Custom Key Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Sign JSON payloads with custom keys using JWS. Supports HMAC, RSA PKCS#1, RSA-PSS, and ECDSA algorithms.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/jwssign.png">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/jwssign.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD: WebApplication Schema -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "JWS Sign Payload with Custom Key Online",
  "alternateName": "JWS Custom Key Signer, JWT Custom Key Signing Tool",
  "description": "Free online tool to sign JSON payloads with custom keys using JSON Web Signature (JWS) standards. Supports HMAC (HS256/384/512), RSA PKCS#1 (RS256/384/512), RSA-PSS (PS256/384/512), and ECDSA (ES256/384/512) algorithms.",
  "image": "https://8gwifi.org/images/site/jwssign.png",
  "url": "https://8gwifi.org/jwssign.jsp",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Cryptography Tool",
  "browserRequirements": "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem": "Any (Web-based)",
  "softwareVersion": "2.0",
  "datePublished": "2020-01-27",
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
    "description": "Free JWS signing with custom keys, no registration required"
  },
  "featureList": [
    "Sign with HMAC shared secrets (HS256, HS384, HS512)",
    "Sign with RSA private keys (RS256, RS384, RS512)",
    "Sign with RSA-PSS keys (PS256, PS384, PS512)",
    "Sign with ECDSA keys (ES256, ES384, ES512)",
    "Bring your own key support",
    "Download signed JWS as JSON",
    "Share URL for verification",
    "Privacy-first - no keys stored"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.6",
    "ratingCount": "412",
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
      "name": "What is the difference between JWS generation and JWS signing with custom key?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JWS generation creates a new key pair and signs the payload in one step. JWS signing with custom key allows you to use your own existing keys (HMAC secret, RSA private key, or EC private key) to sign payloads, giving you full control over key management."
      }
    },
    {
      "@type": "Question",
      "name": "Which algorithm should I use for JWS signing?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For symmetric signing with shared secrets, use HS256 (or HS384/HS512 for higher security). For asymmetric signing, RS256 is widely compatible, PS256 offers better security with RSA-PSS, and ES256 provides excellent security with smaller signatures using elliptic curves."
      }
    },
    {
      "@type": "Question",
      "name": "What key format does this tool accept?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For HMAC algorithms (HS256/384/512), provide a plain text shared secret. For RSA algorithms (RS/PS256/384/512), provide a PEM-formatted RSA private key. For ECDSA algorithms (ES256/384/512), provide a PEM-formatted EC private key with the appropriate curve (P-256 for ES256, P-384 for ES384, P-521 for ES512)."
      }
    },
    {
      "@type": "Question",
      "name": "Can I verify the JWS signature after signing?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! Use the Share URL feature to generate a verification link. For HMAC signatures, you'll need to manually enter the shared secret on the verification page. For RSA/ECDSA, the public key can be derived from the private key for verification."
      }
    },
    {
      "@type": "Question",
      "name": "What is the minimum secret length for HMAC algorithms?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "HS256 requires at least 32 bytes (256 bits), HS384 requires at least 48 bytes (384 bits), and HS512 requires at least 64 bytes (512 bits) for the shared secret. Using shorter secrets will result in an error."
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
  "name": "How to Sign a JWS with Custom Key",
  "description": "Step-by-step guide to signing JSON payloads with your own keys using JWS",
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Select Algorithm",
      "text": "Choose a JWS algorithm based on your key type: HMAC (HS256/384/512) for shared secrets, RSA (RS/PS256/384/512) for RSA keys, or ECDSA (ES256/384/512) for elliptic curve keys."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Enter Payload",
      "text": "Enter your JSON payload in the Payload field. This will become the claims in your signed JWT/JWS."
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Provide Your Key",
      "text": "For HMAC: enter your shared secret. For RSA/ECDSA: paste your PEM-formatted private key. The tool provides sample keys for testing."
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Sign and Export",
      "text": "Click Sign to generate the JWS. Download the result as JSON or use the Share URL to verify the signature."
    }
  ],
  "totalTime": "PT2M"
}
</script>

    <script type="text/javascript">

        var ec256="-----BEGIN EC PRIVATE KEY-----\n" +
                "MHcCAQEEIJ9dBOzljC0Sjm+ExwqYSimlB/FoRIG4Ck7GT4WXtsz5oAoGCCqGSM49\n" +
                "AwEHoUQDQgAEpJAJb5GRI38F8ENaXj9dDw0C5IH735J1WK39+nOqppMkV172zQEw\n" +
                "1ZvCamjxE8QeSkLEAUAYs2jt36dNObIuPg==\n" +
                "-----END EC PRIVATE KEY-----";

        var ec384="-----BEGIN EC PRIVATE KEY-----\n" +
                "MIGkAgEBBDCIYUdofVNWXqGoIlvHsBENRegvswCzArOtKhDHQZ6rOrYHlRJ3BrYF\n" +
                "UJt1d1qmiDugBwYFK4EEACKhZANiAASGN1KVmdWtxUSko2lWV4lHjaXLtz/ylH37\n" +
                "DbwZoqN/owVyCtwYXhjL+8VjT1XGliPFFJAzKjkq4N88U3FjZk7cM3fqyPpyknlg\n" +
                "+Iuc9+VsX8LNx+QPSf312kJtQBWTpsM=\n" +
                "-----END EC PRIVATE KEY-----";

        var ec512="-----BEGIN EC PRIVATE KEY-----\n" +
                "MIHcAgEBBEIA9t5Rfgyuid5fjqJYQwPDfPTo9psgtCp95ARjRacGj7bFPLxN49iK\n" +
                "Pl0bZGVG5PhT01vKRzloPv6WUGxddHa/jQigBwYFK4EEACOhgYkDgYYABADf+Gmd\n" +
                "ZeVvDlLyNdvymp6JdPMi2nu0ggAQrq55HJr++pzTYQ2jcXRrJfFC7UdlPVLEj2Fy\n" +
                "fsTmLtjSxPTCLz1YPgA4BBQGj0A09RAF2EI9aTtYLttfHH7LS6J8b15sr/+DVs7N\n" +
                "Ap1KteIXON6oTeVvYb9oTKvHl9cm7OI373ztaWWKjQ==\n" +
                "-----END EC PRIVATE KEY-----";

        var rsakey = "-----BEGIN RSA PRIVATE KEY-----\n" +
                "MIIEowIBAAKCAQEAzqyzjjC6Mu679TyTrokg1ifH8SsqyLNhpyn/ToyxLahJPPty\n" +
                "DcC+QwRuIzhLR2JbrMNVbWd3LjfPlXLaqHL23v9EOYSe8is+iKSsXW0CrsdiztNn\n" +
                "Y1ZczzUdN+4Ic7CQZxHYdI1IRumd5O1q0AjVOMpwPoZtvmvkqEnfhnoUOPo1hH5X\n" +
                "Y7rmTWEMg0JPZked2zljGKEIBt1gmRvwxuDwBKteycveUHDe7+fvH5TwdVoHEbNs\n" +
                "HCRrO1RpmBd5TG1PrCXVB/wSiyBsxld7H6JYzE7ic8uGT98BLvZGE0qV9D0fR4z+\n" +
                "XIow073ZOIa9v8aPu/2QIpbv6x0re5gPRTAnfwIDAQABAoIBAQCEIk453lVtMszg\n" +
                "oXYZ5Hol8REX021rG6SXZ3ZfFfxBIJKSdoAY4t3Boxd3VQpr/Sp3bfs0Ey5TUkNZ\n" +
                "XTEG+Vl0gOdxjqTAV32HhyDcKlHIxJkbenVjQVfc8ixYEcs9i+kGvJYTDjDjhYD5\n" +
                "WAEuODd6M5NHplKLqBdssK5EH9DGC6uU9sYxHqGTIeh3/RGg2uxRyH92CukajEgn\n" +
                "OSDw7lWLZt9GhOw/CHrCc/UDhfhnT3V0N7DC1sIOkMVxg7Hf8jlxYkp03hTmMw7s\n" +
                "4NKK5Bjnj2wyC/20SHnDw+WU7mW8aXygcsp3Rhpy4GADwHvXcJM4xv7t6tNvBEui\n" +
                "ilvrB/ahAoGBAPLgv6LbNg31lMs3Dq1VboT2yUiW1rCESEhnmNAV3reuFLt15bRN\n" +
                "N0oiD5bEAYViMHFvhXNrOtHP/xP9UIMXl9OZTrugE+65AAfYdp1M4VEv5Bqu6a9M\n" +
                "GrL+M0k0phiOUlqpn1wiVqM8pLTNOqPo85dtVKVLIkahblipyvdupT5tAoGBANnX\n" +
                "OUwOfUCjcK8dljwxFHPmPczZK5ckBNaTzHGx0dDBKjvqzz9r6vMYyIlJvdIT+EL7\n" +
                "eSPokDhKP/l6wUVqc+pFppzrBP3juRVITgPmtGVclH/cMixBuy1XwaKo5qecndoJ\n" +
                "yCBSGXEKES6Pg1X7/lVKOQlozxovdhvHCSZF6ZobAoGAeUNPSu9p2KRhquiNUmuS\n" +
                "J57TtoNhI3aYZFYdDN+ueETZIxNlIZVf4oqI//xSyhbRGwHUPmEuV+0ibQePuDQC\n" +
                "YOptTe5JpWoGouQnrLfi01c26z+jextjRTT3xDgeKap9YbjI0QZv/UZc8cx517aK\n" +
                "UHOMzI5ryZn17xyvMsSyii0CgYBHuU9KNXMT9zxAzBMNGnPLfUFX0yFBEEDvjZZA\n" +
                "0PVuMEuBktxN23BuPfi5CyiOpLiXBUlrg0UI45mQwNQl0Nj9h5VGETOBjJsB4N6e\n" +
                "9jTrMsJKHuv+Gl5QnZZJwia/hReMFLBpw95Qk6n4lJP/mYqx9lA1Qub9jibrGmtu\n" +
                "yJIThQKBgFffqhO7ZGWOmoMSKUyTemKJ8LwSPJTWKiOtxjK1g5wuVCoPWBj3WOhO\n" +
                "zusqafhdJNFsI1cy0ZiRsRcegLK5VWehaPywj0zVf+tDqbb8teOayakn/4RQ1lIF\n" +
                "BaDd01ooIX8Uuydf06TiZt4u11ikjPFv1TY6HFqMnb7USjp+Ge07\n" +
                "-----END RSA PRIVATE KEY-----\n";

        // Store last successful response for download/share
        var lastJwsResponse = null;

        $(document).ready(function() {

            $("#key1").hide();

            // Algorithm click handlers - show/hide appropriate input fields
            $('#HS256, #HS384, #HS512').click(function(event) {
                $("#key1").hide();
                $("#sharedsecret1").show();
            });

            $('#RS256, #RS384, #RS512, #PS256, #PS384, #PS512').click(function(event) {
                $("#sharedsecret1").hide();
                $("#key1").show();
                $("#key").val(rsakey);
            });

            $('#ES256').click(function(event) {
                $("#sharedsecret1").hide();
                $("#key1").show();
                $("#key").val(ec256);
            });

            $('#ES384').click(function(event) {
                $("#sharedsecret1").hide();
                $("#key1").show();
                $("#key").val(ec384);
            });

            $('#ES512').click(function(event) {
                $("#sharedsecret1").hide();
                $("#key1").show();
                $("#key").val(ec512);
            });

            $('#form').submit(function(event) {
                $('#output').html('<div class="text-center py-4"><img src="images/712.GIF" alt="Loading"> <span class="ml-2">Signing payload...</span></div>');
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "JWSFunctionality",
                    data: $("#form").serialize(),
                    dataType: 'json',
                    success: function(response) {
                        console.log('Received JSON response:', response);
                        $('#output').empty();
                        lastJwsResponse = null;

                        if(response.success) {
                            lastJwsResponse = response;

                            var html = '<div class="alert alert-success">';
                            html += '<h5><i class="fas fa-check-circle"></i> JWS Signed Successfully</h5>';
                            html += '<small>Algorithm: <strong>' + (response.algorithm || 'N/A') + '</strong></small>';
                            html += '</div>';

                            // JWS Header
                            if(response.jwsHeader) {
                                var formattedHeader = response.jwsHeader;
                                try {
                                    formattedHeader = JSON.stringify(JSON.parse(response.jwsHeader), null, 2);
                                } catch(e) {}
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-file-code text-info"></i> JWS Header</strong></label>';
                                html += '<textarea id="jwsHeaderOutput" readonly class="form-control" rows="3" style="font-family: monospace; font-size: 12px;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="jwsHeaderOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
                            }

                            // JWS Serialized (compact form)
                            if(response.jwsSerialize) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-key text-success"></i> JWS Compact Serialization</strong></label>';
                                html += '<textarea id="jwsSerializeOutput" readonly class="form-control" rows="5" style="font-family: monospace; font-size: 11px; word-break: break-all;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="jwsSerializeOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
                            }

                            // JWS Signature
                            if(response.jwsSignature) {
                                html += '<div class="form-group">';
                                html += '<label><strong><i class="fas fa-signature text-warning"></i> Signature (Base64URL)</strong></label>';
                                html += '<textarea id="jwsSignatureOutput" readonly class="form-control" rows="3" style="font-family: monospace; font-size: 11px;"></textarea>';
                                html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="jwsSignatureOutput"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div>';
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
                                $('#jwsHeaderOutput').val(formattedHeader);
                            }
                            if(response.jwsSerialize) {
                                $('#jwsSerializeOutput').val(response.jwsSerialize);
                            }
                            if(response.jwsSignature) {
                                $('#jwsSignatureOutput').val(response.jwsSignature);
                            }

                            // Attach copy handlers
                            $('.copy-btn').off('click').on('click', function() {
                                var targetId = $(this).data('target');
                                var text = $('#' + targetId).val();
                                copyToClipboard(text, this);
                            });

                            // Download JSON handler
                            $('#downloadJson').off('click').on('click', function() {
                                downloadJwsJson();
                            });

                            // Share URL handler
                            $('#shareUrl').off('click').on('click', function() {
                                generateShareUrl();
                            });

                        } else {
                            // Error response
                            var errorMsg = response.errorMessage || 'Unknown error occurred';
                            var html = '<div class="alert alert-danger">';
                            html += '<h5><i class="fas fa-exclamation-triangle"></i> Signing Failed</h5>';
                            if(response.algorithm) {
                                html += '<p><small>Algorithm: ' + response.algorithm + '</small></p>';
                            }
                            html += '<p>' + errorMsg + '</p>';
                            html += '</div>';
                            $('#output').html(html);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});
                        $('#output').empty();
                        lastJwsResponse = null;

                        var errorMessage = 'An error occurred during signing.';
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

        function copyToClipboard(text, button) {
            navigator.clipboard.writeText(text).then(() => {
                const originalHTML = button.innerHTML;
                const originalClasses = button.className;

                button.innerHTML = '<i class="fas fa-check-circle"></i> Copied!';
                button.className = button.className.replace('btn-outline-primary', 'btn-success').replace('btn-primary', 'btn-success');
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

        function downloadJwsJson() {
            if (!lastJwsResponse) {
                alert('No JWS data available to download');
                return;
            }

            var downloadData = {
                algorithm: lastJwsResponse.algorithm,
                jwsHeader: lastJwsResponse.jwsHeader,
                jwsSerialize: lastJwsResponse.jwsSerialize,
                jwsSignature: lastJwsResponse.jwsSignature,
                payload: lastJwsResponse.originalMessage,
                generatedAt: new Date().toISOString(),
                tool: "8gwifi.org JWS Sign with Custom Key"
            };

            var jsonStr = JSON.stringify(downloadData, null, 2);
            var blob = new Blob([jsonStr], {type: 'application/json'});
            var url = URL.createObjectURL(blob);

            var date = new Date().toISOString().split('T')[0];
            var filename = '8gwifi.org-jws-signed-' + date + '.json';

            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        function generateShareUrl() {
            if (!lastJwsResponse || !lastJwsResponse.jwsSerialize) {
                alert('No JWS data available to share');
                return;
            }

            // Encode the JWS for URL (note: for HMAC, user needs to provide secret on verification page)
            var shareData = {
                jws: lastJwsResponse.jwsSerialize
            };

            var encoded = btoa(JSON.stringify(shareData));
            var shareUrl = window.location.origin + '/jwsverify.jsp?share=' + encodeURIComponent(encoded);

            // Copy to clipboard and show modal
            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('Share URL copied to clipboard!\n\nNote: For HMAC-signed JWS, the verifier will need to enter the shared secret manually.');
            }).catch(err => {
                prompt('Copy this Share URL:', shareUrl);
            });
        }
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">JWS Sign Payload with Custom Key</h1>

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
        <span class="badge badge-info"><i class="fas fa-lock"></i> No Keys Stored</span>
        <span class="badge badge-primary"><i class="fas fa-free-code-camp"></i> 100% Free</span>
    </div>
</div>

<hr>

<div class="alert alert-info" role="alert">
    <strong><i class="fas fa-info-circle"></i> How to Use:</strong> Select an algorithm, enter your JSON payload, and provide your own key (shared secret for HMAC, or PEM private key for RSA/ECDSA). Click "Sign Payload" to generate a JWS. Sample keys are provided for testing.
</div>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<form id="form" class="form-horizontal" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="SIGN_JSON">

    <div class="row">
        <!-- Left Column: Input Form -->
        <div class="col-lg-5 col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-edit"></i> Sign Configuration</h5>
                </div>
                <div class="card-body">

                    <!-- Algorithm Selection -->
                    <h6 class="mb-3"><i class="fas fa-cog text-primary"></i> Select Algorithm</h6>

                    <!-- HMAC Algorithms -->
                    <p class="mb-2 text-muted small"><strong>HMAC (Symmetric)</strong></p>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" checked type="radio" name="algo" id="HS256" value="HS256">
                        <label class="form-check-label" for="HS256">HS256</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="HS384" value="HS384">
                        <label class="form-check-label" for="HS384">HS384</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="HS512" value="HS512">
                        <label class="form-check-label" for="HS512">HS512</label>
                    </div>

                    <!-- RSA PKCS#1 Algorithms -->
                    <p class="mb-2 mt-3 text-muted small"><strong>RSA PKCS#1 v1.5</strong></p>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="RS256" value="RS256">
                        <label class="form-check-label" for="RS256">RS256</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="RS384" value="RS384">
                        <label class="form-check-label" for="RS384">RS384</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="RS512" value="RS512">
                        <label class="form-check-label" for="RS512">RS512</label>
                    </div>

                    <!-- RSA-PSS Algorithms -->
                    <p class="mb-2 mt-3 text-muted small"><strong>RSA-PSS</strong></p>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="PS256" value="PS256">
                        <label class="form-check-label" for="PS256">PS256</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="PS384" value="PS384">
                        <label class="form-check-label" for="PS384">PS384</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="PS512" value="PS512">
                        <label class="form-check-label" for="PS512">PS512</label>
                    </div>

                    <!-- ECDSA Algorithms -->
                    <p class="mb-2 mt-3 text-muted small"><strong>ECDSA (Elliptic Curve)</strong></p>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="ES256" value="ES256">
                        <label class="form-check-label" for="ES256">ES256</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="ES384" value="ES384">
                        <label class="form-check-label" for="ES384">ES384</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="algo" id="ES512" value="ES512">
                        <label class="form-check-label" for="ES512">ES512</label>
                    </div>

                    <hr>

                    <!-- Payload Input -->
                    <div class="form-group">
                        <label for="payload"><strong><i class="fas fa-file-alt text-info"></i> Payload (JSON)</strong></label>
                        <textarea class="form-control" name="payload" id="payload" rows="6" style="font-family: monospace; font-size: 12px;">{
  "sub": "1234567890",
  "name": "Anish Nath",
  "iat": 1516239022
}</textarea>
                        <small class="form-text text-muted">Enter your JSON payload (JWT claims)</small>
                    </div>

                    <!-- Shared Secret (for HMAC) -->
                    <div id="sharedsecret1" class="form-group">
                        <label for="sharedsecret"><strong><i class="fas fa-key text-warning"></i> Shared Secret</strong></label>
                        <input type="text" class="form-control" name="sharedsecret" id="sharedsecret" value="<%=UUID.randomUUID().toString()%>" style="font-family: monospace;">
                        <small class="form-text text-muted">Your HMAC secret key (min 32 bytes for HS256, 48 for HS384, 64 for HS512)</small>
                    </div>

                    <!-- PEM Key (for RSA/EC) -->
                    <div id="key1" class="form-group">
                        <label for="key"><strong><i class="fas fa-lock text-danger"></i> Private Key (PEM)</strong></label>
                        <textarea class="form-control" name="key" id="key" rows="8" style="font-family: monospace; font-size: 11px;"></textarea>
                        <small class="form-text text-muted">RSA or EC private key in PEM format. Sample keys provided when you select an algorithm.</small>
                    </div>

                    <hr>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">
                        <i class="fas fa-signature"></i> Sign Payload
                    </button>
                </div>
            </div>
        </div>

        <!-- Right Column: Output -->
        <div class="col-lg-7 col-md-6">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-terminal"></i> Signed JWS Output</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-signature fa-4x mb-3 opacity-25"></i>
                            <p class="lead">Your signed JWS will appear here</p>
                            <p class="small">Select an algorithm, enter payload and key, then click "Sign Payload"</p>
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
                    <li class="mb-2"><a href="jwsgen.jsp"><i class="fas fa-plus-circle text-success"></i> JWS Generator (Auto Key)</a></li>
                    <li class="mb-2"><a href="jwsparse.jsp"><i class="fas fa-search text-warning"></i> JWS Parser</a></li>
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

<!-- JWS Signing Guide -->
<div class="card mb-4 mt-4">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-book"></i> JWS Signing with Custom Keys Guide</h2>
    </div>
    <div class="card-body">
        <p class="lead">
            <strong>JSON Web Signature (JWS)</strong> represents content secured with digital signatures or Message Authentication Codes (MACs)
            using JSON-based data structures, as defined in <a href="https://datatracker.ietf.org/doc/html/rfc7515" target="_blank" rel="noopener noreferrer">RFC 7515</a>.
        </p>

        <h4 class="mt-4"><i class="fas fa-key text-primary"></i> When to Use Custom Key Signing</h4>
        <p>Use this tool when you need to:</p>
        <ul>
            <li><strong>Integrate with existing systems:</strong> Sign JWS using keys already deployed in your infrastructure</li>
            <li><strong>Key management control:</strong> Maintain full control over key generation and storage</li>
            <li><strong>Testing and debugging:</strong> Sign JWS with specific keys for testing verification flows</li>
            <li><strong>Interoperability testing:</strong> Verify compatibility with third-party systems using their provided keys</li>
        </ul>

        <h4 class="mt-4"><i class="fas fa-lock text-success"></i> Algorithm Comparison</h4>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Algorithm</th>
                        <th>Type</th>
                        <th>Key Type</th>
                        <th>Hash</th>
                        <th>Use Case</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>HS256</code></td>
                        <td>HMAC</td>
                        <td>Shared Secret (32+ bytes)</td>
                        <td>SHA-256</td>
                        <td>Internal APIs, microservices</td>
                    </tr>
                    <tr>
                        <td><code>HS384</code></td>
                        <td>HMAC</td>
                        <td>Shared Secret (48+ bytes)</td>
                        <td>SHA-384</td>
                        <td>Higher security internal use</td>
                    </tr>
                    <tr>
                        <td><code>HS512</code></td>
                        <td>HMAC</td>
                        <td>Shared Secret (64+ bytes)</td>
                        <td>SHA-512</td>
                        <td>Maximum HMAC security</td>
                    </tr>
                    <tr>
                        <td><code>RS256</code></td>
                        <td>RSA PKCS#1</td>
                        <td>RSA Private Key</td>
                        <td>SHA-256</td>
                        <td>Widely compatible, OAuth 2.0</td>
                    </tr>
                    <tr>
                        <td><code>RS384</code></td>
                        <td>RSA PKCS#1</td>
                        <td>RSA Private Key</td>
                        <td>SHA-384</td>
                        <td>Higher RSA security</td>
                    </tr>
                    <tr>
                        <td><code>RS512</code></td>
                        <td>RSA PKCS#1</td>
                        <td>RSA Private Key</td>
                        <td>SHA-512</td>
                        <td>Maximum RSA security</td>
                    </tr>
                    <tr>
                        <td><code>PS256</code></td>
                        <td>RSA-PSS</td>
                        <td>RSA Private Key</td>
                        <td>SHA-256</td>
                        <td>More secure than PKCS#1</td>
                    </tr>
                    <tr>
                        <td><code>PS384</code></td>
                        <td>RSA-PSS</td>
                        <td>RSA Private Key</td>
                        <td>SHA-384</td>
                        <td>High security RSA-PSS</td>
                    </tr>
                    <tr>
                        <td><code>PS512</code></td>
                        <td>RSA-PSS</td>
                        <td>RSA Private Key</td>
                        <td>SHA-512</td>
                        <td>Maximum RSA-PSS security</td>
                    </tr>
                    <tr>
                        <td><code>ES256</code></td>
                        <td>ECDSA</td>
                        <td>EC P-256 Private Key</td>
                        <td>SHA-256</td>
                        <td>Modern, compact signatures</td>
                    </tr>
                    <tr>
                        <td><code>ES384</code></td>
                        <td>ECDSA</td>
                        <td>EC P-384 Private Key</td>
                        <td>SHA-384</td>
                        <td>Higher EC security</td>
                    </tr>
                    <tr>
                        <td><code>ES512</code></td>
                        <td>ECDSA</td>
                        <td>EC P-521 Private Key</td>
                        <td>SHA-512</td>
                        <td>Maximum EC security</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h4 class="mt-4"><i class="fas fa-file-code text-info"></i> Key Format Requirements</h4>
        <div class="row">
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h6><i class="fas fa-hashtag text-warning"></i> HMAC Keys</h6>
                        <p class="small mb-0">Plain text shared secret. Minimum lengths:</p>
                        <ul class="small mb-0">
                            <li>HS256: 32 bytes</li>
                            <li>HS384: 48 bytes</li>
                            <li>HS512: 64 bytes</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h6><i class="fas fa-lock text-danger"></i> RSA Keys</h6>
                        <p class="small mb-0">PEM format with markers:</p>
                        <code class="small">-----BEGIN RSA PRIVATE KEY-----</code><br>
                        <code class="small">-----END RSA PRIVATE KEY-----</code>
                        <p class="small mt-1 mb-0">Or PKCS#8 format</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h6><i class="fas fa-circle text-success"></i> EC Keys</h6>
                        <p class="small mb-0">PEM format with markers:</p>
                        <code class="small">-----BEGIN EC PRIVATE KEY-----</code><br>
                        <code class="small">-----END EC PRIVATE KEY-----</code>
                        <p class="small mt-1 mb-0">Curve must match algorithm</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="alert alert-warning mt-4">
            <strong><i class="fas fa-exclamation-triangle"></i> Security Note:</strong>
            Never share your private keys or HMAC secrets. This tool processes keys client-side for display purposes,
            but the actual signing happens server-side. For production use, ensure keys are generated and stored securely.
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
