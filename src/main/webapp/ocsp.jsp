<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>OCSP Checker Online - Certificate Revocation Status | 8gwifi.org</title>
    <meta name="description" content="Check SSL/TLS certificate revocation status online using OCSP (Online Certificate Status Protocol). Verify if your certificate has been revoked, debug OCSP responses, and extract OCSP responder URI." />
    <meta name="keywords" content="OCSP checker, certificate revocation, SSL certificate status, OCSP responder, certificate validation, OCSP online, openssl ocsp" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/ocsp.jsp" />

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "OCSP Certificate Checker",
            "description": "Check SSL/TLS certificate revocation status online using OCSP protocol. Debug OCSP requests and responses.",
            "url": "https://8gwifi.org/ocsp.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript",
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
            "datePublished": "2018-09-09",
            "dateModified": "2025-01-15"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Check Certificate Revocation Status via OCSP",
            "description": "Step-by-step guide to verify SSL certificate status using OCSP",
            "step": [
                {
                    "@type": "HowToStep",
                    "name": "Paste Server Certificate",
                    "text": "Copy and paste the PEM-encoded server certificate to check"
                },
                {
                    "@type": "HowToStep",
                    "name": "Add Issuer Certificate",
                    "text": "Paste the intermediate/issuer certificate that signed the server certificate"
                },
                {
                    "@type": "HowToStep",
                    "name": "Perform OCSP Query",
                    "text": "Click the button to send an OCSP request and view the revocation status"
                }
            ],
            "tool": {
                "@type": "HowToTool",
                "name": "8gwifi.org OCSP Checker"
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
                    "name": "What is OCSP?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "OCSP (Online Certificate Status Protocol) is an Internet protocol used to obtain the revocation status of an X.509 digital certificate. It is an alternative to CRLs (Certificate Revocation Lists) and provides real-time certificate status."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What does OCSP response 'good' mean?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "An OCSP response of 'good' indicates that the certificate has not been revoked and is currently valid according to the Certificate Authority."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Why is my OCSP response 'unauthorized'?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "An 'unauthorized' OCSP response typically means the OCSP responder doesn't recognize the certificate or the issuer certificate is incorrect. Make sure you're using the correct intermediate certificate."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #059669;
            --theme-secondary: #10b981;
            --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 50%, #34d399 100%);
            --theme-light: #ecfdf5;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(5, 150, 105, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 300px;
            display: flex;
            flex-direction: column;
        }
        .result-placeholder {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .result-content {
            display: none;
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
        .info-badge {
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .ocsp-status {
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 1rem;
        }
        .ocsp-good {
            background: #d1fae5;
            border: 2px solid #10b981;
            color: #065f46;
        }
        .ocsp-revoked {
            background: #fee2e2;
            border: 2px solid #ef4444;
            color: #991b1b;
        }
        .ocsp-unknown {
            background: #fef3c7;
            border: 2px solid #f59e0b;
            color: #92400e;
        }
        .terminal-block {
            background: #1e1e1e;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .terminal-header {
            background: #323232;
            color: #d4d4d4;
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .terminal-body {
            padding: 1rem;
            color: #4ec9b0;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.8rem;
            overflow-x: auto;
        }
        .terminal-body code {
            color: #ce9178;
        }
        .cmd-description {
            color: #6a9955;
            font-size: 0.75rem;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(5, 150, 105, 0.2);
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
        .cert-textarea {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.75rem;
            background: #f8fafc;
        }
        .char-counter {
            font-size: 0.7rem;
            color: #6c757d;
            text-align: right;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">OCSP Certificate Checker</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Real-time Check</span>
            <span class="info-badge"><i class="fas fa-certificate"></i> X.509</span>
            <span class="info-badge"><i class="fas fa-check-circle"></i> RFC 6960</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<!-- Deprecation Warning Banner -->
<div class="alert alert-warning border-warning mb-3" role="alert" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-left: 4px solid #f59e0b !important;">
    <div class="d-flex align-items-start">
        <i class="fas fa-exclamation-triangle fa-lg me-3 mt-1" style="color: #d97706;"></i>
        <div>
            <h6 class="alert-heading mb-1" style="color: #92400e; font-weight: 700;">
                <i class="fas fa-clock me-1"></i>OCSP Deprecation Notice - Let's Encrypt
            </h6>
            <p class="mb-2 small" style="color: #78350f;">
                <strong>Let's Encrypt is ending OCSP support in 2025</strong> in favor of Certificate Revocation Lists (CRLs) for improved privacy.
                The sample certificates on this page use Let's Encrypt and will no longer work after OCSP shutdown.
            </p>
            <div class="small" style="color: #92400e;">
                <strong>Timeline:</strong>
                <ul class="mb-1 ps-3">
                    <li><strong>Jan 30, 2025:</strong> OCSP Must-Staple requests will fail</li>
                    <li><strong>May 7, 2025:</strong> New certificates won't include OCSP URLs</li>
                    <li><strong>Aug 6, 2025:</strong> OCSP responders go offline</li>
                </ul>
            </div>
            <a href="https://letsencrypt.org/2024/12/05/ending-ocsp" target="_blank" class="small" style="color: #b45309;">
                <i class="fas fa-external-link-alt me-1"></i>Read the official announcement
            </a>
        </div>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-search me-2"></i>OCSP Query</h5>
            </div>
            <div class="card-body">
                <form id="ocspForm">
                    <input type="hidden" name="methodName" value="CALCULATE_OCSP">

                    <!-- Server Certificate -->
                    <div class="form-section">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="form-section-title mb-0"><i class="fas fa-certificate me-1"></i>Server Certificate</div>
                            <div class="char-counter"><span id="cert1Chars">0</span> chars</div>
                        </div>
                        <textarea class="form-control cert-textarea" rows="6" name="p_pem1" id="p_pem1" required>-----BEGIN CERTIFICATE-----
MIIF/TCCBOWgAwIBAgISA/80l7+l1Fw2xRGAn5/V8owgMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xODA3MjIwNzU5MjRaFw0x
ODEwMjAwNzU5MjRaMBUxEzARBgNVBAMTCjhnd2lmaS5vcmcwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDD80G293JoZaHdzQZ1y9qT5HaaxumFhmrhkhsZ
BvvYY7WezLzuKkRgb+eyiBT0z5gzPfW3CKnNc/RXlPT53eRUf3zy8EWwzGgUHODi
+x86g2HHzOOIJUMhFcu8nMxlFWmYUE3CzwcZCVXJyLMiPbOIqd5XuTxrbebLrI2Q
mytV7YLCfUurlv+X6HEhjGGTqQzdjJRF0LvrALPgPJhxbMgwpmVWi797f2noHKTj
ZeqRKS9pl4dZpEgBlpLbkRc+N8tWAfKiWAw/HDN7RkLKuTNKmAWlKMAZdjRFDTOc
vIC/IKQzWFYhkCt29dvIQMrr+sCVB/gQ0cBjK+ms2y2bT7pJAgMBAAGjggMQMIID
DDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMC
MAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFASRBHzTfFovjmNwcgLnhzoUIunZMB8G
A1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEBBGMwYTAu
BggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0Lm9yZzAv
BggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0Lm9yZy8w
FQYDVR0RBA4wDIIKOGd3aWZpLm9yZzCB/gYDVR0gBIH2MIHzMAgGBmeBDAECATCB
5gYLKwYBBAGC3xMBAQEwgdYwJgYIKwYBBQUHAgEWGmh0dHA6Ly9jcHMubGV0c2Vu
Y3J5cHQub3JnMIGrBggrBgEFBQcCAjCBngyBm1RoaXMgQ2VydGlmaWNhdGUgbWF5
IG9ubHkgYmUgcmVsaWVkIHVwb24gYnkgUmVseWluZyBQYXJ0aWVzIGFuZCBvbmx5
IGluIGFjY29yZGFuY2Ugd2l0aCB0aGUgQ2VydGlmaWNhdGUgUG9saWN5IGZvdW5k
IGF0IGh0dHBzOi8vbGV0c2VuY3J5cHQub3JnL3JlcG9zaXRvcnkvMIIBAgYKKwYB
BAHWeQIEAgSB8wSB8ADuAHUA23Sv7ssp7LH+yj5xbSzluaq7NveEcYPHXZ1PN7Yf
v2QAAAFkwTcBAwAABAMARjBEAiAlnLsP6q6vc65OA5j+VdntLVcj9rhD73y5hS1F
uVwtsQIgJ7b9/U90tvOPh9XVIK1U1ZbRv9CQNVv4bQbrfyxvP9AAdQApPFGWVMg5
ZbqqUPxYB9S3b79Yeily3KTDDPTlRUf0eAAAAWTBNwL4AAAEAwBGMEQCICDKbBEA
rvxm3rTO5BY2ltXSY2X/0h68O9WC4Ym7O8MNAiB/+Ed4RHBIbeHMfpEtqin/bw5Q
T3GRZNAbGJFlFrNwHTANBgkqhkiG9w0BAQsFAAOCAQEANNWOBbrlwvEaa8GYc3FL
oOlcCgv6kuJN6jWOKfocX7DXDKMuJ9ImbGsWY0/Eb7ehNghiWBXRpCwpXP1tHXAv
GdnVfMajz7V6fdO3lX/T4jYHIaOzs46DPAchjBspDuPglqswQUD1X+FR57v/8hUe
JV3pPI1H1i3aNSBbg9q5CLpjSmZ5V0OJFQod+4Ru6evux0HyJTnXR+gdjujfnIm1
Fku2fMS4eM/tmMOjxQT1eY7KxSBOwTCfLIPls09Sa72UNAPC8bInT1KRR5wNXcNc
EYq3/Uh15XFI/y94xFgzvoQatuMBYBoju8+/64bupR7DcIr/z1TSy3JkymOjFJDp
qw==
-----END CERTIFICATE-----</textarea>
                    </div>

                    <!-- Issuer/Intermediate Certificate -->
                    <div class="form-section">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="form-section-title mb-0"><i class="fas fa-link me-1"></i>Issuer Certificate</div>
                            <div class="char-counter"><span id="cert2Chars">0</span> chars</div>
                        </div>
                        <textarea class="form-control cert-textarea" rows="6" name="p_pem2" id="p_pem2" required>-----BEGIN CERTIFICATE-----
MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0Nlow
SjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMT
GkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EF
q6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8
SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0
Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWA
a6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj
/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0T
AQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIG
CCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNv
bTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9k
c3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAw
VAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcC
ARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAz
MDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwu
Y3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsF
AAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJo
uM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/
wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwu
X4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlG
PfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6
KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
-----END CERTIFICATE-----</textarea>
                    </div>

                    <button type="submit" class="btn w-100" id="submitBtn" disabled style="background: #9ca3af; color: white; font-weight: 600; cursor: not-allowed;">
                        <i class="fas fa-ban me-2"></i>OCSP Service Discontinued
                    </button>
                    <small class="text-muted d-block text-center mt-2">
                        <i class="fas fa-info-circle me-1"></i>Let's Encrypt OCSP ended August 2025
                    </small>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-clipboard-check me-2"></i>OCSP Response</h5>
            </div>
            <div class="card-body" style="overflow-y: auto;">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-shield-alt fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">OCSP response will appear here</p>
                        <small class="text-muted">Paste certificates and click Check OCSP Status</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: var(--theme-primary);" role="status">
                        <span class="visually-hidden">Querying...</span>
                    </div>
                    <p class="mt-2 mb-0">Performing OCSP query...</p>
                </div>

                <div class="result-content" id="resultContent">
                    <!-- Results will be dynamically inserted here -->
                </div>
            </div>
        </div>

        <!-- OpenSSL Commands Reference -->
        <div class="card tool-card mt-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL OCSP Commands</h5>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Extract OCSP URI from Certificate</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl x509 -in cert.pem -noout -ocsp_uri">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Get OCSP responder URL</div>
                        <div>$ openssl x509 -in <code>cert.pem</code> -noout -ocsp_uri</div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Perform OCSP Query</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl ocsp -issuer issuer.pem -cert cert.pem -url http://ocsp.example.com -resp_text">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Check certificate status via OCSP</div>
                        <div>$ openssl ocsp -issuer <code>issuer.pem</code> -cert <code>cert.pem</code> \<br>  -url <code>http://ocsp.example.com</code> -resp_text</div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>OCSP with CA Bundle</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl ocsp -issuer chain.pem -cert cert.pem -CAfile ca-bundle.crt -url http://ocsp.example.com">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Verify OCSP response signature</div>
                        <div>$ openssl ocsp -issuer <code>chain.pem</code> -cert <code>cert.pem</code> \<br>  -CAfile <code>ca-bundle.crt</code> -url <code>http://ocsp.example.com</code></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related Certificate Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="PemParserFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-code me-1"></i>PEM Parser</h6>
                <p>Parse and decode PEM certificates</p>
            </a>
            <a href="certsverify.jsp" class="related-tool-card">
                <h6><i class="fas fa-check-double me-1"></i>Certificate Matcher</h6>
                <p>Verify certificate and key pairs</p>
            </a>
            <a href="ssl.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>SSL Checker</h6>
                <p>Check SSL/TLS configuration</p>
            </a>
            <a href="sslinfo.jsp" class="related-tool-card">
                <h6><i class="fas fa-info-circle me-1"></i>SSL Info</h6>
                <p>Get SSL certificate details</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding OCSP</h5>
    </div>
    <div class="card-body">
        <h6>What is OCSP?</h6>
        <p>OCSP (Online Certificate Status Protocol) defined in RFC 6960 is an Internet protocol used for obtaining the revocation status of X.509 digital certificates. Unlike CRLs (Certificate Revocation Lists), OCSP provides real-time certificate status checking.</p>

        <h6 class="mt-4">OCSP Response Status</h6>
        <div class="row mb-4">
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #d1fae5; border: 2px solid #10b981;">
                    <i class="fas fa-check-circle fa-2x mb-2" style="color: #059669;"></i>
                    <div><strong>Good</strong></div>
                    <small class="text-muted">Certificate is valid and not revoked</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #fee2e2; border: 2px solid #ef4444;">
                    <i class="fas fa-times-circle fa-2x mb-2" style="color: #dc2626;"></i>
                    <div><strong>Revoked</strong></div>
                    <small class="text-muted">Certificate has been revoked by CA</small>
                </div>
            </div>
            <div class="col-md-4 text-center mb-3">
                <div class="p-3 rounded h-100" style="background: #fef3c7; border: 2px solid #f59e0b;">
                    <i class="fas fa-question-circle fa-2x mb-2" style="color: #d97706;"></i>
                    <div><strong>Unknown</strong></div>
                    <small class="text-muted">OCSP responder doesn't know this certificate</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">OCSP vs CRL</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Feature</th>
                    <th>OCSP</th>
                    <th>CRL</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><strong>Update Frequency</strong></td>
                    <td><span class="badge bg-success">Real-time</span></td>
                    <td><span class="badge bg-warning text-dark">Periodic</span></td>
                </tr>
                <tr>
                    <td><strong>Bandwidth</strong></td>
                    <td><span class="badge bg-success">Low (single cert)</span></td>
                    <td><span class="badge bg-warning text-dark">High (full list)</span></td>
                </tr>
                <tr>
                    <td><strong>Privacy</strong></td>
                    <td><span class="badge bg-warning text-dark">CA knows which certs you check</span></td>
                    <td><span class="badge bg-success">Better privacy</span></td>
                </tr>
                <tr>
                    <td><strong>Availability</strong></td>
                    <td><span class="badge bg-warning text-dark">Requires online responder</span></td>
                    <td><span class="badge bg-success">Can be cached</span></td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Common OCSP Errors</h6>
        <ul class="small">
            <li><strong>Unauthorized:</strong> The OCSP responder doesn't recognize the issuer. Make sure you're using the correct intermediate certificate.</li>
            <li><strong>Try Later:</strong> The OCSP responder is temporarily unavailable. Retry after some time.</li>
            <li><strong>Signature Error:</strong> The OCSP response signature verification failed. The response may have been tampered with.</li>
        </ul>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
    $(document).ready(function() {
        // Character counter for textareas
        $('#p_pem1').on('input', function() {
            $('#cert1Chars').text($(this).val().length);
        });
        $('#p_pem2').on('input', function() {
            $('#cert2Chars').text($(this).val().length);
        });

        // Initial count
        $('#cert1Chars').text($('#p_pem1').val().length);
        $('#cert2Chars').text($('#p_pem2').val().length);

        // Form submission
        $('#ocspForm').submit(function(event) {
            event.preventDefault();

            var cert1 = $('#p_pem1').val().trim();
            var cert2 = $('#p_pem2').val().trim();

            if (!cert1 || !cert2) {
                showToast('Please paste both certificates');
                return;
            }

            // Show loading state
            $('#resultPlaceholder').hide();
            $('#resultContent').hide();
            $('#loadingSpinner').show();
            $('#submitBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Querying...');

            $.ajax({
                type: "POST",
                url: "OCSPFunctionality",
                data: $("#ocspForm").serialize(),
                success: function(msg) {
                    $('#loadingSpinner').hide();
                    $('#resultContent').html(msg).show();
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Check OCSP Status');
                },
                error: function() {
                    $('#loadingSpinner').hide();
                    $('#resultContent').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>Error performing OCSP query. Please try again.</div>').show();
                    $('#submitBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Check OCSP Status');
                }
            });
        });
    });

    function copyCommand(btn) {
        var cmd = $(btn).data('cmd');
        navigator.clipboard.writeText(cmd).then(function() {
            showToast('Command copied!');
        });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show" role="alert">' +
            '<div class="toast-body text-white rounded" style="background: linear-gradient(135deg, #059669 0%, #10b981 100%);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message +
            '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() {
            toast.fadeOut(function() { toast.remove(); });
        }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
