<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>SAML Signature Verification & Decoder – Free | 8gwifi.org</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online SAML signature verification tool. Verify SAML Response signatures, validate Assertions, decode Base64 SAML messages, and inflate deflated AuthnRequests. Essential for SSO debugging.">
    <meta name="keywords" content="saml signature verification, verify saml response, saml assertion validation, base64 saml decode, saml decoder, deflate saml, saml debugger, sso validation">

    <!-- Open Graph -->
    <meta property="og:title" content="SAML Signature Verification & Decoder – Free | 8gwifi.org">
    <meta property="og:description" content="Verify SAML signatures, validate assertions, and decode Base64/deflated SAML messages. Essential tool for SSO debugging.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/samlverifysign.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/samlverifysign.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="SAML Signature Verification & Decoder – Free | 8gwifi.org">
    <meta name="twitter:description" content="Verify SAML signatures and decode Base64/deflated messages. SSO debugging made easy.">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/samlverifysign.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@graph": [
            {
                "@type": "WebApplication",
                "@id": "https://8gwifi.org/samlverifysign.jsp#app",
                "name": "SAML Signature Verification & Decoder",
                "description": "Verify SAML Response signatures, validate Assertions, decode Base64 SAML messages, and inflate deflated AuthnRequests.",
                "url": "https://8gwifi.org/samlverifysign.jsp",
                "applicationCategory": "SecurityApplication",
                "operatingSystem": "Any",
                "offers": {
                    "@type": "Offer",
                    "price": "0",
                    "priceCurrency": "USD"
                },
                "author": {
                    "@type": "Person",
                    "name": "Anish Nath",
                    "url": "https://x.com/anish2good"
                },
                "datePublished": "2018-03-30",
                "dateModified": "2025-01-28"
            },
            {
                "@type": "FAQPage",
                "mainEntity": [
                    {
                        "@type": "Question",
                        "name": "How do I verify a SAML signature?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "Paste your SAML Response XML and the Identity Provider's X.509 certificate. Select whether to verify the Response signature or the Assertion signature, then click Submit. The tool will validate the XML signature using the provided certificate."
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "How do I decode a Base64 SAML message?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "Select 'SAML Message (base64 encoded)' mode, paste your Base64-encoded SAML message, and click Submit. The tool will decode the Base64 and display the plain XML. For HTTP-Redirect binding messages, use the 'base64 + deflate' mode."
                        }
                    }
                ]
            }
        ]
    }
    </script>

    <style>
        :root {
            --theme-primary: #ea580c;
            --theme-secondary: #f97316;
            --theme-gradient: linear-gradient(135deg, #ea580c 0%, #f97316 100%);
            --theme-light: #fff7ed;
        }

        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: box-shadow 0.2s;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }

        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
        }

        .result-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem 1rem;
            color: #6c757d;
        }
        .result-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }

        .info-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-right: 0.5rem;
        }

        .eeat-badge {
            background: var(--theme-gradient);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-theme {
            background: var(--theme-gradient);
            border: none;
            color: white;
        }
        .btn-theme:hover {
            opacity: 0.9;
            color: white;
        }

        .mode-option {
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s;
            margin-bottom: 0.5rem;
        }
        .mode-option:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .mode-option.active {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .mode-option input[type="radio"] {
            margin-right: 0.5rem;
        }
        .mode-option-title {
            font-weight: 600;
            color: #374151;
        }
        .mode-option-desc {
            font-size: 0.8rem;
            color: #6b7280;
            margin-left: 1.5rem;
        }

        .verify-option {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s;
            margin-right: 0.5rem;
        }
        .verify-option:hover {
            border-color: var(--theme-primary);
        }
        .verify-option.active {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .verify-option input[type="radio"] {
            margin-right: 0.5rem;
        }

        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            display: block;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
            border: 1px solid transparent;
        }
        .related-tool-card:hover {
            background: var(--theme-light);
            border-color: var(--theme-primary);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }

        #output {
            margin-top: 1rem;
        }

        @media (max-width: 991.98px) {
            .row > .col-lg-5,
            .row > .col-lg-7 {
                margin-bottom: 1.5rem;
            }
        }
    </style>

    <script type="text/javascript">
        // Escape HTML for XSS prevention
        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.appendChild(document.createTextNode(text));
            return div.innerHTML;
        }

        // Copy to clipboard function
        function copyToClipboard(text, button) {
            navigator.clipboard.writeText(text).then(function() {
                var originalHtml = button.innerHTML;
                button.innerHTML = '<i class="fas fa-check me-1"></i>Copied!';
                button.classList.add('btn-success');
                button.classList.remove('btn-outline-secondary');
                setTimeout(function() {
                    button.innerHTML = originalHtml;
                    button.classList.remove('btn-success');
                    button.classList.add('btn-outline-secondary');
                }, 2000);
            });
        }

        // Verify the decoded XML - switch to verify mode
        function verifyDecodedXml(target) {
            if (!window.lastDecodedXml) {
                alert('No decoded XML available');
                return;
            }

            // Fill the form with raw XML - backend accepts SAML XML directly
            $('#samlmessage').val(window.lastDecodedXml);

            // Switch to verify mode
            $('input[value="verifysignature"]').prop('checked', true);
            $('.mode-option').removeClass('active');
            $('input[value="verifysignature"]').closest('.mode-option').addClass('active');

            // Show x509 and verify options sections
            $('#x509Section').show();
            $('#verifyOptions').show();

            // Select the target (response or assertion)
            $('input[name="cipherparameter"][value="' + target + '"]').prop('checked', true);
            $('.verify-option').removeClass('active');
            $('input[name="cipherparameter"][value="' + target + '"]').closest('.verify-option').addClass('active');

            // Scroll to form
            $('html, body').animate({
                scrollTop: $('#form').offset().top - 100
            }, 500);

            // Highlight the form briefly
            $('.tool-card').first().addClass('border-primary');
            setTimeout(function() {
                $('.tool-card').first().removeClass('border-primary');
            }, 2000);

            // Show instruction toast
            $('#output').html('<div class="alert alert-info"><i class="fas fa-arrow-left me-2"></i><strong>Ready to verify!</strong> The decoded XML has been loaded. Please ensure the X.509 certificate is correct, then click <strong>Process</strong>.</div>');
        }

        // Format XML with indentation
        function formatXml(xml) {
            if (!xml) return '';
            var formatted = '';
            var reg = /(>)(<)(\/*)/g;
            xml = xml.replace(reg, '$1\r\n$2$3');
            var pad = 0;
            var lines = xml.split('\r\n');
            for (var i = 0; i < lines.length; i++) {
                var line = lines[i];
                var indent = 0;
                if (line.match(/.+<\/\w[^>]*>$/)) {
                    indent = 0;
                } else if (line.match(/^<\/\w/)) {
                    if (pad != 0) pad -= 1;
                } else if (line.match(/^<\w([^>]*[^\/])?>.*$/)) {
                    indent = 1;
                } else {
                    indent = 0;
                }
                var padding = '';
                for (var j = 0; j < pad; j++) padding += '  ';
                formatted += padding + line + '\r\n';
                pad += indent;
            }
            return formatted.trim();
        }

        // Render verify/decode result
        function renderVerifyResult(data) {
            var html = '';

            // Error response
            if (!data.success) {
                html = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i><strong>Error:</strong> ' + escapeHtml(data.errorMessage) + '</div>';
                $('#output').html(html);
                return;
            }

            // Verify operation
            if (data.operation === 'verify') {
                if (data.verified === true) {
                    html += '<div class="alert alert-success"><i class="fas fa-check-circle me-2"></i><strong>Signature Valid!</strong></div>';
                } else {
                    html += '<div class="alert alert-danger"><i class="fas fa-times-circle me-2"></i><strong>Signature Invalid</strong></div>';
                }

                // Verification details
                html += '<div class="card mb-3">';
                html += '<div class="card-header bg-light py-2"><h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Verification Details</h6></div>';
                html += '<div class="card-body">';
                html += '<table class="table table-sm mb-0">';
                html += '<tr><td class="text-muted" style="width:150px;">Status</td><td>';
                html += data.verified ? '<span class="badge bg-success"><i class="fas fa-check me-1"></i>Verified</span>' : '<span class="badge bg-danger"><i class="fas fa-times me-1"></i>Failed</span>';
                html += '</td></tr>';
                if (data.verifyTarget) {
                    html += '<tr><td class="text-muted">Target</td><td><code>' + escapeHtml(data.verifyTarget) + '</code></td></tr>';
                }
                if (data.verificationMessage) {
                    html += '<tr><td class="text-muted">Message</td><td>' + escapeHtml(data.verificationMessage) + '</td></tr>';
                }
                html += '</table>';
                html += '</div></div>';
            }

            // Decode operation
            else if (data.operation === 'decode') {
                var modeLabel = data.decodeMode === 'deflate' ? 'Base64 + Inflate' : 'Base64 Decode';
                html += '<div class="alert alert-success"><i class="fas fa-check-circle me-2"></i><strong>Decoded Successfully!</strong> (' + escapeHtml(modeLabel) + ')</div>';

                // Decoded XML output
                if (data.decodedXml) {
                    // Store decoded XML for later use
                    window.lastDecodedXml = data.decodedXml;
                    var formattedXml = formatXml(data.decodedXml);

                    html += '<div class="card mb-3">';
                    html += '<div class="card-header bg-light py-2 d-flex justify-content-between align-items-center">';
                    html += '<h6 class="mb-0"><i class="fas fa-code me-2"></i>Decoded XML</h6>';
                    html += '<div>';
                    html += '<button class="btn btn-sm btn-outline-secondary me-2" onclick="copyToClipboard(document.getElementById(\'decodedXmlContent\').textContent, this)"><i class="fas fa-copy me-1"></i>Copy</button>';
                    html += '</div>';
                    html += '</div>';
                    html += '<div class="card-body p-0">';
                    html += '<pre class="bg-dark text-light p-3 mb-0 rounded-bottom" style="max-height: 400px; overflow: auto;"><code id="decodedXmlContent">' + escapeHtml(formattedXml) + '</code></pre>';
                    html += '</div></div>';

                    // Detect message type and show info
                    var messageType = 'Unknown';
                    var hasSignature = data.decodedXml.indexOf('ds:Signature') !== -1 || data.decodedXml.indexOf('Signature xmlns') !== -1;
                    if (data.decodedXml.indexOf('samlp:AuthnRequest') !== -1) {
                        messageType = 'AuthnRequest';
                    } else if (data.decodedXml.indexOf('samlp:Response') !== -1) {
                        messageType = 'SAMLResponse';
                    } else if (data.decodedXml.indexOf('samlp:LogoutRequest') !== -1) {
                        messageType = 'LogoutRequest';
                    } else if (data.decodedXml.indexOf('samlp:LogoutResponse') !== -1) {
                        messageType = 'LogoutResponse';
                    }

                    html += '<div class="card mb-3">';
                    html += '<div class="card-header bg-light py-2"><h6 class="mb-0"><i class="fas fa-tags me-2"></i>Message Info</h6></div>';
                    html += '<div class="card-body">';
                    html += '<table class="table table-sm mb-0">';
                    html += '<tr><td class="text-muted" style="width:150px;">Message Type</td><td><span class="badge" style="background: var(--theme-gradient);">' + escapeHtml(messageType) + '</span></td></tr>';
                    html += '<tr><td class="text-muted">Decode Mode</td><td><code>' + escapeHtml(data.decodeMode) + '</code></td></tr>';
                    html += '<tr><td class="text-muted">Has Signature</td><td>';
                    html += hasSignature ? '<span class="badge bg-success"><i class="fas fa-check me-1"></i>Yes</span>' : '<span class="badge bg-secondary"><i class="fas fa-times me-1"></i>No</span>';
                    html += '</td></tr>';
                    html += '</table>';
                    html += '</div></div>';

                    // Action buttons - Verify Signature (only show if message has signature)
                    if (hasSignature) {
                        html += '<div class="card border-primary">';
                        html += '<div class="card-header py-2" style="background: var(--theme-gradient); color: white;">';
                        html += '<h6 class="mb-0"><i class="fas fa-shield-alt me-2"></i>Next Step: Verify Signature</h6>';
                        html += '</div>';
                        html += '<div class="card-body">';
                        html += '<p class="mb-3 small text-muted">The decoded message contains a digital signature. You can verify it using the IdP\'s X.509 certificate.</p>';
                        html += '<div class="d-flex flex-wrap gap-2">';
                        html += '<button class="btn btn-theme" onclick="verifyDecodedXml(\'response\')"><i class="fas fa-file-signature me-1"></i>Verify Response Signature</button>';
                        html += '<button class="btn btn-outline-secondary" onclick="verifyDecodedXml(\'assertion\')"><i class="fas fa-user-check me-1"></i>Verify Assertion Signature</button>';
                        html += '</div>';
                        html += '</div></div>';
                    } else {
                        html += '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>This message does not contain a digital signature. AuthnRequests sent via HTTP-Redirect binding are typically signed using query string parameters, not embedded XML signatures.</div>';
                    }
                }
            }

            // Unknown operation - show raw data
            else {
                html += '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>Operation completed</div>';
                html += '<pre class="bg-dark text-light p-3 rounded">' + escapeHtml(JSON.stringify(data, null, 2)) + '</pre>';
            }

            $('#output').html(html);
        }

        $(document).ready(function() {
            // Mode selection handling
            $('.mode-option').click(function() {
                $(this).find('input[type="radio"]').prop('checked', true);
                $('.mode-option').removeClass('active');
                $(this).addClass('active');
                updateUIForMode();
            });

            // Verify option selection
            $('.verify-option').click(function() {
                $(this).find('input[type="radio"]').prop('checked', true);
                $('.verify-option').removeClass('active');
                $(this).addClass('active');
            });

            function updateUIForMode() {
                var mode = $('input[name="verifysignatureparameter"]:checked').val();
                if (mode === 'verifysignature') {
                    $('#x509Section').show();
                    $('#verifyOptions').show();
                } else {
                    $('#x509Section').hide();
                    $('#verifyOptions').hide();
                }
            }

            // Initialize
            updateUIForMode();
            $('input[name="verifysignatureparameter"]:checked').closest('.mode-option').addClass('active');
            $('input[name="cipherparameter"]:checked').closest('.verify-option').addClass('active');

            // Check if coming from sign page with signed XML to verify
            if (window.location.search.indexOf('from=sign') !== -1) {
                var samlToVerify = sessionStorage.getItem('samlToVerify');
                var verifyCert = sessionStorage.getItem('samlVerifyCert');
                if (samlToVerify) {
                    // Load the encoded SAML (DEFLATE+Base64 format)
                    $('#samlmessage').val(samlToVerify);
                    // Load certificate if available
                    if (verifyCert) {
                        $('#x509').val(verifyCert);
                    }
                    // Clear sessionStorage
                    sessionStorage.removeItem('samlToVerify');
                    sessionStorage.removeItem('samlVerifyCert');

                    // Switch to verify mode - encoded SAML from sign page
                    $('input[value="verifysignature"]').prop('checked', true);
                    $('.mode-option').removeClass('active');
                    $('input[value="verifysignature"]').closest('.mode-option').addClass('active');
                    updateUIForMode();
                    // Show info message
                    $('#output').html('<div class="alert alert-info"><i class="fas fa-arrow-left me-2"></i><strong>Encoded SAML loaded from Sign tool (DEFLATE + Base64).</strong> The certificate has been pre-filled. Click <strong>Process</strong> to verify the signature.</div>');
                }
            }

            // Load sample for verification (Base64 encoded SAML Response) - exact copy from original
            $('#loadSampleVerify').click(function() {
                $('#samlmessage').val('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');
                $('input[value="verifysignature"]').prop('checked', true);
                $('.mode-option').removeClass('active');
                $('input[value="verifysignature"]').closest('.mode-option').addClass('active');
                updateUIForMode();
            });

            // Load sample deflated message
            $('#loadSample').click(function() {
                $('#samlmessage').val('pVNNj9owEL3vr4h8hxCSCmJtkCjbDyQKKdAeeqm8zqRryR+px9ml/752YFv3sBy2cxzPzHvz3vgWmZIdXfbuQe/hZw/okpOSGunwUJHeamoYCqSaKUDqOD0sP23odDyhnTXOcCNJsr6ryPfd9t1m92G9zSZ5MZ2Xk5LdAy+mRcvezPPprJ2VxawoZwVJvoJFYXRF/BTfjNjDWqNj2vnUJCtGWTbK8mOW0bykefGNJO+N5TCwrEjLJEJoqxmieIQ/mfrC563QjdA/rpO/Pxch/Xg81qN6dziSZIkI1nlmK6OxV2APYB8Fhy/7TUUenOtomsKJqU7CmBuVMo5kcZP4uA1y0WETGwl4nQJ7hrsMCXFBEU03jpEUONYwx85gaYQW4Xd06zHWd7WRgv96jY9eZsXc9eqQEc2oHUppF6xEB9qR5FAH/M89k6IVYCsSbeDFldI8rSww5x1ztveGpf+Qv9wfNIPP3gIHp1dd48qojlmB4cI8Be4ifc9GxQgr6X3YQ/tftoW42sMpDzg+Ha72ydjmL6X0RU6LyO8XBFrcPD/Hn3jxGw==');
                $('input[value="samlmessagedeflate"]').prop('checked', true);
                $('.mode-option').removeClass('active');
                $('input[value="samlmessagedeflate"]').closest('.mode-option').addClass('active');
                updateUIForMode();
            });

            // Form submission
            $('#form').submit(function(event) {
                event.preventDefault();
                $('#output').html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x" style="color: var(--theme-primary);"></i><p class="mt-2 text-muted">Processing...</p></div>');
                $.ajax({
                    type: "POST",
                    url: "SAMLFunctionality",
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(data) {
                        renderVerifyResult(data);
                    },
                    error: function(xhr, status, error) {
                        var errorMsg = 'Error processing request. Please try again.';
                        if (xhr.responseJSON && xhr.responseJSON.errorMessage) {
                            errorMsg = xhr.responseJSON.errorMessage;
                        }
                        $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + escapeHtml(errorMsg) + '</div>');
                    }
                });
            });

            $('#submitBtn').click(function() {
                $('#form').submit();
            });
        });
    </script>
</head>
<%@ include file="body-script.jsp"%>
    <%@ include file="pgp-menu-nav.jsp"%>
    <%@ include file="footer_adsense.jsp"%>
<div class="container mt-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <div>
            <h1 class="h4 mb-1">SAML Verify & Decode</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-check-double"></i> Signature Verify</span>
                <span class="info-badge"><i class="fas fa-code"></i> Base64 Decode</span>
                <span class="info-badge"><i class="fas fa-compress-alt"></i> Inflate</span>
            </div>
        </div>
        <div class="d-flex align-items-center gap-2 mt-2 mt-md-0">
            <a href="saml-guide.jsp" class="btn btn-sm btn-outline-secondary">
                <i class="fas fa-book-open me-1"></i>Learn SAML
            </a>
            <span class="eeat-badge">
                <i class="fas fa-user-check"></i>
                <span>Anish Nath</span>
            </span>
        </div>
    </div>

    <div class="row">
        <!-- Left Column: Input Form -->
        <div class="col-lg-5 mb-4">
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-shield-alt me-2"></i>Verify / Decode</h5>
                </div>
                <div class="card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" id="methodName" value="VERIFY_SIGNATURE_OR_DECODE">

                        <!-- Operation Mode -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-cog me-1"></i> Operation Mode</div>

                            <div class="mode-option active">
                                <input type="radio" name="verifysignatureparameter" value="verifysignature" id="modeVerify" checked>
                                <label for="modeVerify" class="mode-option-title mb-0">Verify Signature</label>
                                <div class="mode-option-desc">Validate XML signature using X.509 certificate</div>
                            </div>

                            <div class="mode-option">
                                <input type="radio" name="verifysignatureparameter" value="samlmessagedecoder" id="modeBase64">
                                <label for="modeBase64" class="mode-option-title mb-0">Base64 Decode</label>
                                <div class="mode-option-desc">Decode Base64-encoded SAML message to XML</div>
                            </div>

                            <div class="mode-option">
                                <input type="radio" name="verifysignatureparameter" value="samlmessagedeflate" id="modeDeflate">
                                <label for="modeDeflate" class="mode-option-title mb-0">Base64 + Inflate</label>
                                <div class="mode-option-desc">Decode and inflate HTTP-Redirect binding messages</div>
                            </div>
                        </div>

                        <!-- Verify Options (shown only for signature verification) -->
                        <div class="form-section" id="verifyOptions">
                            <div class="form-section-title"><i class="fas fa-check-circle me-1"></i> What to Verify</div>
                            <div class="d-flex flex-wrap">
                                <label class="verify-option active">
                                    <input type="radio" name="cipherparameter" value="response" checked>
                                    <span>Response Signature</span>
                                </label>
                                <label class="verify-option">
                                    <input type="radio" name="cipherparameter" value="assertion">
                                    <span>Assertion Signature</span>
                                </label>
                            </div>
                        </div>

                        <!-- SAML Message -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-file-code me-1"></i> SAML Message</div>
                            <textarea class="form-control" rows="10" name="samlmessage" id="samlmessage" placeholder="Paste your SAML message here..."></textarea>
                            <div class="mt-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="loadSampleVerify">
                                    <i class="fas fa-shield-alt me-1"></i> Load Sample (Verify)
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="loadSample">
                                    <i class="fas fa-compress-alt me-1"></i> Load Sample (Deflate)
                                </button>
                            </div>
                        </div>

                        <!-- X.509 Certificate (for signature verification) -->
                        <div class="form-section" id="x509Section">
                            <div class="form-section-title"><i class="fas fa-certificate me-1"></i> X.509 Certificate (IdP Public Key)</div>
                            <textarea class="form-control" rows="8" name="x509" id="x509">-----BEGIN CERTIFICATE-----
MIICgTCCAeoCCQCbOlrWDdX7FTANBgkqhkiG9w0BAQUFADCBhDELMAkGA1UEBhMC
Tk8xGDAWBgNVBAgTD0FuZHJlYXMgU29sYmVyZzEMMAoGA1UEBxMDRm9vMRAwDgYD
VQQKEwdVTklORVRUMRgwFgYDVQQDEw9mZWlkZS5lcmxhbmcubm8xITAfBgkqhkiG
9w0BCQEWEmFuZHJlYXNAdW5pbmV0dC5ubzAeFw0wNzA2MTUxMjAxMzVaFw0wNzA4
MTQxMjAxMzVaMIGEMQswCQYDVQQGEwJOTzEYMBYGA1UECBMPQW5kcmVhcyBTb2xi
ZXJnMQwwCgYDVQQHEwNGb28xEDAOBgNVBAoTB1VOSU5FVFQxGDAWBgNVBAMTD2Zl
aWRlLmVybGFuZy5ubzEhMB8GCSqGSIb3DQEJARYSYW5kcmVhc0B1bmluZXR0Lm5v
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDivbhR7P516x/S3BqKxupQe0LO
NoliupiBOesCO3SHbDrl3+q9IbfnfmE04rNuMcPsIxB161TdDpIesLCn7c8aPHIS
KOtPlAeTZSnb8QAu7aRjZq3+PbrP5uW3TcfCGPtKTytHOge/OlJbo078dVhXQ14d
1EDwXJW1rRXuUt4C8QIDAQABMA0GCSqGSIb3DQEBBQUAA4GBACDVfp86HObqY+e8
BUoWQ9+VMQx1ASDohBjwOsg2WykUqRXF+dLfcUH9dWR63CtZIKFDbStNomPnQz7n
bK+onygwBspVEbnHuUihZq3ZUdmumQqCw4Uvs/1Uvq3orOo/WJVhTyvLgFVK2Qar
Q4/67OZfHd7R+POBXhophSMv1ZOo
-----END CERTIFICATE-----</textarea>
                            <small class="text-muted mt-1 d-block">The IdP's public certificate used to verify the signature.</small>
                        </div>

                        <!-- Submit Button -->
                        <button type="button" class="btn btn-theme btn-block" id="submitBtn">
                            <i class="fas fa-play me-1"></i> Process
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Right Column: Results & Info -->
        <div class="col-lg-7 mb-4">
            <!-- Results Card -->
            <div class="card tool-card mb-3">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-file-alt me-2"></i>Results</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="result-placeholder">
                            <i class="fas fa-shield-alt"></i>
                            <h6>Results Will Appear Here</h6>
                            <p class="text-muted small mb-0">Select an operation mode, paste your SAML message, and click Process</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Guide -->
            <div class="card tool-card mb-3">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Quick Guide</h6>
                </div>
                <div class="card-body small">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mode</th>
                                <th>Input</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Verify Signature</strong></td>
                                <td>SAML XML + X.509 Cert</td>
                                <td>Validate signatures from IdP</td>
                            </tr>
                            <tr>
                                <td><strong>Base64 Decode</strong></td>
                                <td>Base64 string</td>
                                <td>HTTP-POST binding messages</td>
                            </tr>
                            <tr>
                                <td><strong>Base64 + Inflate</strong></td>
                                <td>Deflated Base64</td>
                                <td>HTTP-Redirect binding (SAMLRequest param)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Signature Verification Tips -->
            <div class="card tool-card">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-lightbulb me-2"></i>Signature Verification Tips</h6>
                </div>
                <div class="card-body small">
                    <ul class="mb-0">
                        <li><strong>Response vs Assertion:</strong> IdPs may sign the Response, the Assertion, or both. Try both options if verification fails.</li>
                        <li><strong>Certificate Mismatch:</strong> Ensure you're using the correct IdP certificate (not the SP certificate).</li>
                        <li><strong>Embedded Certificates:</strong> Some signed messages include the certificate in &lt;ds:X509Certificate&gt;. You can extract and use it.</li>
                        <li><strong>Clock Skew:</strong> Assertion conditions (NotBefore, NotOnOrAfter) may fail due to server time differences.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Educational Content -->
    <div class="row mt-2">
        <div class="col-12">
            <div class="card tool-card mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>SAML Message Processing</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>SAML Signature Verification</h6>
                            <p>SAML signatures use XML Digital Signatures (XMLDSig) to ensure message integrity and authenticity. Verification involves:</p>
                            <ol>
                                <li>Canonicalizing the signed XML element</li>
                                <li>Computing the digest of the canonicalized content</li>
                                <li>Verifying the digest matches &lt;ds:DigestValue&gt;</li>
                                <li>Verifying the signature using the IdP's public key</li>
                            </ol>

                            <h6 class="mt-3">What to Verify</h6>
                            <ul>
                                <li><strong>Response Signature:</strong> Verifies the entire &lt;samlp:Response&gt; element wasn't modified</li>
                                <li><strong>Assertion Signature:</strong> Verifies the &lt;saml:Assertion&gt; element independently</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6>SAML Message Encoding</h6>
                            <p>SAML messages are encoded differently depending on the binding:</p>
                            <ul>
                                <li><strong>HTTP-POST:</strong> Base64-encoded XML in a form field</li>
                                <li><strong>HTTP-Redirect:</strong> DEFLATE compressed, then Base64-encoded, then URL-encoded</li>
                            </ul>

                            <h6 class="mt-3">Decoding HTTP-Redirect Messages</h6>
                            <pre class="bg-dark text-light p-2 rounded small"><code># Decode SAMLRequest from URL
urldecode "$SAMLRequest" | base64 -d | inflate</code></pre>

                            <h6 class="mt-3">Security Best Practices</h6>
                            <ul>
                                <li>Always verify signatures before trusting assertions</li>
                                <li>Check NotBefore and NotOnOrAfter conditions</li>
                                <li>Validate the Issuer matches expected IdP</li>
                                <li>Verify Destination matches your ACS URL</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="row">
        <div class="col-12">
            <div class="card tool-card mb-4">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
                </div>
                <div class="card-body">
                    <div class="related-tools">
                        <a href="saml-guide.jsp" class="related-tool-card" style="border-color: var(--theme-primary); background: var(--theme-light);">
                            <h6><i class="fas fa-book-open me-1"></i>SAML Guide</h6>
                            <p>Complete guide to understanding SAML 2.0</p>
                        </a>
                        <a href="samlfunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-file-signature me-1"></i>SAML Sign</h6>
                            <p>Sign SAML XML messages</p>
                        </a>
                        <a href="rsafunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-key me-1"></i>RSA Tools</h6>
                            <p>RSA encryption, decryption, signing</p>
                        </a>
                        <a href="Base64Functions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-exchange-alt me-1"></i>Base64</h6>
                            <p>Base64 encode and decode</p>
                        </a>
                        <a href="PemParserFunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-certificate me-1"></i>PEM Parser</h6>
                            <p>Parse and decode PEM certificates</p>
                        </a>
                        <a href="JWTToken.jsp" class="related-tool-card">
                            <h6><i class="fas fa-ticket-alt me-1"></i>JWT Decoder</h6>
                            <p>Decode and verify JWT tokens</p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>


    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
</div>
<%@ include file="body-close.jsp"%>
