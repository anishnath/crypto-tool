<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
	<title>PGP Encryption Decryption Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention. Created by security engineer Anish Nath.">
	<meta name="keywords"  content="pgp encryption, decryption tool, online free, simple PGP Online Encrypt and Decrypt. Tool for PGP Encryption and Decryption. PGP Key Generator Tool, pgp message format, openssl pgp generation, pgp interview question, OpenPGP, RFC 4880, RSA encryption, end-to-end encryption">
	<meta name="author" content="Anish Nath">
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="canonical" href="https://8gwifi.org/pgpencdec.jsp">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgpencdec.jsp">
	<meta property="og:title" content="PGP Encryption Decryption Online – Free | 8gwifi.org">
	<meta property="og:description" content="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention. Created by security engineer.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgp.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgpencdec.jsp">
	<meta name="twitter:title" content="PGP Encryption Decryption Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Free PGP encryption & decryption tool implementing OpenPGP (RFC 4880). Secure RSA public-key cryptography with AES-256. No data retention.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgp.png">
	<meta name="twitter:creator" content="@anish2good">
	<meta name="twitter:site" content="@8gwifi">

    <head>
	<%@ include file="header-script.jsp"%>

		<!-- JSON-LD markup with E-E-A-T signals -->
		<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Encryption Decryption Online – Free",
  "description" : "Free online PGP encryption and decryption tool implementing OpenPGP standard (RFC 4880) with RSA public-key cryptography and AES-256 encryption. No data retention, secure message encryption.",
  "url" : "https://8gwifi.org/pgpencdec.jsp",
  "image" : "https://8gwifi.org/images/site/pgp.png",
  "screenshot" : "https://8gwifi.org/images/site/pgp.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "UtilitiesApplication"],
  "applicationSubCategory" : "Encryption Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer",
    "description" : "Security engineer specializing in cryptographic implementations and secure coding practices"
  },
  "datePublished" : "2018-10-23",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "PGP encryption using OpenPGP standard (RFC 4880)",
    "RSA public-key cryptography (2048-4096 bit)",
    "AES-256 symmetric encryption",
    "Secure message encryption and decryption",
    "Private key passphrase protection",
    "Share encrypted messages via URL",
    "Send encrypted messages via email",
    "No data retention - all processing in-memory",
    "HTTPS/TLS encryption for data transmission"
  ]
}
</script>

	<style>
		/* Modern UI Improvements */
		.pgp-container {
			max-width: 95%;
			margin: 0 auto;
			padding: 0 15px;
		}

		/* Compact Mode Selection */
		.mode-selection-card {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			border-radius: 8px;
			padding: 15px 20px;
			margin-bottom: 15px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.1);
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 20px;
		}

		.mode-selection-card p {
			color: white;
			font-size: 0.95rem;
			margin: 0;
			font-weight: 500;
		}

		.radio-group {
			display: flex;
			gap: 12px;
			flex-wrap: nowrap;
			margin: 0;
		}

		.radio-option {
			flex: 0 0 auto;
		}

		.radio-option input[type="radio"] {
			display: none;
		}

		.radio-label {
			display: flex;
			align-items: center;
			justify-content: center;
			padding: 10px 20px;
			background: rgba(255,255,255,0.2);
			border: 2px solid rgba(255,255,255,0.3);
			border-radius: 6px;
			color: white;
			cursor: pointer;
			transition: all 0.3s ease;
			font-weight: 500;
			font-size: 0.9rem;
			white-space: nowrap;
		}

		.radio-option input[type="radio"]:checked + .radio-label {
			background: white;
			color: #667eea;
			border-color: white;
			box-shadow: 0 4px 12px rgba(0,0,0,0.15);
		}

		.radio-label:hover {
			background: rgba(255,255,255,0.3);
			transform: translateY(-2px);
		}

		.radio-label::before {
			content: '🔒';
			margin-right: 8px;
			font-size: 1.2rem;
		}

		.radio-option:last-child .radio-label::before {
			content: '🔓';
		}

		/* Responsive Container Layout */
		.three-column-container {
			display: flex;
			flex-wrap: wrap;
			gap: 15px;
			margin-bottom: 15px;
			align-items: stretch;
			justify-content: flex-start;
		}

		.two-column-layout {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
			gap: 15px;
			height: auto;
		}

		.column {
			background: white;
			border-radius: 10px;
			padding: 20px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.08);
			transition: all 0.3s ease;
			overflow-y: auto;
			display: flex;
			flex-direction: column;
		}

		.column.left-column {
			border-left: 4px solid #667eea;
		}

		.column.right-column {
			border-left: 4px solid #8b5cf6;
		}

		.column.result-column {
			border-left: 4px solid #10b981;
			background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
			flex: 1 1 360px;
			min-width: 280px;
			display: flex;
			flex-direction: column;
			min-height: 0;
		}

		/* Form Section Cards */
		.form-section {
			flex: 2 1 640px;
			min-width: 320px;
			height: auto;
			display: grid;
			grid-template-rows: auto 1fr;
			gap: 15px;
			align-self: stretch;
		}

		.form-section.inactive {
			display: none;
		}

		.form-section.encrypt-mode,
		.form-section.decrypt-mode {
			/* Styles handled by columns */
		}

		.section-header {
			text-align: center;
			padding-bottom: 15px;
			border-bottom: 2px solid #f3f4f6;
		}

		.section-header h3 {
			margin: 0;
			font-size: 1.3rem;
			font-weight: 600;
			display: inline-flex;
			align-items: center;
			gap: 8px;
		}

		.section-header p {
			margin: 5px 0 0 0;
			font-size: 0.85rem;
			color: #6b7280;
		}

		/* Better Form Labels */
		.form-section label, .form-section b, .column label {
			display: block;
			color: #374151;
			font-weight: 600;
			margin-bottom: 8px;
			font-size: 0.95rem;
			text-transform: uppercase;
			letter-spacing: 0.5px;
		}

		.column label {
			margin-top: 0;
		}

		/* Textarea Improvements */
		.form-section textarea, .column textarea {
			border: 2px solid #e5e7eb;
			border-radius: 8px;
			padding: 10px;
			font-family: 'Courier New', monospace;
			font-size: 0.85rem;
			transition: all 0.3s ease;
			margin-bottom: 0;
			resize: none;
			width: 100%;
			box-sizing: border-box;
		}

		.form-section textarea:focus, .column textarea:focus {
			border-color: #667eea;
			box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
			outline: none;
		}

		.form-section textarea.invalid, .column textarea.invalid {
			border-color: #ef4444 !important;
			box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
			animation: shake 0.3s ease-in-out;
		}

		.form-section input[type="password"], .column input[type="password"] {
			border: 2px solid #e5e7eb;
			border-radius: 8px;
			padding: 12px;
			transition: all 0.3s ease;
			width: 100%;
			box-sizing: border-box;
		}

		.form-section input[type="password"]:focus, .column input[type="password"]:focus {
			border-color: #667eea;
			box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
			outline: none;
		}

		.form-section input[type="password"].invalid, .column input[type="password"].invalid {
			border-color: #ef4444 !important;
			box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
			animation: shake 0.3s ease-in-out;
		}

		@keyframes shake {
			0%, 100% { transform: translateX(0); }
			25% { transform: translateX(-5px); }
			75% { transform: translateX(5px); }
		}

		/* Hidden utility class */
		.hidden {
			display: none !important;
		}

		/* Output Section */
		#output {
			background: transparent;
			border-radius: 8px;
			padding: 0;
			transition: all 0.3s ease;
			position: relative;
		}

		#output:not(:empty) {
			background: transparent;
		}

		#output.loading {
			opacity: 0.6;
		}

		#output textarea {
			border: 2px solid #e5e7eb !important;
			border-radius: 8px !important;
			background: #f9fafb !important;
			width: 100% !important;
			font-size: 0.85rem !important;
			padding: 10px !important;
		}

		#output .alert-success,
		#output .alert-error {
			font-size: 0.9rem !important;
			padding: 12px !important;
			margin: 0 !important;
		}

		/* Copy Button Styling */
		.copy-btn {
			position: absolute;
			top: 10px;
			right: 10px;
			padding: 6px 12px;
			background: #667eea;
			color: white;
			border: none;
			border-radius: 6px;
			cursor: pointer;
			font-size: 0.85rem;
			transition: all 0.2s ease;
			z-index: 10;
		}

		.copy-btn:hover {
			background: #5568d3;
			transform: translateY(-1px);
		}

		.copy-btn:active {
			transform: translateY(0);
		}

		/* Button Improvements */
		.btn-primary {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			border: none;
			border-radius: 8px;
			padding: 12px 28px;
			font-weight: 600;
			font-size: 1rem;
			transition: all 0.3s ease;
			box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
		}

		.btn-primary:hover {
			transform: translateY(-2px);
			box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
		}

		.btn-primary:active {
			transform: translateY(0);
		}

		#sendemail {
			min-height: 38px;
			transition: opacity 0.2s ease-in-out, visibility 0.2s ease-in-out;
			background: linear-gradient(135deg, #10b981 0%, #059669 100%);
		}

		#sendemail:hover {
			box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
		}

		#sendemail.hidden {
			opacity: 0;
			visibility: hidden;
			pointer-events: none;
		}

		.btn-actions {
			display: flex;
			gap: 12px;
			margin-top: 20px;
			flex-wrap: wrap;
		}

		/* Loading Spinner */
		.loading-spinner {
			display: inline-block;
			width: 20px;
			height: 20px;
			border: 3px solid rgba(102, 126, 234, 0.2);
			border-radius: 50%;
			border-top-color: #667eea;
			animation: spin 0.6s linear infinite;
			margin-right: 8px;
			vertical-align: middle;
		}

		@keyframes spin {
			to { transform: rotate(360deg); }
		}

		/* Info Badges */
		.info-badge {
			display: inline-block;
			background: #dbeafe;
			color: #1e40af;
			padding: 4px 10px;
			border-radius: 4px;
			font-size: 0.8rem;
			margin-left: 8px;
			font-weight: 500;
		}

		/* Success/Error Messages */
		.alert-success {
			background: #d1fae5;
			border-left: 4px solid #10b981;
			padding: 15px;
			border-radius: 8px;
			color: #065f46;
			margin: 15px 0;
		}

		.alert-error {
			background: #fee2e2;
			border-left: 4px solid #ef4444;
			padding: 15px;
			border-radius: 8px;
			color: #991b1b;
			margin: 15px 0;
		}

		/* Column Headers */
		.column-header {
			display: flex;
			align-items: center;
			gap: 8px;
			margin-bottom: 12px;
			padding-bottom: 10px;
			border-bottom: 2px solid #f3f4f6;
			flex-shrink: 0;
		}

		.column-header h4 {
			margin: 0;
			font-weight: 600;
			font-size: 0.95rem;
			color: #374151;
		}

		.column-icon {
			font-size: 1.2rem;
		}

		.column-content {
			flex: 1;
			display: flex;
			flex-direction: column;
			overflow-y: auto;
			min-height: 0;
		}

		.column-content textarea {
			flex: 1 1 auto;
			min-height: 300px;
			max-height: 100%;
		}

		/* Responsive Design */
		@media (max-width: 1200px) {
			.form-section,
			.column.result-column {
				flex: 1 1 100%;
			}
		}

		@media (max-width: 968px) {
			.two-column-layout {
				grid-template-columns: 1fr;
			}

			.column.result-column {
				min-height: 320px;
			}
		}

		@media (max-width: 768px) {
			.mode-selection-card {
				padding: 12px 15px;
				flex-direction: column;
				gap: 10px;
			}

			.radio-group {
				width: 100%;
				flex-direction: column;
			}

			.radio-label {
				width: 100%;
			}

			.form-section, .column {
				padding: 15px;
			}

			.btn-actions {
				flex-direction: column;
			}

			.btn-primary {
				width: 100%;
			}
		}

		/* Hints */
		.input-hint {
			font-size: 0.85rem;
			color: #6b7280;
			margin-top: -5px;
			margin-bottom: 10px;
			font-style: italic;
		}

		.column .input-hint {
			margin-top: -5px;
			margin-bottom: 10px;
		}
	</style>

	<script type="text/javascript">
		$(document).ready(function() {

			// Check for encrypted message in URL parameter
			const urlParams = new URLSearchParams(window.location.search);
			const encryptedMessage = urlParams.get('encrypted');

			// Initialize UI state
			if (encryptedMessage) {
				// Switch to decrypt mode and populate encrypted message
				$('#decrypt').prop('checked', true);
				$('#encryptmsg').addClass('inactive').removeClass('encrypt-mode');
				$('#descryptmsg').removeClass('inactive').addClass('decrypt-mode');
				$('#p_pgpmessage').val(decodeURIComponent(encryptedMessage));
				$('#sendemail').addClass('hidden');

				// Show notification
				$('#output').html(
					'<div class="alert-success" style="padding: 15px;">' +
					'<strong>✅ Encrypted Message Loaded</strong><br/>' +
					'<span style="font-size: 0.85rem;">The encrypted message has been loaded from the URL. Enter your private key and passphrase to decrypt.</span>' +
					'</div>'
				);
			} else {
				$('#encryptmsg').removeClass('inactive').addClass('encrypt-mode');
				$('#descryptmsg').addClass('inactive');
				$('#sendemail').addClass('hidden');
			}

			// Copy to clipboard function
			window.copyToClipboard = function(elementId) {
				const textarea = $(elementId).find('textarea');
				if(textarea.length > 0) {
					textarea.select();
					document.execCommand('copy');

					// Visual feedback
					const btn = event.target;
					const originalText = btn.textContent;
					btn.textContent = '✓ Copied!';
					btn.style.background = '#10b981';

					setTimeout(function() {
						btn.textContent = originalText;
						btn.style.background = '#667eea';
					}, 2000);
				}
			};

			// Mode switching
			$('#encrypt').click(function (event)
			{
				$('#encryptmsg').removeClass('inactive').addClass('encrypt-mode');
				$('#descryptmsg').addClass('inactive').removeClass('decrypt-mode');
				$('#output').empty();
				$('#action-buttons').addClass('hidden');
			});

			$('#decrypt').click(function (event)
			{
				$('#encryptmsg').addClass('inactive').removeClass('encrypt-mode');
				$('#descryptmsg').removeClass('inactive').addClass('decrypt-mode');
				$('#output').empty();
				$('#action-buttons').addClass('hidden');
			});

			// Share URL functionality
			$('#shareurl').click(function(event) {
				const text = $('#output').find('textarea[name="comment"]').val();

				if(!text || text.trim() === '') {
					$('#output').html('<div class="alert-error">⚠️ No encrypted message to share. Please encrypt a message first.</div>');
					$('#action-buttons').addClass('hidden');
					return;
				}

				// Create shareable URL with encoded message
				const baseUrl = window.location.origin + window.location.pathname;
				const encodedMessage = encodeURIComponent(text);
				const shareableUrl = baseUrl + '?encrypted=' + encodedMessage;

				// Copy to clipboard
				const tempInput = document.createElement('textarea');
				tempInput.value = shareableUrl;
				document.body.appendChild(tempInput);
				tempInput.select();
				document.execCommand('copy');
				document.body.removeChild(tempInput);

				// Show success message
				const originalContent = $('#output').html();
				$('#output').html(
					'<div class="alert-success" style="text-align: center; padding: 20px;">' +
					'<div style="font-size: 2rem; margin-bottom: 10px;">✅</div>' +
					'<strong>Share URL Copied!</strong><br/>' +
					'<div style="margin-top: 10px; font-size: 0.85rem; word-break: break-all; background: #f3f4f6; padding: 10px; border-radius: 6px; max-height: 100px; overflow-y: auto;">' +
					shareableUrl +
					'</div>' +
					'<div style="margin-top: 10px; font-size: 0.8rem; color: #059669;">Share this URL with the recipient to send them the encrypted message</div>' +
					'</div>'
				);

				// Restore original content after 5 seconds
				setTimeout(() => {
					$('#output').html(originalContent);
				}, 5000);
			});

			// Send email functionality
			$('#sendemail').click(function(event) {
				const text = $('#output').find('textarea[name="comment"]').val();
				if ( text != null ) {
					$("#pgp_message").val(text);
				}

				if(!text || text.trim() === '')
				{
					alert("Encrypt the message first")
					return
				}

				const email = prompt("Please enter your email address:");
				if(!email) return;

				const validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
				if(email.match(validRegex))
				{
					$("#methodName").val("PGP_SEND_ENCRYPTION_EMAIL");
					$("#email").val(email);
					$('#form').delay(200).submit()
					$("#methodName").val("PGP_ENCRYPTION_DECRYPTION");
				}
				else{
					alert("Invalid Email Address")
				}
			});

			// Encrypt button click handler
			$('#encryptbutton').click(function(event) {
				$('#form').delay(200).submit()
			});

			// Decrypt button click handler
			$('#decryptbutton').click(function(event) {
				$('#form').delay(200).submit()
			});

			// Remove invalid class on input
			$('textarea, input[type="password"]').on('input', function() {
				$(this).removeClass('invalid');
			});

			// Form submission with better feedback
			$('#form').submit(function (event)
			{
				event.preventDefault();

				// Clear previous invalid states
				$('textarea, input[type="password"]').removeClass('invalid');

				// Frontend Validation
				const isEncryptMode = $('#encrypt').is(':checked');
				let validationErrors = [];

				if (isEncryptMode) {
					// Encrypt mode validation
					const message = $('#p_cmsg').val().trim();
					const publicKey = $('#p_publicKey').val().trim();

					if (!message) {
						validationErrors.push('❌ Message to encrypt is required');
						$('#p_cmsg').addClass('invalid');
					}
					if (!publicKey) {
						validationErrors.push('❌ PGP Public Key is required');
						$('#p_publicKey').addClass('invalid');
					} else if (!publicKey.includes('BEGIN PGP PUBLIC KEY BLOCK') || !publicKey.includes('END PGP PUBLIC KEY BLOCK')) {
						validationErrors.push('❌ Invalid PGP Public Key format (must include BEGIN/END markers)');
						$('#p_publicKey').addClass('invalid');
					}
				} else {
					// Decrypt mode validation
					const pgpMessage = $('#p_pgpmessage').val().trim();
					const privateKey = $('#p_privateKey').val().trim();
					const passphrase = $('#p_passpharse').val().trim();

					if (!pgpMessage) {
						validationErrors.push('❌ PGP Encrypted Message is required');
						$('#p_pgpmessage').addClass('invalid');
					} else if (!pgpMessage.includes('BEGIN PGP MESSAGE') || !pgpMessage.includes('END PGP MESSAGE')) {
						validationErrors.push('❌ Invalid PGP Message format (must include BEGIN/END markers)');
						$('#p_pgpmessage').addClass('invalid');
					}
					if (!privateKey) {
						validationErrors.push('❌ PGP Private Key is required');
						$('#p_privateKey').addClass('invalid');
					} else if (!privateKey.includes('BEGIN PGP PRIVATE KEY BLOCK') || !privateKey.includes('END PGP PRIVATE KEY BLOCK')) {
						validationErrors.push('❌ Invalid PGP Private Key format (must include BEGIN/END markers)');
						$('#p_privateKey').addClass('invalid');
					}
					if (!passphrase) {
						validationErrors.push('❌ Passphrase is required');
						$('#p_passpharse').addClass('invalid');
					}
				}

				// Show validation errors
				if (validationErrors.length > 0) {
					const errorHtml = '<div class="alert-error">' +
						'<strong>⚠️ Validation Failed:</strong><br/>' +
						validationErrors.join('<br/>') +
						'</div>';
					$('#output').html(errorHtml);

					// Hide action buttons on validation error
					$('#action-buttons').addClass('hidden');

					// Scroll to first invalid field
					const firstInvalid = $('.invalid').first();
					if (firstInvalid.length > 0) {
						firstInvalid[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
						setTimeout(() => firstInvalid.focus(), 300);
					}
					return false;
				}

				// Proceed with submission
				const mode = isEncryptMode ? 'Encrypting' : 'Decrypting';
				$('#output').addClass('loading').html(
					'<div style="text-align: center; padding: 40px;">' +
					'<div class="loading-spinner"></div>' +
					'<div style="margin-top: 10px; color: #667eea; font-weight: 500;">' + mode + ' your message...</div>' +
					'</div>'
				);

				$.ajax({
					type: "POST",
					url: "PGPFunctionality",
					data: $("#form").serialize(),
					success: function(msg){
						$('#output').removeClass('loading').empty();

						// Modernize the server's old <font> tags
						let modernMsg = msg;

						// Replace green success font tags with modern styling
						modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']green["'][^>]*>/gi, '<div class="alert-success" style="font-size: 1rem;">');
						modernMsg = modernMsg.replace(/<font[^>]*color\s*=\s*["']red["'][^>]*>/gi, '<div class="alert-error" style="font-size: 0.95rem;">');

						// Close font tags
						let fontCount = (modernMsg.match(/<div class="alert-(success|error)"/g) || []).length;
						for(let i = 0; i < fontCount; i++) {
							modernMsg = modernMsg.replace('</font>', '</div>');
						}

						// Check if there's an error in the response
						const hasError = modernMsg.includes('alert-error') || modernMsg.includes('color="red"') || modernMsg.includes('System Error') || modernMsg.includes('INVALID');

						// Check if response contains textarea (encrypted message output)
						const hasTextarea = modernMsg.includes('<textarea') || modernMsg.toLowerCase().includes('textarea');

						// Check current mode
						const isEncryptMode = $('#encrypt').is(':checked');

						if(hasTextarea) {
							const outputWrapper = $('<div style="position: relative;"></div>');
							outputWrapper.append(modernMsg);
							outputWrapper.append('<button class="copy-btn" onclick="copyToClipboard(\'#output\')">📋 Copy</button>');
							$('#output').append(outputWrapper);
						} else {
							// Check if it's an error message
							if(hasError) {
								$('#output').html(modernMsg);
							} else if(modernMsg.includes('alert-success')) {
								// Success message without textarea (decrypt result)
								const wrapper = $('<div style="position: relative; padding: 20px; background: white; border-radius: 8px; border: 2px solid #10b981;"></div>');
								wrapper.append(modernMsg);
								$('#output').append(wrapper);
							} else {
								$('#output').append(modernMsg);
							}
						}

						// Show/hide action buttons based on result state
						if (hasError) {
							// Hide buttons when there's an error
							$('#action-buttons').addClass('hidden');
						} else if (hasTextarea && isEncryptMode) {
							// Show buttons for successful encryption with textarea output
							$('#action-buttons').removeClass('hidden');
							// Explicitly show both individual buttons
							$('#shareurl').removeClass('hidden');
							$('#sendemail').removeClass('hidden');
						} else {
							// Hide buttons for decryption or when no textarea
							$('#action-buttons').addClass('hidden');
						}
					},
					error: function(xhr, status, error) {
						$('#output').removeClass('loading').html(
							'<div class="alert-error">' +
							'<strong>Error:</strong> ' + (error || 'Failed to process request') +
							'</div>'
						);
						// Hide action buttons on AJAX error
						$('#action-buttons').addClass('hidden');
					}
				});
			});

			// Clear output when switching inputs in decrypt mode
			$('#p_pgpmessage, #p_privateKey, #p_passpharse').on('input', function() {
				// Don't auto-submit for decrypt mode
			});
		});

	</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<div class="pgp-container">
<h1 style="margin: 15px 0 5px 0; font-size: 1.8rem;">🔐 PGP Encryption & Decryption</h1>
<p style="color: #6b7280; margin-bottom: 15px; font-size: 0.9rem;">Secure your messages with military-grade PGP encryption</p>

<form id="form" class="form-horizontal" method="POST" enctype="application/x-www-form-urlencoded">
	<input type="hidden" name="methodName" id="methodName" value="PGP_ENCRYPTION_DECRYPTION">
    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>" >
    <input type="hidden" id="email" name="email" value="">
    <input type="hidden" id="pgp_message" name="pgp_message" value="">

	<!-- Mode Selection Card -->
	<div class="mode-selection-card">
		<p>Select Operation Mode</p>
		<div class="radio-group">
			<div class="radio-option">
				<input checked id="encrypt" type="radio" name="encryptdecrypt" value="encrypt">
				<label for="encrypt" class="radio-label">Encrypt Message</label>
			</div>
			<div class="radio-option">
				<input id="decrypt" type="radio" name="encryptdecrypt" value="decrypt">
				<label for="decrypt" class="radio-label">Decrypt Message</label>
			</div>
		</div>
	</div>


	<!-- Three Column Container -->
	<div class="three-column-container">
		<!-- Decrypt Section -->
		<div id="descryptmsg" class="form-section decrypt-mode inactive">
		<div class="section-header">
			<h3 style="color: #f59e0b;"><span style="font-size: 1.5rem;">🔓</span> Decrypt Message</h3>
			<p>Paste encrypted message & credentials</p>
		</div>
		<div class="two-column-layout">
			<!-- Left Column: Encrypted Message -->
			<div class="column left-column">
				<div class="column-header">
					<span class="column-icon">📨</span>
					<h4>Encrypted Message</h4>
				</div>
				<div class="column-content">
					<label for="p_pgpmessage">Encrypted Message <span class="info-badge">Required</span></label>
					<div class="input-hint">Paste PGP message block</div>
					<textarea class="form-control animated" id="p_pgpmessage" name="p_pgpmessage" placeholder="-----BEGIN PGP MESSAGE-----
Version: BCPG v1.58

hIwDmCS94uDDx9kBA/9hH8V38pyzUOvcBPa5Rcv38doT3zJ/tvhxI/5h+1tF5sPg
nmeQDs7D829eR9x6nMos395hbJZezx+iGn1tfdhBoy0FpH3KHTNY+0qLNu37qVwU
ogXF+tQ3umq/CUqQgpETHS/awvuNhvRfo240u+tmrXUZl18fDdAVg6BKpgMmH9Ju
AVPnVI+0DoCls0IKZSegwO5T0Cj/D/fJuT7VSxCHCtJ6aAS1F8TAfn98oiik3CzS
9oBh+KHqawk3supbiXPmpJdyV45oOfV4fsVPnP8zbtLtQNv6EBO+mEwday9Hq2xo
+sxxQx0poYZDI7sq4i8=
=v0g9
-----END PGP MESSAGE-----"></textarea>
					<div style="margin-top: 8px; padding: 6px 8px; background: #fef3c7; border-radius: 6px; font-size: 0.75rem; color: #92400e; flex-shrink: 0;">
						⚠️ Include complete message
					</div>
				</div>
			</div>

			<!-- Right Column: Private Key & Passphrase -->
			<div class="column right-column">
				<div class="column-header">
					<span class="column-icon">🔐</span>
					<h4>Your Credentials</h4>
				</div>
				<div class="column-content">
					<label for="p_privateKey">Private Key <span class="info-badge">Required</span></label>
					<div class="input-hint">Your PGP private key</div>
					<textarea class="form-control animated" id="p_privateKey" name="p_privateKey" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: BCPG v1.58

lQH+BFojjHkBBACJghEFJ0kOeHnvpp5ADbI8r2ZtkLAtbBiARKZsiW4dsVrpbify
lUyFEqm5CzhKuAjiJcxtH4bq7lFgTNvgDWs6uY5MS62Jh1+AMANkOo73d8RPAdbl
Y6k9ExCsmbZgcHrBLMFMW/rzsFS3Vil6XMkl7SEIaClgFFcxu3ubhGsMlwARAQAB
/gQDApBPMSbTsvQjYNgi3vBAHHkJ5YurFXAPWeZ87jXJ/DdruVoK5cXqdgg4g5Sz
9ZBE2rkcJ7qL54I2zMEZaXmQeqANqfhRuJH2E8DlRW6wbt2jU5WorD/a/5iTcjGu
/AfBRIktji4LW/BcsKnXirDZK12IjxYjyCHv4AY3P/v6Osf91zdmg9C1S7vuwz5I
2hXqJBj7jhyZ2y/C6CP84Rnr7XyvqQxNV1BDIJH21z4er15axuY23pywA6I8Qqwm
I5vaSmJlBHwpQ22Fh5EkltMIHNqcpQ50HoNL/XKwXy1PvgyEA79462RvTY6Bj6JE
WPEHCFa9mvuubeXOO7D1S9pM3ygpuwQiR9F4EFCWU5m5xR1Wr2QlftiJI7Fhyg7M
ttkyjEW0AX6RbGgbhKnCOaiDO7CJpSULwwkMfOGAWYwrsxcJh8LqZVEUVrH//Ajo
kNPN+u9X0U/g4Vt5aKuEygFkF0QcLruOW/BUgpH4KFUWtAVhbmlzaIicBBABAgAG
BQJaI4x5AAoJEJgkveLgw8fZR3sD/1LbEpN5co+Rpx8qEx2TM/rFBaRZWp+2oKh3
+qVdj4HW/TjAlWrjMJfW4z2PR0h0IP2t4E0OajavbcYiNuBbKNkNwEel3FZNsEMU
uqayfYpj4tZ6V2qwsGZBIFi11i7kCx6MUVh3/aJVKnluz5MEJSdSvSG/OaQk78de
gze0MEL/
=5jHf
-----END PGP PRIVATE KEY BLOCK-----"></textarea>

					<label for="p_passpharse" style="margin-top: 10px;">Passphrase <span class="info-badge">Required</span></label>
					<div class="input-hint">Private key passphrase</div>
					<input id="p_passpharse" class="form-control" type="password" name="p_passpharse" placeholder="Enter passphrase">

					<div class="btn-actions" style="margin-top: 15px;">
						<button type="button" class="btn btn-primary" id="decryptbutton" style="width: 100%;">🔓 Decrypt</button>
					</div>
				</div>
			</div>
		</div>
		</div>

		<!-- Encrypt Section -->
		<div id="encryptmsg" class="form-section encrypt-mode">
			<div class="section-header">
				<h3 style="color: #10b981;"><span style="font-size: 1.5rem;">🔒</span> Encrypt Message</h3>
				<p>Type message & add public key</p>
			</div>
			<div class="two-column-layout">
				<!-- Left Column: Message Input -->
				<div class="column left-column">
					<div class="column-header">
						<span class="column-icon">✍️</span>
						<h4>Your Message</h4>
					</div>
					<div class="column-content">
						<label for="p_cmsg">Message to Encrypt <span class="info-badge">Required</span></label>
						<div class="input-hint">Type your secret message</div>
						<textarea class="form-control animated" placeholder="Type your secret message here..."  name="p_cmsg" id="p_cmsg"></textarea>
						<div style="margin-top: 8px; padding: 8px; background: #dbeafe; border-radius: 6px; font-size: 0.75rem; color: #1e40af; flex-shrink: 0;">
							💡 Click "Encrypt Message" when ready
						</div>
					</div>
				</div>

				<!-- Right Column: Public Key -->
				<div class="column right-column">
					<div class="column-header">
						<span class="column-icon">🔑</span>
						<h4>Recipient's Public Key</h4>
					</div>
					<div class="column-content">
						<label for="p_publicKey">Public Key <span class="info-badge">Required</span></label>
						<div class="input-hint">Recipient's PGP public key</div>
						<textarea class="form-control animated" id="p_publicKey" name="p_publicKey" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----"  name="p_publicKey" id="p_publicKey">-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----</textarea>

						<div class="btn-actions" style="margin-top: 15px;">
							<button type="button" class="btn btn-primary" id="encryptbutton" style="width: 100%;">🔒 Encrypt Message</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Results Column (Third Column) -->
		<div class="column result-column">
			<div class="column-header">
				<span class="column-icon">📋</span>
				<h4>Result</h4>
			</div>
			<div id="output" style="flex: 1; overflow-y: auto; min-height: 0; display: flex; flex-direction: column;">
				<div style="text-align: center; color: #9ca3af; padding: 30px 15px; flex: 1; display: flex; flex-direction: column; justify-content: center;">
					<div style="font-size: 2rem; margin-bottom: 8px;">⏳</div>
					<div style="font-weight: 500; font-size: 0.85rem;">Your result will appear here</div>
				</div>
			</div>
			<div class="btn-actions hidden" id="action-buttons" style="margin-top: 8px; flex-shrink: 0; gap: 8px;">
				<button type="button" class="btn btn-primary" id="shareurl" style="flex: 1; padding: 10px; background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);">🔗 Share URL</button>
				<button type="button" class="btn btn-primary" id="sendemail" style="flex: 1; padding: 10px;">📧 Send Email</button>
			</div>
		</div>
	</div> <!-- End three-column-container -->

</form>

</div> <!-- End pgp-container -->

    <div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<!-- E-E-A-T: Experience, Expertise, Authoritativeness, Trustworthiness -->
<section class="container my-5">
  <div class="row">
    <div class="col-lg-12">
      <div class="card">
        <div class="card-body">
          <h2 class="h5 mb-3">🔐 About This PGP Tool & Cryptographic Methodology</h2>
          <p>This online PGP encryption and decryption tool implements the OpenPGP standard (RFC 4880) using industry-standard Java cryptography libraries (Bouncy Castle). All cryptographic operations are performed server-side using RSA public-key cryptography with configurable key sizes (1024-4096 bits). Messages are encrypted using a hybrid approach: symmetric encryption (AES/3DES) for the message body and RSA public-key encryption for the session key.</p>

          <h3 class="h6 mt-4 mb-2">How PGP Encryption Works:</h3>
          <ol>
            <li><strong>Key Generation:</strong> RSA keypair (public + private) is generated using cryptographically secure random number generation</li>
            <li><strong>Encryption:</strong> Message is compressed (ZIP), encrypted with a symmetric key (AES-256), then the symmetric key is encrypted with recipient's RSA public key</li>
            <li><strong>Decryption:</strong> Private key decrypts the session key, which then decrypts the message body. Passphrase protects the private key using symmetric encryption</li>
            <li><strong>Security Model:</strong> Even if the encrypted message is intercepted, only the holder of the private key (and passphrase) can decrypt it</li>
          </ol>

          <div class="row mt-4">
            <div class="col-md-6">
              <h3 class="h6">👨‍💻 Authorship & Expertise</h3>
              <ul>
                <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a></li>
                <li><strong>Background:</strong> Security engineer specializing in cryptographic implementations and secure coding practices</li>
                <li><strong>Reviewed by:</strong> 8gwifi.org security team</li>
                <li><strong>First published:</strong> 2018-10-23</li>
                <li><strong>Last updated:</strong> 2025-11-20</li>
                <li><strong>Maintenance:</strong> Actively maintained with security updates</li>
              </ul>
            </div>
            <div class="col-md-6">
              <h3 class="h6">🔒 Trust & Privacy Guarantees</h3>
              <ul>
                <li><strong>No Data Retention:</strong> Messages and keys are processed in-memory only; nothing is logged or stored on servers</li>
                <li><strong>HTTPS Only:</strong> All data transmission uses TLS 1.2+ encryption</li>
                <li><strong>Client-Side Validation:</strong> Input validation happens before transmission</li>
                <li><strong>No Analytics on Crypto Data:</strong> We never track message content or key material</li>
                <li><strong>Open Standards:</strong> Implements RFC 4880 (OpenPGP) - publicly auditable specification</li>
                <li><strong>Support:</strong> Contact <a href="https://x.com/anish2good" target="_blank" rel="noopener">@anish2good</a> for issues</li>
              </ul>
            </div>
          </div>

          <h3 class="h6 mt-4 mb-2">🎓 Technical Implementation Details</h3>
          <p><strong>Cryptographic Library:</strong> Bouncy Castle (org.bouncycastle.openpgp) - industry-standard, peer-reviewed Java cryptography provider</p>
          <ul>
            <li><strong>Key Algorithm:</strong> RSA (Rivest-Shamir-Adleman) - asymmetric encryption</li>
            <li><strong>Symmetric Cipher:</strong> AES-256 or 3DES for message encryption</li>
            <li><strong>Hash Algorithm:</strong> SHA-256 for integrity verification</li>
            <li><strong>Compression:</strong> ZIP compression before encryption (reduces ciphertext size)</li>
            <li><strong>Armor Format:</strong> ASCII-armored output (Base64 encoding with checksums)</li>
            <li><strong>Key Protection:</strong> Private keys encrypted with passphrase using S2K (String-to-Key) with iteration count</li>
          </ul>

          <h3 class="h6 mt-4 mb-2">⚠️ Security Best Practices</h3>
          <ul>
            <li><strong>Key Size:</strong> Use 2048-bit or 4096-bit RSA keys for long-term security</li>
            <li><strong>Strong Passphrases:</strong> Protect private keys with 20+ character passphrases (use passphrase generator)</li>
            <li><strong>Key Storage:</strong> Store private keys in secure, offline locations (encrypted USB drives, hardware tokens)</li>
            <li><strong>Key Rotation:</strong> Rotate keys every 2-3 years or immediately if compromised</li>
            <li><strong>Verify Recipients:</strong> Always verify public key fingerprints through a separate channel before encrypting sensitive data</li>
            <li><strong>Backup Keys:</strong> Securely backup private keys - if lost, encrypted messages are unrecoverable</li>
          </ul>

          <h3 class="h6 mt-4 mb-2">📚 Authoritative Sources & Standards</h3>
          <ul>
            <li><a href="https://www.ietf.org/rfc/rfc4880.txt" target="_blank" rel="nofollow noopener">RFC 4880 - OpenPGP Message Format</a> (IETF Standard)</li>
            <li><a href="https://www.openpgp.org/" target="_blank" rel="nofollow noopener">OpenPGP.org - Official OpenPGP Working Group</a></li>
            <li><a href="https://www.bouncycastle.org/java.html" target="_blank" rel="nofollow noopener">Bouncy Castle Crypto APIs</a> (Legion of the Bouncy Castle Inc.)</li>
            <li><a href="https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf" target="_blank" rel="nofollow noopener">NIST SP 800-57 - Key Management Guidelines</a></li>
            <li><a href="https://datatracker.ietf.org/doc/html/rfc3447" target="_blank" rel="nofollow noopener">RFC 3447 - RSA Cryptography Specifications</a></li>
            <li><a href="https://www.gnupg.org/documentation/" target="_blank" rel="nofollow noopener">GNU Privacy Guard (GPG) Documentation</a></li>
          </ul>

          <h3 class="h6 mt-4 mb-2">🔍 Common Use Cases</h3>
          <ul>
            <li><strong>Email Encryption:</strong> Encrypt sensitive emails end-to-end (E2EE)</li>
            <li><strong>File Encryption:</strong> Secure confidential documents before cloud storage or transmission</li>
            <li><strong>API Credentials:</strong> Share API keys, passwords, or tokens securely</li>
            <li><strong>Compliance:</strong> Meet GDPR, HIPAA, PCI-DSS encryption requirements</li>
            <li><strong>Secure Messaging:</strong> Send encrypted messages without trusting intermediaries</li>
            <li><strong>Code Signing:</strong> Verify authenticity of software releases (with PGP signatures)</li>
          </ul>

          <div class="alert alert-info mt-4">
            <strong>🛡️ Security Disclaimer:</strong> While this tool implements industry-standard cryptography, for maximum security when handling highly sensitive data (financial, medical, classified), consider using offline PGP implementations (GPG) on air-gapped systems. Online tools should be used with awareness of the threat model and trust boundaries.
          </div>

          <p class="text-muted small mt-3"><strong>Related Topics:</strong> PGP encryption, OpenPGP, GPG, RSA encryption, public key cryptography, end-to-end encryption, email encryption, secure file transfer, digital signatures, key management, RFC 4880, Bouncy Castle, AES encryption, asymmetric cryptography</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- E-E-A-T JSON-LD for WebPage with Author Credentials -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Encryption Decryption Online – Free | 8gwifi.org",
  "url": "https://8gwifi.org/pgpencdec.jsp",
  "description": "Free online PGP encryption and decryption tool implementing OpenPGP standard (RFC 4880). Secure message encryption using RSA public-key cryptography.",
  "datePublished": "2018-10-23",
  "dateModified": "2025-11-20",
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://x.com/anish2good",
    "jobTitle": "Security Engineer",
    "description": "Security engineer specializing in cryptographic implementations and secure coding practices"
  },
  "reviewedBy": {
    "@type": "Organization",
    "name": "8gwifi.org Security Team"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org"
  },
  "mainEntity": {
    "@type": "SoftwareApplication",
    "name": "PGP Encryption/Decryption Tool",
    "applicationCategory": "SecurityApplication",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    }
  },
  "about": {
    "@type": "Thing",
    "name": "PGP Encryption",
    "description": "Pretty Good Privacy (PGP) - cryptographic protocol for encrypting and decrypting data"
  },
  "citation": [
    {
      "@type": "CreativeWork",
      "name": "RFC 4880 - OpenPGP Message Format",
      "url": "https://www.ietf.org/rfc/rfc4880.txt"
    },
    {
      "@type": "CreativeWork",
      "name": "NIST SP 800-57 - Key Management Guidelines",
      "url": "https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf"
    }
  ]
}
</script>

