<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!-- JSON-LD markup with EEAT signals -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PEM Parser Online - Certificate Decoder",
  "alternateName" : "PEM Decoder, Certificate Parser, X.509 Certificate Viewer",
  "description" : "Free online PEM parser and certificate decoder. Decode and parse CRL, CRT, CSR, PEM, private keys, public keys, RSA, DSA, EC keys, and PKCS7 formats. View X.509 certificate details, decrypt encrypted private keys, and parse certificate revocation lists.",
  "image" : "https://8gwifi.org/images/site/online_pem_parser.png",
  "url" : "https://8gwifi.org/PemParserFunctions.jsp",
  "applicationCategory" : "SecurityApplication",
  "applicationSubCategory" : "Cryptography Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem" : "Any (Web-based)",
  "softwareVersion" : "2.0",
  "datePublished" : "2017-09-25",
  "dateModified" : "2025-01-23",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://8gwifi.org",
    "sameAs" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer & Cryptography Expert",
    "description" : "Experienced security professional specializing in cryptographic implementations and network security tools"
  },
  "publisher" : {
    "@type" : "Organization",
    "name" : "8gwifi.org",
    "url" : "https://8gwifi.org",
    "logo" : {
      "@type" : "ImageObject",
      "url" : "https://8gwifi.org/images/site/logo.png"
    },
    "description" : "Provider of professional online cryptography and network security tools"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "description": "Free online PEM parser with no registration required"
  },
  "featureList" : [
    "Parse X.509 certificates (CRT)",
    "Parse Certificate Signing Requests (CSR)",
    "Parse Certificate Revocation Lists (CRL)",
    "Decode RSA private and public keys",
    "Decode DSA private keys",
    "Decode Elliptic Curve (EC) keys",
    "Decode PKCS7 format",
    "Decrypt encrypted private keys (DES-EDE3-CBC)",
    "View certificate details and metadata",
    "One-click sample certificate loading",
    "No registration required",
    "Privacy-first approach"
  ],
  "keywords" : "pem parser, certificate decoder, pem decoder, certificate viewer, decode certificate online, parse crl crt csr, rsa private key decoder, x.509 certificate viewer, openssl decode certificate, pem file decoder, certificate parser, private key decoder, public key decoder, pkcs7 viewer, certificate revocation list parser",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "892",
    "bestRating": "5",
    "worstRating": "1"
  },
  "review": {
    "@type": "Review",
    "reviewRating": {
      "@type": "Rating",
      "ratingValue": "5",
      "bestRating": "5"
    },
    "author": {
      "@type": "Person",
      "name": "Security Community"
    },
    "reviewBody": "Essential tool for parsing and viewing PEM certificates. Handles all major formats including encrypted private keys."
  },
  "potentialAction": {
    "@type": "UseAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://8gwifi.org/PemParserFunctions.jsp",
      "actionPlatform": [
        "http://schema.org/DesktopWebPlatform",
        "http://schema.org/MobileWebPlatform"
      ]
    },
    "name": "Parse PEM Certificate Online"
  },
  "audience": {
    "@type": "ProfessionalAudience",
    "audienceType": "Developers, System Administrators, DevOps Engineers, Security Professionals"
  },
  "isAccessibleForFree": true,
  "inLanguage": "en-US"
}
</script>

	<title>PEM Parser Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Parse and decode PEM certificates online. Free tool decodes CRL, CRT, CSR, private keys, public keys, RSA, DSA, EC, and PKCS7. View X.509 details instantly.">
	<meta name="keywords" content="pem parser, certificate decoder, pem decoder, certificate viewer, decode certificate online, parse crl crt csr, rsa private key decoder, x.509 certificate viewer, openssl decode certificate, pem file decoder">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="index,follow">
	<meta name="author" content="Anish Nath">
	
	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/PemParserFunctions.jsp">
	<meta property="og:title" content="PEM Parser Online – Free | 8gwifi.org">
	<meta property="og:description" content="Parse and decode PEM certificates online. Free tool decodes CRL, CRT, CSR, private keys, public keys, RSA, DSA, EC, and PKCS7. View X.509 details instantly.">
	<meta property="og:image" content="https://8gwifi.org/images/site/online_pem_parser.png">
	
	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/PemParserFunctions.jsp">
	<meta name="twitter:title" content="PEM Parser Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Parse and decode PEM certificates online. Free tool decodes CRL, CRT, CSR, private keys, public keys, RSA, DSA, EC, and PKCS7. View X.509 details instantly.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/online_pem_parser.png">
	
	<!-- Canonical URL -->
	<link rel="canonical" href="https://8gwifi.org/PemParserFunctions.jsp">
	
	<%@ include file="header-script.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {


			$('#ctrTitles').change(function() {
				pem = $(this).val();
				$("#pem").val(pem);
			});
			
			// Handle URL parameters for Share URL feature
			const urlParams = new URLSearchParams(window.location.search);
			if (urlParams.has('pem')) {
				var pemData = urlParams.get('pem');
				$('#pem').val(pemData);
				
				// Highlight the input field
				$('#pem').addClass('border-warning');
				setTimeout(function() {
					$('#pem').removeClass('border-warning');
				}, 3000);
				
				// Check if password is in URL
				if (urlParams.has('pass')) {
					var password = urlParams.get('pass');
					$('#certpassword').val(password);
					
					// Show security warning if private key detected
					if (pemData.includes('PRIVATE KEY') || 
					    pemData.includes('RSA PRIVATE KEY') ||
					    pemData.includes('EC PRIVATE KEY') ||
					    pemData.includes('DSA PRIVATE KEY')) {
						$('#output').html(`
							<div class="alert alert-warning">
								<strong><i class="fas fa-exclamation-triangle"></i> Security Notice:</strong>
								<p class="mb-0">This URL contains a private key. Make sure you trust the source of this link.</p>
							</div>
						`);
					}
				}
				
				// Auto-submit if PEM data is present
				setTimeout(function() {
					$('#form').submit();
				}, 500);
			}
			
			// Copy Share URL from modal
			$('#copyShareUrl').click(function() {
				const shareUrl = $('#shareUrlText').val();
				const $button = $(this);
				const originalHTML = $button.html();
				
				if (!shareUrl || shareUrl.trim() === '') {
					alert('No URL to copy!');
					return;
				}
				
				// Try modern clipboard API first
				if (navigator.clipboard && navigator.clipboard.writeText) {
					navigator.clipboard.writeText(shareUrl).then(() => {
						$button.html('<i class="fas fa-check"></i> Copied!');
						setTimeout(() => {
							$button.html(originalHTML);
						}, 2000);
					}).catch(err => {
						console.error('Clipboard API failed:', err);
						// Fallback to text selection
						fallbackCopyShareUrl(shareUrl, $button, originalHTML);
					});
				} else {
					// Fallback for older browsers
					fallbackCopyShareUrl(shareUrl, $button, originalHTML);
				}
			});
			
			function fallbackCopyShareUrl(text, $button, originalHTML) {
				// Create temporary textarea
				const textarea = document.createElement('textarea');
				textarea.value = text;
				textarea.style.position = 'fixed';
				textarea.style.left = '-999999px';
				textarea.style.top = '-999999px';
				document.body.appendChild(textarea);
				textarea.focus();
				textarea.select();
				
				try {
					const successful = document.execCommand('copy');
					if (successful) {
						$button.html('<i class="fas fa-check"></i> Copied!');
						setTimeout(() => {
							$button.html(originalHTML);
						}, 2000);
					} else {
						alert('Failed to copy. Please select and copy manually.');
					}
				} catch (err) {
					console.error('Fallback copy failed:', err);
					alert('Failed to copy. Please select and copy manually.');
				}
				
				document.body.removeChild(textarea);
			}


			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#form').submit(function(event) {
				event.preventDefault();
				$('#output1').html('<div class="text-center"><img src="images/712.GIF" alt="loading"> <span class="ml-2">Parsing PEM...</span></div>');
				$('#output').empty();
				
				$.ajax({
					type : "POST",
					url : "CipherFunctionality",
					data : $("#form").serialize(),
					dataType : "json",
					success : function(response) {
						$('#output1').empty();
						displayPemResults(response);
					},
					error : function(xhr, status, error) {
						$('#output1').empty();
						var errorMsg = "Error parsing PEM. ";
						if (xhr.responseJSON && xhr.responseJSON.errorMessage) {
							errorMsg += xhr.responseJSON.errorMessage;
						} else if (xhr.responseText) {
							try {
								var errorResponse = JSON.parse(xhr.responseText);
								errorMsg += errorResponse.errorMessage || errorResponse.message || "Unknown error";
							} catch(e) {
								errorMsg += "Please check your PEM format and try again.";
							}
						} else {
							errorMsg += "Please check your PEM format and try again.";
						}
						$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> ' + errorMsg + '</div>');
					}
				});
			});
			
			// Store response globally for Copy JSON and Share URL
			window.currentPemResponse = null;
			
			// Function to display PEM parsing results
			function displayPemResults(response) {
				// Store response globally
				window.currentPemResponse = response;
				
				var html = '';
				
				// Add action buttons at the top
				html += '<div class="mb-3 d-flex justify-content-end gap-2">';
				html += '<button type="button" class="btn btn-sm btn-outline-primary copy-json-btn">';
				html += '<i class="fas fa-copy"></i> Copy JSON</button>';
				html += '<button type="button" class="btn btn-sm btn-outline-info share-url-btn">';
				html += '<i class="fas fa-share-alt"></i> Share URL</button>';
				html += '</div>';
				
				if (!response.success) {
					html += '<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> ' + 
						(response.errorMessage || 'Failed to parse PEM') + '</div>';
					$('#output').html(html);
					return;
				}
				
				// Display X.509 Certificate
				if (response.x509) {
					html += renderX509Certificate(response.x509);
				}
				// Display RSA Key
				else if (response.rsapojo) {
					html += renderRSAKey(response.rsapojo);
				}
				// Display EC Key
				else if (response.eckeypojo) {
					html += renderECKey(response.eckeypojo);
				}
				// Display DSA Key
				else if (response.dsapojo) {
					html += renderDSAKey(response.dsapojo);
				}
				// Generic message
				else if (response.message) {
					html += '<div class="alert alert-info"><pre class="mb-0">' + escapeHtml(response.message) + '</pre></div>';
				}
				else {
					html += '<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No parseable data found in PEM format.</div>';
				}
				
				$('#output').html(html);
				
				// Attach event handlers for new buttons
				attachActionButtonHandlers();
			}
			
			// Attach handlers for Copy JSON and Share URL buttons
			function attachActionButtonHandlers() {
				// Copy JSON button
				$('.copy-json-btn').off('click').on('click', function() {
					if (!window.currentPemResponse) {
						alert('No data to copy');
						return;
					}
					
					var jsonString = JSON.stringify(window.currentPemResponse, null, 2);
					// Add branding link
					var brandedJson = jsonString + '\n\n---\nParsed using: https://8gwifi.org/PemParserFunctions.jsp';
					var $button = $(this);
					var originalHTML = $button.html();
					
					if (navigator.clipboard && navigator.clipboard.writeText) {
						navigator.clipboard.writeText(brandedJson).then(function() {
							$button.html('<i class="fas fa-check"></i> Copied!');
							$button.removeClass('btn-outline-primary');
							$button.addClass('btn-success');
							setTimeout(function() {
								$button.html(originalHTML);
								$button.removeClass('btn-success');
								$button.addClass('btn-outline-primary');
							}, 2000);
						}).catch(function(err) {
							console.error('Failed to copy:', err);
							alert('Failed to copy JSON to clipboard');
						});
					} else {
						// Fallback
						var textarea = document.createElement('textarea');
						textarea.value = brandedJson;
						textarea.style.position = 'fixed';
						textarea.style.left = '-999999px';
						document.body.appendChild(textarea);
						textarea.select();
						try {
							document.execCommand('copy');
							$button.html('<i class="fas fa-check"></i> Copied!');
							setTimeout(function() {
								$button.html(originalHTML);
							}, 2000);
						} catch(e) {
							alert('Failed to copy. Please select and copy manually.');
						}
						document.body.removeChild(textarea);
					}
				});
				
				// Share URL button
				$('.share-url-btn').off('click').on('click', function() {
					var pemInput = $('#pem').val();
					if (!pemInput || !pemInput.trim()) {
						alert('No PEM data to share');
						return;
					}
					
					// Check if PEM contains private key
					var includesPrivateKey = pemInput.includes('PRIVATE KEY') || 
					                          pemInput.includes('RSA PRIVATE KEY') ||
					                          pemInput.includes('EC PRIVATE KEY') ||
					                          pemInput.includes('DSA PRIVATE KEY');
					
					// Create URL parameters
					const params = new URLSearchParams({
						pem: pemInput
					});
					
					// Add password if present
					var password = $('#certpassword').val();
					if (password && password.trim()) {
						params.append('pass', password);
					}
					
					const shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();
					
					// Update modal warning based on content
					if (includesPrivateKey) {
						$('#shareWarningContent').html(`
							<div class="alert alert-danger mb-3">
								<strong><i class="fas fa-exclamation-triangle"></i> WARNING: Private Key in URL!</strong>
								<p class="mb-2"><strong>You are about to share your PRIVATE KEY via URL!</strong></p>
								<p class="mb-0">This is extremely dangerous! Anyone with this URL can access your private key. Only share this URL if you fully understand the security implications and trust the recipient completely.</p>
							</div>
							<div class="alert alert-warning mb-3">
								<strong><i class="fas fa-shield-alt"></i> Security Best Practices:</strong>
								<ul class="mb-0 mt-2">
									<li>Never share private keys via URL in production environments</li>
									<li>Use secure channels (encrypted email, secure file transfer) for sharing private keys</li>
									<li>Consider using password-protected keys and sharing the password separately</li>
									<li>Revoke and regenerate keys if accidentally shared</li>
								</ul>
							</div>
						`);
					} else {
						$('#shareWarningContent').html(`
							<div class="alert alert-info mb-3">
								<strong><i class="fas fa-info-circle"></i> Share PEM Data</strong>
								<p class="mb-0">This URL contains your PEM data. Anyone with this link can view and use it. Share responsibly.</p>
							</div>
						`);
					}
					
					$('#shareUrlText').val(shareUrl);
					$('#shareUrlModal').modal('show');
				});
			}
			
			// Render X.509 Certificate
			function renderX509Certificate(x509) {
				var html = '<div class="card mb-3 border-primary">';
				html += '<div class="card-header bg-primary text-white"><h5 class="mb-0"><i class="fas fa-certificate"></i> X.509 Certificate Details</h5></div>';
				html += '<div class="card-body">';
				
				if (x509.isSelfSigned) {
					html += '<div class="alert alert-info mb-3"><i class="fas fa-info-circle"></i> <strong>' + escapeHtml(x509.isSelfSigned) + '</strong></div>';
				}
				
				// Type and Version in single row
				html += '<div class="row">';
				html += '<div class="col-md-6">' + renderField('Type', x509.type) + '</div>';
				html += '<div class="col-md-6">' + renderField('Version', x509.version) + '</div>';
				html += '</div>';
				
				html += '<div class="row">';
				html += '<div class="col-md-6">';
				html += renderField('Serial Number', x509.serialNumber, 2);
				html += renderField('Not Before', x509.notBefore);
				html += renderField('Not After', x509.notAfter);
				html += '</div><div class="col-md-6">';
				html += renderField('Signature Algorithm', x509.sigAlgName);
				html += renderField('Subject DN', x509.subjectDN, 2);
				html += renderField('Issuer DN', x509.issuerDN, 2);
				html += renderField('Subject Alternative Names (SANs)', x509.subjectAlternativeNames, 3);
				html += '</div></div>';
				
				// Fingerprints - each on dedicated row
				html += '<hr><h6 class="text-primary"><i class="fas fa-fingerprint"></i> Fingerprints</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('MD5', x509.md5) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-1', x509.sha1) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-256', x509.sha256, 2) + '</div>';
				html += '</div>';
				
				// Extensions
				if (x509.crticalExtensions && x509.crticalExtensions.length > 0) {
					html += '<hr><h6 class="text-danger"><i class="fas fa-exclamation-circle"></i> Critical Extensions</h6>';
					html += renderField('', x509.crticalExtensions, 6);
				}
				if (x509.noncrticalExtensions && x509.noncrticalExtensions.length > 0) {
					html += '<hr><h6 class="text-info"><i class="fas fa-info-circle"></i> Non-Critical Extensions</h6>';
					html += renderField('', x509.noncrticalExtensions, 6);
				}
				
				// Signature & Encoded
				html += '<hr><h6 class="text-secondary"><i class="fas fa-code"></i> Raw Data</h6>';
				html += renderField('Signature', x509.signature, 6);
				html += renderField('Encoded', x509.encoded, 6);
				
				html += '</div></div>';
				return html;
			}
			
			// Render RSA Key
			function renderRSAKey(rsa) {
				var html = '<div class="card mb-3 border-success">';
				html += '<div class="card-header bg-success text-white"><h5 class="mb-0"><i class="fas fa-key"></i> RSA Key Details</h5></div>';
				html += '<div class="card-body">';
				
				html += '<div class="row">';
				html += '<div class="col-md-6">';
				html += renderField('Key Size', rsa.keySize);
				html += renderField('Algorithm', rsa.algo);
				html += renderField('Format', rsa.format);
				html += renderField('Type', rsa.type);
				html += renderField('Fingerprint', rsa.fingerprint);
				html += '</div><div class="col-md-6">';
				html += renderField('Public Exponent', rsa.publicexponent);
				html += '</div></div>';
				
				// Key Components
				html += '<hr><h6 class="text-primary"><i class="fas fa-cog"></i> Key Components</h6>';
				html += renderField('Modulus', rsa.modulus, 10);
				if (rsa.privateexponent) {
					html += renderField('Private Exponent', rsa.privateexponent, 10);
				}
				if (rsa.primeP) {
					html += '<div class="row"><div class="col-md-6">' + renderField('Prime P', rsa.primeP, 8) + '</div>';
					html += '<div class="col-md-6">' + renderField('Prime Q', rsa.primeQ, 8) + '</div></div>';
					html += '<div class="row"><div class="col-md-6">' + renderField('Prime Exponent P', rsa.primeExponentP, 8) + '</div>';
					html += '<div class="col-md-6">' + renderField('Prime Exponent Q', rsa.primeExponentQ, 8) + '</div></div>';
					html += renderField('CRT Coefficient', rsa.crtCoefficient, 6);
				}
				
				// Fingerprints - each on dedicated row
				html += '<hr><h6 class="text-primary"><i class="fas fa-fingerprint"></i> Fingerprints</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('MD5', rsa.md5) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-1', rsa.sha1) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-256', rsa.sha256, 2) + '</div>';
				html += '</div>';
				
				if (rsa.encoded) {
					html += '<hr><h6 class="text-secondary"><i class="fas fa-code"></i> Encoded</h6>';
					html += renderField('', rsa.encoded, 10);
				}
				
				html += '</div></div>';
				return html;
			}
			
			// Render EC Key
			function renderECKey(ec) {
				var html = '<div class="card mb-3 border-info">';
				html += '<div class="card-header bg-info text-white"><h5 class="mb-0"><i class="fas fa-key"></i> Elliptic Curve Key Details</h5></div>';
				html += '<div class="card-body">';
				
				html += '<div class="row">';
				html += '<div class="col-md-6">';
				html += renderField('Key Size', ec.keySize);
				html += renderField('Algorithm', ec.algo);
				html += renderField('Format', ec.format);
				html += renderField('Curve Name', ec.curveName);
				html += renderField('Cofactor', ec.cofactor);
				html += '</div><div class="col-md-6">';
				html += renderField('Private Key', ec.privateKey, 3);
				html += renderField('Public Key', ec.publicKey, 4);
				html += '</div></div>';
				
				html += '<hr><h6 class="text-primary"><i class="fas fa-chart-line"></i> Curve Parameters</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-6">' + renderField('Affine X', ec.affineX, 3) + '</div>';
				html += '<div class="col-md-6">' + renderField('Affine Y', ec.affineY, 3) + '</div>';
				html += '</div>';
				html += renderField('Order', ec.order, 3);
				
				// Fingerprints - each on dedicated row
				html += '<hr><h6 class="text-primary"><i class="fas fa-fingerprint"></i> Fingerprints</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('MD5', ec.md5) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-1', ec.sha1) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-256', ec.sha256, 2) + '</div>';
				html += '</div>';
				
				html += '</div></div>';
				return html;
			}
			
			// Render DSA Key
			function renderDSAKey(dsa) {
				var html = '<div class="card mb-3 border-warning">';
				html += '<div class="card-header bg-warning text-dark"><h5 class="mb-0"><i class="fas fa-key"></i> DSA Key Details</h5></div>';
				html += '<div class="card-body">';
				
				html += '<div class="row">';
				html += '<div class="col-md-6">';
				html += renderField('Key Size', dsa.keySize);
				html += renderField('Algorithm', dsa.algo);
				html += renderField('Format', dsa.format);
				html += '</div><div class="col-md-6">';
				html += renderField('Public Key', dsa.pub, 5);
				html += renderField('Private Key', dsa.encoded, 5);
				html += '</div></div>';
				
				html += '<hr><h6 class="text-primary"><i class="fas fa-cog"></i> DSA Parameters</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-4">' + renderField('P', dsa.p, 6) + '</div>';
				html += '<div class="col-md-4">' + renderField('Q', dsa.q, 3) + '</div>';
				html += '<div class="col-md-4">' + renderField('G', dsa.g, 6) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-6">' + renderField('X', dsa.x, 3) + '</div>';
				html += '<div class="col-md-6">' + renderField('Y', dsa.y, 6) + '</div>';
				html += '</div>';
				
				// Fingerprints - each on dedicated row
				html += '<hr><h6 class="text-primary"><i class="fas fa-fingerprint"></i> Fingerprints</h6>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('MD5', dsa.md5) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-1', dsa.sha1) + '</div>';
				html += '</div>';
				html += '<div class="row">';
				html += '<div class="col-md-12">' + renderField('SHA-256', dsa.sha256, 2) + '</div>';
				html += '</div>';
				
				html += '</div></div>';
				return html;
			}
			
			// Helper function to render a field
			function renderField(label, value, rows) {
				if (!value) return '';
				rows = rows || 1;
				var html = '<div class="form-group mb-3">';
				if (label) {
					html += '<label class="font-weight-bold text-secondary">' + escapeHtml(label) + '</label>';
				}
				html += '<div class="input-group">';
				html += '<textarea class="form-control" readonly rows="' + rows + '" id="field_' + (label || 'value').replace(/\s+/g, '_') + '">' + escapeHtml(value) + '</textarea>';
				html += '<div class="input-group-append">';
				html += '<button class="btn btn-outline-secondary" type="button" onclick="copyToClipboard(\'field_' + (label || 'value').replace(/\s+/g, '_') + '\')" title="Copy to clipboard">';
				html += '<i class="fas fa-copy"></i></button>';
				html += '</div></div></div>';
				return html;
			}
			
			// Escape HTML
			function escapeHtml(text) {
				if (!text) return '';
				var map = {
					'&': '&amp;',
					'<': '&lt;',
					'>': '&gt;',
					'"': '&quot;',
					"'": '&#039;'
				};
				return text.replace(/[&<>"']/g, function(m) { return map[m]; });
			}
		});
		
		// Copy to clipboard function - MUST be in global scope for onclick handlers
		function copyToClipboard(elementId) {
			var textarea = document.getElementById(elementId);
			if (!textarea) {
				console.error('Textarea not found:', elementId);
				return;
			}
			
			var textToCopy = textarea.value;
			if (!textToCopy) {
				console.error('No text to copy');
				return;
			}
			
			// Find the button - it's in the input-group-append div
			var inputGroup = textarea.closest('.input-group');
			var btn = inputGroup ? inputGroup.querySelector('button') : null;
			var originalHtml = btn ? btn.innerHTML : '';
			
			// Use modern clipboard API
			if (navigator.clipboard && navigator.clipboard.writeText) {
				navigator.clipboard.writeText(textToCopy).then(function() {
					// Show success feedback
					if (btn) {
						btn.innerHTML = '<i class="fas fa-check text-success"></i>';
						btn.classList.remove('btn-outline-secondary');
						btn.classList.add('btn-success');
						setTimeout(function() {
							btn.innerHTML = originalHtml;
							btn.classList.remove('btn-success');
							btn.classList.add('btn-outline-secondary');
						}, 2000);
					}
				}).catch(function(err) {
					console.error('Failed to copy:', err);
					// Fallback to execCommand
					fallbackCopy(textarea, btn, originalHtml);
				});
			} else {
				// Fallback for older browsers
				fallbackCopy(textarea, btn, originalHtml);
			}
		}
		
		// Fallback copy function using execCommand
		function fallbackCopy(textarea, btn, originalHtml) {
			try {
				textarea.select();
				textarea.setSelectionRange(0, 99999); // For mobile devices
				var success = document.execCommand('copy');
				if (success && btn) {
					btn.innerHTML = '<i class="fas fa-check text-success"></i>';
					btn.classList.remove('btn-outline-secondary');
					btn.classList.add('btn-success');
					setTimeout(function() {
						btn.innerHTML = originalHtml;
						btn.classList.remove('btn-success');
						btn.classList.add('btn-outline-secondary');
					}, 2000);
				} else if (btn) {
					btn.innerHTML = '<i class="fas fa-exclamation-triangle text-warning"></i>';
					setTimeout(function() {
						btn.innerHTML = originalHtml;
					}, 2000);
				}
			} catch(err) {
				console.error('Fallback copy failed:', err);
				if (btn) {
					btn.innerHTML = '<i class="fas fa-exclamation-triangle text-danger"></i>';
					setTimeout(function() {
						btn.innerHTML = originalHtml;
					}, 2000);
				}
			}
		}
	</script>
