<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="z.y.x.Security.ecpojo" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ECDSA Sign & Verify Online – Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Generate ECDSA key pairs, sign messages, and verify signatures online. Free tool supporting secp256k1 (Bitcoin), P-256, P-384, P-521, and Brainpool curves.">
    <meta name="keywords" content="ecdsa sign verify, elliptic curve signature, ec sign online, ecdsa bitcoin, secp256k1 signature, ec key generation, ecdsa verification, ec digital signature">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/ecsignverify.jsp">
    <meta property="og:title" content="ECDSA Sign & Verify Online – Free | 8gwifi.org">
    <meta property="og:description" content="Generate EC keys, sign messages, and verify ECDSA signatures. Supports Bitcoin's secp256k1 and NIST curves.">
    <meta property="og:image" content="https://8gwifi.org/images/site/ec.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/ecsignverify.jsp">
    <meta name="twitter:title" content="ECDSA Sign & Verify Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Generate EC keys, sign messages, and verify ECDSA signatures. Supports Bitcoin's secp256k1 and NIST curves.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/ec.png">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/ecsignverify.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD: WebApplication Schema -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "ECDSA Sign & Verify Online",
  "alternateName": "Elliptic Curve Digital Signature Tool, EC Sign Verify, Bitcoin Signature Generator",
  "description": "Free online tool for ECDSA (Elliptic Curve Digital Signature Algorithm) operations. Generate EC key pairs, sign messages with private keys, and verify signatures with public keys. Supports secp256k1 (Bitcoin), NIST curves (P-256, P-384, P-521), and Brainpool curves.",
  "image": "https://8gwifi.org/images/site/ec.png",
  "url": "https://8gwifi.org/ecsignverify.jsp",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Cryptography Tool",
  "browserRequirements": "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem": "Any (Web-based)",
  "softwareVersion": "2.0",
  "datePublished": "2018-10-26",
  "dateModified": "2025-01-23",
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://8gwifi.org",
    "sameAs": "https://x.com/anish2good",
    "jobTitle": "Security Engineer & Cryptography Expert"
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
    "availability": "https://schema.org/InStock"
  },
  "featureList": [
    "Generate EC key pairs for 30+ curves",
    "Sign messages with EC private keys",
    "Verify signatures with EC public keys",
    "Support for Bitcoin's secp256k1 curve",
    "NIST curves (P-256, P-384, P-521)",
    "Brainpool curves support",
    "Download keys and signatures as JSON",
    "Share URL for verification"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "ratingCount": "523",
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
      "name": "What is ECDSA and how does it work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "ECDSA (Elliptic Curve Digital Signature Algorithm) is a cryptographic algorithm that uses elliptic curve cryptography to create digital signatures. It provides the same security level as RSA but with smaller key sizes, making it more efficient for resource-constrained environments."
      }
    },
    {
      "@type": "Question",
      "name": "Which curve does Bitcoin use for signatures?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Bitcoin uses the secp256k1 curve for ECDSA signatures. This curve was chosen for its specific properties that make it slightly faster than other curves, and because it was constructed in a predictable way that reduces the risk of backdoors."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between secp256k1 and secp256r1 (P-256)?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Both are 256-bit elliptic curves, but secp256k1 uses Koblitz curve parameters while secp256r1 (P-256) uses random parameters. secp256k1 is used by Bitcoin and Ethereum, while P-256 is the NIST standard widely used in TLS and other protocols."
      }
    },
    {
      "@type": "Question",
      "name": "How do I verify an ECDSA signature?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To verify an ECDSA signature, you need: 1) The original message, 2) The signature (Base64 encoded), and 3) The EC public key in PEM format. Select 'Verify Signature' mode, enter these inputs, and the tool will confirm if the signature is valid."
      }
    },
    {
      "@type": "Question",
      "name": "What key format does this tool use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool uses PEM format for both private and public keys. EC private keys are in SEC 1 format (BEGIN EC PRIVATE KEY), and public keys are in X.509 SubjectPublicKeyInfo format (BEGIN PUBLIC KEY)."
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
  "name": "How to Sign and Verify with ECDSA",
  "description": "Step-by-step guide to signing messages and verifying signatures using ECDSA",
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Generate EC Key Pair",
      "text": "Select an elliptic curve (e.g., secp256k1 for Bitcoin) and click Submit to generate a new EC key pair."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Sign a Message",
      "text": "Select 'Generate Signature', enter your message in the Plain Text field, and ensure your EC private key is loaded. Click Submit to generate the signature."
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Verify a Signature",
      "text": "Select 'Verify Signature', enter the original message, paste the signature (Base64), and ensure the EC public key is loaded. Click Submit to verify."
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Export Results",
      "text": "Download the signature as JSON or use the Share URL to send to others for verification."
    }
  ],
  "totalTime": "PT3M"
}
</script>