<!-- Breadcrumb Schema for Navigation -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://8gwifi.org/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Cryptography Tools",
      "item": "https://8gwifi.org/pgpencdec.jsp"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "PGP Encryption/Decryption",
      "item": "https://8gwifi.org/pgpencdec.jsp"
    }
  ]
}
</script>

<!-- HowTo Schema for Encryption Process -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Encrypt Messages with PGP",
  "description": "Step-by-step guide to encrypt messages using PGP public key encryption",
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Select Encrypt Mode",
      "text": "Choose 'Encrypt' mode in the operation selector"
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Enter Message",
      "text": "Type or paste the message you want to encrypt in the message field"
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Add Public Key",
      "text": "Paste the recipient's PGP public key (BEGIN PGP PUBLIC KEY BLOCK)"
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Encrypt",
      "text": "Click 'Encrypt Message' button to generate encrypted PGP message"
    },
    {
      "@type": "HowToStep",
      "position": 5,
      "name": "Share",
      "text": "Copy the encrypted message or use 'Share URL' to send to recipient"
    }
  ]
}
</script>

<!-- FAQ Schema for Featured Snippets -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is PGP encryption and how does it work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "PGP (Pretty Good Privacy) is a public-key cryptography system that uses RSA asymmetric encryption. It works by: 1) Generating a keypair (public key for encryption, private key for decryption), 2) Encrypting messages with the recipient's public key, 3) The recipient decrypts with their private key protected by a passphrase. Messages are encrypted using hybrid cryptography: symmetric AES-256 for the message body and RSA for the session key."
      }
    },
    {
      "@type": "Question",
      "name": "Is this PGP tool secure? Do you store my keys or messages?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, this tool is secure. We implement OpenPGP standard (RFC 4880) using Bouncy Castle cryptography library. All encryption/decryption happens server-side in-memory only. We do NOT store, log, or retain any keys, passphrases, or messages. All data transmission uses HTTPS/TLS encryption. For maximum security with highly sensitive data, consider using offline PGP tools like GPG."
      }
    },
    {
      "@type": "Question",
      "name": "How do I encrypt a message with PGP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To encrypt: 1) Select 'Encrypt' mode, 2) Enter your message, 3) Paste the recipient's PGP public key (must include BEGIN/END markers), 4) Click 'Encrypt Message'. The tool generates an encrypted message that only the recipient can decrypt with their private key. You can share the encrypted message via the 'Share URL' feature or copy it directly."
      }
    },
    {
      "@type": "Question",
      "name": "How do I decrypt a PGP encrypted message?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To decrypt: 1) Select 'Decrypt' mode, 2) Paste the PGP encrypted message (BEGIN PGP MESSAGE block), 3) Paste your PGP private key (BEGIN PGP PRIVATE KEY BLOCK), 4) Enter your passphrase to unlock the private key, 5) Click 'Decrypt'. The tool will display the original plaintext message if the private key matches the encryption."
      }
    },
    {
      "@type": "Question",
      "name": "What does 'secret key for message not found' error mean?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This error means the private key you provided does not belong to the recipient of the encrypted message. PGP messages are encrypted for a specific public key, and only the corresponding private key can decrypt them. Verify you're using the correct private key that matches the public key used for encryption."
      }
    },
    {
      "@type": "Question",
      "name": "What key size should I use for PGP encryption?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For modern security, use 2048-bit or 4096-bit RSA keys. 1024-bit keys are considered weak. 2048-bit keys offer good security for most use cases. 4096-bit keys provide maximum security for long-term protection but are slower. This tool supports RSA keys from 1024 to 4096 bits implementing the OpenPGP standard (RFC 4880)."
      }
    },
    {
      "@type": "Question",
      "name": "Can I share encrypted messages via URL?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! After encrypting a message, click the 'Share URL' button. This generates a shareable link with the encrypted message encoded in the URL parameter. Recipients can click the link to automatically load the encrypted message and decrypt it with their private key. This is safe because the message is already encrypted - only the intended recipient with the matching private key can decrypt it."
      }
    }
  ]
}
</script>

<!-- Organization Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "8gwifi.org",
  "url": "https://8gwifi.org",
  "logo": "https://8gwifi.org/images/site/logo.png",
  "description": "Free online tools for cryptography, networking, development, and security. Specializing in PGP encryption, SSL/TLS tools, hashing, encoding, and blockchain utilities.",
  "sameAs": [
    "https://x.com/anish2good",
    "https://github.com/anish2good"
  ],
  "founder": {
    "@type": "Person",
    "name": "Anish Nath",
    "jobTitle": "Security Engineer",
    "url": "https://x.com/anish2good"
  }
}
</script>

<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>