</head>


<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">PEM Parser & Certificate Decoder</h1>

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

<hr>

<div class="alert alert-info" role="alert">
	<strong><i class="fas fa-info-circle"></i> Expert Tip:</strong> This tool parses and decodes various PEM formats including X.509 certificates, 
	Certificate Signing Requests (CSR), Certificate Revocation Lists (CRL), private keys, public keys, and PKCS7. 
	You can decrypt encrypted private keys by providing the password. Use the sample files dropdown to quickly test different formats.
</div>




<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="loading" />Loading!
</div>



<form class="form-horizontal" id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName"
		   value="PEM_DECODER">
	
	<div class="row">
		<!-- Left Column: Input -->
		<div class="col-lg-6 col-md-12 mb-4">
			<div class="card">
				<div class="card-header bg-primary text-white">
					<h5 class="mb-0"><i class="fas fa-upload"></i> PEM Input</h5>
				</div>
				<div class="card-body">
					<div class="form-group">
						<label for="ctrTitles"><strong>Sample Files:</strong></label>
						<select name="ctrTitles" id="ctrTitles" class="form-control">
			<option value="-----BEGIN X509 CRL-----
MIIBHTCBhzANBgkqhkiG9w0BAQQFADBCMQswCQYDVQQGEwJJRTEPMA0GA1UECBMG
RHVibGluMQ0wCwYDVQQKEwRJT05BMRMwEQYDVQQDFApDQV9mb3JfQ1JMFw0wNjAy
MTUxMDQ3NDBaFw0wNjAzMTUxMDQ3NDBaMBQwEgIBAhcNMDYwMjE1MTA0NTA1WjAN
BgkqhkiG9w0BAQQFAAOBgQBpPlWKIKBX0jZ58DS7c2UeHKlANY3E5rl3/SsfqCYM
evswZ39qE3RYueKI563F0mJIax72EA1FzBHLa0go4nit8M/91ld48qoZi7xieZuQ
9xi6ltx7pbTVvw/oXnGJSziM+HUX3bp08QHgSNDk9N3qRzKLcF4dmkqIQbq/sjnO
Mg==
-----END X509 CRL-----">CRL</option>
			<option value="-----BEGIN CERTIFICATE-----