<%
    String pubKey = "";
    String privKey = "";
    String checkedKey="512";
    boolean k1=false;
    boolean k2=false;
    boolean k3=false;
    boolean k4=false;


    if (request.getSession().getAttribute("pubkey")==null) {
        Gson gson = new Gson();
        DefaultHttpClient httpClient = new DefaultHttpClient();
        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/generatekpecdsa/secp256k1";

        HttpGet getRequest = new HttpGet(url1);
        getRequest.addHeader("accept", "application/json");

        HttpResponse response1 = httpClient.execute(getRequest);


        BufferedReader br = new BufferedReader(
                new InputStreamReader(
                        (response1.getEntity().getContent())
                )
        );

        StringBuilder content = new StringBuilder();
        String line;
        while (null != (line = br.readLine())) {
            content.append(line);
        }
        ecpojo ecpojo = (ecpojo) gson.fromJson(content.toString(), ecpojo.class);

        pubKey = ecpojo.getEcprivateKeyA();
        privKey = ecpojo.getEcpubliceKeyA();
        k2=true;
    }
    else {
        pubKey = (String)request.getSession().getAttribute("pubkey");
        privKey = (String)request.getSession().getAttribute("privKey");
        checkedKey = (String)request.getSession().getAttribute("keysize");
    }
