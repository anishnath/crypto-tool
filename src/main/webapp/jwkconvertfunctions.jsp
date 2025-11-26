<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<!DOCTYPE html>
<html>
<head>

	<!-- JSON-LD markup with EEAT signals -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "JWK to PEM Converter - Online JSON Web Key Converter",
  "alternateName" : "PEM to JWK Converter, JWK PEM Format Converter",
  "description" : "Professional online tool to convert JSON Web Keys (JWK) to PEM format and PEM to JWK. Supports RSA and Elliptic Curve (EC) keys. Free, secure, and privacy-first conversion tool.",
  "image" : "https://8gwifi.org/images/site/jwkconvert.png",
  "url" : "https://8gwifi.org/jwkconvertfunctions.jsp",
  "applicationCategory" : "SecurityApplication",
  "applicationSubCategory" : "Cryptography Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem" : "Any (Web-based)",
  "softwareVersion" : "2.0",
  "datePublished" : "2018-09-28",
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
    "description": "Free online JWK converter with no registration required"
  },
  "featureList" : [
    "JWK to PEM conversion (RSA and EC supported)",
    "PEM to JWK conversion (RSA only)",
    "Support for RSA keys (2048, 4096-bit)",
    "Support for Elliptic Curve keys (P-256, P-384, P-521)",
    "One-click copy to clipboard",
    "No registration required",
    "Client-side processing for security",
    "Privacy-first approach"
  ],
  "keywords" : "jwk to pem, pem to jwk, json web key converter, jwk format converter, pem format converter, jwk openssl, jwk rsa, jwk ec, elliptic curve jwk, rsa jwk, jwk pem online, convert jwk to pem, convert pem to jwk, jwk key format, pem key format, jwk json, jwk converter tool",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.6",
    "ratingCount": "756",
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
      "name": "Developer Community"
    },
    "reviewBody": "Essential tool for converting between JWK and PEM formats. Works perfectly with RSA and EC keys."
  },
  "potentialAction": {
    "@type": "UseAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://8gwifi.org/jwkconvertfunctions.jsp",
      "actionPlatform": [
        "http://schema.org/DesktopWebPlatform",
        "http://schema.org/MobileWebPlatform"
      ]
    },
    "name": "Convert JWK to PEM Online"
  },
  "audience": {
    "@type": "ProfessionalAudience",
    "audienceType": "Developers, System Administrators, DevOps Engineers, Security Professionals"
  },
  "isAccessibleForFree": true,
  "inLanguage": "en-US"
}
</script>

	<!-- FAQPage JSON-LD for rich snippets -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is a JSON Web Key (JWK)?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "A JSON Web Key (JWK) is a JSON object that represents a cryptographic key. It's defined in RFC 7517 and is commonly used in JWT (JSON Web Tokens), OAuth 2.0, and other security protocols. JWK format makes it easy to exchange cryptographic keys in JSON format."
      }
    },
    {
      "@type": "Question",
      "name": "Can I convert EC (Elliptic Curve) keys from JWK to PEM?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, this tool supports converting Elliptic Curve (EC) keys from JWK to PEM format. Supported curves include P-256 (secp256r1), P-384 (secp384r1), and P-521 (secp521r1). However, PEM to JWK conversion currently supports RSA keys only."
      }
    },
    {
      "@type": "Question",
      "name": "What key types are supported for JWK to PEM conversion?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool supports RSA and Elliptic Curve (EC) keys for JWK to PEM conversion. RSA keys can be 2048-bit or 4096-bit. EC keys support P-256, P-384, and P-521 curves. For PEM to JWK conversion, only RSA keys are currently supported."
      }
    },
    {
      "@type": "Question",
      "name": "Is my key data stored or transmitted to servers?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No, your key data is processed securely and is not stored on our servers. The conversion happens through secure API calls, and we follow privacy-first principles. Your keys are never logged or retained."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between JWK and PEM formats?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "JWK (JSON Web Key) is a JSON-based format defined in RFC 7517, commonly used in modern web applications and APIs. PEM (Privacy-Enhanced Mail) is a base64-encoded format with header/footer lines (-----BEGIN/END-----), widely used in OpenSSL and traditional cryptographic tools. JWK is more structured and easier to parse programmatically, while PEM is more human-readable and widely supported."
      }
    }
  ]
}
</script>

	<title>JWK to PEM Converter Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Convert JWK to PEM and PEM to JWK online. Free tool supports RSA and EC keys. Instant conversion, privacy-first, no registration required.">
	<meta name="keywords" content="jwk to pem, pem to jwk, json web key converter, jwk format converter, pem format converter, jwk openssl, jwk rsa, jwk ec, elliptic curve jwk, rsa jwk, jwk pem online, convert jwk to pem, convert pem to jwk">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="index,follow">
	<meta name="author" content="Anish Nath">
	
	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/jwkconvertfunctions.jsp">
	<meta property="og:title" content="JWK to PEM Converter Online – Free | 8gwifi.org">
	<meta property="og:description" content="Convert JWK to PEM and PEM to JWK online. Free tool supports RSA and EC keys. Instant conversion, privacy-first.">
	<meta property="og:image" content="https://8gwifi.org/images/site/jwkconvert.png">
	
	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/jwkconvertfunctions.jsp">
	<meta name="twitter:title" content="JWK to PEM Converter Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Convert JWK to PEM and PEM to JWK online. Free tool supports RSA and EC keys. Instant conversion, privacy-first.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/jwkconvert.png">
	
	<!-- Canonical URL -->
	<link rel="canonical" href="https://8gwifi.org/jwkconvertfunctions.jsp">
	
	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {

			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#form').submit(function(event) {
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "JWKFunctionality",
					data : $("#form").serialize(),
					dataType: 'json',
					success : function(response) {
						console.log('Received JSON response:', response);
						$('#output').empty();

						if(response.success) {
							// Success - display converted keys
							var operation = response.operation || 'convert';
							var algorithm = response.algorithm || '';
							var publicKey = response.message || '';
							var privateKey = response.base64Encoded || '';
							var jwkOutput = response.message || '';

							var html = '<div class="alert alert-success">';
							html += '<h5><i class="fas fa-check-circle"></i> Conversion Successful</h5>';
							html += '<p><strong>Operation:</strong> ' + algorithm + '</p>';
							html += '</div>';

							// Store values for button handlers
							window.currentConversion = {
								algorithm: algorithm,
								publicKey: publicKey,
								privateKey: privateKey,
								jwkOutput: jwkOutput
							};

							if(algorithm === 'JWK-to-PEM') {
								// Display PEM keys
								if(privateKey) {
									html += '<div class="form-group">';
									html += '<label><strong><i class="fas fa-key text-danger"></i> Private Key (PEM)</strong> <span class="badge badge-danger">Keep Secret</span></label>';
									html += '<textarea id="privateKeyOutput" readonly class="form-control" rows="12" style="font-family: monospace; font-size: 12px;"></textarea>';
									html += '<div class="mt-2">';
									html += '<button type="button" class="btn btn-sm btn-success copy-private-key"><i class="fas fa-copy"></i> Copy Private Key</button>';
									html += '<button type="button" class="btn btn-sm btn-info ml-2 use-as-pem-to-jwk" data-key-type="private"><i class="fas fa-exchange-alt"></i> Use this as PEM to JWK</button>';
									html += '</div>';
									html += '</div>';
								}

								if(publicKey) {
									html += '<div class="form-group">';
									html += '<label><strong><i class="fas fa-lock-open text-success"></i> Public Key (PEM)</strong> <span class="badge badge-success">Share This</span></label>';
									html += '<textarea id="publicKeyOutput" readonly class="form-control" rows="6" style="font-family: monospace; font-size: 12px;"></textarea>';
									html += '<div class="mt-2">';
									html += '<button type="button" class="btn btn-sm btn-primary copy-public-key"><i class="fas fa-copy"></i> Copy Public Key</button>';
									html += '<button type="button" class="btn btn-sm btn-info ml-2 use-as-pem-to-jwk" data-key-type="public"><i class="fas fa-exchange-alt"></i> Use this as PEM to JWK</button>';
									html += '<button type="button" class="btn btn-sm btn-outline-info ml-2 share-url-btn" data-key-type="public"><i class="fas fa-share-alt"></i> Share URL</button>';
									html += '</div>';
									html += '</div>';
								}
							} else if(algorithm === 'PEM-to-JWK') {
								// Format JSON nicely
								var formattedJWK = '';
								try {
									var jwkObj = JSON.parse(jwkOutput);
									formattedJWK = JSON.stringify(jwkObj, null, 2);
								} catch(e) {
									formattedJWK = jwkOutput;
								}

								// Display JWK with formatted JSON
								html += '<div class="form-group">';
								html += '<label><strong><i class="fas fa-code text-info"></i> JSON Web Key (JWK)</strong></label>';
								html += '<textarea id="jwkOutput" readonly class="form-control" rows="15" style="font-family: monospace; font-size: 12px;"></textarea>';
								html += '<div class="mt-2">';
								html += '<button type="button" class="btn btn-sm btn-primary copy-jwk"><i class="fas fa-copy"></i> Copy JWK</button>';
								html += '<button type="button" class="btn btn-sm btn-info ml-2 use-as-jwk-to-pem"><i class="fas fa-exchange-alt"></i> Use this as JWK to PEM</button>';
								html += '<button type="button" class="btn btn-sm btn-outline-info ml-2 share-url-btn" data-key-type="jwk"><i class="fas fa-share-alt"></i> Share URL</button>';
								html += '</div>';
								html += '</div>';
							} else {
								// Calculate JWK - display as-is
								var formattedJWK = '';
								try {
									var jwkObj = JSON.parse(jwkOutput);
									formattedJWK = JSON.stringify(jwkObj, null, 2);
								} catch(e) {
									formattedJWK = jwkOutput;
								}

								html += '<div class="form-group">';
								html += '<label><strong><i class="fas fa-code text-info"></i> Generated JWK</strong></label>';
								html += '<textarea id="jwkOutput" readonly class="form-control" rows="15" style="font-family: monospace; font-size: 12px;"></textarea>';
								html += '<button type="button" class="btn btn-sm btn-primary mt-2 copy-jwk"><i class="fas fa-copy"></i> Copy JWK</button>';
								html += '</div>';
							}

							$('#output').html(html);

							// Set textarea values after HTML is inserted
							if($('#privateKeyOutput').length) {
								$('#privateKeyOutput').val(privateKey);
							}
							if($('#publicKeyOutput').length) {
								$('#publicKeyOutput').val(publicKey);
							}
							if($('#jwkOutput').length) {
								// Use formatted JSON if available
								var formattedValue = '';
								try {
									var jwkObj = JSON.parse(jwkOutput);
									formattedValue = JSON.stringify(jwkObj, null, 2);
								} catch(e) {
									formattedValue = jwkOutput;
								}
								$('#jwkOutput').val(formattedValue);
							}

							// Attach copy handlers using event delegation
							$('.copy-private-key').off('click').on('click', function() {
								var text = $('#privateKeyOutput').val();
								copyToClipboard(text, this);
							});

							$('.copy-public-key').off('click').on('click', function() {
								var text = $('#publicKeyOutput').val();
								copyToClipboard(text, this);
							});

							$('.copy-jwk').off('click').on('click', function() {
								var text = $('#jwkOutput').val();
								copyToClipboard(text, this);
							});

							// Use as PEM to JWK button handler
							$('.use-as-pem-to-jwk').off('click').on('click', function() {
								var keyType = $(this).data('key-type') || 'public';
								var pemKey = '';
								if (keyType === 'private' && window.currentConversion.privateKey) {
									pemKey = window.currentConversion.privateKey;
								} else if (keyType === 'public' && window.currentConversion.publicKey) {
									pemKey = window.currentConversion.publicKey;
								}
								$('#input').val(pemKey);
								$('#PEM-to-JWK').prop('checked', true);
								$('#JWK-to-PEM').prop('checked', false);
								// Trigger conversion
								$('#form').submit();
							});

							// Use as JWK to PEM button handler
							$('.use-as-jwk-to-pem').off('click').on('click', function() {
								var jwkKey = window.currentConversion.jwkOutput || '';
								$('#input').val(jwkKey);
								$('#JWK-to-PEM').prop('checked', true);
								$('#PEM-to-JWK').prop('checked', false);
								// Trigger conversion
								$('#form').submit();
							});

							// Share URL button handler
							$('.share-url-btn').off('click').on('click', function() {
								var keyType = $(this).data('key-type') || 'public';
								var pubKey = '';
								var privKey = '';
								var jwk = '';
								var algo = window.currentConversion.algorithm || '';

								if (keyType === 'jwk') {
									jwk = window.currentConversion.jwkOutput || '';
								} else {
									pubKey = window.currentConversion.publicKey || '';
									privKey = window.currentConversion.privateKey || '';
								}

								// Create URL parameters
								const params = new URLSearchParams({
									op: algo,
									algo: algo
								});

								// Add keys based on what's available
								let includesPrivateKey = false;
								if (pubKey && pubKey.trim()) {
									params.append('pubkey', pubKey);
								}
								if (privKey && privKey.trim()) {
									params.append('privkey', privKey);
									includesPrivateKey = true;
								}
								if (jwk && jwk.trim()) {
									params.append('jwk', jwk);
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
											<strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
											<ul class="mb-0 mt-2">
												<li><strong>Private Key:</strong> Included - <span class="text-danger">KEEP SECRET</span></li>
												<li><strong>Public Key:</strong> ${pubKey && pubKey.trim() ? 'Included - Safe to share' : 'Not included'}</li>
												<li><strong>JWK:</strong> ${jwk && jwk.trim() ? 'Included' : 'Not included'}</li>
												<li><strong>Operation:</strong> ${algo}</li>
											</ul>
										</div>
									`);
								} else {
									$('#shareWarningContent').html(`
										<div class="alert alert-warning mb-3">
											<strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
											<ul class="mb-0 mt-2">
												<li><strong>Public Key:</strong> ${pubKey && pubKey.trim() ? 'Included - Safe to share' : 'Not included'}</li>
												<li><strong>JWK:</strong> ${jwk && jwk.trim() ? 'Included' : 'Not included'}</li>
												<li><strong>Operation:</strong> ${algo}</li>
												<li><strong>NOT Included:</strong> Your private key (kept secure)</li>
											</ul>
										</div>
										<div class="alert alert-info mb-3">
											<strong><i class="fas fa-info-circle"></i> Security Reminder:</strong>
											<p class="mb-0">This URL contains your public key or JWK and conversion information.</p>
											<ul class="mb-0 mt-2">
												<li>The URL will be very long (keys are 1000+ characters)</li>
												<li>Anyone with this URL can see your public key or JWK</li>
												<li>Your private key remains secure</li>
											</ul>
										</div>
									`);
								}

								// Set URL in modal and show it
								$('#shareUrlText').val(shareUrl);
								$('#shareUrlModal').modal('show');
							});
						} else {
							// Error
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

						var errorMessage = 'An error occurred during conversion.';
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
						fallbackCopy(shareUrl, $button, originalHTML);
					});
				} else {
					// Fallback for older browsers
					fallbackCopy(shareUrl, $button, originalHTML);
				}
			});

			function fallbackCopy(text, $button, originalHTML) {
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
						// Show URL in prompt as last resort
						prompt('Copy this URL:', text);
					}
				} catch (err) {
					console.error('Fallback copy failed:', err);
					// Show URL in prompt as last resort
					prompt('Copy this URL:', text);
				} finally {
					document.body.removeChild(textarea);
				}
			}

			// Handle URL parameters for Share URL feature
			const urlParams = new URLSearchParams(window.location.search);
			if (urlParams.has('jwk') || urlParams.has('pubkey') || urlParams.has('privkey')) {
				// Set operation based on URL parameter
				const op = urlParams.get('op');
				if (op === 'PEM-to-JWK') {
					$('#PEM-to-JWK').prop('checked', true);
					$('#JWK-to-PEM').prop('checked', false);
				} else if (op === 'JWK-to-PEM') {
					$('#JWK-to-PEM').prop('checked', true);
					$('#PEM-to-JWK').prop('checked', false);
				}

				// Set JWK if provided
				if (urlParams.has('jwk')) {
					var jwk = urlParams.get('jwk');
					$('#input').val(jwk);
					$('#input').addClass('border-primary').focus();
					setTimeout(() => {
						$('#input').removeClass('border-primary');
					}, 3000);
				}

				// Set public key if provided
				if (urlParams.has('pubkey')) {
					var pubKey = urlParams.get('pubkey');
					$('#input').val(pubKey);
					$('#input').addClass('border-success');
					setTimeout(() => {
						$('#input').removeClass('border-success');
					}, 3000);
				}

				// Set private key if provided (with warning)
				if (urlParams.has('privkey')) {
					var privKey = urlParams.get('privkey');
					$('#input').val(privKey);
					$('#input').addClass('border-danger');
					setTimeout(() => {
						$('#input').removeClass('border-danger');
					}, 5000);

					// Show security warning alert
					const warningAlert = `
						<div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
							<strong><i class="fas fa-exclamation-triangle"></i> Security Notice:</strong>
							A private key was loaded from the URL. This is sensitive information!
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
					`;
					$('.container-fluid').first().prepend(warningAlert);

					// Auto-dismiss after 10 seconds
					setTimeout(() => {
						$('.alert-danger.alert-dismissible').fadeOut();
					}, 10000);
				}
			}

		});

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

		function copyToClipboard(text, button) {
			navigator.clipboard.writeText(text).then(() => {
				const originalHTML = button.innerHTML;
				const originalClasses = button.className;

				// Update button to show success
				button.innerHTML = '<i class="fas fa-check-circle"></i> Copied!';
				button.className = 'btn btn-sm btn-success mt-2';
				button.disabled = true;

				setTimeout(() => {
					button.innerHTML = originalHTML;
					button.className = originalClasses;
					button.disabled = false;
				}, 2000);
			}).catch(err => {
				console.error('Failed to copy:', err);
				// Fallback: Select the text for manual copy
				const originalHTML = button.innerHTML;
				button.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Copy Failed - Select text manually';
				button.className = 'btn btn-sm btn-warning mt-2';

				setTimeout(() => {
					button.innerHTML = originalHTML;
					button.className = originalClasses;
				}, 3000);
			});
		}
	</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<%@ include file="footer_adsense.jsp"%>
<h1 class="mt-4">JWK to PEM Converter Online</h1>

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
		<i class="fas fa-star text-warning"></i> 4.6/5 (756 reviews)
	</div>
	<div class="badge-group">
		<span class="badge badge-success"><i class="fas fa-shield-alt"></i> Privacy-First</span>
		<span class="badge badge-info"><i class="fas fa-lock"></i> No Data Stored</span>
		<span class="badge badge-primary"><i class="fas fa-free-code-camp"></i> 100% Free</span>
	</div>
</div>

<hr>

<div class="alert alert-info" role="alert">
	<strong><i class="fas fa-info-circle"></i> Expert Tip:</strong> This tool supports converting <strong>RSA and Elliptic Curve (EC)</strong> keys from JWK to PEM format. For PEM to JWK conversion, currently only <strong>RSA keys</strong> are supported. JWK format is commonly used in JWT, OAuth 2.0, and modern web security protocols.
</div>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<form id="form" class="form-horizontal" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CONVERT_JWK">

	<div class="row">
		<!-- Left Column: Configuration -->
		<div class="col-lg-5 col-md-6 mb-4">
			<div class="card">
				<div class="card-header bg-primary text-white">
					<h5 class="mb-0"><i class="fas fa-cog"></i> Conversion Configuration</h5>
				</div>
				<div class="card-body">
					<p><strong>Convert between JWK and PEM formats</strong></p>

					<div class="form-check mb-3">
						<input class="form-check-input" checked="checked" type="radio" name="param" id="JWK-to-PEM" value="JWK-to-PEM">
						<label class="form-check-label" for="JWK-to-PEM">
							<strong>JWK to PEM</strong> <span class="badge badge-success">RSA & EC Supported</span>
						</label>
						<small class="form-text text-muted d-block ml-4">Convert JSON Web Key to PEM format (RSA and Elliptic Curve keys supported)</small>
					</div>

					<div class="form-check mb-3">
						<input class="form-check-input" type="radio" name="param" id="PEM-to-JWK" value="PEM-to-JWK">
						<label class="form-check-label" for="PEM-to-JWK">
							<strong>PEM to JWK</strong> <span class="badge badge-info">RSA Only</span>
						</label>
						<small class="form-text text-muted d-block ml-4">Convert PEM format to JSON Web Key (RSA keys only)</small>
					</div>

					<hr>

					<div class="form-group">
						<label for="input"><strong>Input</strong></label>
						<textarea class="form-control" id="input" name="input" rows="12" placeholder="Paste your JWK or PEM key here...">{
"kty": "RSA",
"n": "33TqqLR3eeUmDtHS89qF3p4MP7Wfqt2Zjj3lZjLjjCGDvwr9cJNlNDiuKboODgUiT4ZdPWbOiMAfDcDzlOxA04DDnEFGAf-kDQiNSe2ZtqC7bnIc8-KSG_qOGQIVaay4Ucr6ovDkykO5Hxn7OU7sJp9TP9H0JH8zMQA6YzijYH9LsupTerrY3U6zyihVEDXXOv08vBHk50BMFJbE9iwFwnxCsU5-UZUZYw87Uu0n4LPFS9BT8tUIvAfnRXIEWCha3KbFWmdZQZlyrFw0buUEf0YN3_Q0auBkdbDR_ES2PbgKTJdkjc_rEeM0TxvOUf7HuUNOhrtAVEN1D5uuxE1WSw",
"e": "AQAB",
"d": "DjU54mYvHpICXHjc5-JiFqiH8NkUgOG8LL4kwt3DeBp9bP0-5hSJH8vmzwJkeGG9L79EWG4b_bfxgYdeNX7cFFagmWPRFrlxbd64VRYFawZHRJt-2cbzMVI6DL8EK4bu5Ux5qTiV44Jw19hoD9nDzCTfPzSTSGrKD3iLPdnREYaIGDVxcjBv3Tx6rrv3Z2lhHHKhEHb0RRjATcjAVKV9NZhMajJ4l9pqJ3A4IQrCBl95ux6Xm1oXP0i6aR78cjchsCpcMXdP3WMsvHgTlsZT0RZLFHrvkiNHlPiil4G2_eHkwvT__CrcbO6SmI_zCtMmypuHJqcr-Xb7GPJoa64WoQ",
"p": "8K33pX90XX6PZGiv26wZm7tfvqlqWFT03nUMvOAytqdxhO2HysiPn4W58OaJd1tY4372Qpiv6enmUeI4MidCie-s-d0_B6A0xfhU5EeeaDN0xDOOl8yN-kaaVj9b4HDR3c91OAwKpDJQIeJVZtxoijxl-SRx3u7Vs_7meeSpOfE",
"q": "7a5KnUs1pTo72A-JquJvIz4Eu794Yh3ftTk_Et-83aE_FVc6Nk-EhfnwYSNpVmM6UKdrAoy5gsCvZPxrq-eR9pEwU8M5UOlki03vWY_nqDBpJSIqwPvGHUB16zvggsPQUyQBfnN3N8XlDi12n88ltvWwEhn1LQOwMUALEfka9_s",
"dp": "DB9nGuHplY_7Xv5a5UCs5YgxkWPtJFfbIZ1Zr-XHCCY09JIWReOGQG226OhjwixKtOK_OqmAKtMKM9OmKviJRHNbDhbTxumN3u7cL8dftjXpSryiEQlPmWyW94MneI2WNIrvh4wruQuDt8EztgOiDFxwcnUgey8iend7WmZnE7E",
"dq": "O-bSTUQ4N_UuQezgkF3TDrnBraO67leDGwRbfiE_U0ghQvqh5DA0QSPVzlWDZc9KUitvj8vxsR9o1PW9GS0an17GJEYuetLnkShKK3NWOhBBX6d1yP9rVdH6JhgIJEy_g0Suz7TAFiFc8i7JF8u4QJ05C8bZAMhOLotqftQeVOM",
"qi": "InfGmkb2jNkPGuNiZ-mU0-ZrOgLza_fLL9ErZ35jUPhGFzdGxJNobklvsNoTd-E2GAU41YkJh24bncMLvJVYxHHA5iF7FBWx1SvpEyKVhhnIcuXGD7N5PbNZzEdmr9C6I7cPVkWO-sUV7zfFukexIcANmsd_oBBGKRoYzP5Tti4"
}</textarea>
						<small class="form-text text-muted"><i class="fas fa-info-circle"></i> Paste your JWK (JSON format) or PEM key here</small>
					</div>

					<hr>

					<div class="form-group mb-0">
						<button type="button" class="btn btn-primary btn-block btn-lg" id="submit" name="Generate JSON Web Keys">
							<i class="fas fa-exchange-alt"></i> Convert
						</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Right Column: Output -->
		<div class="col-lg-7 col-md-6">
			<div class="card">
				<div class="card-header bg-success text-white">
					<h5 class="mb-0"><i class="fas fa-terminal"></i> Conversion Result</h5>
				</div>
				<div class="card-body">
					<div id="output">
						<div class="text-center text-muted py-5">
							<i class="fas fa-exchange-alt fa-4x mb-3 opacity-25"></i>
							<p class="lead">Your converted keys will appear here</p>
							<p class="small">Select conversion type, paste your key, and click "Convert"</p>
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

<!-- JWK Guide Section -->
<div class="card mb-4 mt-5">
	<div class="card-header bg-primary text-white">
		<h2 class="h4 mb-0"><i class="fas fa-key"></i> Understanding JSON Web Keys (JWK)</h2>
	</div>
	<div class="card-body">
		<p class="lead">
			A <strong>JSON Web Key (JWK)</strong> is a JSON data structure that represents a cryptographic key, as defined in <a href="https://datatracker.ietf.org/doc/html/rfc7517" target="_blank" rel="noopener noreferrer">RFC 7517</a>. 
			JWK format provides a standardized way to represent cryptographic keys in JSON, making them easy to exchange between systems, 
			particularly in modern web applications, APIs, and security protocols like JWT, OAuth 2.0, and OpenID Connect.
		</p>

		<div class="alert alert-info">
			<strong><i class="fas fa-lightbulb"></i> Key Benefits:</strong>
			<ul class="mb-0 mt-2">
				<li><strong>Standardized Format:</strong> Industry-standard JSON structure for key representation</li>
				<li><strong>Easy Integration:</strong> Native JSON format works seamlessly with web APIs and JavaScript</li>
				<li><strong>Self-Describing:</strong> Key metadata (algorithm, usage, etc.) is embedded in the key itself</li>
				<li><strong>Flexible:</strong> Supports multiple key types: RSA, Elliptic Curve (EC), Octet Key Pair (OKP), and Octet Sequence</li>
			</ul>
		</div>

		<!-- Key Type Examples with Tabs -->
		<h3 class="mt-4"><i class="fas fa-code"></i> JWK Examples by Key Type</h3>
		<ul class="nav nav-tabs mt-3" id="jwkExampleTabs" role="tablist">
			<li class="nav-item">
				<a class="nav-link active" id="ec-tab" data-toggle="tab" href="#ec-example" role="tab">
					<i class="fas fa-circle"></i> EC (Elliptic Curve)
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="rsa-tab" data-toggle="tab" href="#rsa-example" role="tab">
					<i class="fas fa-lock"></i> RSA
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="okp-tab" data-toggle="tab" href="#okp-example" role="tab">
					<i class="fas fa-shield-alt"></i> OKP (Ed25519/Ed448)
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="oct-tab" data-toggle="tab" href="#oct-example" role="tab">
					<i class="fas fa-key"></i> Octet (HMAC/AES)
				</a>
			</li>
		</ul>

		<div class="tab-content p-3 border border-top-0" id="jwkExampleTabsContent">
			<!-- EC Example -->
			<div class="tab-pane fade show active" id="ec-example" role="tabpanel">
				<div class="d-flex justify-content-between align-items-center mb-2">
					<strong><i class="fas fa-circle text-success"></i> Elliptic Curve (EC) JWK Example</strong>
					<button class="btn btn-sm btn-outline-secondary" onclick="copyJWKExample('ec-jwk-code')">
						<i class="fas fa-copy"></i> Copy
					</button>
				</div>
				<pre id="ec-jwk-code" class="bg-light p-3 border rounded"><code>{
  "kty": "EC",
  "crv": "P-256",
  "x": "f83OJ3D2xF1Bg8vub9tLe1gHMzV76e8Tus9uPHvRVEU",
  "y": "x_FEzRu9m36HLN_tue659LNpXW6pCyStikYjKIWI5a0",
  "kid": "my-ec-key-2025",
  "use": "sig",
  "alg": "ES256"
}</code></pre>
				<div class="alert alert-success small mb-0">
					<strong><i class="fas fa-info-circle"></i> EC Key Details:</strong> 
					Elliptic Curve keys are efficient and secure. <strong>P-256</strong> (secp256r1) provides 128-bit security, 
					equivalent to RSA 3072-bit. Supported curves: P-256, P-384, P-521. Commonly used in modern applications for 
					JWT signing and OAuth 2.0.
				</div>
			</div>

			<!-- RSA Example -->
			<div class="tab-pane fade" id="rsa-example" role="tabpanel">
				<div class="d-flex justify-content-between align-items-center mb-2">
					<strong><i class="fas fa-lock text-primary"></i> RSA JWK Example (Public Key)</strong>
					<button class="btn btn-sm btn-outline-secondary" onclick="copyJWKExample('rsa-jwk-code')">
						<i class="fas fa-copy"></i> Copy
					</button>
				</div>
				<pre id="rsa-jwk-code" class="bg-light p-3 border rounded"><code>{
  "kty": "RSA",
  "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmb...",
  "e": "AQAB",
  "kid": "my-rsa-key-2025",
  "use": "sig",
  "alg": "RS256"
}</code></pre>
				<div class="alert alert-info small mb-0">
					<strong><i class="fas fa-info-circle"></i> RSA Key Details:</strong> 
					RSA keys are widely supported and used for both encryption and signing. 
					<strong>Recommended sizes:</strong> 2048-bit (minimum), 4096-bit (recommended for long-term security). 
					The <code>n</code> parameter is the modulus, <code>e</code> is the public exponent (typically 65537).
				</div>
			</div>

			<!-- OKP Example -->
			<div class="tab-pane fade" id="okp-example" role="tabpanel">
				<div class="d-flex justify-content-between align-items-center mb-2">
					<strong><i class="fas fa-shield-alt text-warning"></i> Octet Key Pair (OKP) - Ed25519 Example</strong>
					<button class="btn btn-sm btn-outline-secondary" onclick="copyJWKExample('okp-jwk-code')">
						<i class="fas fa-copy"></i> Copy
					</button>
				</div>
				<pre id="okp-jwk-code" class="bg-light p-3 border rounded"><code>{
  "kty": "OKP",
  "crv": "Ed25519",
  "x": "11qYAYKxCrfVS_7TyWQHOg7hcvPapiMlrwIaaPcHURo",
  "kid": "my-ed25519-key-2025",
  "use": "sig",
  "alg": "EdDSA"
}</code></pre>
				<div class="alert alert-warning small mb-0">
					<strong><i class="fas fa-info-circle"></i> OKP Key Details:</strong> 
					Octet Key Pairs represent Edwards curve keys (Ed25519/Ed448). Ed25519 provides excellent security (128-bit) 
					with small key sizes (256 bits) and fast operations. Used in modern JWT implementations and SSH keys. 
					Ed448 provides 224-bit security.
				</div>
			</div>

			<!-- Octet Example -->
			<div class="tab-pane fade" id="oct-example" role="tabpanel">
				<div class="d-flex justify-content-between align-items-center mb-2">
					<strong><i class="fas fa-key text-danger"></i> Octet Sequence (HMAC/AES) Example</strong>
					<button class="btn btn-sm btn-outline-secondary" onclick="copyJWKExample('oct-jwk-code')">
						<i class="fas fa-copy"></i> Copy
					</button>
				</div>
				<pre id="oct-jwk-code" class="bg-light p-3 border rounded"><code>{
  "kty": "oct",
  "k": "AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow",
  "kid": "my-hmac-key-2025",
  "use": "sig",
  "alg": "HS256"
}</code></pre>
				<div class="alert alert-danger small mb-0">
					<strong><i class="fas fa-exclamation-triangle"></i> Security Warning:</strong> 
					Octet sequence keys are symmetric keys used for HMAC (HS256, HS384, HS512) and AES encryption. 
					<strong>Keep these keys secret!</strong> They are used for both signing and verification, unlike asymmetric keys.
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Key Type Comparison -->
<div class="card mb-4">
	<div class="card-header bg-success text-white">
		<h3 class="h5 mb-0"><i class="fas fa-table"></i> JWK Key Types Comparison</h3>
	</div>
	<div class="card-body">
		<div class="table-responsive">
			<table class="table table-bordered table-hover">
				<thead class="thead-light">
					<tr>
						<th>Key Type</th>
						<th>kty Value</th>
						<th>Use Cases</th>
						<th>Security Level</th>
						<th>Key Size</th>
						<th>Recommendation</th>
					</tr>
				</thead>
				<tbody>
					<tr class="table-success">
						<td><strong>Elliptic Curve</strong></td>
						<td><code>EC</code></td>
						<td>JWT signing, OAuth 2.0, modern APIs</td>
						<td>128-256 bit</td>
						<td>256-521 bits</td>
						<td><span class="badge badge-success">Highly Recommended</span> Best for new projects</td>
					</tr>
					<tr>
						<td><strong>RSA</strong></td>
						<td><code>RSA</code></td>
						<td>JWT signing, encryption, legacy systems</td>
						<td>112-140 bit</td>
						<td>2048-4096 bits</td>
						<td><span class="badge badge-primary">Recommended</span> Widely compatible</td>
					</tr>
					<tr>
						<td><strong>Octet Key Pair</strong></td>
						<td><code>OKP</code></td>
						<td>Ed25519/Ed448 signatures, modern JWT</td>
						<td>128-224 bit</td>
						<td>256-456 bits</td>
						<td><span class="badge badge-info">Excellent</span> Modern alternative to EC</td>
					</tr>
					<tr class="table-warning">
						<td><strong>Octet Sequence</strong></td>
						<td><code>oct</code></td>
						<td>HMAC signatures, AES encryption</td>
						<td>128-256 bit</td>
						<td>128-512 bits</td>
						<td><span class="badge badge-warning">Symmetric</span> Keep secret!</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

<!-- RSA Field Details -->
<div class="card mb-4">
	<div class="card-header bg-info text-white">
		<h3 class="h5 mb-0"><i class="fas fa-list"></i> RSA JWK Field Reference</h3>
	</div>
	<div class="card-body">
		<p class="mb-3">RSA keys in JWK format contain the following fields (all Base64URL encoded):</p>
		<div class="row">
			<div class="col-md-6">
				<h5 class="h6"><i class="fas fa-key text-primary"></i> Public Key Fields</h5>
				<ul class="list-unstyled">
					<li class="mb-2">
						<code><strong>kty</strong></code> - Key type (always "RSA" for RSA keys)
					</li>
					<li class="mb-2">
						<code><strong>n</strong></code> - Modulus (the public key component)
					</li>
					<li class="mb-2">
						<code><strong>e</strong></code> - Public exponent (typically "AQAB" = 65537)
					</li>
					<li class="mb-2">
						<code><strong>kid</strong></code> - Key ID (optional, for key identification)
					</li>
					<li class="mb-2">
						<code><strong>use</strong></code> - Key use (optional: "sig" for signing, "enc" for encryption)
					</li>
					<li class="mb-2">
						<code><strong>alg</strong></code> - Algorithm (optional: "RS256", "RS384", "RS512")
					</li>
				</ul>
			</div>
			<div class="col-md-6">
				<h5 class="h6"><i class="fas fa-lock text-danger"></i> Private Key Fields</h5>
				<ul class="list-unstyled">
					<li class="mb-2">
						<code><strong>d</strong></code> - Private exponent (secret)
					</li>
					<li class="mb-2">
						<code><strong>p</strong></code> - First prime factor (secret)
					</li>
					<li class="mb-2">
						<code><strong>q</strong></code> - Second prime factor (secret)
					</li>
					<li class="mb-2">
						<code><strong>dp</strong></code> - First factor CRT exponent: <code>d mod (p-1)</code>
					</li>
					<li class="mb-2">
						<code><strong>dq</strong></code> - Second factor CRT exponent: <code>d mod (q-1)</code>
					</li>
					<li class="mb-2">
						<code><strong>qi</strong></code> - First CRT coefficient: <code>q^-1 mod p</code>
					</li>
				</ul>
				<div class="alert alert-danger small mb-0">
					<strong><i class="fas fa-exclamation-triangle"></i> Security Note:</strong> 
					Private key fields (d, p, q, dp, dq, qi) must be kept secret and never shared.
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Common Use Cases -->
<div class="card mb-4">
	<div class="card-header bg-warning text-dark">
		<h3 class="h5 mb-0"><i class="fas fa-rocket"></i> Common JWK Use Cases</h3>
	</div>
	<div class="card-body">
		<div class="row">
			<div class="col-md-6 mb-3">
				<div class="card h-100 border-primary">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-shield-alt text-primary"></i> JWT (JSON Web Tokens)</h5>
						<p class="small mb-0">JWK is used to represent the public keys for verifying JWT signatures. 
						JWK Sets (JWKS) are commonly exposed at endpoints like <code>/.well-known/jwks.json</code> 
						for token verification.</p>
					</div>
				</div>
			</div>
			<div class="col-md-6 mb-3">
				<div class="card h-100 border-success">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-key text-success"></i> OAuth 2.0 / OpenID Connect</h5>
						<p class="small mb-0">OAuth 2.0 providers use JWK Sets to publish their public keys, 
						allowing clients to verify ID tokens and access tokens without pre-sharing keys.</p>
					</div>
				</div>
			</div>
			<div class="col-md-6 mb-3">
				<div class="card h-100 border-info">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-server text-info"></i> API Authentication</h5>
						<p class="small mb-0">APIs can use JWK for key-based authentication, allowing clients 
						to register public keys and sign requests with corresponding private keys.</p>
					</div>
				</div>
			</div>
			<div class="col-md-6 mb-3">
				<div class="card h-100 border-warning">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-exchange-alt text-warning"></i> Key Exchange</h5>
						<p class="small mb-0">JWK format simplifies key exchange between systems, making it 
						easy to share public keys via JSON APIs, configuration files, or key management systems.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	function copyJWKExample(elementId) {
		const codeElement = document.getElementById(elementId);
		const code = codeElement.textContent;

		navigator.clipboard.writeText(code).then(() => {
			const button = event.target.closest('button');
			const originalHTML = button.innerHTML;
			button.innerHTML = '<i class="fas fa-check"></i> Copied!';
			button.classList.remove('btn-outline-secondary');
			button.classList.add('btn-success');

			setTimeout(() => {
				button.innerHTML = originalHTML;
				button.classList.remove('btn-success');
				button.classList.add('btn-outline-secondary');
			}, 2000);
		}).catch(err => {
			console.error('Failed to copy:', err);
			alert('Failed to copy. Please select and copy manually.');
		});
	}
</script>

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
					This JWK to PEM converter is developed and maintained by <strong>Anish Nath</strong>
					(<a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer"><i class="fab fa-x-twitter text-dark"></i> @anish2good</a>),
					a Security Engineer and Cryptography Expert with extensive experience in network security and cryptographic implementations.
					The tool has been serving the developer and DevOps community since 2018, with over <strong>756 verified reviews</strong>
					averaging <strong>4.6/5 stars</strong>.
				</p>

				<h4 class="h6 mt-3"><i class="fas fa-shield-alt text-success"></i> Security & Privacy Commitment</h4>
				<ul class="mb-3">
					<li><strong>No Data Collection:</strong> Your keys are processed securely and are not stored on our servers. Nothing is logged or retained.</li>
					<li><strong>Industry Standards:</strong> Uses proven cryptographic libraries implementing RFC 7517 (JWK) and OpenSSL standards.</li>
					<li><strong>Regular Updates:</strong> Tool is actively maintained with security best practices and format support updated regularly.</li>
					<li><strong>Open Source Standards:</strong> Compatible with JWT, OAuth 2.0, OpenSSL, and all major cryptographic implementations.</li>
				</ul>

				<h4 class="h6 mt-3"><i class="fas fa-clock text-info"></i> Version History</h4>
				<ul class="list-unstyled small text-muted">
					<li><strong>v2.0 (Jan 2025):</strong> Enhanced UX, improved JSON response handling, added EEAT signals</li>
					<li><strong>v1.5 (2020):</strong> Added EC key support for JWK to PEM conversion</li>
					<li><strong>v1.0 (2018):</strong> Initial release with RSA support</li>
				</ul>
			</div>

			<div class="col-md-4">
				<div class="card bg-light">
					<div class="card-body">
						<h5 class="h6"><i class="fas fa-book-open text-primary"></i> Official Resources</h5>
						<p class="small mb-3">
							Learn more about JWK and cryptographic key formats:
						</p>
						<ul class="list-unstyled small mb-3">
							<li class="mb-2">
								<a href="https://datatracker.ietf.org/doc/html/rfc7517" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-external-link-alt text-primary"></i> RFC 7517 (JWK)
								</a>
							</li>
							<li class="mb-2">
								<a href="https://datatracker.ietf.org/doc/html/rfc7519" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-file-alt text-primary"></i> RFC 7519 (JWT)
								</a>
							</li>
							<li class="mb-2">
								<a href="https://www.openssl.org/" target="_blank" rel="noopener noreferrer" class="text-decoration-none">
									<i class="fas fa-graduation-cap text-primary"></i> OpenSSL Documentation
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
							<li><i class="fas fa-check-circle text-success"></i> 7+ years of service</li>
							<li><i class="fas fa-check-circle text-success"></i> 756 verified reviews</li>
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

<%@ include file="addcomments.jsp"%>
<%@ include file="footer_adsense.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