MIIFtTCCA52gAwIBAgIJAO0cq2lJPZZJMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTQwMzEyMTc0NzU5WhcNMTkwMzEyMTc0NzU5WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
CgKCAgEAsgzs6vN2sveHVraXV0zdoVyhWUHWNQ0xnhHTPhjt5ggHmSvrUxvUpXfK
WCP9gZo59Q7dx0ydjqBsdooXComVP4kGDjulvOHWgvcVmwTsL0bAMqmsCyyJKM6J
Wqi8E+CPTOpMBWdapUxvwaSmop8geiTtnX0aV4zGXwsz2mwdogbounQjMB/Ew7vv
8XtqwXSpnR7kM5HPfM7wb9F8MjlRuna6Nt2V7i0oUr+EEt6fIYEVZFiHTSUzDLaz
2eClJeCNdvyqaeGCCqs+LunMq3kZjO9ahtS2+1qZxfBzac/0KXRYnLa0kGQHZbw0
ecgdZC9YpqqMeTeSnJPPX4/TQt54qVLQXM3+h8xvwt3lItcJPZR0v+0yQe5QEwPL
4c5UF81jfGrYfEzmGth6KRImRMdFLF9+F7ozAgGqCLQt3eV2YMXIBYfZS9L/lO/Q
3m4MGARZXUE3jlkcfFlcbnA0uwMBSjdNUsw4zHjVwk6aG5CwYFYVHG9n5v4qCxKV
ENRinzgGRnwkNyADecvbcQ30/UOuhU5YBnfFSYrrhq/fyCbpneuxk2EouL3pk/GA
7mGzqhjPYzaaNGVZ8n+Yys0kxuP9XDOUEDkjXpa/SzeZEk9FXMlLc7Wydj/7ES4r
6SYCs4KMr+p7CjFg/a7IdepLQ3txrZecrBxoG5mBDYgCJCfLBu0CAwEAAaOBpzCB
pDAdBgNVHQ4EFgQUWQI/JOoU+RrUPUED63dMfd2JMFkwdQYDVR0jBG4wbIAUWQI/
JOoU+RrUPUED63dMfd2JMFmhSaRHMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpT
b21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGSCCQDt
HKtpST2WSTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4ICAQBwGbAmiLHE
jubdLeMygwrV8VjlOVxV41wvRi6y1B5Bdvh71HPoOZdvuiZOogzxB22Tzon6Uv5q
8uuAy37rHLlQTOqLwdLJOu/ijMirAkh13gQWt4oZGUDikyiI4PMNo/hr6XoZWUfU
fwmcAzoEMln8HyISluTau1mtQIDgvGprU472GqC4AC7bYeED+ChCevc7Ytjl4zte
/tw8u3nqrkESYBIA2yEgyFAr1pRwJPM/T1U6Ehalp1ZTeQcAXEa7IC6ht2NlN1FC
fk2KQmrk4Z3jaSVv8GxshA354W+UEpti0o6Fv+2ozkAaQ1/xjiNwBTHtgJ1/AG1j
bDYcCFfmYmND0RFjvVu7ma+UNdKQ+t1o7ip4tHQUTEFvdqoaCLN09PcTVgvm71Lr
s8IOldiMgiCjQK3e0jwXx78tXs/msMzVI+9AR9aNzo0Y42C97ctlGu3+v07Zp+x4
6w1rg3eklJM02davNWK2EUSetn9EWsIJXU34Bj7mnI/2DFo292GVNw1kT5Bf4IvA
T74gsJLB6wacN4Ue6zPtIvrK93DABAfRUmrAWmH8+7MJolSC/rabJF3E2CeBTYqZ
R5M5azDV1CIhIeOTiPA/mq5fL1UrgVbB+IATIsUAQfuWivDyoeu96LB/QswyHAWG
8k2fPbA2QVWJpcnryesCy3qtzwbHSYbshQ==
-----END CERTIFICATE-----">CRT</option>
			<option value="-----BEGIN CERTIFICATE REQUEST-----
MIICijCCAXICAQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUx
ITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJw+rBXgiX/W0ezx/2IrD8AnjzFJbRC6v4afw5uN
PV1P8hG4AUyP8DFJx/to7jk2HgoqzgddG3P0KxVYWi1d4B1sr0i/lr9Ln3VnmYi1
wJyAjXXYiQkLzlPubHjVKD8OECrxQEIGS6ILI1ptrmoyUp0hrJFQrePIGllayIju
DkGVZEk8V61DZJ3p1yfW9m12pvwbdcmtRNbdf2/yE2f9N1kI3xsF4HLamMrbwBwt
7+eNbPaOdydrlp/6TgSXNtOfAHeVss6j0R8wNYG5fl4pyrPOV+VOTwMCYlQrEsgh
ZDRsCZprgj7ax4qcGYuWseY362+9T5YpY9lTl3a0ds1OxTkCAwEAAaAAMA0GCSqG
SIb3DQEBBQUAA4IBAQAfXuOjzg8VobCHLHRXz69DKOLWRlYyYfuL5sO4A7FfnDms
9u7Yzkb7nGz/qJyqOi2Zek7w/9H5b5AprMZpLwvpDQlCbSxRSdHSamzZ1ojQUMR9
Zkz4tNGz2Ka9poxSKdBbV7MaFg8HnLnpe7wwRAvDL45bCXsdfA6DyaUp/2C+0eaR
RhcTIyAFeQdsLyhgj4FMfsoMnq+/7fzT+qFbI0ExOyLff4ZnywGiJ2c+aWC8DBTm
N35QKLGcM0+u1Wme0VC11AxhfrW8bEi7saE28Yc+x2ZIW+XzKFwm+pp6MCrTEAlW
G0x8oMpILA6XfMiDMDbOxPGUY/6vTSpzI81A/T5O
-----END CERTIFICATE REQUEST-----">CSR</option>
			<option value="-----BEGIN NEW CERTIFICATE REQUEST-----
MIICijCCAXICAQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUx
ITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJw+rBXgiX/W0ezx/2IrD8AnjzFJbRC6v4afw5uN
PV1P8hG4AUyP8DFJx/to7jk2HgoqzgddG3P0KxVYWi1d4B1sr0i/lr9Ln3VnmYi1
wJyAjXXYiQkLzlPubHjVKD8OECrxQEIGS6ILI1ptrmoyUp0hrJFQrePIGllayIju
DkGVZEk8V61DZJ3p1yfW9m12pvwbdcmtRNbdf2/yE2f9N1kI3xsF4HLamMrbwBwt
7+eNbPaOdydrlp/6TgSXNtOfAHeVss6j0R8wNYG5fl4pyrPOV+VOTwMCYlQrEsgh
ZDRsCZprgj7ax4qcGYuWseY362+9T5YpY9lTl3a0ds1OxTkCAwEAAaAAMA0GCSqG
SIb3DQEBBQUAA4IBAQAfXuOjzg8VobCHLHRXz69DKOLWRlYyYfuL5sO4A7FfnDms
9u7Yzkb7nGz/qJyqOi2Zek7w/9H5b5AprMZpLwvpDQlCbSxRSdHSamzZ1ojQUMR9
Zkz4tNGz2Ka9poxSKdBbV7MaFg8HnLnpe7wwRAvDL45bCXsdfA6DyaUp/2C+0eaR
RhcTIyAFeQdsLyhgj4FMfsoMnq+/7fzT+qFbI0ExOyLff4ZnywGiJ2c+aWC8DBTm
N35QKLGcM0+u1Wme0VC11AxhfrW8bEi7saE28Yc+x2ZIW+XzKFwm+pp6MCrTEAlW
G0x8oMpILA6XfMiDMDbOxPGUY/6vTSpzI81A/T5O
-----END NEW CERTIFICATE REQUEST-----">NEW CSR</option>
			<option value="-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,F57524B7B26F4694