%>

    <script type="text/javascript">
        // Store last successful response for download/share
        var lastEcResponse = null;

        $(document).ready(function() {

            $('#ctrTitles').change(function() {
                pem = $(this).val();
                $("#pem").val(pem);
            });

            // Mode toggle - update UI based on selection
            $('input[name="encryptdecryptparameter"]').change(function() {
                var mode = $(this).val();
                if (mode === 'encrypt') {
                    $('#signatureInputSection').hide();
                    $('#actionButton').html('<i class="fas fa-signature"></i> Generate Signature');
                } else {
                    $('#signatureInputSection').show();
                    $('#actionButton').html('<i class="fas fa-check-double"></i> Verify Signature');
                }
                // Clear validation errors when switching modes
                $('.is-invalid').removeClass('is-invalid');
                $('.invalid-feedback').remove();
            });

            // Clear validation on input
            $('#message, #publickeyparam, #privatekeyparam, #signature').on('input', function() {
                $(this).removeClass('is-invalid');
                $(this).next('.invalid-feedback').remove();
            });

            $('#form').submit(function(event) {
                event.preventDefault();

                // Client-side validation
                var mode = $('input[name="encryptdecryptparameter"]:checked').val();
                var message = $('#message').val().trim();
                var privateKey = $('#publickeyparam').val().trim();
                var publicKey = $('#privatekeyparam').val().trim();
                var signature = $('#signature').val().trim();

                // Clear previous validation states
                $('.is-invalid').removeClass('is-invalid');
                $('.invalid-feedback').remove();

                var errors = [];

                // Validate message (required for both modes)
                if (!message) {
                    errors.push({field: '#message', message: 'Message is required'});
                }

                if (mode === 'encrypt') {
                    // Signing mode - validate private key
                    if (!privateKey) {
                        errors.push({field: '#publickeyparam', message: 'EC Private Key is required for signing'});
                    } else if (!privateKey.includes('BEGIN EC PRIVATE KEY') || !privateKey.includes('END EC PRIVATE KEY')) {
                        errors.push({field: '#publickeyparam', message: 'Invalid EC Private Key format. Must be PEM format with BEGIN/END EC PRIVATE KEY markers'});
                    }
                } else {
                    // Verification mode - validate public key and signature
                    if (!publicKey) {
                        errors.push({field: '#privatekeyparam', message: 'EC Public Key is required for verification'});
                    } else if (!publicKey.includes('BEGIN PUBLIC KEY') || !publicKey.includes('END PUBLIC KEY')) {
                        errors.push({field: '#privatekeyparam', message: 'Invalid EC Public Key format. Must be PEM format with BEGIN/END PUBLIC KEY markers'});
                    }

                    if (!signature) {
                        errors.push({field: '#signature', message: 'Signature is required for verification'});
                    } else if (!/^[A-Za-z0-9+/=]+$/.test(signature.replace(/\s/g, ''))) {
                        errors.push({field: '#signature', message: 'Invalid signature format. Must be Base64 encoded'});
                    }
                }

                // Show validation errors
                if (errors.length > 0) {
                    var errorHtml = '<div class="alert alert-danger"><h5><i class="fas fa-exclamation-triangle"></i> Validation Error</h5><ul class="mb-0">';
                    errors.forEach(function(err) {
                        errorHtml += '<li>' + err.message + '</li>';
                        $(err.field).addClass('is-invalid');
                        if (!$(err.field).next('.invalid-feedback').length) {
                            $(err.field).after('<div class="invalid-feedback">' + err.message + '</div>');
                        }
                    });
                    errorHtml += '</ul></div>';
                    $('#output').html(errorHtml);

                    // Scroll to first error
                    $('html, body').animate({
                        scrollTop: $(errors[0].field).offset().top - 100
                    }, 300);
                    return;
                }

                $('#output').html('<div class="text-center py-4"><img src="images/712.GIF" alt="Loading"> <span class="ml-2">Processing...</span></div>');
                $.ajax({
                    type: "POST",
                    url: "ECFunctionality",
                    data: $("#form").serialize(),
                    dataType: 'json',
                    success: function(response) {
                        console.log('Received JSON response:', response);
                        $('#output').empty();
                        lastEcResponse = null;

                        if(response.success) {
                            lastEcResponse = response;

                            var html = '';

                            if(response.operation === 'ec_sign') {
                                // Signature generation success
                                html += '<div class="alert alert-success">';
                                html += '<h5><i class="fas fa-check-circle"></i> Signature Generated Successfully</h5>';
                                html += '</div>';

                                if(response.jwsSignature) {
                                    html += '<div class="form-group">';
                                    html += '<label><strong><i class="fas fa-signature text-success"></i> Signature (Base64)</strong></label>';
                                    html += '<textarea id="signatureOutput" readonly class="form-control" rows="5" style="font-family: monospace; font-size: 11px;"></textarea>';
                                    html += '<button type="button" class="btn btn-sm btn-outline-primary mt-1 copy-btn" data-target="signatureOutput"><i class="fas fa-copy"></i> Copy</button>';
                                    html += '<button type="button" class="btn btn-sm btn-outline-success mt-1 ml-1" id="useForVerify"><i class="fas fa-check-double"></i> Use for Verification</button>';
                                    html += '</div>';
                                }

                                // Action buttons
                                html += '<hr>';
                                html += '<div class="btn-group flex-wrap" role="group">';
                                html += '<button type="button" class="btn btn-primary" id="downloadSignature"><i class="fas fa-download"></i> Download Signature</button>';
                                html += '<button type="button" class="btn btn-secondary" id="downloadKeys"><i class="fas fa-key"></i> Download Keys</button>';
                                html += '<button type="button" class="btn btn-info" id="shareUrl"><i class="fas fa-share-alt"></i> Share URL</button>';
                                html += '</div>';

                            } else if(response.operation === 'ec_verify') {
                                // Verification result
                                if(response.jwsState === 'VALID') {
                                    html += '<div class="alert alert-success">';
                                    html += '<h4><i class="fas fa-check-circle fa-2x"></i></h4>';
                                    html += '<h5>Signature Verification PASSED</h5>';
                                    html += '<p class="mb-0">The signature is valid for the given message and public key.</p>';
                                    html += '</div>';
                                } else {
                                    html += '<div class="alert alert-danger">';
                                    html += '<h4><i class="fas fa-times-circle fa-2x"></i></h4>';
                                    html += '<h5>Signature Verification FAILED</h5>';
                                    html += '<p class="mb-0">The signature does not match the message or the wrong public key was used.</p>';
                                    html += '</div>';
                                }
                            }

                            $('#output').html(html);

                            // Set values
                            if(response.jwsSignature && response.operation === 'ec_sign') {
                                $('#signatureOutput').val(response.jwsSignature);
                            }

                            // Attach copy handlers
                            $('.copy-btn').off('click').on('click', function() {
                                var targetId = $(this).data('target');
                                var text = $('#' + targetId).val();
                                copyToClipboard(text, this);
                            });

                            // Use for verification handler
                            $('#useForVerify').off('click').on('click', function() {
                                if(lastEcResponse && lastEcResponse.jwsSignature) {
                                    $('#signature').val(lastEcResponse.jwsSignature);
                                    $('#decryptparameter').prop('checked', true).trigger('change');
                                    $('#signatureInputSection').show();
                                    $('#actionButton').text('Verify Signature');
                                }
                            });

                            // Download Signature handler
                            $('#downloadSignature').off('click').on('click', function() {
                                downloadSignatureJson();
                            });

                            // Download Keys handler
                            $('#downloadKeys').off('click').on('click', function() {
                                downloadKeysJson();
                            });

                            // Share URL handler - open modal
                            $('#shareUrl').off('click').on('click', function() {
                                openShareUrlModal();
                            });

                        } else {
                            // Error response
                            var errorMsg = response.errorMessage || 'Unknown error occurred';
                            var html = '<div class="alert alert-danger">';
                            html += '<h5><i class="fas fa-exclamation-triangle"></i> Error</h5>';
                            html += '<p>' + errorMsg + '</p>';
                            html += '</div>';
                            $('#output').html(html);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});
                        $('#output').empty();
                        lastEcResponse = null;

                        var errorMessage = 'An error occurred during the operation.';
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

        function downloadSignatureJson() {
            if (!lastEcResponse) {
                alert('No signature data available to download');
                return;
            }

            var downloadData = {
                operation: lastEcResponse.operation,
                signature: lastEcResponse.jwsSignature,
                message: lastEcResponse.originalMessage,
                publicKey: $('#privatekeyparam').val(),
                generatedAt: new Date().toISOString(),
                tool: "8gwifi.org ECDSA Sign & Verify"
            };

            var jsonStr = JSON.stringify(downloadData, null, 2);
            var blob = new Blob([jsonStr], {type: 'application/json'});
            var url = URL.createObjectURL(blob);

            var date = new Date().toISOString().split('T')[0];
            var filename = '8gwifi.org-ecdsa-signature-' + date + '.json';

            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        function downloadKeysJson() {
            var privateKey = $('#publickeyparam').val();
            var publicKey = $('#privatekeyparam').val();

            if (!privateKey && !publicKey) {
                alert('No keys available to download');
                return;
            }

            var downloadData = {
                keyType: "EC",
                privateKey: privateKey,
                publicKey: publicKey,
                generatedAt: new Date().toISOString(),
                tool: "8gwifi.org ECDSA Sign & Verify",
                warning: "NEVER share your private key! Keep it secure."
            };

            var jsonStr = JSON.stringify(downloadData, null, 2);
            var blob = new Blob([jsonStr], {type: 'application/json'});
            var url = URL.createObjectURL(blob);

            var date = new Date().toISOString().split('T')[0];
            var filename = '8gwifi.org-ec-keys-' + date + '.json';

            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }

        function openShareUrlModal() {
            if (!lastEcResponse || !lastEcResponse.jwsSignature) {
                alert('No signature data available to share');
                return;
            }

            var signature = lastEcResponse.jwsSignature;
            var message = lastEcResponse.originalMessage || '';
            var publicKey = $('#privatekeyparam').val();
            var privateKey = $('#publickeyparam').val();

            // Create URL parameters
            var params = new URLSearchParams({
                sig: signature,
                msg: message,
                mode: 'verify'
            });

            // Add public key (safe to share)
            if (publicKey && publicKey.trim()) {
                params.append('pubkey', publicKey);
            }

            // Check if user wants to include private key (dangerous!)
            var includesPrivateKey = false;

            var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

            // Update modal warning content
            $('#shareWarningContent').html(
                '<div class="alert alert-success mb-3">' +
                    '<strong><i class="fas fa-shield-alt"></i> What\'s Being Shared:</strong>' +
                    '<ul class="mb-0 mt-2">' +
                        '<li><strong>Signature:</strong> The ECDSA signature (Base64)</li>' +
                        '<li><strong>Message:</strong> The original message that was signed</li>' +
                        '<li><strong>Public Key:</strong> ' + (publicKey && publicKey.trim() ? 'Included - Safe to share' : 'Not included') + '</li>' +
                        '<li><strong class="text-success">NOT Included:</strong> Your private key (kept secure)</li>' +
                    '</ul>' +
                '</div>' +
                '<div class="alert alert-info mb-3">' +
                    '<strong><i class="fas fa-info-circle"></i> How to Use:</strong>' +
                    '<p class="mb-0">The recipient can use this URL to verify the signature. They will see the message, signature, and public key pre-filled for verification.</p>' +
                '</div>'
            );

            // Set URL in modal and show it
            $('#shareUrlText').val(shareUrl);
            $('#shareUrlModal').modal('show');
        }

        // Handle shared URL on page load
        $(document).ready(function() {
            // Copy Share URL from modal
            $('#copyShareUrl').click(function() {
                var shareUrl = $('#shareUrlText').val();
                var btn = $(this);
                navigator.clipboard.writeText(shareUrl).then(function() {
                    btn.html('<i class="fas fa-check"></i> Copied!');
                    setTimeout(function() {
                        btn.html('<i class="fas fa-copy"></i> Copy');
                    }, 1500);
                }).catch(function(err) {
                    // Fallback for older browsers
                    $('#shareUrlText').select();
                    document.execCommand('copy');
                    btn.html('<i class="fas fa-check"></i> Copied!');
                    setTimeout(function() {
                        btn.html('<i class="fas fa-copy"></i> Copy');
                    }, 1500);
                });
            });
            var urlParams = new URLSearchParams(window.location.search);

            // Check for new URL parameter format
            var sig = urlParams.get('sig');
            var msg = urlParams.get('msg');
            var pubkey = urlParams.get('pubkey');
            var mode = urlParams.get('mode');

            if (sig || msg || pubkey) {
                if (sig) {
                    $('#signature').val(sig);
                }
                if (msg) {
                    $('#message').val(msg);
                }
                if (pubkey) {
                    $('#privatekeyparam').val(pubkey);
                }
                // Switch to verify mode
                if (mode === 'verify' || sig) {
                    $('#decryptparameter').prop('checked', true).trigger('change');
                    $('#signatureInputSection').show();
                    $('#actionButton').text('Verify Signature');
                }
            }

            // Also support legacy base64 share format
            var shareParam = urlParams.get('share');
            if (shareParam) {
                try {
                    var decoded = JSON.parse(atob(decodeURIComponent(shareParam)));
                    if (decoded.sig) {
                        $('#signature').val(decoded.sig);
                    }
                    if (decoded.msg) {
                        $('#message').val(decoded.msg);
                    }
                    if (decoded.pubKey) {
                        $('#privatekeyparam').val(decoded.pubKey);
                    }
                    // Switch to verify mode
                    $('#decryptparameter').prop('checked', true).trigger('change');
                    $('#signatureInputSection').show();
                    $('#actionButton').text('Verify Signature');
                } catch(e) {
                    console.error('Error decoding share parameter:', e);
                }
            }
        });
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">ECDSA Sign & Verify</h1>

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



<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<!-- Key Generation Form -->
<div class="card mb-4">
    <div class="card-header bg-secondary text-white">
        <h5 class="mb-0"><i class="fas fa-key"></i> Generate EC Key Pair</h5>
    </div>
    <div class="card-body">
        <form id="form1" action="ECFunctionality" method="POST" class="form-inline">
            <input type="hidden" name="methodName" id="methodName" value="EC_GENERATE_KEYPAIR_ECDSA">
            <div class="form-group mr-3">
                <label for="ecparam" class="mr-2"><strong>EC Curve:</strong></label>
                <select name="ecparam" id="ecparam" class="form-control">
                    <option value="secp256k1">secp256k1 (Bitcoin)</option>
                    <%
                        String[] validList = { "c2pnb272w1", "c2tnb359v1", "prime256v1", "c2pnb304w1", "c2pnb368w1", "c2tnb431r1",
                                "sect283r1", "sect283k1", "secp256r1", "sect571r1", "sect571k1", "sect409r1", "sect409k1",
                                "secp521r1", "secp384r1", "P-521", "P-256", "P-384", "B-409", "B-283", "B-571", "K-409", "K-283",
                                "K-571", "brainpoolp512r1", "brainpoolp384t1", "brainpoolp256r1", "brainpoolp512t1", "brainpoolp256t1",
                                "brainpoolp320r1", "brainpoolp384r1", "brainpoolp320t1", "FRP256v1", "sm2p256v1" };
                        for (int i = 0; i < validList.length; i++) {
                            String param = validList[i];
                    %>
                    <option value="<%=param%>"><%=param%></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary"><i class="fas fa-sync-alt"></i> Generate Keys</button>
        </form>
    </div>
</div>

<!-- Sign/Verify Form -->
<form id="form" class="form-horizontal" method="POST">
    <input type="hidden" name="methodName" id="EC_SIGN_VERIFY_MESSAGEE" value="EC_SIGN_VERIFY_MESSAGEE">

    <div class="row">
        <!-- Left Column: Input -->
        <div class="col-lg-5 col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-edit"></i> Sign / Verify Configuration</h5>
                </div>
                <div class="card-body">

                    <!-- Mode Selection -->
                    <div class="form-group">
                        <label><strong><i class="fas fa-toggle-on text-info"></i> Operation Mode</strong></label>
                        <div class="btn-group btn-group-toggle d-block" data-toggle="buttons">
                            <label class="btn btn-outline-primary active">
                                <input checked id="encryptparameter" type="radio" name="encryptdecryptparameter" value="encrypt"> Sign Message
                            </label>
                            <label class="btn btn-outline-success">
                                <input id="decryptparameter" type="radio" name="encryptdecryptparameter" value="decryprt"> Verify Signature
                            </label>
                        </div>
                    </div>

                    <hr>

                    <!-- Private Key -->
                    <div class="form-group">
                        <label for="publickeyparam"><strong><i class="fas fa-lock text-danger"></i> EC Private Key (for signing)</strong></label>
                        <textarea class="form-control" rows="5" name="publickeyparam" id="publickeyparam" style="font-family: monospace; font-size: 11px;"><%= pubKey %></textarea>
                        <small class="form-text text-muted">PEM format (BEGIN EC PRIVATE KEY)</small>
                    </div>

                    <!-- Public Key -->
                    <div class="form-group">
                        <label for="privatekeyparam"><strong><i class="fas fa-unlock text-success"></i> EC Public Key (for verification)</strong></label>
                        <textarea class="form-control" rows="5" name="privatekeyparam" id="privatekeyparam" style="font-family: monospace; font-size: 11px;"><%= privKey %></textarea>
                        <small class="form-text text-muted">PEM format (BEGIN PUBLIC KEY)</small>
                    </div>

                    <hr>

                    <!-- Message Input -->
                    <div class="form-group">
                        <label for="message"><strong><i class="fas fa-file-alt text-primary"></i> Message</strong></label>
                        <textarea class="form-control" rows="4" placeholder="Enter your message to sign or verify..." name="message" id="message"></textarea>
                    </div>

                    <!-- Signature Input (for verification) -->
                    <div id="signatureInputSection" class="form-group" style="display: none;">
                        <label for="signature"><strong><i class="fas fa-signature text-warning"></i> Signature (Base64)</strong></label>
                        <textarea class="form-control" rows="4" name="signature" id="signature" placeholder="Paste signature here for verification..." style="font-family: monospace; font-size: 11px;"></textarea>
                    </div>

                    <button type="submit" id="actionButton" class="btn btn-primary btn-block btn-lg">
                        <i class="fas fa-signature"></i> Generate Signature
                    </button>
                </div>
            </div>
        </div>

        <!-- Right Column: Output -->
        <div class="col-lg-7 col-md-6">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-terminal"></i> Output</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-signature fa-4x mb-3 opacity-25"></i>
                            <p class="lead">Signature output will appear here</p>
                            <p class="small">Enter a message and click "Generate Signature" or "Verify Signature"</p>
                        </div>

                        <div class="alert alert-info" role="alert">
                            <strong><i class="fas fa-info-circle"></i> How to Use:</strong>
                            <ol class="mb-0 mt-2">
                                <li><strong>Generate Keys:</strong> Select an EC curve and click Submit to generate a new key pair</li>
                                <li><strong>Sign:</strong> Select "Generate Signature", enter your message, and submit</li>
                                <li><strong>Verify:</strong> Select "Verify Signature", enter message, signature, and public key</li>
                            </ol>
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
        <h5 class="mb-0"><i class="fas fa-tools"></i> Related Cryptography Tools</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="ecfunctions.jsp"><i class="fas fa-ellipsis-h text-primary"></i> EC Key Exchange (ECDH)</a></li>
                    <li class="mb-2"><a href="rsafunctions.jsp"><i class="fas fa-key text-info"></i> RSA Encrypt/Decrypt</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="rsasignverifyfunctions.jsp"><i class="fas fa-signature text-success"></i> RSA Sign & Verify</a></li>
                    <li class="mb-2"><a href="jwsgen.jsp"><i class="fas fa-file-signature text-warning"></i> JWS Generator</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="CipherFunctions.jsp"><i class="fas fa-lock text-danger"></i> AES Encryption</a></li>
                    <li class="mb-2"><a href="HashFunctions.jsp"><i class="fas fa-hashtag text-secondary"></i> Hash Functions</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<!-- ECDSA Guide -->
<div class="card mb-4 mt-4">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-book"></i> Understanding ECDSA</h2>
    </div>
    <div class="card-body">
        <p class="lead">
            <strong>Elliptic Curve Digital Signature Algorithm (ECDSA)</strong> is a cryptographic algorithm used to ensure that data can only be signed by its rightful owners. It's widely used in cryptocurrencies like Bitcoin and Ethereum, as well as TLS/SSL, SSH, and secure messaging protocols.
        </p>

        <h4 class="mt-4"><i class="fas fa-question-circle text-primary"></i> What is ECDSA?</h4>
        <p>ECDSA is a variant of the Digital Signature Algorithm (DSA) that uses elliptic curve cryptography. It provides the same level of security as RSA but with significantly smaller key sizes, making it more efficient for:</p>
        <ul>
            <li><strong>Mobile devices</strong> - Less computational power required</li>
            <li><strong>IoT devices</strong> - Smaller memory footprint</li>
            <li><strong>Blockchain</strong> - Faster transaction verification</li>
            <li><strong>TLS handshakes</strong> - Reduced bandwidth and latency</li>
        </ul>

        <h4 class="mt-4"><i class="fas fa-cogs text-info"></i> How ECDSA Works</h4>
        <div class="row">
            <div class="col-md-6">
                <div class="card border-success mb-3">
                    <div class="card-header bg-success text-white"><i class="fas fa-pen"></i> Signing Process</div>
                    <div class="card-body">
                        <ol class="small mb-0">
                            <li>Hash the message using SHA-256 (or similar)</li>
                            <li>Generate a random number <code>k</code> (critical for security)</li>
                            <li>Calculate point <code>R = k × G</code> on the curve</li>
                            <li>Calculate <code>r = R.x mod n</code></li>
                            <li>Calculate <code>s = k⁻¹(hash + r × privateKey) mod n</code></li>
                            <li>Signature is the pair <code>(r, s)</code></li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-info mb-3">
                    <div class="card-header bg-info text-white"><i class="fas fa-check"></i> Verification Process</div>
                    <div class="card-body">
                        <ol class="small mb-0">
                            <li>Hash the message using the same algorithm</li>
                            <li>Calculate <code>w = s⁻¹ mod n</code></li>
                            <li>Calculate <code>u1 = hash × w mod n</code></li>
                            <li>Calculate <code>u2 = r × w mod n</code></li>
                            <li>Calculate point <code>P = u1 × G + u2 × PublicKey</code></li>
                            <li>Signature valid if <code>P.x mod n == r</code></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mt-4"><i class="fas fa-info-circle text-primary"></i> Key Concepts</h4>
        <div class="row">
            <div class="col-md-4">
                <div class="card bg-light mb-3">
                    <div class="card-body">
                        <h6><i class="fas fa-lock text-danger"></i> Private Key</h6>
                        <p class="small mb-0">A secret 256-bit integer known only to the owner. Used to generate signatures. In Bitcoin, this is derived from a random number. Must be kept absolutely secret.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light mb-3">
                    <div class="card-body">
                        <h6><i class="fas fa-unlock text-success"></i> Public Key</h6>
                        <p class="small mb-0">Derived from the private key using elliptic curve point multiplication: <code>PublicKey = privateKey × G</code>. Can be shared publicly and used to verify signatures.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light mb-3">
                    <div class="card-body">
                        <h6><i class="fas fa-signature text-primary"></i> Signature</h6>
                        <p class="small mb-0">Proves that the signer has the private key without revealing it. Consists of two values (r, s) typically encoded as DER format or concatenated raw bytes.</p>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mt-4"><i class="fas fa-balance-scale text-warning"></i> ECDSA vs RSA</h4>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Feature</th>
                        <th>ECDSA (256-bit)</th>
                        <th>RSA (3072-bit)</th>
                        <th>Winner</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Security Level</td>
                        <td>128-bit</td>
                        <td>128-bit</td>
                        <td><span class="badge badge-secondary">Tie</span></td>
                    </tr>
                    <tr>
                        <td>Key Size</td>
                        <td>256 bits (32 bytes)</td>
                        <td>3072 bits (384 bytes)</td>
                        <td><span class="badge badge-success">ECDSA</span></td>
                    </tr>
                    <tr>
                        <td>Signature Size</td>
                        <td>64 bytes</td>
                        <td>384 bytes</td>
                        <td><span class="badge badge-success">ECDSA</span></td>
                    </tr>
                    <tr>
                        <td>Sign Speed</td>
                        <td>Fast</td>
                        <td>Slow</td>
                        <td><span class="badge badge-success">ECDSA</span></td>
                    </tr>
                    <tr>
                        <td>Verify Speed</td>
                        <td>Moderate</td>
                        <td>Fast</td>
                        <td><span class="badge badge-primary">RSA</span></td>
                    </tr>
                    <tr>
                        <td>Adoption</td>
                        <td>Growing (TLS 1.3, Bitcoin)</td>
                        <td>Legacy (widespread)</td>
                        <td><span class="badge badge-secondary">Depends</span></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h4 class="mt-4"><i class="fas fa-bezier-curve text-success"></i> Popular EC Curves</h4>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Curve</th>
                        <th>Bits</th>
                        <th>Security</th>
                        <th>Usage</th>
                        <th>Notes</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>secp256k1</code></td>
                        <td>256</td>
                        <td>128-bit</td>
                        <td>Bitcoin, Ethereum, Litecoin</td>
                        <td>Koblitz curve, efficient for verification</td>
                    </tr>
                    <tr>
                        <td><code>P-256 (secp256r1)</code></td>
                        <td>256</td>
                        <td>128-bit</td>
                        <td>TLS, WebAuthn, FIDO2, Apple</td>
                        <td>NIST standard, most widely supported</td>
                    </tr>
                    <tr>
                        <td><code>P-384 (secp384r1)</code></td>
                        <td>384</td>
                        <td>192-bit</td>
                        <td>Government, NSA Suite B</td>
                        <td>Required for TOP SECRET classification</td>
                    </tr>
                    <tr>
                        <td><code>P-521 (secp521r1)</code></td>
                        <td>521</td>
                        <td>256-bit</td>
                        <td>High-security applications</td>
                        <td>Maximum NIST curve security</td>
                    </tr>
                    <tr>
                        <td><code>Ed25519</code></td>
                        <td>256</td>
                        <td>128-bit</td>
                        <td>SSH, Signal, Tor</td>
                        <td>EdDSA variant, deterministic signatures</td>
                    </tr>
                    <tr>
                        <td><code>brainpoolP256r1</code></td>
                        <td>256</td>
                        <td>128-bit</td>
                        <td>European standards, German BSI</td>
                        <td>Alternative to NIST curves</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h4 class="mt-4"><i class="fas fa-globe text-info"></i> Real-World Applications</h4>
        <div class="row">
            <div class="col-md-3">
                <div class="card text-center mb-3">
                    <div class="card-body">
                        <i class="fab fa-bitcoin fa-2x text-warning mb-2"></i>
                        <h6>Cryptocurrency</h6>
                        <p class="small mb-0">Bitcoin, Ethereum use ECDSA for transaction signing</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center mb-3">
                    <div class="card-body">
                        <i class="fas fa-lock fa-2x text-success mb-2"></i>
                        <h6>TLS/SSL</h6>
                        <p class="small mb-0">HTTPS certificates and key exchange</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center mb-3">
                    <div class="card-body">
                        <i class="fas fa-terminal fa-2x text-dark mb-2"></i>
                        <h6>SSH</h6>
                        <p class="small mb-0">Secure shell authentication keys</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center mb-3">
                    <div class="card-body">
                        <i class="fas fa-mobile-alt fa-2x text-primary mb-2"></i>
                        <h6>Mobile Auth</h6>
                        <p class="small mb-0">FIDO2, WebAuthn, passkeys</p>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mt-4"><i class="fas fa-terminal text-secondary"></i> OpenSSL Commands</h4>
        <pre class="bg-dark text-light p-3 rounded"><code># List available curves
openssl ecparam -list_curves

# Generate EC key pair (secp256k1 for Bitcoin compatibility)
openssl ecparam -name secp256k1 -genkey -noout -out ec-private.pem

# Extract public key
openssl ec -in ec-private.pem -pubout -out ec-public.pem

# View key details
openssl ec -in ec-private.pem -text -noout

# Sign a message (creates binary signature)
openssl dgst -sha256 -sign ec-private.pem -out signature.bin message.txt

# Convert signature to Base64
base64 signature.bin > signature.b64

# Verify signature
openssl dgst -sha256 -verify ec-public.pem -signature signature.bin message.txt

# Generate key for P-256 (NIST) curve
openssl ecparam -name prime256v1 -genkey -noout -out p256-key.pem</code></pre>

        <h4 class="mt-4"><i class="fas fa-shield-alt text-danger"></i> Security Best Practices</h4>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-danger">
                    <strong><i class="fas fa-times-circle"></i> DON'T:</strong>
                    <ul class="mb-0 small">
                        <li>Never reuse the random nonce <code>k</code> - leads to private key recovery</li>
                        <li>Never share your private key</li>
                        <li>Don't use weak random number generators</li>
                        <li>Don't ignore signature malleability in blockchain apps</li>
                        <li>Don't use deprecated curves (e.g., secp112r1)</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-success">
                    <strong><i class="fas fa-check-circle"></i> DO:</strong>
                    <ul class="mb-0 small">
                        <li>Use deterministic signatures (RFC 6979) when possible</li>
                        <li>Use well-tested cryptographic libraries</li>
                        <li>Verify signatures before trusting data</li>
                        <li>Use curves with at least 256-bit security</li>
                        <li>Keep private keys in secure hardware (HSM) when possible</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="alert alert-warning mt-3">
            <strong><i class="fas fa-exclamation-triangle"></i> Critical Security Note:</strong>
            The security of ECDSA depends entirely on the randomness of the nonce <code>k</code>. In 2010, Sony's PlayStation 3 private key was compromised because they used the same <code>k</code> value for multiple signatures. Always use cryptographically secure random number generators or deterministic signature schemes (RFC 6979).
        </div>
    </div>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt"></i> Share URL for Verification
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Dynamic warning content populated by JavaScript -->
                <div id="shareWarningContent"></div>

                <label class="font-weight-bold mb-2">Share URL:</label>
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="shareUrlText" readonly style="font-size: 11px; font-family: monospace;">
                    <div class="input-group-append">
                        <button class="btn btn-success" type="button" id="copyShareUrl">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                </div>

                <small class="text-muted">
                    <i class="fas fa-lightbulb"></i> <strong>Tip:</strong> The URL may be long due to the public key. Use a URL shortener if needed.
                </small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
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
