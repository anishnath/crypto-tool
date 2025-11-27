<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
	<!-- Enhanced JSON-LD Structured Data for SEO -->
	<script type="application/ld+json">
	[
		{
			"@context": "https://schema.org",
			"@type": "Organization",
			"name": "8gwifi.org",
			"url": "https://8gwifi.org",
			"logo": "https://8gwifi.org/images/logo.png",
			"sameAs": [
				"https://x.com/anish2good",
				"https://github.com/anishnath"
			],
			"contactPoint": {
				"@type": "ContactPoint",
				"contactType": "technical support",
				"url": "https://x.com/anish2good"
			}
		},
		{
			"@context": "https://schema.org",
			"@type": "WebApplication",
			"name": "Certificate Authority Generator Online",
			"description": "Generate complete PKI certificate chains including Root CA, Intermediate CA, and Server Certificates for testing SSL/TLS implementations",
			"url": "https://8gwifi.org/cafunctions.jsp",
			"applicationCategory": "SecurityApplication",
			"operatingSystem": "Any",
			"browserRequirements": "Requires JavaScript",
			"offers": {
				"@type": "Offer",
				"price": "0",
				"priceCurrency": "USD"
			},
			"featureList": [
				"Root CA certificate generation",
				"Intermediate CA certificate generation",
				"Server certificate generation",
				"Complete PKI chain creation",
				"Private key generation",
				"X.509 certificate format"
			],
			"screenshot": "https://8gwifi.org/images/site/genca.png",
			"aggregateRating": {
				"@type": "AggregateRating",
				"ratingValue": "4.8",
				"ratingCount": "245",
				"bestRating": "5",
				"worstRating": "1"
			}
		},
		{
			"@context": "https://schema.org",
			"@type": "BreadcrumbList",
			"itemListElement": [
				{
					"@type": "ListItem",
					"position": 1,
					"name": "Home",
					"item": "https://8gwifi.org"
				},
				{
					"@type": "ListItem",
					"position": 2,
					"name": "CA Certificate Generator",
					"item": "https://8gwifi.org/cafunctions.jsp"
				}
			]
		},
		{
			"@context": "https://schema.org",
			"@type": "FAQPage",
			"mainEntity": [
				{
					"@type": "Question",
					"name": "What is a Certificate Authority (CA)?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "A Certificate Authority (CA) is a trusted entity that issues digital certificates. These certificates verify that a public key belongs to the named subject. CAs form the backbone of PKI (Public Key Infrastructure) and enable secure communication over the internet through SSL/TLS."
					}
				},
				{
					"@type": "Question",
					"name": "What is the difference between Root CA and Intermediate CA?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "A Root CA is the top-level certificate authority that self-signs its certificate. It's kept offline for security. An Intermediate CA is signed by the Root CA and is used for day-to-day certificate issuance. This hierarchy protects the Root CA from exposure while enabling efficient certificate management."
					}
				},
				{
					"@type": "Question",
					"name": "Why do I need a certificate chain?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "A certificate chain establishes trust from an end-entity certificate back to a trusted Root CA. When a browser connects to a server, it validates the entire chain. Without a complete chain, browsers cannot verify the certificate's authenticity and will show security warnings."
					}
				},
				{
					"@type": "Question",
					"name": "Can I use these certificates in production?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "These certificates are for testing and development purposes only. Production environments should use certificates from publicly trusted CAs like Let's Encrypt, DigiCert, or Comodo. Self-signed certificates will trigger browser warnings and are not suitable for public-facing websites."
					}
				},
				{
					"@type": "Question",
					"name": "What certificate formats are supported?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "This tool generates certificates in PEM format, which is Base64 encoded and enclosed between BEGIN/END markers. PEM is widely supported across platforms. You can convert PEM to other formats like DER, PKCS#12, or PFX using OpenSSL commands."
					}
				},
				{
					"@type": "Question",
					"name": "How do I install the generated certificates?",
					"acceptedAnswer": {
						"@type": "Answer",
						"text": "For testing, import the Root CA certificate into your browser's trusted certificate store. Configure your server with the server certificate, private key, and intermediate certificate. The exact steps vary by server (Apache, Nginx, IIS) and operating system."
					}
				}
			]
		},
		{
			"@context": "https://schema.org",
			"@type": "HowTo",
			"name": "How to Generate a Test PKI Certificate Chain",
			"description": "Step-by-step guide to generate Root CA, Intermediate CA, and Server certificates for testing",
			"totalTime": "PT1M",
			"supply": [
				{
					"@type": "HowToSupply",
					"name": "Hostname or Common Name (CN)"
				}
			],
			"tool": [
				{
					"@type": "HowToTool",
					"name": "Web browser with JavaScript enabled"
				}
			],
			"step": [
				{
					"@type": "HowToStep",
					"position": 1,
					"name": "Enter Hostname",
					"text": "Enter the hostname or Common Name (CN) for your server certificate",
					"url": "https://8gwifi.org/cafunctions.jsp#step1"
				},
				{
					"@type": "HowToStep",
					"position": 2,
					"name": "Generate Certificates",
					"text": "Click 'Generate CA Authority' to create the complete certificate chain",
					"url": "https://8gwifi.org/cafunctions.jsp#step2"
				},
				{
					"@type": "HowToStep",
					"position": 3,
					"name": "Download Server Certificate",
					"text": "Copy or download the server certificate and private key for your application",
					"url": "https://8gwifi.org/cafunctions.jsp#step3"
				},
				{
					"@type": "HowToStep",
					"position": 4,
					"name": "Install Root CA",
					"text": "Import the Root CA certificate into your system's trusted certificate store",
					"url": "https://8gwifi.org/cafunctions.jsp#step4"
				},
				{
					"@type": "HowToStep",
					"position": 5,
					"name": "Configure Server",
					"text": "Configure your web server with the server certificate, private key, and certificate chain",
					"url": "https://8gwifi.org/cafunctions.jsp#step5"
				}
			]
		},
		{
			"@context": "https://schema.org",
			"@type": "TechArticle",
			"headline": "Certificate Authority Generator - Create PKI Certificate Chains",
			"description": "Generate complete PKI certificate chains including Root CA, Intermediate CA, and Server Certificates for testing SSL/TLS implementations",
			"author": {
				"@type": "Person",
				"name": "Anish Nath",
				"url": "https://x.com/anish2good"
			},
			"datePublished": "2017-11-16",
			"dateModified": "2024-01-15",
			"publisher": {
				"@type": "Organization",
				"name": "8gwifi.org",
				"logo": {
					"@type": "ImageObject",
					"url": "https://8gwifi.org/images/site/logo.png"
				}
			},
			"mainEntityOfPage": "https://8gwifi.org/cafunctions.jsp",
			"keywords": "certificate authority, root ca, intermediate ca, ssl certificate, tls certificate, pki, x509, openssl, certificate chain"
		},
		{
			"@context": "https://schema.org",
			"@type": "SoftwareSourceCode",
			"name": "Certificate Authority Generator",
			"codeRepository": "https://8gwifi.org",
			"programmingLanguage": ["Java", "JavaScript"],
			"runtimePlatform": "JVM",
			"targetProduct": {
				"@type": "WebApplication",
				"name": "8gwifi.org Certificate Authority Generator"
			}
		}
	]
	</script>
	<title>Certificate Authority Generator Online - Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Generate complete PKI certificate chains online - Root CA, Intermediate CA, and Server Certificates for testing SSL/TLS. Free online CA certificate generator with private keys.">
	<meta name="keywords" content="certificate authority generator, root ca generator, intermediate ca, ssl certificate generator, tls certificate, pki generator, x509 certificate, openssl alternative, test certificate, self-signed certificate, certificate chain">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="index, follow">
	<link rel="canonical" href="https://8gwifi.org/cafunctions.jsp">
	<%@ include file="header-script.jsp"%>

	<style>
		.cert-card {
			border-left: 4px solid #007bff;
			background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
		}
		.cert-card.root-ca {
			border-left-color: #dc3545;
		}
		.cert-card.intermediate-ca {
			border-left-color: #ffc107;
		}
		.cert-card.server-cert {
			border-left-color: #28a745;
		}
		.hierarchy-arrow {
			font-size: 2rem;
			color: #6c757d;
			text-align: center;
			padding: 0.5rem 0;
		}
		.copy-btn {
			position: absolute;
			top: 0.5rem;
			right: 0.5rem;
			opacity: 0.7;
			transition: opacity 0.2s;
		}
		.copy-btn:hover {
			opacity: 1;
		}
		.textarea-wrapper {
			position: relative;
		}
		.result-section {
			display: none;
		}
		.result-section.show {
			display: block;
		}
		.download-btn-group .btn {
			margin-right: 0.25rem;
			margin-bottom: 0.25rem;
		}
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}
		.fade-in {
			animation: fadeIn 0.3s ease-out;
		}
		.pki-visual {
			background: #f8f9fa;
			border-radius: 8px;
			padding: 1.5rem;
		}
		.pki-node {
			text-align: center;
			padding: 1rem;
			border-radius: 8px;
			margin: 0.5rem 0;
		}
		.pki-node.root { background: rgba(220, 53, 69, 0.1); border: 2px solid #dc3545; }
		.pki-node.intermediate { background: rgba(255, 193, 7, 0.1); border: 2px solid #ffc107; }
		.pki-node.server { background: rgba(40, 167, 69, 0.1); border: 2px solid #28a745; }
	</style>

	<script type="text/javascript">
		var lastResponse = null;

		$(document).ready(function() {
			$('#generateca').click(function(event) {
				event.preventDefault();

				// Client-side validation
				var hostname = $('#p_dns_name').val().trim();
				if (!hostname) {
					$('#p_dns_name').addClass('is-invalid');
					$('#error-message').html('<div class="alert alert-danger">Please enter a hostname (CN).</div>');
					return;
				}

				// Validate hostname format
				var hostnameRegex = /^[a-zA-Z0-9. ]+$/;
				if (!hostnameRegex.test(hostname)) {
					$('#p_dns_name').addClass('is-invalid');
					$('#error-message').html('<div class="alert alert-danger">Invalid hostname. Only alphanumeric characters, dots, and spaces are allowed.</div>');
					return;
				}

				$('#p_dns_name').removeClass('is-invalid');
				$('#error-message').html('');
				$('#loading').show();
				$('#result-section').removeClass('show');

				$.ajax({
					type: "POST",
					url: "GenCAFunctionality",
					data: $("#form").serialize(),
					dataType: 'json',
					success: function(response) {
						$('#loading').hide();
						lastResponse = response;

						if (response.success) {
							displayCertificates(response);
							$('#result-placeholder').hide();
							$('#result-section').addClass('show fade-in');
						} else {
							$('#error-message').html('<div class="alert alert-danger">' + response.errorMessage + '</div>');
						}
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						$('#error-message').html('<div class="alert alert-danger">Error generating certificates. Please try again.</div>');
					}
				});
			});

			$('#p_dns_name').on('input', function() {
				$(this).removeClass('is-invalid');
			});
		});

		function displayCertificates(data) {
			$('#hostname-display').text(data.hostname);

			// Server Certificate
			$('#server-private-key').val(data.serverPrivateKey || '');
			$('#server-public-key').val(data.serverPublicKey || '');
			$('#server-certificate').val(data.serverCertificate || '');

			// Intermediate CA
			$('#intermediate-private-key').val(data.intermediatePrivateKey || '');
			$('#intermediate-public-key').val(data.intermediatePublicKey || '');
			$('#intermediate-certificate').val(data.intermediateCertificate || '');

			// Root CA
			$('#root-private-key').val(data.rootPrivateKey || '');
			$('#root-public-key').val(data.rootPublicKey || '');
			$('#root-certificate').val(data.rootCertificate || '');
		}

		function copyToClipboard(elementId) {
			var element = document.getElementById(elementId);
			element.select();
			element.setSelectionRange(0, 99999);
			document.execCommand('copy');

			// Show feedback
			var btn = event.target;
			var originalText = btn.innerHTML;
			btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
			setTimeout(function() {
				btn.innerHTML = originalText;
			}, 2000);
		}

		function downloadAsJson() {
			if (!lastResponse) return;

			var dataStr = JSON.stringify(lastResponse, null, 2);
			var blob = new Blob([dataStr], { type: 'application/json' });
			var url = URL.createObjectURL(blob);
			var a = document.createElement('a');
			a.href = url;
			a.download = 'ca-certificates-' + lastResponse.hostname + '.json';
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
			URL.revokeObjectURL(url);
		}

		function downloadCert(type, format) {
			if (!lastResponse) return;

			var content, filename;
			switch(type) {
				case 'server':
					content = format === 'key' ? lastResponse.serverPrivateKey : lastResponse.serverCertificate;
					filename = lastResponse.hostname + (format === 'key' ? '.key' : '.crt');
					break;
				case 'intermediate':
					content = format === 'key' ? lastResponse.intermediatePrivateKey : lastResponse.intermediateCertificate;
					filename = 'intermediate-ca' + (format === 'key' ? '.key' : '.crt');
					break;
				case 'root':
					content = format === 'key' ? lastResponse.rootPrivateKey : lastResponse.rootCertificate;
					filename = 'root-ca' + (format === 'key' ? '.key' : '.crt');
					break;
				case 'chain':
					content = lastResponse.serverCertificate + '\n' + lastResponse.intermediateCertificate + '\n' + lastResponse.rootCertificate;
					filename = lastResponse.hostname + '-chain.pem';
					break;
			}

			var blob = new Blob([content], { type: 'text/plain' });
			var url = URL.createObjectURL(blob);
			var a = document.createElement('a');
			a.href = url;
			a.download = filename;
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
			URL.revokeObjectURL(url);
		}

		function shareUrl() {
			var url = window.location.href.split('?')[0];
			$('#share-url-input').val(url);
			$('#shareModal').modal('show');
		}

		function copyShareUrl() {
			var input = document.getElementById('share-url-input');
			input.select();
			document.execCommand('copy');
			$('#copy-share-btn').text('Copied!');
			setTimeout(function() {
				$('#copy-share-btn').text('Copy');
			}, 2000);
		}

		function parseCertificate(type) {
			if (!lastResponse) {
				alert('Please generate certificates first');
				return;
			}

			var certData;
			switch(type) {
				case 'server':
					certData = lastResponse.serverCertificate;
					break;
				case 'intermediate':
					certData = lastResponse.intermediateCertificate;
					break;
				case 'root':
					certData = lastResponse.rootCertificate;
					break;
				case 'chain':
					certData = lastResponse.serverCertificate + '\n' + lastResponse.intermediateCertificate + '\n' + lastResponse.rootCertificate;
					break;
				default:
					return;
			}

			if (!certData) {
				alert('Certificate data not available');
				return;
			}

			// Open PemParserFunctions.jsp with the certificate data as URL parameter
			var url = 'PemParserFunctions.jsp?pem=' + encodeURIComponent(certData);
			window.open(url, '_blank');
		}
	</script>
</head>

<%@ include file="body-script.jsp"%>
    <%@ include file="pgp-menu-nav.jsp"%>
<div class="container-fluid">
	<h1 class="mt-4">Certificate Authority Generator Online</h1>
	<p class="lead">Generate complete PKI certificate chains for testing - Root CA, Intermediate CA, and Server Certificates</p>

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
            <span class="mx-2">|</span>
            <i class="fas fa-star text-warning"></i> 4.8/5 (892 reviews)
        </div>
        <div class="badge-group">
            <span class="badge badge-success"><i class="fas fa-shield-alt"></i> Privacy-First</span>
            <span class="badge badge-info"><i class="fas fa-lock"></i> No Data Stored</span>
            <span class="badge badge-primary"><i class="fas fa-free-code-camp"></i> 100% Free</span>
        </div>
    </div>

	<div class="row">
		<!-- Left Column - Input Form -->
		<div class="col-lg-5">
			<div class="card shadow-sm mb-4">
				<div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
					<span><i class="fas fa-certificate"></i> Generate Test CA</span>
				</div>
				<div class="card-body">
					<form id="form" method="POST">
						<input type="hidden" name="methodName" id="methodName" value="GENERATE_TEST_CA">

						<div class="form-group">
							<label for="p_dns_name"><strong>Hostname / Common Name (CN)</strong></label>
							<input class="form-control" id="p_dns_name" type="text" name="p_dns_name"
								   placeholder="e.g., example.com or localhost" autocomplete="off">
							<div class="invalid-feedback">Please enter a valid hostname.</div>
							<small class="form-text text-muted">Enter the hostname for your server certificate (alphanumeric, dots, spaces only)</small>
						</div>

						<button type="button" class="btn btn-primary btn-lg btn-block" id="generateca">
							<i class="fas fa-key"></i> Generate CA Authority
						</button>
					</form>

					<div id="error-message" class="mt-3"></div>

					<div id="loading" style="display: none;" class="text-center mt-3">
						<img src="images/712.GIF" alt="Loading..." />
						<p>Generating certificate chain...</p>
					</div>
				</div>
			</div>

<%--			<!-- PKI Hierarchy Visual -->--%>
<%--			<div class="card shadow-sm mb-4">--%>
<%--				<div class="card-header">--%>
<%--					<i class="fas fa-sitemap"></i> PKI Certificate Hierarchy--%>
<%--				</div>--%>
<%--				<div class="card-body pki-visual">--%>
<%--					<div class="pki-node root">--%>
<%--						<i class="fas fa-shield-alt"></i>--%>
<%--						<strong>Root CA</strong>--%>
<%--						<small class="d-block text-muted">Self-signed, highest trust</small>--%>
<%--					</div>--%>
<%--					<div class="hierarchy-arrow"><i class="fas fa-arrow-down"></i></div>--%>
<%--					<div class="pki-node intermediate">--%>
<%--						<i class="fas fa-certificate"></i>--%>
<%--						<strong>Intermediate CA</strong>--%>
<%--						<small class="d-block text-muted">Signed by Root CA</small>--%>
<%--					</div>--%>
<%--					<div class="hierarchy-arrow"><i class="fas fa-arrow-down"></i></div>--%>
<%--					<div class="pki-node server">--%>
<%--						<i class="fas fa-server"></i>--%>
<%--						<strong>Server Certificate</strong>--%>
<%--						<small class="d-block text-muted">Signed by Intermediate CA</small>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
		</div>

		<!-- Right Column - Results -->
		<div class="col-lg-7">
			<!-- Placeholder when no results -->
			<div id="result-placeholder" class="card shadow-sm mb-4">
				<div class="card-body text-center py-5">
					<i class="fas fa-certificate fa-4x text-muted mb-3"></i>
					<h5 class="text-muted">Output will appear here</h5>
					<p class="text-muted mb-0">Enter a hostname and click "Generate CA Authority" to create your certificate chain</p>
				</div>
			</div>

			<div id="result-section" class="result-section">
				<!-- Action Buttons -->
				<div class="mb-3 download-btn-group">
					<button class="btn btn-success" onclick="downloadAsJson()">
						<i class="fas fa-download"></i> Download JSON
					</button>
					<button class="btn btn-info" onclick="downloadCert('chain', 'cert')">
						<i class="fas fa-link"></i> Download Chain
					</button>
					<button class="btn btn-outline-secondary" onclick="shareUrl()">
						<i class="fas fa-share-alt"></i> Share
					</button>
					<button class="btn btn-outline-primary" onclick="parseCertificate('chain')">
						<i class="fas fa-search"></i> Parse Full Chain
					</button>
				</div>

				<h5>Certificates for: <span id="hostname-display" class="badge badge-primary"></span></h5>

				<!-- Server Certificate -->
				<div class="card cert-card server-cert shadow-sm mb-3">
					<div class="card-header d-flex justify-content-between align-items-center">
						<span><i class="fas fa-server text-success"></i> Server Certificate</span>
						<div>
							<button class="btn btn-sm btn-outline-primary" onclick="parseCertificate('server')" title="Parse this certificate">
								<i class="fas fa-search"></i> Parse
							</button>
							<button class="btn btn-sm btn-outline-success" onclick="downloadCert('server', 'cert')">
								<i class="fas fa-download"></i> .crt
							</button>
							<button class="btn btn-sm btn-outline-warning" onclick="downloadCert('server', 'key')">
								<i class="fas fa-key"></i> .key
							</button>
						</div>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-4">
								<label><small>Private Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="server-private-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('server-private-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Public Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="server-public-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('server-public-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Certificate (X.509)</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="server-certificate" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('server-certificate')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Intermediate CA -->
				<div class="card cert-card intermediate-ca shadow-sm mb-3">
					<div class="card-header d-flex justify-content-between align-items-center">
						<span><i class="fas fa-certificate text-warning"></i> Intermediate CA</span>
						<div>
							<button class="btn btn-sm btn-outline-primary" onclick="parseCertificate('intermediate')" title="Parse this certificate">
								<i class="fas fa-search"></i> Parse
							</button>
							<button class="btn btn-sm btn-outline-success" onclick="downloadCert('intermediate', 'cert')">
								<i class="fas fa-download"></i> .crt
							</button>
							<button class="btn btn-sm btn-outline-warning" onclick="downloadCert('intermediate', 'key')">
								<i class="fas fa-key"></i> .key
							</button>
						</div>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-4">
								<label><small>Private Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="intermediate-private-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('intermediate-private-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Public Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="intermediate-public-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('intermediate-public-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Certificate (X.509)</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="intermediate-certificate" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('intermediate-certificate')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Root CA -->
				<div class="card cert-card root-ca shadow-sm mb-3">
					<div class="card-header d-flex justify-content-between align-items-center">
						<span><i class="fas fa-shield-alt text-danger"></i> Root CA</span>
						<div>
							<button class="btn btn-sm btn-outline-primary" onclick="parseCertificate('root')" title="Parse this certificate">
								<i class="fas fa-search"></i> Parse
							</button>
							<button class="btn btn-sm btn-outline-success" onclick="downloadCert('root', 'cert')">
								<i class="fas fa-download"></i> .crt
							</button>
							<button class="btn btn-sm btn-outline-warning" onclick="downloadCert('root', 'key')">
								<i class="fas fa-key"></i> .key
							</button>
						</div>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-md-4">
								<label><small>Private Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="root-private-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('root-private-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Public Key</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="root-public-key" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('root-public-key')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
							<div class="col-md-4">
								<label><small>Certificate (X.509)</small></label>
								<div class="textarea-wrapper">
									<textarea class="form-control" id="root-certificate" rows="6" readonly></textarea>
									<button class="btn btn-sm btn-light copy-btn" onclick="copyToClipboard('root-certificate')">
										<i class="fas fa-copy"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Share Modal -->
	<div class="modal fade" id="shareModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Share This Tool</h5>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="input-group">
						<input type="text" class="form-control" id="share-url-input" readonly>
						<div class="input-group-append">
							<button class="btn btn-primary" id="copy-share-btn" onclick="copyShareUrl()">Copy</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<hr>

	<div class="sharethis-inline-share-buttons"></div>

	<%@ include file="thanks.jsp"%>

	<hr>

	<%@ include file="footer_adsense.jsp"%>

	<!-- Understanding PKI Section - Expanded -->
	<div class="card shadow-sm mb-4">
		<div class="card-header bg-info text-white">
			<h2 class="h5 mb-0"><i class="fas fa-graduation-cap"></i> Understanding Public Key Infrastructure (PKI)</h2>
		</div>
		<div class="card-body">
			<!-- What is PKI -->
			<div class="row mb-4">
				<div class="col-12">
					<h4><i class="fas fa-question-circle text-primary"></i> What is PKI?</h4>
					<p>Public Key Infrastructure (PKI) is a comprehensive framework that manages digital certificates and public-key encryption. It provides the foundation for secure communication, authentication, and data integrity across the internet. PKI enables organizations to:</p>
					<div class="row">
						<div class="col-md-4">
							<div class="card bg-light mb-2">
								<div class="card-body text-center py-3">
									<i class="fas fa-lock fa-2x text-success mb-2"></i>
									<h6>Encrypt Data</h6>
									<small class="text-muted">Protect sensitive information in transit</small>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="card bg-light mb-2">
								<div class="card-body text-center py-3">
									<i class="fas fa-user-check fa-2x text-primary mb-2"></i>
									<h6>Authenticate Identity</h6>
									<small class="text-muted">Verify users, servers, and devices</small>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="card bg-light mb-2">
								<div class="card-body text-center py-3">
									<i class="fas fa-signature fa-2x text-info mb-2"></i>
									<h6>Digital Signatures</h6>
									<small class="text-muted">Ensure data integrity and non-repudiation</small>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<hr>

			<!-- PKI Components -->
			<div class="row mb-4">
				<div class="col-12">
					<h4><i class="fas fa-puzzle-piece text-primary"></i> Core PKI Components</h4>
				</div>
				<div class="col-md-6">
					<div class="card border-primary mb-3">
						<div class="card-header bg-primary text-white">
							<i class="fas fa-building"></i> Certificate Authority (CA)
						</div>
						<div class="card-body">
							<p>The trusted entity that issues and manages digital certificates. CAs verify the identity of certificate requesters before issuing certificates.</p>
							<ul class="mb-0">
								<li><strong>Root CA:</strong> Top of trust hierarchy, self-signed</li>
								<li><strong>Intermediate CA:</strong> Issues end-entity certificates</li>
								<li><strong>Issuing CA:</strong> Day-to-day certificate operations</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card border-success mb-3">
						<div class="card-header bg-success text-white">
							<i class="fas fa-address-card"></i> Registration Authority (RA)
						</div>
						<div class="card-body">
							<p>Acts as an intermediary between users and the CA. The RA verifies the identity of entities requesting certificates.</p>
							<ul class="mb-0">
								<li>Validates identity documents</li>
								<li>Approves or rejects certificate requests</li>
								<li>Handles certificate revocation requests</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card border-warning mb-3">
						<div class="card-header bg-warning">
							<i class="fas fa-certificate"></i> Digital Certificate (X.509)
						</div>
						<div class="card-body">
							<p>An electronic document that binds a public key to an identity. Contains:</p>
							<ul class="mb-0">
								<li>Subject name (who the cert belongs to)</li>
								<li>Public key</li>
								<li>Issuer name (CA that signed it)</li>
								<li>Validity period (not before/not after)</li>
								<li>Serial number and extensions</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="card border-info mb-3">
						<div class="card-header bg-info text-white">
							<i class="fas fa-ban"></i> Revocation Services
						</div>
						<div class="card-body">
							<p>Mechanisms to invalidate certificates before expiration:</p>
							<ul class="mb-0">
								<li><strong>CRL:</strong> Certificate Revocation List - periodic list of revoked certs</li>
								<li><strong>OCSP:</strong> Online Certificate Status Protocol - real-time status check</li>
								<li><strong>OCSP Stapling:</strong> Server provides OCSP response with cert</li>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<hr>

			<!-- Certificate Hierarchy Visual -->
			<div class="row mb-4">
				<div class="col-12">
					<h4><i class="fas fa-sitemap text-primary"></i> Certificate Trust Hierarchy</h4>
					<p>PKI uses a hierarchical trust model where trust flows from the Root CA down to end-entity certificates:</p>
				</div>
				<div class="col-md-8 offset-md-2">
					<div class="card bg-light">
						<div class="card-body">
							<!-- Root CA Level -->
							<div class="text-center mb-2">
								<div class="d-inline-block px-4 py-2 rounded" style="background: rgba(220, 53, 69, 0.15); border: 2px solid #dc3545;">
									<i class="fas fa-shield-alt text-danger"></i>
									<strong class="text-danger">Root CA</strong>
									<br><small class="text-muted">Self-signed | Offline | 20+ years validity</small>
								</div>
							</div>
							<div class="text-center text-muted mb-2">
								<i class="fas fa-arrow-down fa-lg"></i>
								<small class="d-block">Signs</small>
							</div>
							<!-- Intermediate CA Level -->
							<div class="text-center mb-2">
								<div class="d-inline-block px-4 py-2 rounded" style="background: rgba(255, 193, 7, 0.15); border: 2px solid #ffc107;">
									<i class="fas fa-certificate text-warning"></i>
									<strong class="text-warning">Intermediate CA</strong>
									<br><small class="text-muted">Signed by Root | Online | 10-15 years validity</small>
								</div>
							</div>
							<div class="text-center text-muted mb-2">
								<i class="fas fa-arrow-down fa-lg"></i>
								<small class="d-block">Signs</small>
							</div>
							<!-- End Entity Level -->
							<div class="text-center">
								<div class="d-inline-flex flex-wrap justify-content-center">
									<div class="px-3 py-2 m-1 rounded" style="background: rgba(40, 167, 69, 0.15); border: 2px solid #28a745;">
										<i class="fas fa-server text-success"></i>
										<strong class="text-success d-block">Server Cert</strong>
										<small class="text-muted">1-2 years</small>
									</div>
									<div class="px-3 py-2 m-1 rounded" style="background: rgba(23, 162, 184, 0.15); border: 2px solid #17a2b8;">
										<i class="fas fa-user text-info"></i>
										<strong class="text-info d-block">Client Cert</strong>
										<small class="text-muted">1-2 years</small>
									</div>
									<div class="px-3 py-2 m-1 rounded" style="background: rgba(108, 117, 125, 0.15); border: 2px solid #6c757d;">
										<i class="fas fa-code text-secondary"></i>
										<strong class="text-secondary d-block">Code Signing</strong>
										<small class="text-muted">1-3 years</small>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<hr>

			<!-- How Certificate Validation Works -->
			<div class="row mb-4">
				<div class="col-12">
					<h4><i class="fas fa-check-double text-primary"></i> How Certificate Validation Works</h4>
					<p>When a client (browser) connects to a server over HTTPS, this validation process occurs:</p>
				</div>
				<div class="col-12">
					<div class="row">
						<div class="col-md-3 mb-3">
							<div class="card h-100 border-primary">
								<div class="card-body text-center">
									<div class="rounded-circle bg-primary text-white d-inline-flex align-items-center justify-content-center mb-2" style="width: 40px; height: 40px;">1</div>
									<h6>Server Sends Certificate</h6>
									<p class="small text-muted mb-0">Server presents its certificate and the intermediate CA certificate chain</p>
								</div>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card h-100 border-info">
								<div class="card-body text-center">
									<div class="rounded-circle bg-info text-white d-inline-flex align-items-center justify-content-center mb-2" style="width: 40px; height: 40px;">2</div>
									<h6>Chain Building</h6>
									<p class="small text-muted mb-0">Client builds a chain from server cert up to a trusted Root CA in its trust store</p>
								</div>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card h-100 border-warning">
								<div class="card-body text-center">
									<div class="rounded-circle bg-warning text-dark d-inline-flex align-items-center justify-content-center mb-2" style="width: 40px; height: 40px;">3</div>
									<h6>Validation Checks</h6>
									<p class="small text-muted mb-0">Verify signatures, validity dates, hostname match, and revocation status</p>
								</div>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="card h-100 border-success">
								<div class="card-body text-center">
									<div class="rounded-circle bg-success text-white d-inline-flex align-items-center justify-content-center mb-2" style="width: 40px; height: 40px;">4</div>
									<h6>Secure Connection</h6>
									<p class="small text-muted mb-0">If all checks pass, TLS handshake completes and encrypted session begins</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<hr>

			<!-- What Gets Validated -->
			<div class="row mb-4">
				<div class="col-md-6">
					<h5><i class="fas fa-clipboard-check text-success"></i> Certificate Validation Checks</h5>
					<table class="table table-sm table-bordered">
						<thead class="thead-light">
							<tr><th>Check</th><th>What It Verifies</th></tr>
						</thead>
						<tbody>
							<tr><td><i class="fas fa-signature text-primary"></i> Signature</td><td>Certificate was signed by the claimed issuer</td></tr>
							<tr><td><i class="fas fa-calendar-check text-success"></i> Validity Period</td><td>Current date is within notBefore and notAfter</td></tr>
							<tr><td><i class="fas fa-link text-info"></i> Chain of Trust</td><td>Chain leads to a trusted Root CA</td></tr>
							<tr><td><i class="fas fa-globe text-warning"></i> Hostname</td><td>Certificate CN or SAN matches requested domain</td></tr>
							<tr><td><i class="fas fa-ban text-danger"></i> Revocation</td><td>Certificate has not been revoked (CRL/OCSP)</td></tr>
							<tr><td><i class="fas fa-key text-secondary"></i> Key Usage</td><td>Certificate is authorized for its intended use</td></tr>
						</tbody>
					</table>
				</div>
				<div class="col-md-6">
					<h5><i class="fas fa-exclamation-triangle text-danger"></i> Common Certificate Errors</h5>
					<div class="alert alert-danger py-2 mb-2"><strong>ERR_CERT_AUTHORITY_INVALID</strong><br><small>Root CA not in browser's trust store</small></div>
					<div class="alert alert-warning py-2 mb-2"><strong>ERR_CERT_DATE_INVALID</strong><br><small>Certificate expired or not yet valid</small></div>
					<div class="alert alert-info py-2 mb-2"><strong>ERR_CERT_COMMON_NAME_INVALID</strong><br><small>Certificate doesn't match the domain</small></div>
					<div class="alert alert-secondary py-2 mb-2"><strong>ERR_CERT_REVOKED</strong><br><small>Certificate has been revoked by the CA</small></div>
				</div>
			</div>

			<hr>

			<!-- Certificate Types -->
			<div class="row mb-4">
				<div class="col-12">
					<h4><i class="fas fa-tags text-primary"></i> Types of SSL/TLS Certificates</h4>
				</div>
				<div class="col-md-4 mb-3">
					<div class="card h-100">
						<div class="card-header bg-success text-white"><i class="fas fa-check"></i> Domain Validated (DV)</div>
						<div class="card-body">
							<p class="small">Basic validation - only proves domain ownership</p>
							<ul class="small mb-0">
								<li>Issued in minutes</li>
								<li>Lowest cost (often free)</li>
								<li>Good for: blogs, personal sites</li>
								<li>Example: Let's Encrypt</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-4 mb-3">
					<div class="card h-100">
						<div class="card-header bg-primary text-white"><i class="fas fa-building"></i> Organization Validated (OV)</div>
						<div class="card-body">
							<p class="small">Verifies organization identity and domain ownership</p>
							<ul class="small mb-0">
								<li>Issued in 1-3 days</li>
								<li>Moderate cost</li>
								<li>Good for: business websites</li>
								<li>Shows org name in cert details</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-4 mb-3">
					<div class="card h-100">
						<div class="card-header bg-warning"><i class="fas fa-award"></i> Extended Validation (EV)</div>
						<div class="card-body">
							<p class="small">Strictest validation - thorough business verification</p>
							<ul class="small mb-0">
								<li>Issued in 1-2 weeks</li>
								<li>Highest cost</li>
								<li>Good for: e-commerce, banking</li>
								<li>Highest trust level</li>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<hr>

			<!-- Security Best Practices -->
			<div class="row">
				<div class="col-md-6">
					<h5><i class="fas fa-check-circle text-success"></i> PKI Best Practices - DO</h5>
					<ul class="list-group">
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Keep Root CA offline in an air-gapped system</li>
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Use strong key sizes (RSA 2048+ or ECC P-256+)</li>
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Implement certificate monitoring and alerting</li>
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Automate certificate renewal (ACME protocol)</li>
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Use Certificate Transparency logs</li>
						<li class="list-group-item list-group-item-success py-2"><i class="fas fa-check text-success"></i> Implement HSTS and certificate pinning where appropriate</li>
					</ul>
				</div>
				<div class="col-md-6">
					<h5><i class="fas fa-times-circle text-danger"></i> PKI Pitfalls - DON'T</h5>
					<ul class="list-group">
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Use self-signed certs in production</li>
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Share private keys between servers</li>
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Disable certificate validation in code</li>
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Use weak algorithms (MD5, SHA-1, RSA 1024)</li>
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Ignore certificate expiration warnings</li>
						<li class="list-group-item list-group-item-danger py-2"><i class="fas fa-times text-danger"></i> Store private keys in version control</li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<!-- Certificate Extensions Reference -->
	<div class="card shadow-sm mb-4">
		<div class="card-header">
			<h2 class="h5 mb-0"><i class="fas fa-file-alt"></i> Certificate File Extensions Reference</h2>
		</div>
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead class="thead-light">
						<tr>
							<th>Extension</th>
							<th>Format</th>
							<th>Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><code>.pem</code></td>
							<td>Base64 (ASCII)</td>
							<td>Privacy-Enhanced Mail format. Base64 encoded with BEGIN/END markers. Most common format.</td>
						</tr>
						<tr>
							<td><code>.crt, .cer</code></td>
							<td>Base64 or DER</td>
							<td>Certificate files. Can be either PEM or DER encoded.</td>
						</tr>
						<tr>
							<td><code>.der</code></td>
							<td>Binary</td>
							<td>Distinguished Encoding Rules format. Binary encoded certificates.</td>
						</tr>
						<tr>
							<td><code>.key</code></td>
							<td>Base64 (ASCII)</td>
							<td>Private key files in PEM format.</td>
						</tr>
						<tr>
							<td><code>.p12, .pfx</code></td>
							<td>Binary</td>
							<td>PKCS#12 format. Contains certificate and private key, password protected.</td>
						</tr>
						<tr>
							<td><code>.p7b, .p7c</code></td>
							<td>Base64 or Binary</td>
							<td>PKCS#7 format. Contains certificates and chain, no private keys.</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<!-- OpenSSL Commands Reference -->
	<div class="card shadow-sm mb-4">
		<div class="card-header">
			<h2 class="h5 mb-0"><i class="fas fa-terminal"></i> Useful OpenSSL Commands</h2>
		</div>
		<div class="card-body">
			<div class="row">
				<div class="col-md-6">
					<h6>View Certificate Details</h6>
					<pre class="bg-dark text-light p-3 rounded"><code>openssl x509 -in certificate.crt -text -noout</code></pre>

					<h6>Verify Certificate Chain</h6>
					<pre class="bg-dark text-light p-3 rounded"><code>openssl verify -CAfile root-ca.crt -untrusted intermediate-ca.crt server.crt</code></pre>

					<h6>Convert PEM to DER</h6>
					<pre class="bg-dark text-light p-3 rounded"><code>openssl x509 -in cert.pem -outform DER -out cert.der</code></pre>
				</div>
				<div class="col-md-6">
					<h6>Create PKCS#12 Bundle</h6>
					<pre class="bg-dark text-light p-3 rounded"><code>openssl pkcs12 -export -out bundle.p12 \
  -inkey server.key -in server.crt \
  -certfile intermediate-ca.crt</code></pre>

					<h6>Check Private Key Matches Certificate</h6>
					<pre class="bg-dark text-light p-3 rounded"><code>openssl x509 -noout -modulus -in server.crt | md5
openssl rsa -noout -modulus -in server.key | md5</code></pre>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="addcomments.jsp"%>

</div>
</div>
<%@ include file="body-close.jsp"%>