IJ/e6Xrf4pTBSO+CHdcqGocyAj5ysUre5BwTp6Yk2w9P/r7si7YA+pivghbUzYKc
uy2hFwWG+LVajZXaG0dFXmbDHd9oYlW/SeJhPrxMvxaqC9R/x4MugAMFOhCQGMq3
XW58R70L48BIuG6TCSOAGIwMDowv5ToL4nZYnqIRT77aACcsM0ozC+LCyqmLvvsU
NV/YX4ZgMhzaT2eVK+mtOut6m1Wb7t6iUCS14dB/fTF+RaGYYZYMGut/alFaPqj0
/KKlTNxCRD99+UZDbg3TnxIFSZd00zY75votTZnlLypoB9pUFP5iQglvuQ4pD3Ux
bzU4cO0/hrdo04wORwWG/DUoAPlq8wjGei5jbEwHQJ8fNBzCl3Zy5Fx3bcAaaXEK
zB97cyqhr80f2KnyiAKzk7vmyuRtMO/6Y4yE+1mLFE7NWcRkGXLEd3+wEt8DEq2R
nQibvRTbT26HkO0bcfBAaeOYxHawdNcF2SZ1dUSZeo/teHNBI2JD5xRgtEPekXRs
bBuCmxUevuh2+Q632oOpNNpFWBJTsyTcp9cAsxTEkbOCicxLN6c1+GvwyIqfSykR
G08Y5M88n7Ey5GZ43KUbGh60vV5QN/mzhf3SotBl9+wetpm+4AmkKVUQyQVdRrn2
1jXrkUZcSN8VbYk2tB74/FFXuaaF2WRQNawceXjrvegxz3/AkjZ7ahYI4rgptCqz
OXvMk+le5tmVKbJfl1G+EZm2CqDLly5makeMKvX3fSWefKoZSbN0NuW28RgSJIQC
pqja3dWZyGl7Z9dlM+big0nbLhMdIvT8526lD+p+9aMMuBL14MhWGp4IIfvXOPR+
Ots3ZoGR9vtPQyO6YN5/CtRp1DBbRA48W9xk0BnnjSNpFBLY4ykqZj/cS01Up88x
UMATqoMLiBwKCyaeibiIXpzqPTagG3PEEJkYPsrG/zql1EktjTtNo4LaYdFuZZzb
fMmcEpFZLerCIgu2cOnhhKwCHYWbZ2MSVsgoiu6RyqqBblAfNkttthiPtCLY82sQ
2ejN3NMsq+xlc/ISc21eClUaoUXmvyaSf2E3D4CN3FAi8fD74fP64EiKr+JjMNUC
DWZ79UdwZcpl2VJ7JUAAyRzEt66U5PwQqv1U8ITjsBjykxRQ68/c/+HCOfg9NYn3
cmpK5UxdFGj6261c6nVRlLVmV0+mPj1+sWHow5jZiH81IuoL3zqGkKzqy5FkTgs4
MG3hViN9lHEmMPZdK16EPhCwvff0eBV+vhfPjmGoAE6TK3YY/yh9bfhMliLoc1jr
NmPxL0FWrNzqWxZwMtDYcXu4KUesBL6/Hr+K9HSUa8zF+4UbELJTPOd1QAU6HF7a
9BidzGMZ+J2Vjqa/NGpWckBRjWb6S7aItK6rrtORU1QHmpQlYpqEh49sreo6DCrb
s8yejjKm2gSB/KhTe1nJXcTM16Xa4qWXTv11x46FNTZPUWQ7KoI0AzzScn6StBdo
YCvzqCrla1em/Kakkws7Qu/pVj9R8ndHzoLktOi3l6lwwy5d4L697DyhP+02+eLt
SBefoVnBNp449CSHW+brvPEyKD3D5CVpTIDfu2y8+nHszfBL22wuO4T+oem5h55A
-----END RSA PRIVATE KEY-----">PEM</option>
			<option value="-----BEGIN PKCS7-----
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
lr9Ln3VnmYi1wJyAjXXYiQkLzlPubHjVKD8OECrxQEIGS6ILI1ptrmoyUp0hrJFQ
rePIGllayIjuDkGVZEk8V61DZJ3p1yfW9m12pvwbdcmtRNbdf2/yE2f9N1kI3xsF
4HLamMrbwBwt7+eNbPaOdydrlp/6TgSXNtOfAHeVss6j0R8wNYG5fl4pyrPOV+VO
TwMCYlQrEsghZDRsCZprgj7ax4qcGYuWseY362+9T5YpY9lTl3a0ds1OxTkCAwEA
AaOBpzCBpDAdBgNVHQ4EFgQUnrQ+TtZoses1K7B0uC+TMpNPcaMwdQYDVR0jBG4w
bIAUnrQ+TtZoses1K7B0uC+TMpNPcaOhSaRHMEUxCzAJBgNVBAYTAkFVMRMwEQYD
VQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBM
dGSCCQCf5by5/710vzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQAo
WZYYI5XfHa7nQsTFlIP86/eE/BgZqPkEyJmk2NyT7qWo3wQkZt+HCi/oKIFLn+uo
heX4Etj2geHI2KO5TO0+qdEESoYVAFqxcgPAlOx6FMnjTujNbABdrSoKVklOVPNS
8zUogAR/fo8t7bX7zWhdCnIs047F77k1Mnn38QfzdKHTNVVJvf02UBzRdS86T07o
3zujj5YOY/ESSaTAHO2os7AbL1g2i4cbPJzZziOgMoS7gXQhxUrS0ePPPOTTt2VY
dylawwgHrKZW7iAv5zTndZNGdvehuf7r4iyvbYQhRu6CHSFadk3goggB+FQTljfR
eex+rScBkONIaUU6U8NwoQAxAA==
-----END PKCS7-----">PKCS7</option>
			<option value="-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCoknaik3X9AwXf
1nb/BfHlR4RBcij+Ri2RzxZfdcTuhcIL4XLrgwaz/Skx3R/UjU3eoxneBjcGeA7X
QX75aXMS2FKrfQEJ6mp9AVQTowPC5VkAp8L8vk/cBrckZFHQsm9bHnLirJ6LYhWK
sLbvgpJo+P4OMG4P/GeQVwaWwLxaZNSs0sEjVRuy0vbWCO4jJwnmZpPMxU0sRCRN
xod3n6DJ0XhwCP/CxhlFVHjoM/nX/HGlPWkwG05BFBH4J9Zy4SNNNg6CDjIsl56R
2Fu8d/RHtIB/UPhIEoV6t5rWkJx4SP76OwjiXl9IGiDWpb6uu2/OQctZRBezxvCZ
O4lgzKFXAgMBAAECggEAYK4XsmhmbCTWsqka+GqdcIVS2gIydpsjOZQO3dL6jl5S
i2PS+DXem04f2URcJBiix4S9qjPgTSqAQH6E52DOKcm9qDL6bIhwaJ9hbB27Y4UM
Ra7xyukPfj6vvQR4U/xyl0zgURb1mzU266MsWDOH6wKbGuI1zZ9SelsfIUkK/cAV
s6Ao4kzCCQWZMQ/GkYxtQXg/tdPtI2Ueexon0Xtr4bc50XefEFvpKNi3ZqX7fRHV
e2bvnzKH6TN6DlEBruIdRwLsfmFXMIXU98D1OYokaaeVeHH5iZ2nXrlGGw72RfcQ
awrEHvMTTUhzg5LnMw30Smq1ogPanhLtbofPqIQJwQKBgQDfxKZ7lFle+tiMEKmU
87uiRavAHrmQNipqBcbtadJqqQtvGOCxwSg9phh2YnwxRSyw1oBpg4ogvg1QbhqV
UNfB8b/M2kpPRpGZpjCvi6En8GzK6K4e/UQJ4i0l7tPT9tt3TynbMwb3xFcEnFEX
IxfcWnlbC5tm5Sea6b4BzwK84QKBgQDA2nvqHNsqU9HyCX61R5Bo2QLnsI4CgUBk
z2hhc4bteb//mKCWeVvPNRu9AFhNEJzix0/EEkCVhbpIKE1DUCzBPWI/4CkH1bRc
RBE7/7I3pcMBbV22OdGoISmUf6IFZSyQuBoShLDBH3CVmqdmto9b5nwYaTgdycvt
xpyQvdKtNwKBgHFzF2EyXnlcPqwMyp29URU9s41NRpGKFMj6MtgtvcPb/vMNruYQ
Y2GWM3LaDdNBGh5yMlrMmRxunvt3Rz0K5sjq025+AgzdX3aCHs7xwPwp1k6t15HY
oEVOictgob8mujBsT3FWFqNJxUCOLELJxRAwQrTZVqm9Zu4Qsgfit6WhAoGBAKWx
UbOUNU0JlSDBvaacpNsgUFmlnG1UhXHXrVPFAVE5QJeml5qRDCtb8sgQ6szTkCdb
nRHVqL2Olrz2O2OxF7KzPZ2pxzbfCkYXiUMmbgVXmtK4F0LALHyqeWIHwrml8oMo
WeY9MOvMSluO83LRORx5S3dht4AIZ/iTouLM5JxDAoGAcAnam49TeCFZuOu5/QCb
GYyAntOQL/nunSbuHoNvC+bBrcUX2BfDkalkzlm/YRJgmqSQ7Ih3fbp4i5NCVtpM
1dafoyed5UqY0F7Vou7JJE57tlKieKPhQOMTSl2Q5WMvby+owRb0Sx325xQvoslH
QM9+y6wy6YMdNweC+JkcZVo=
-----END PRIVATE KEY-----">PRIVATE KEY</option>
			<option value="-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnD6sFeCJf9bR7PH/YisP
