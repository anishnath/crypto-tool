<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>SAML Sign XML Online – Free | 8gwifi.org</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online SAML XML signing tool. Sign AuthnRequest, SAML Response, Assertions with RSA/DSA keys. Generate embedded signatures (HTTP-POST) and redirect binding signatures. SSO debugging made easy.">
    <meta name="keywords" content="saml sign xml, saml signature, authnrequest sign, saml response sign, xml signature, sso tool, saml online, identity provider, service provider">

    <!-- Open Graph -->
    <meta property="og:title" content="SAML Sign XML Online – Free | 8gwifi.org">
    <meta property="og:description" content="Sign SAML AuthnRequest, Response, and Assertions with your private key. Generate XML signatures for SSO integration testing.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/samlfunctions.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/samlsign.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="SAML Sign XML Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Sign SAML messages online. AuthnRequest, SAML Response, Assertions with RSA/DSA signatures.">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/samlfunctions.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@graph": [
            {
                "@type": "WebApplication",
                "@id": "https://8gwifi.org/samlfunctions.jsp#app",
                "name": "SAML Sign XML Online",
                "description": "Free online tool to sign SAML XML messages including AuthnRequest, SAML Response, and Assertions using RSA or DSA private keys.",
                "url": "https://8gwifi.org/samlfunctions.jsp",
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
                "datePublished": "2018-03-23",
                "dateModified": "2025-01-28"
            },
            {
                "@type": "FAQPage",
                "mainEntity": [
                    {
                        "@type": "Question",
                        "name": "What is SAML XML signing?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "SAML XML signing adds a digital signature to SAML messages (AuthnRequest, Response, Assertions) using XML Signature (XMLDSig) standard. This ensures the message integrity and authenticity between Identity Providers and Service Providers."
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "Which signature algorithms are supported?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "This tool supports RSA-SHA1, RSA-SHA256, RSA-SHA384, RSA-SHA512, DSA-SHA1, and DSA-SHA256 signature algorithms as defined in the XML Signature specification."
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

        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
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

        .sample-select {
            max-width: 100%;
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
        $(document).ready(function() {
            $('#ctrTitles').change(function() {
                var pem = $(this).val();
                $("#p_xml").val(pem);
            });

            function escapeHtml(text) {
                if (!text) return '';
                var div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            function copyToClipboard(text) {
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text);
                } else {
                    var ta = document.createElement('textarea');
                    ta.value = text;
                    ta.style.position = 'fixed';
                    ta.style.opacity = '0';
                    document.body.appendChild(ta);
                    ta.select();
                    try { document.execCommand('copy'); } catch (e) {}
                    document.body.removeChild(ta);
                }
            }

            function showToast(message, isError) {
                var bgColor = isError ? '#dc3545' : 'var(--theme-gradient)';
                var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
                    '<div class="toast show"><div class="toast-body text-white rounded" style="background: ' + bgColor + ';">' +
                    '<i class="fas ' + (isError ? 'fa-exclamation-circle' : 'fa-check-circle') + ' me-2"></i>' + message +
                    '</div></div></div>');
                $('body').append(toast);
                setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2500);
            }

            function renderSignResult(data) {
                var html = '';

                if (!data.success) {
                    html = '<div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>' + escapeHtml(data.errorMessage) + '</div>';
                    $('#output').html(html);
                    return;
                }

                // Success
                html += '<div class="alert alert-success mb-3"><i class="fas fa-check-circle me-2"></i><strong>XML Signed Successfully!</strong></div>';

                // Message type badge
                if (data.messageType) {
                    html += '<div class="mb-3"><span class="badge bg-info">' + escapeHtml(data.messageType) + '</span>';
                    if (data.signatureAlgorithm) {
                        html += ' <span class="badge bg-secondary">' + escapeHtml(data.signatureAlgorithm.split('#').pop()) + '</span>';
                    }
                    html += '</div>';
                }

                // Store signed XML and encoded version for verify function
                window.lastSignedXml = data.signedXml;
                window.lastEncodedXml = data.encodedXml || null;

                // Signed XML output
                html += '<div class="mb-3">';
                html += '<label class="form-label fw-bold"><i class="fas fa-file-code me-1"></i> Signed XML</label>';
                html += '<div class="input-group">';
                html += '<textarea class="form-control" id="signedXmlOutput" rows="8" readonly style="font-family: monospace; font-size: 0.85rem;">' + escapeHtml(data.signedXml) + '</textarea>';
                html += '</div>';
                html += '<button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="copySignedXml()"><i class="fas fa-copy me-1"></i> Copy XML</button>';
                html += '</div>';

                // Encoded XML (DEFLATE+Base64) for verification
                if (data.encodedXml) {
                    html += '<div class="mb-3">';
                    html += '<label class="form-label fw-bold"><i class="fas fa-compress-alt me-1"></i> Encoded SAML (DEFLATE + Base64)</label>';
                    html += '<small class="text-muted d-block mb-1">Use this format for HTTP-Redirect binding or signature verification</small>';
                    html += '<textarea class="form-control" id="encodedXmlOutput" rows="4" readonly style="font-family: monospace; font-size: 0.85rem;">' + escapeHtml(data.encodedXml) + '</textarea>';
                    html += '<div class="mt-2 d-flex flex-wrap gap-2">';
                    html += '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="copyEncodedXml()"><i class="fas fa-copy me-1"></i> Copy Encoded</button>';
                    html += '<button type="button" class="btn btn-sm btn-theme" onclick="verifySignedXml()"><i class="fas fa-check-double me-1"></i> Verify Signature</button>';
                    html += '</div>';
                    html += '</div>';
                }

                // Signature (if present)
                if (data.signature) {
                    html += '<div class="mb-3">';
                    html += '<label class="form-label fw-bold"><i class="fas fa-signature me-1"></i> Signature (for HTTP-Redirect)</label>';
                    html += '<textarea class="form-control" id="signatureOutput" rows="4" readonly style="font-family: monospace; font-size: 0.85rem;">' + escapeHtml(data.signature) + '</textarea>';
                    html += '<button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="copySignature()"><i class="fas fa-copy me-1"></i> Copy Signature</button>';
                    html += '</div>';
                }

                // Signature calculation logic (if relay state provided)
                if (data.signatureCalculationLogic) {
                    html += '<div class="mb-3">';
                    html += '<label class="form-label fw-bold"><i class="fas fa-calculator me-1"></i> Signature Calculation (HTTP-Redirect)</label>';
                    html += '<div class="alert alert-info small mb-0">';
                    html += '<code>' + escapeHtml(data.signatureCalculationLogic) + '</code>';
                    html += '</div>';
                    html += '</div>';
                }

                $('#output').html(html);
            }

            // Global copy functions
            window.copySignedXml = function() {
                copyToClipboard($('#signedXmlOutput').val());
                showToast('Signed XML copied!');
            };

            window.copySignature = function() {
                copyToClipboard($('#signatureOutput').val());
                showToast('Signature copied!');
            };

            window.copyEncodedXml = function() {
                copyToClipboard($('#encodedXmlOutput').val());
                showToast('Encoded SAML copied!');
            };

            // Verify signed XML - opens verify page with the encoded XML pre-loaded
            window.verifySignedXml = function() {
                // Prefer encoded XML (DEFLATE+Base64) for verification, fall back to raw XML
                var xmlToVerify = window.lastEncodedXml || window.lastSignedXml;
                if (!xmlToVerify) {
                    showToast('No signed XML available', true);
                    return;
                }
                // Store the encoded/signed XML for verification
                sessionStorage.setItem('samlToVerify', xmlToVerify);
                sessionStorage.setItem('samlVerifyCert', $('#p_key').val() || '');
                window.location.href = 'samlverifysign.jsp?from=sign';
            };

            $('#form').submit(function(event) {
                event.preventDefault();
                $('#output').html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x" style="color: var(--theme-primary);"></i><p class="mt-2 text-muted">Signing XML...</p></div>');
                $.ajax({
                    type: "POST",
                    url: "SAMLFunctionality",
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(data) {
                        renderSignResult(data);
                    },
                    error: function(xhr) {
                        var errorMsg = 'Error processing request. Please try again.';
                        try {
                            var resp = JSON.parse(xhr.responseText);
                            if (resp.errorMessage) errorMsg = resp.errorMessage;
                        } catch(e) {}
                        $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>' + errorMsg + '</div>');
                    }
                });
            });

            $('#Sign-XML').click(function(event) {
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
            <h1 class="h4 mb-1">SAML Sign XML</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-signature"></i> XML Signature</span>
                <span class="info-badge"><i class="fas fa-key"></i> RSA/DSA</span>
                <span class="info-badge"><i class="fas fa-exchange-alt"></i> SSO</span>
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
                    <h5><i class="fas fa-file-signature me-2"></i>Sign SAML XML</h5>
                </div>
                <div class="card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" id="methodName" value="SIGN_XML">

                        <!-- Sample SAML Selection -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-file-code me-1"></i> Sample SAML Messages</div>
                            <select name="ctrTitles" id="ctrTitles" class="form-control sample-select">
                                <option value="">-- Select a sample SAML message --</option>
                                <option value="&lt;samlp:AuthnRequest xmlns:samlp=&quot;urn:oasis:names:tc:SAML:2.0:protocol&quot; xmlns:saml=&quot;urn:oasis:names:tc:SAML:2.0:assertion&quot; ID=&quot;ONELOGIN_809707f0030a5d00620c9d9df97f627afe9dcc24&quot; Version=&quot;2.0&quot; ProviderName=&quot;SP test&quot; IssueInstant=&quot;2014-07-16T23:52:45Z&quot; Destination=&quot;http://idp.example.com/SSOService.php&quot; ProtocolBinding=&quot;urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&quot; AssertionConsumerServiceURL=&quot;http://sp.example.com/demo1/index.php?acs&quot;&gt;
  &lt;saml:Issuer&gt;http://sp.example.com/demo1/metadata.php&lt;/saml:Issuer&gt;
  &lt;samlp:NameIDPolicy Format=&quot;urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress&quot; AllowCreate=&quot;true&quot;/&gt;
  &lt;samlp:RequestedAuthnContext Comparison=&quot;exact&quot;&gt;
    &lt;saml:AuthnContextClassRef&gt;urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport&lt;/saml:AuthnContextClassRef&gt;
  &lt;/samlp:RequestedAuthnContext&gt;
&lt;/samlp:AuthnRequest&gt;">AuthnRequest (unsigned)</option>
                                <option value="&lt;samlp:Response xmlns:samlp=&quot;urn:oasis:names:tc:SAML:2.0:protocol&quot; xmlns:saml=&quot;urn:oasis:names:tc:SAML:2.0:assertion&quot; ID=&quot;_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6&quot; Version=&quot;2.0&quot; IssueInstant=&quot;2014-07-17T01:01:48Z&quot; Destination=&quot;http://sp.example.com/demo1/index.php?acs&quot; InResponseTo=&quot;ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685&quot;&gt;
  &lt;saml:Issuer&gt;http://idp.example.com/metadata.php&lt;/saml:Issuer&gt;
  &lt;samlp:Status&gt;
    &lt;samlp:StatusCode Value=&quot;urn:oasis:names:tc:SAML:2.0:status:Success&quot;/&gt;
  &lt;/samlp:Status&gt;
  &lt;saml:Assertion xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xs=&quot;http://www.w3.org/2001/XMLSchema&quot; ID=&quot;_d71a3a8e9fcc45c9e9d248ef7049393fc8f04e5f75&quot; Version=&quot;2.0&quot; IssueInstant=&quot;2014-07-17T01:01:48Z&quot;&gt;
    &lt;saml:Issuer&gt;http://idp.example.com/metadata.php&lt;/saml:Issuer&gt;
    &lt;saml:Subject&gt;
      &lt;saml:NameID SPNameQualifier=&quot;http://sp.example.com/demo1/metadata.php&quot; Format=&quot;urn:oasis:names:tc:SAML:2.0:nameid-format:transient&quot;&gt;_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7&lt;/saml:NameID&gt;
      &lt;saml:SubjectConfirmation Method=&quot;urn:oasis:names:tc:SAML:2.0:cm:bearer&quot;&gt;
        &lt;saml:SubjectConfirmationData NotOnOrAfter=&quot;2024-01-18T06:21:48Z&quot; Recipient=&quot;http://sp.example.com/demo1/index.php?acs&quot; InResponseTo=&quot;ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685&quot;/&gt;
      &lt;/saml:SubjectConfirmation&gt;
    &lt;/saml:Subject&gt;
    &lt;saml:Conditions NotBefore=&quot;2014-07-17T01:01:18Z&quot; NotOnOrAfter=&quot;2024-01-18T06:21:48Z&quot;&gt;
      &lt;saml:AudienceRestriction&gt;
        &lt;saml:Audience&gt;http://sp.example.com/demo1/metadata.php&lt;/saml:Audience&gt;
      &lt;/saml:AudienceRestriction&gt;
    &lt;/saml:Conditions&gt;
    &lt;saml:AuthnStatement AuthnInstant=&quot;2014-07-17T01:01:48Z&quot; SessionNotOnOrAfter=&quot;2024-07-17T09:01:48Z&quot; SessionIndex=&quot;_be9967abd904ddcae3c0eb4189adbe3f71e327cf93&quot;&gt;
      &lt;saml:AuthnContext&gt;
        &lt;saml:AuthnContextClassRef&gt;urn:oasis:names:tc:SAML:2.0:ac:classes:Password&lt;/saml:AuthnContextClassRef&gt;
      &lt;/saml:AuthnContext&gt;
    &lt;/saml:AuthnStatement&gt;
    &lt;saml:AttributeStatement&gt;
      &lt;saml:Attribute Name=&quot;uid&quot; NameFormat=&quot;urn:oasis:names:tc:SAML:2.0:attrname-format:basic&quot;&gt;
        &lt;saml:AttributeValue xsi:type=&quot;xs:string&quot;&gt;test&lt;/saml:AttributeValue&gt;
      &lt;/saml:Attribute&gt;
      &lt;saml:Attribute Name=&quot;mail&quot; NameFormat=&quot;urn:oasis:names:tc:SAML:2.0:attrname-format:basic&quot;&gt;
        &lt;saml:AttributeValue xsi:type=&quot;xs:string&quot;&gt;test@example.com&lt;/saml:AttributeValue&gt;
      &lt;/saml:Attribute&gt;
    &lt;/saml:AttributeStatement&gt;
  &lt;/saml:Assertion&gt;
&lt;/samlp:Response&gt;">SAML Response (unsigned)</option>
                                <option value="&lt;samlp:LogoutRequest xmlns:samlp=&quot;urn:oasis:names:tc:SAML:2.0:protocol&quot; xmlns:saml=&quot;urn:oasis:names:tc:SAML:2.0:assertion&quot; ID=&quot;ONELOGIN_21df91a89767879fc0f7df6a1490c6000c81644d&quot; Version=&quot;2.0&quot; IssueInstant=&quot;2014-07-18T01:13:06Z&quot; Destination=&quot;http://idp.example.com/SingleLogoutService.php&quot;&gt;
  &lt;saml:Issuer&gt;http://sp.example.com/demo1/metadata.php&lt;/saml:Issuer&gt;
  &lt;saml:NameID SPNameQualifier=&quot;http://sp.example.com/demo1/metadata.php&quot; Format=&quot;urn:oasis:names:tc:SAML:2.0:nameid-format:transient&quot;&gt;ONELOGIN_f92cc1834efc0f73e9c09f482fce80037a6251e7&lt;/saml:NameID&gt;
&lt;/samlp:LogoutRequest&gt;">Logout Request</option>
                                <option value="&lt;samlp:LogoutResponse xmlns:samlp=&quot;urn:oasis:names:tc:SAML:2.0:protocol&quot; xmlns:saml=&quot;urn:oasis:names:tc:SAML:2.0:assertion&quot; ID=&quot;_6c3737282f007720e736f0f4028feed8cb9b40291c&quot; Version=&quot;2.0&quot; IssueInstant=&quot;2014-07-18T01:13:06Z&quot; Destination=&quot;http://sp.example.com/demo1/index.php?acs&quot; InResponseTo=&quot;ONELOGIN_21df91a89767879fc0f7df6a1490c6000c81644d&quot;&gt;
  &lt;saml:Issuer&gt;http://idp.example.com/metadata.php&lt;/saml:Issuer&gt;
  &lt;samlp:Status&gt;
    &lt;samlp:StatusCode Value=&quot;urn:oasis:names:tc:SAML:2.0:status:Success&quot;/&gt;
  &lt;/samlp:Status&gt;
&lt;/samlp:LogoutResponse&gt;">Logout Response</option>
                            </select>
                            <small class="text-muted mt-1 d-block">Select a sample or paste your own XML below.</small>
                        </div>

                        <!-- Signature Algorithm -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-cog me-1"></i> Signature Algorithm</div>
                            <select name="xmlsignaturealgo" id="xmlsignaturealgo" class="form-control">
                                <option value="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256">RSA-SHA256 (Recommended)</option>
                                <option value="http://www.w3.org/2001/04/xmldsig-more#rsa-sha512">RSA-SHA512</option>
                                <option value="http://www.w3.org/2001/04/xmldsig-more#rsa-sha384">RSA-SHA384</option>
                                <option value="http://www.w3.org/2000/09/xmldsig#rsa-sha1">RSA-SHA1 (Legacy)</option>
                                <option value="http://www.w3.org/2009/xmldsig11#dsa-sha256">DSA-SHA256</option>
                                <option value="http://www.w3.org/2000/09/xmldsig#dsa-sha1">DSA-SHA1 (Legacy)</option>
                            </select>
                        </div>

                        <!-- XML to Sign -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-code me-1"></i> XML to Sign</div>
                            <textarea class="form-control" rows="6" name="p_xml" id="p_xml" placeholder="Paste your SAML XML here or select a sample above..."></textarea>
                        </div>

                        <!-- X.509 Certificate -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-certificate me-1"></i> X.509 Certificate</div>
                            <textarea class="form-control" rows="6" name="p_key" id="p_key">-----BEGIN CERTIFICATE-----
MIICwDCCAaigAwIBAgIEZ3cS4zANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApJ
bnRlcm1lZENBMB4XDTE4MTIwOTE0MTYxN1oXDTI1MTIzMDE4MzAwMFowEDEOMAwG
A1UEAwwFaGVsbG8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQChGc3k
67vzhZh44oddqYHRse582kMYnBZS4I8ruQGZwYaaMr4uUYdxw09Mh+VoYF3x3G8Y
ZqyoJ6Wvf0oVR9/JoerM7aV3PdRDvm3GoturpF0fHLRLbS7fBy/YkR66fIy/iqBZ
j5FESLSymWiZ1LLcwwWJRgesZRftEE+QQhYccy+/IjKCXiRZgboUieY6Y3qfw01i
mk55rRROylQE7U34j1AiVPJdHEgFBntVEEGASTBzLXYhiZzAHttf8tEO4l4wZzmQ
MTvaU8E4Ro2wvLD7mU9P6VPz7g8f5KNGI8oGyKh2cZlwfRXe/NQuKCSA9hLyD7+y
5prC2X+PjybpQUXFAgMBAAGjHTAbMA4GA1UdDwEB/wQEAwIHgDAJBgNVHRMEAjAA
MA0GCSqGSIb3DQEBCwUAA4IBAQA5AsCG0e2+5Y7KRqqJCr6u9KfDFIYWXFFAoBam
bjiqmw1ZcK787jIPmMAVpTTycnZ6GoXXLdorpyDq4FPUKU47GHv0ByzThKBJpYNQ
EW1fcRdxAnUf23XV/6U51SBbFuF4C2NKpzv6NPiQz8yIZeie3FOCjPGLlfrextqN
hXBomt5C6HZ6LqG5cN/lvR1z+y8MgcgwBzBHGATYPUfQ7pt22BZ7nncHXCGhO2LB
dx9hHaM3I2LFaC7YW+nQUrK8YcPnahGTxA7Nu9U1QfCH/3bwRU3iMwOaR/7ntWUn
GvIBGiHQc2kA27aWPVfuYf+u7sTJ2Qh0syo9+Mqm7QXzcHyK
-----END CERTIFICATE-----</textarea>
                        </div>

                        <!-- Private Key -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-key me-1"></i> Private Key</div>
                            <textarea class="form-control" rows="6" name="p_privkey" id="p_privkey">-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAoRnN5Ou784WYeOKHXamB0bHufNpDGJwWUuCPK7kBmcGGmjK+
LlGHccNPTIflaGBd8dxvGGasqCelr39KFUffyaHqzO2ldz3UQ75txqLbq6RdHxy0
S20u3wcv2JEeunyMv4qgWY+RREi0splomdSy3MMFiUYHrGUX7RBPkEIWHHMvvyIy
gl4kWYG6FInmOmN6n8NNYppOea0UTspUBO1N+I9QIlTyXRxIBQZ7VRBBgEkwcy12
IYmcwB7bX/LRDuJeMGc5kDE72lPBOEaNsLyw+5lPT+lT8+4PH+SjRiPKBsiodnGZ
cH0V3vzULigkgPYS8g+/suaawtl/j48m6UFFxQIDAQABAoIBAAZFomn4sYsUFvER
5LJFUKwQ0NekibsyDH5yhrBtlf3d9ncXZacY/nxz3aj9m3VaVx389ohNKwiq7nzs
KD622yQW/TS4RdpkGlj+13hFy+adUhDNhclv+USum3LDh548DiDA7Wg/Oikd6YcQ
iO2ARexpXVRQWSkhkHJm0aosoH6//2T9cM9LAqyvTsOhFf80ecBy2U/um1vu6zb0
g2i4I03Rm8QD0ty0/xw70A5DD+PG3U50uXnoZThgmUlwDVOxGoIFWAFTlp9VTezJ
AY+TPxoyzqiS6DTh4BrXDFHhVpLlejC5I3EI2JFSWoysdH2tZ9oBAqlPcrkazrab
vZWXm8sCgYEA4P1X/PS6QNQAM1Lk6cyMRwaTj2ftjaUHHY+8Btptx3oUzwcYFM43
Vw6/2khrlEmLDO32ke2ydTsN14/RywWM3QCAQ8xOOpuboHiEfkp3S377OqZft+z+
pyh47HTy3l/1fMt02D123vfAoQVyBecRwRbt1k9+1g+aYP4pEe/rlzcCgYEAt04s
J4iKjtIcsluFN8wOY52Kd54TUI3JA/PolvzkW5sh5tTyB36N3tQrnEaslnRSX2MZ
GWp8FtZN5o/ulGJ8qiklA3GN08B1FFlTKEYiNjxDSyezK1/FnmAnOIFCiJls30tW
PD2UoImIKjoEtssQw7FoYQ21uU6b/viyQ/8vUOMCgYBH3sXnqSmCIfa6bmVvhgbd
fW1PpwxMbgYa3Fpc+hONYCMbixGXO9STu8NvcCjlYqTHiZB1Ry/1oNqoHGoQ54H6
6vkOL0piEGkjVrxEN3dqJ3MLZjA3ab5jGVufdTBL9u1NYxS9Ks05Jn1jMoEc/5Y9
TxzEk/pZWPygtS/baf+g+wKBgQCG1ioEqpvBky0oxcmo0aGEBU7lzpHGn4VOMwzU
hBI2kFbPxbSDbsRNNSUfP52UztwI7ox39axx4BJNl3KYFBo/0SQ49D6vlNKKtWpG
JdDktE+L6RgSv9BOP8yZ8/tNIA7F8lTs2x+JN6HB7gupqpYaXVW6jqsuNHTriWUY
P44+oQKBgG8g1fE/A2f17B0trZdYGVAc5cwkiZbUjHdxAjD53AGItrtnS3rjQwe0
TOzBp9BY2Mf/6eDhTNcWSjlAqUNPJ2PdWUbcVfEdEoJGhzQO1tbpePIOUCFvShxB
ZbT5EXjFautmGROwWOoDrLHBnL2q/befzKbnat33Oe3IKupehqzy
-----END RSA PRIVATE KEY-----</textarea>
                            <small class="text-muted mt-1 d-block">Your private key is processed server-side and never stored.</small>
                        </div>

                        <!-- Optional Fields -->
                        <div class="form-section">
                            <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i> Optional Settings</div>
                            <div class="mb-2">
                                <label class="small text-muted">Relay State</label>
                                <input class="form-control form-control-sm" type="text" name="p_relaystate" id="p_relaystate" placeholder="Optional relay state parameter">
                            </div>
                            <div class="mb-0">
                                <label class="small text-muted">Private Key Password (if encrypted)</label>
                                <input class="form-control form-control-sm" type="password" name="passphrase" id="passphrase" placeholder="Leave empty if not encrypted">
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="button" class="btn btn-theme btn-block" id="Sign-XML">
                            <i class="fas fa-file-signature me-1"></i> Sign XML
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
                    <h5><i class="fas fa-check-circle me-2"></i>Signed Output</h5>
                </div>
                <div class="card-body">
                    <div id="output">
                        <div class="result-placeholder">
                            <i class="fas fa-file-signature"></i>
                            <h6>Signed XML Will Appear Here</h6>
                            <p class="text-muted small mb-0">Enter XML, certificate, and private key, then click "Sign XML"</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Info Card -->
            <div class="card tool-card mb-3">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>About SAML Signing</h6>
                </div>
                <div class="card-body small">
                    <p><strong>SAML XML Signing</strong> adds a digital signature to SAML messages using the XML Signature (XMLDSig) standard. This provides:</p>
                    <ul class="mb-2">
                        <li><strong>Message Integrity:</strong> Detects if the message was tampered with</li>
                        <li><strong>Authentication:</strong> Proves the message came from the expected sender</li>
                        <li><strong>Non-repudiation:</strong> Sender cannot deny sending the message</li>
                    </ul>
                    <p class="mb-1"><strong>Common Use Cases:</strong></p>
                    <ul class="mb-0">
                        <li>Sign AuthnRequest from Service Provider (SP)</li>
                        <li>Sign SAML Response from Identity Provider (IdP)</li>
                        <li>Sign individual Assertions within a Response</li>
                        <li>Sign LogoutRequest/LogoutResponse messages</li>
                    </ul>
                </div>
            </div>

            <!-- Algorithm Guide -->
            <div class="card tool-card">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-cogs me-2"></i>Signature Algorithms</h6>
                </div>
                <div class="card-body">
                    <table class="table table-sm table-bordered mb-0 small">
                        <thead class="table-light">
                            <tr>
                                <th>Algorithm</th>
                                <th>URI</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="table-success">
                                <td><strong>RSA-SHA256</strong></td>
                                <td class="text-monospace small">xmldsig-more#rsa-sha256</td>
                                <td><span class="badge bg-success">Recommended</span></td>
                            </tr>
                            <tr class="table-success">
                                <td><strong>RSA-SHA512</strong></td>
                                <td class="text-monospace small">xmldsig-more#rsa-sha512</td>
                                <td><span class="badge bg-success">Recommended</span></td>
                            </tr>
                            <tr>
                                <td>RSA-SHA1</td>
                                <td class="text-monospace small">xmldsig#rsa-sha1</td>
                                <td><span class="badge bg-warning text-dark">Legacy</span></td>
                            </tr>
                            <tr>
                                <td>DSA-SHA256</td>
                                <td class="text-monospace small">xmldsig11#dsa-sha256</td>
                                <td><span class="badge bg-secondary">Niche</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Educational Content -->
    <div class="row mt-2">
        <div class="col-12">
            <div class="card tool-card mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding SAML</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>SAML Message Types</h6>
                            <ul>
                                <li><strong>AuthnRequest:</strong> SP requests authentication from IdP (base64 deflated for HTTP-Redirect)</li>
                                <li><strong>SAMLResponse:</strong> IdP returns authentication result with Assertions</li>
                                <li><strong>SAML Assertions:</strong> Statements about the subject (user), including attributes</li>
                                <li><strong>LogoutRequest/Response:</strong> Single Logout (SLO) messages</li>
                            </ul>

                            <h6 class="mt-3">XML Signature Locations</h6>
                            <ul>
                                <li><strong>Response Signature:</strong> Signs the entire &lt;samlp:Response&gt;</li>
                                <li><strong>Assertion Signature:</strong> Signs the &lt;saml:Assertion&gt; element</li>
                                <li><strong>Both:</strong> Some IdPs sign both Response and Assertion</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6>SAML Bindings</h6>
                            <ul>
                                <li><strong>HTTP-POST:</strong> Full XML with embedded signature in form POST</li>
                                <li><strong>HTTP-Redirect:</strong> Deflated + Base64 URL-encoded, signature in query params</li>
                                <li><strong>SOAP:</strong> Used for back-channel (Artifact Resolution, AttributeQuery)</li>
                            </ul>

                            <h6 class="mt-3">Security Considerations</h6>
                            <ul>
                                <li>Always verify signatures on received SAML messages</li>
                                <li>Use SHA-256 or stronger algorithms (avoid SHA-1)</li>
                                <li>Validate certificate chain and expiration</li>
                                <li>Check assertion conditions (NotBefore, NotOnOrAfter)</li>
                            </ul>
                        </div>
                    </div>

                    <h6 class="mt-3">References</h6>
                    <ul class="mb-0">
                        <li><a href="http://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf" target="_blank" rel="noopener">OASIS SAML 2.0 Core Specification</a></li>
                        <li><a href="https://www.w3.org/TR/xmldsig-core1/" target="_blank" rel="noopener">W3C XML Signature Syntax and Processing</a></li>
                        <li><a href="https://addons.mozilla.org/en-US/firefox/addon/saml-tracer/" target="_blank" rel="noopener">Firefox SAML Tracer Plugin</a></li>
                    </ul>
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
                        <a href="samlverifysign.jsp" class="related-tool-card">
                            <h6><i class="fas fa-check-double me-1"></i>SAML Verify</h6>
                            <p>Verify SAML signatures and decode messages</p>
                        </a>
                        <a href="rsafunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-key me-1"></i>RSA Tools</h6>
                            <p>RSA encryption, decryption, signing</p>
                        </a>
                        <a href="PemParserFunctions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-certificate me-1"></i>PEM Parser</h6>
                            <p>Parse and decode PEM certificates</p>
                        </a>
                        <a href="JWTToken.jsp" class="related-tool-card">
                            <h6><i class="fas fa-ticket-alt me-1"></i>JWT Decoder</h6>
                            <p>Decode and verify JWT tokens</p>
                        </a>
                        <a href="Base64Functions.jsp" class="related-tool-card">
                            <h6><i class="fas fa-exchange-alt me-1"></i>Base64</h6>
                            <p>Base64 encode and decode</p>
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