wCePMUltELq/hp/Dm409XU/yEbgBTI/wMUnH+2juOTYeCirOB10bc/QrFVhaLV3g
HWyvSL+Wv0ufdWeZiLXAnICNddiJCQvOU+5seNUoPw4QKvFAQgZLogsjWm2uajJS
nSGskVCt48gaWVrIiO4OQZVkSTxXrUNknenXJ9b2bXam/Bt1ya1E1t1/b/ITZ/03
WQjfGwXgctqYytvAHC3v541s9o53J2uWn/pOBJc2058Ad5WyzqPRHzA1gbl+XinK
s85X5U5PAwJiVCsSyCFkNGwJmmuCPtrHipwZi5ax5jfrb71Plilj2VOXdrR2zU7F
OQIDAQAB
-----END PUBLIC KEY-----">PUBLIC KEY</option>
			<option value="-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----">RSA</option>
			<option value="-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEA+xGZ/wcz9ugFpP07Nspo6U17l0YhFiFpxxU4pTk3Lifz9R3zsIsu
ERwta7+fWIfxOo208ett/jhskiVodSEt3QBGh4XBipyWopKwZ93HHaDVZAALi/2A
+xTBtWdEo7XGUujKDvC2/aZKukfjpOiUI8AhLAfjmlcD/UZ1QPh0mHsglRNCmpCw
mwSXA9VNmhz+PiB+Dml4WWnKW/VHo2ujTXxq7+efMU4H2fny3Se3KYOsFPFGZ1TN
QSYlFuShWrHPtiLmUdPoP6CV2mML1tk+l7DIIqXrQhLUKDACeM5roMx0kLhUWB8P
+0uj1CNlNN4JRZlC7xFfqiMbFRU9Z4N6YwIDAQAB
-----END RSA PUBLIC KEY-----">RSA PUBLIC KEY</option>
			<option value="-----BEGIN DSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,7CB02793DCE4E8D4

+iddBMW+2IrJpOj8u41UH2x739D/aryspRX9Ucfjhc1EfMRF4An3T9NgyIKnzsbq
siEIykm6ZlkBjxyLw5JHd/JodZlHdlogD0SseK3GsJPxg9MT9Dpu2FCY+1LShn8D
1xtP2Jh6cJ95VXGW2NVvYtxzY3gY7/rj+MZXe+7vt77ktky9RV2ODF06GXnX9NqL
lqRY/TTejveVa/WZHvy8hlWyv4ALoaYPpVCko2Dop9IlefPujYqpu8fEa5iPh5ch
BV5axY09eB//RYng1Kh9+tYuR/mAOb45ckYQJBxP4LofHYFSAfD9P+hk7XzSBfcU
8bdAKK0mg8SaVUO3nmuQ+sXdql0t+ubyQ6zkLfs5E6TCLv8JUe2L/Meakpnx5Dqq
rlr/k9WTGaSHCKbFT/F9lbsG5Gr5qWyHHp0CqQ0YdEaBp5WZHyhxQYASIgavxCwq
0fVT5t/AEWt+0caFnsCVXkcLS8P0kjOJ1nMDlU0LqtZiwKR59IZ/4ZDWKKcC9+Vo
qhHixao6g0PBhbZugEsGP02K3Cq77D/zxyqmCnIVgHUdj33FeVmb5b6H7YFsyzKY
sBJE8S3Nfb/tBIFU+qLVoXAfXvgqJVijC4zuCzMwqAPt5RsQitrLBtMJwAaD2okW
3zfd7ppTGORiXZi/EVtCCa8Ifh27y2sQlLtS12Ojy8pOE7UfYFzqx52tZk5FNm8r
v1k8r5B6u937hH/8w3NWScfbRhtdLEaTAGIMgTLpoE5LcEejMLFkKlbKftN1BKW/
8TZq3WAZuiVeh0EcVna9E8QM9qK8TtrayecdfDpblXIwc1MH4oRGRharX2uF6tcZ
UG6H/BArIM8sgsfvhGwq3rWBtP+Q9aiMZv+dtGVbIguf9GQSq0jZ2RTqMGSw/xzI
Aho4r0T0XavC08k3ENL8Qyb0twzUq2mUIEJgO3u27A2Ksyg6VqujiPsLfl1ccs1Z
d/NshTgg0KC6oDsncYhxDgKMEL6vcgv58i4532Wclkbv/NwDWhs8Vb8ZfYc4JVYU
srRpiOaYRy4e7TD1wUIucxHoXWT1Fxie2kZVz/DFNxRqQVyVSkE4XOV6vrNov1zj
UU2iTN4uCR0zmUj0xuuRXGaPv2TJ9fxa
-----END DSA PRIVATE KEY-----">DSA</option>
						</select>
						<small class="form-text text-muted"><i class="fas fa-info-circle"></i> Select a sample file to load into the textarea below</small>
					</div>

	<div class="form-group">
						<label for="pem"><strong>PEM Format Input</strong></label>
						<textarea class="form-control" rows="8" name="pem" id="pem" placeholder="Paste your PEM certificate, key, or CSR here...">-----BEGIN CERTIFICATE-----
MIIFtTCCA52gAwIBAgIJAO0cq2lJPZZJMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTQwMzEyMTc0NzU5WhcNMTkwMzEyMTc0NzU5WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
CgKCAgEAsgzs6vN2sveHVraXV0zdoVyhWUHWNQ0xnhHTPhjt5ggHmSvrUxvUpXfK
WCP9gZo59Q7dx0ydjqBsdooXComVP4kGDjulvOHWgvcVmwTsL0bAMqmsCyyJKM6J
Wqi8E+CPTOpMBWdapUxvwaSmop8geiTtnX0aV4zGXwsz2mwdogbounQjMB/Ew7vv
8XtqwXSpnR7kM5HPfM7wb9F8MjlRuna6Nt2V7i0oUr+EEt6fIYEVZFiHTSUzDLaz
2eClJeCNdvyqaeGCCqs+LunMq3kZjO9ahtS2+1qZxfBzac/0KXRYnLa0kGQHZbw0
ecgdZC9YpqqMeTeSnJPPX4/TQt54qVLQXM3+h8xvwt3lItcJPZR0v+0yQe5QEwPL
4c5UF81jfGrYfEzmGth6KRImRMdFLF9+F7ozAgGqCLQt3eV2YMXIBYfZS9L/lO/Q
3m4MGARZXUE3jlkcfFlcbnA0uwMBSjdNUsw4zHjVwk6aG5CwYFYVHG9n5v4qCxKV
ENRinzgGRnwkNyADecvbcQ30/UOuhU5YBnfFSYrrhq/fyCbpneuxk2EouL3pk/GA
7mGzqhjPYzaaNGVZ8n+Yys0kxuP9XDOUEDkjXpa/SzeZEk9FXMlLc7Wydj/7ES4r
6SYCs4KMr+p7CjFg/a7IdepLQ3txrZecrBxoG5mBDYgCJCfLBu0CAwEAAaOBpzCB
pDAdBgNVHQ4EFgQUWQI/JOoU+RrUPUED63dMfd2JMFkwdQYDVR0jBG4wbIAUWQI/
JOoU+RrUPUED63dMfd2JMFmhSaRHMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpT
b21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGSCCQDt
HKtpST2WSTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4ICAQBwGbAmiLHE
jubdLeMygwrV8VjlOVxV41wvRi6y1B5Bdvh71HPoOZdvuiZOogzxB22Tzon6Uv5q
8uuAy37rHLlQTOqLwdLJOu/ijMirAkh13gQWt4oZGUDikyiI4PMNo/hr6XoZWUfU
fwmcAzoEMln8HyISluTau1mtQIDgvGprU472GqC4AC7bYeED+ChCevc7Ytjl4zte
/tw8u3nqrkESYBIA2yEgyFAr1pRwJPM/T1U6Ehalp1ZTeQcAXEa7IC6ht2NlN1FC
fk2KQmrk4Z3jaSVv8GxshA354W+UEpti0o6Fv+2ozkAaQ1/xjiNwBTHtgJ1/AG1j
bDYcCFfmYmND0RFjvVu7ma+UNdKQ+t1o7ip4tHQUTEFvdqoaCLN09PcTVgvm71Lr
s8IOldiMgiCjQK3e0jwXx78tXs/msMzVI+9AR9aNzo0Y42C97ctlGu3+v07Zp+x4
6w1rg3eklJM02davNWK2EUSetn9EWsIJXU34Bj7mnI/2DFo292GVNw1kT5Bf4IvA
T74gsJLB6wacN4Ue6zPtIvrK93DABAfRUmrAWmH8+7MJolSC/rabJF3E2CeBTYqZ
R5M5azDV1CIhIeOTiPA/mq5fL1UrgVbB+IATIsUAQfuWivDyoeu96LB/QswyHAWG
8k2fPbA2QVWJpcnryesCy3qtzwbHSYbshQ==
-----END CERTIFICATE-----
			</textarea>
						<small class="form-text text-muted"><i class="fas fa-info-circle"></i> Paste your PEM certificate, private key, public key, CSR, CRL, or PKCS7 format</small>
	</div>

	<div class="form-group">
						<label for="certpassword"><strong>Certificate Password</strong> <span class="badge badge-secondary">Optional</span></label>
						<input type="password" class="form-control" value="" id="certpassword" name="certpassword" placeholder="Enter password if key is encrypted">
						<small class="form-text text-muted"><i class="fas fa-lock"></i> Required only for encrypted private keys (DES-EDE3-CBC)</small>
	</div>

					<div class="form-group mb-0">
						<button type="submit" class="btn btn-primary btn-block btn-lg" id="submit" name="convert">
							<i class="fas fa-search"></i> Parse & Decode PEM
						</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Right Column: Output -->
		<div class="col-lg-6 col-md-12 mb-4">
			<div class="card">
				<div class="card-header bg-success text-white">
					<h5 class="mb-0"><i class="fas fa-terminal"></i> Parsed Results</h5>
				</div>
				<div class="card-body">
	<div id="output1"></div>
					<div id="output">
						<div class="text-center text-muted py-5">
							<i class="fas fa-file-code fa-4x mb-3 opacity-25"></i>
							<p class="lead">Parsed certificate details will appear here</p>
							<p class="small">Paste your PEM format and click "Parse & Decode PEM"</p>
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

<!-- Supported PEM Formats -->
<div class="card mb-4 mt-5">
	<div class="card-header bg-info text-white">
		<h3 class="h5 mb-0"><i class="fas fa-list"></i> Supported PEM Formats</h3>
	</div>
	<div class="card-body">
		<div class="row">
			<div class="col-md-6">
				<h5 class="h6"><i class="fas fa-certificate text-primary"></i> Certificates & Requests</h5>
				<ul class="list-unstyled">
					<li class="mb-2">
						<code>-----BEGIN CERTIFICATE-----</code><br>
						<small class="text-muted">X.509 Certificate (CRT)</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN CERTIFICATE REQUEST-----</code><br>
						<small class="text-muted">Certificate Signing Request (CSR)</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN NEW CERTIFICATE REQUEST-----</code><br>
						<small class="text-muted">New Format CSR</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN X509 CRL-----</code><br>
						<small class="text-muted">Certificate Revocation List</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN PKCS7-----</code><br>
						<small class="text-muted">PKCS#7 format</small>
					</li>
				</ul>
			</div>
			<div class="col-md-6">
				<h5 class="h6"><i class="fas fa-key text-danger"></i> Keys</h5>
				<ul class="list-unstyled">
					<li class="mb-2">
						<code>-----BEGIN RSA PRIVATE KEY-----</code><br>
						<small class="text-muted">PKCS#1 RSA Private Key (supports encrypted)</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN RSA PUBLIC KEY-----</code><br>
						<small class="text-muted">PKCS#1 RSA Public Key</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN PRIVATE KEY-----</code><br>
						<small class="text-muted">PKCS#8 Private Key</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN PUBLIC KEY-----</code><br>
						<small class="text-muted">X.509 SubjectPublicKeyInfo</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN DSA PRIVATE KEY-----</code><br>
						<small class="text-muted">DSA Private Key (supports encrypted)</small>
					</li>
					<li class="mb-2">
						<code>-----BEGIN EC PRIVATE KEY-----</code><br>
						<small class="text-muted">Elliptic Curve Private Key</small>
					</li>
				</ul>
			</div>
		</div>
		<div class="alert alert-warning mt-3 mb-0">
			<strong><i class="fas fa-exclamation-triangle"></i> Note:</strong> Encrypted private keys (with <code>Proc-Type: 4,ENCRYPTED</code> and <code>DEK-Info</code>) 
			require a password. The tool supports DES-EDE3-CBC encryption. Enter the password in the "Certificate Password" field above.
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
					This PEM parser is developed and maintained by <strong>Anish Nath</strong>
					(<a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer"><i class="fab fa-x-twitter text-dark"></i> @anish2good</a>),
					a Security Engineer and Cryptography Expert with extensive experience in network security and cryptographic implementations.
					The tool has been serving the developer and DevOps community since 2017, with over <strong>892 verified reviews</strong>
					averaging <strong>4.8/5 stars</strong>.
				</p>

				<h4 class="h6 mt-3"><i class="fas fa-shield-alt text-success"></i> Security & Privacy Commitment</h4>
				<ul class="mb-3">
					<li><strong>No Data Collection:</strong> Your certificates and keys are processed securely and are not stored on our servers. Nothing is logged or retained.</li>
					<li><strong>Industry Standards:</strong> Uses proven cryptographic libraries implementing X.509, PKCS standards, and OpenSSL compatibility.</li>
					<li><strong>Regular Updates:</strong> Tool is actively maintained with security best practices and format support updated regularly.</li>
					<li><strong>Open Source Standards:</strong> Compatible with OpenSSL, Java KeyStore, and all major cryptographic implementations.</li>
</ul>

				<h4 class="h6 mt-3"><i class="fas fa-clock text-info"></i> Version History</h4>
				<ul class="list-unstyled small text-muted">
					<li><strong>v2.0 (Jan 2025):</strong> Enhanced UX, improved parsing, added EEAT signals</li>
					<li><strong>v1.5 (2020):</strong> Added PKCS7 and additional format support</li>
					<li><strong>v1.0 (2017):</strong> Initial release with basic PEM parsing</li>
				</ul>
			</div>

			<div class="col-md-4">
				<div class="card bg-light">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-book-open text-primary"></i> Official Resources</h5>
						<p class="small mb-3">
							Learn more about PEM formats and certificates:
						</p>
						<ul class="list-unstyled small mb-3">
							<li class="mb-2">
								<a href="https://www.openssl.org/" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-external-link-alt text-primary"></i> OpenSSL Documentation
								</a>
							</li>
							<li class="mb-2">
								<a href="https://datatracker.ietf.org/doc/html/rfc5280" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-file-alt text-primary"></i> RFC 5280 (X.509)
								</a>
							</li>
							<li class="mb-2">
								<a href="https://datatracker.ietf.org/doc/html/rfc2986" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-file-code text-primary"></i> RFC 2986 (PKCS#10 CSR)
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
							<li><i class="fas fa-check-circle text-success"></i> 8+ years of service</li>
							<li><i class="fas fa-check-circle text-success"></i> 892 verified reviews</li>
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

<%@ include file="footer_adsense.jsp"%>

<%@ include file="addcomments.jsp"%>

</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header bg-warning">
				<h5 class="modal-title" id="shareUrlModalLabel">
					<i class="fas fa-exclamation-triangle"></i> Share URL - Security Notice
				</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
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
					<i class="fas fa-lightbulb"></i> <strong>Tip:</strong> Use a URL shortener service if the link is too long for your needs.
				</small>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<%@ include file="body-close.jsp"%>
