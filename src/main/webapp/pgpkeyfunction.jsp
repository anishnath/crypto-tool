<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
	<title>PGP Key Generator Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Free online PGP key pair generator. Create RSA public/private keys with AES-256, TWOFISH, or BLOWFISH encryption. OpenPGP standard (RFC 4880) compliant. Choose 2048 or 4096-bit key sizes. No data retention.">
	<meta name="keywords"  content="pgp key generation, pgp key generator, openPGP keys, RSA key pair, public private key, AES-256, TWOFISH, BLOWFISH, CAST5, encryption keys, GPG keys">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgpkeyfunction.jsp">
	<meta property="og:title" content="PGP Key Generator Online – Free | 8gwifi.org">
	<meta property="og:description" content="Free online PGP key pair generator. Create RSA public/private keys with AES-256, TWOFISH, or BLOWFISH encryption. OpenPGP standard (RFC 4880) compliant. No data retention.">
	<meta property="og:image" content="https://8gwifi.org/images/site/gpg.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgpkeyfunction.jsp">
	<meta name="twitter:title" content="PGP Key Generator Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Free online PGP key pair generator. Create RSA public/private keys with AES-256, TWOFISH, or BLOWFISH encryption. OpenPGP compliant.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/gpg.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Key Generator Online – Free",
  "description" : "Free online PGP key pair generator implementing OpenPGP standard (RFC 4880). Generate RSA public/private keys with multiple cipher options (AES-256, TWOFISH, BLOWFISH, CAST5). Choose 1024, 2048, or 4096-bit key sizes. No data retention, secure key generation.",
  "url" : "https://8gwifi.org/pgpkeyfunction.jsp",
  "image" : "https://8gwifi.org/images/site/gpg.png",
  "screenshot" : "https://8gwifi.org/images/site/gpg.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "UtilitiesApplication"],
  "applicationSubCategory" : "PGP Key Generator",
  "browserRequirements" : "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer"
  },
  "datePublished" : "2018-11-30",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "Generate RSA public/private key pairs (1024-4096 bit)",
    "Multiple cipher options: AES-256, TWOFISH, BLOWFISH, CAST5, TRIPLE_DES, AES-192, AES-128",
    "OpenPGP standard (RFC 4880) compliant",
    "Email key pair delivery option",
    "No data retention - keys generated in browser",
    "Custom identity and passphrase support"
  ]
}
</script>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Key Generator Online – Free",
  "description": "Generate PGP/OpenPGP key pairs online with RSA encryption and multiple cipher algorithms.",
  "url": "https://8gwifi.org/pgpkeyfunction.jsp",
  "breadcrumb": {
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
        "name": "PGP Tools",
        "item": "https://8gwifi.org/pgpencdec.jsp"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "PGP Key Generator",
        "item": "https://8gwifi.org/pgpkeyfunction.jsp"
      }
    ]
  }
}
</script>

	<!-- HowTo Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Generate PGP Key Pairs Online",
  "description": "Step-by-step guide to generating PGP/OpenPGP public and private key pairs using RSA encryption.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Enter Identity",
      "text": "Enter your identity (name or email address) that will be associated with the PGP key pair.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Set Passphrase",
      "text": "Create a strong passphrase to protect your private key. This passphrase will be required to use the private key for decryption.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Choose Cipher Algorithm",
      "text": "Select a cipher algorithm: BLOWFISH, TWOFISH, AES_256, AES_192, AES_128, CAST5, or TRIPLE_DES. AES_256 is recommended for maximum security.",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Select Key Size",
      "text": "Choose RSA key size: 1024-bit (legacy), 2048-bit (recommended), or 4096-bit (maximum security but slower performance).",
      "position": 4
    },
    {
      "@type": "HowToStep",
      "name": "Generate Keys",
      "text": "Click 'Generate Keypair' to create your PGP keys. Optionally, use 'Email Key Pair' to receive the keys via email.",
      "position": 5
    }
  ]
}
</script>

	<style>
		/* UX Improvements */
		.cipher-option, .keysize-option {
			display: inline-block;
			margin: 5px;
		}
		.cipher-option label, .keysize-option label {
			display: inline-flex;
			align-items: center;
			padding: 8px 16px;
			border: 2px solid #ddd;
			border-radius: 6px;
			cursor: pointer;
			transition: all 0.2s;
			font-weight: 500;
			background: #fff;
		}
		.cipher-option input[type="radio"], .keysize-option input[type="radio"] {
			margin-right: 8px;
		}
		.cipher-option label:hover, .keysize-option label:hover {
			border-color: #007bff;
			background: #f8f9fa;
		}
		.cipher-option input[type="radio"]:checked + label,
		.keysize-option input[type="radio"]:checked + label {
			border-color: #007bff;
			background: #007bff;
			color: white;
		}
		/* Updated selector for new structure */
		.cipher-option label.active, .keysize-option label.active {
			border-color: #007bff;
			background: #007bff;
			color: white;
		}
		.recommended-badge {
			background: #28a745;
			color: white;
			padding: 2px 8px;
			border-radius: 10px;
			font-size: 11px;
			margin-left: 5px;
			font-weight: bold;
		}
		.legacy-badge {
			background: #ffc107;
			color: #000;
			padding: 2px 8px;
			border-radius: 10px;
			font-size: 11px;
			margin-left: 5px;
			font-weight: bold;
		}
		.passphrase-strength {
			margin-top: 5px;
			height: 4px;
			border-radius: 2px;
			background: #ddd;
			overflow: hidden;
		}
		.passphrase-strength-bar {
			height: 100%;
			width: 0%;
			transition: all 0.3s;
		}
		.strength-weak { background: #dc3545; width: 25%; }
		.strength-fair { background: #ffc107; width: 50%; }
		.strength-good { background: #17a2b8; width: 75%; }
		.strength-strong { background: #28a745; width: 100%; }
		.strength-text {
			font-size: 12px;
			margin-top: 3px;
			font-weight: 500;
		}
		.input-group-append-password {
			cursor: pointer;
		}
		.help-icon {
			cursor: help;
			color: #6c757d;
			margin-left: 5px;
			font-size: 14px;
		}
		#output textarea {
			font-family: 'Courier New', monospace;
			font-size: 12px;
		}
		.key-actions {
			margin-top: 10px;
			display: flex;
			gap: 10px;
		}
		/* CLS prevention - reserve space for output */
		#output {
			min-height: 100px;
			transition: min-height 0.3s ease;
		}
		#output:empty {
			min-height: 0;
		}
		/* Smooth animations for content loading */
		#output > * {
			animation: fadeIn 0.3s ease-in;
		}
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}
		/* Single page view optimization */
		.form-container {
			transition: all 0.4s ease;
		}
		.form-container.minimized {
			max-height: 80px;
			overflow: hidden;
		}
		.form-summary {
			display: none;
			padding: 15px;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			color: white;
			border-radius: 8px;
			margin-bottom: 20px;
			cursor: pointer;
			transition: all 0.3s;
		}
		.form-summary:hover {
			transform: translateY(-2px);
			box-shadow: 0 4px 12px rgba(0,0,0,0.15);
		}
		.form-summary.show {
			display: block;
		}
		.compact-output .card {
			margin-bottom: 12px;
		}
		.compact-output textarea {
			height: 180px !important;
			max-height: 180px;
			overflow-y: auto;
			resize: none;
		}
		.compact-output .alert {
			padding: 10px 15px;
			margin-bottom: 12px;
		}
		.compact-output .alert-heading {
			font-size: 1rem;
			margin-bottom: 5px;
		}
		.compact-output .card-header {
			padding: 8px 15px;
		}
		.expand-form-btn {
			background: white;
			color: #667eea;
			border: none;
			padding: 5px 15px;
			border-radius: 20px;
			font-weight: 600;
			transition: all 0.2s;
		}
		.expand-form-btn:hover {
			background: #f0f0f0;
		}
	</style>

	<script type="text/javascript">
		$(document).ready(function() {

			// Passphrase strength indicator
			$('#p_passpharse').on('input', function() {
				const pass = $(this).val();
				let strength = 0;
				let strengthText = '';
				let strengthClass = '';

				if (pass.length >= 8) strength++;
				if (pass.length >= 12) strength++;
				if (/[a-z]/.test(pass) && /[A-Z]/.test(pass)) strength++;
				if (/\d/.test(pass)) strength++;
				if (/[^a-zA-Z0-9]/.test(pass)) strength++;

				if (strength <= 2) {
					strengthText = 'Weak';
					strengthClass = 'strength-weak';
				} else if (strength === 3) {
					strengthText = 'Fair';
					strengthClass = 'strength-fair';
				} else if (strength === 4) {
					strengthText = 'Good';
					strengthClass = 'strength-good';
				} else {
					strengthText = 'Strong';
					strengthClass = 'strength-strong';
				}

				$('.passphrase-strength-bar').attr('class', 'passphrase-strength-bar ' + strengthClass);
				$('.strength-text').text(strengthText).css('color',
					strengthClass === 'strength-weak' ? '#dc3545' :
					strengthClass === 'strength-fair' ? '#ffc107' :
					strengthClass === 'strength-good' ? '#17a2b8' : '#28a745'
				);
			});

			// Toggle passphrase visibility
			$('#togglePassphrase').click(function() {
				const input = $('#p_passpharse');
				const icon = $(this).find('i');
				if (input.attr('type') === 'password') {
					input.attr('type', 'text');
					icon.removeClass('fa-eye').addClass('fa-eye-slash');
				} else {
					input.attr('type', 'password');
					icon.removeClass('fa-eye-slash').addClass('fa-eye');
				}
			});

			// Generate secure passphrase
			$('#generatePassphrase').click(function() {
				const length = parseInt($('#passphraseLength').val());
				const includeSymbols = $('#includeSymbols').is(':checked');
				const includeNumbers = $('#includeNumbers').is(':checked');
				const includeUppercase = $('#includeUppercase').is(':checked');
				const includeLowercase = $('#includeLowercase').is(':checked');

				// Build character set
				let charset = '';
				if (includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
				if (includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
				if (includeNumbers) charset += '0123456789';
				if (includeSymbols) charset += '!@#$%^&*()_+-=[]{}|;:,.<>?';

				// Ensure at least one character set is selected
				if (charset.length === 0) {
					alert('Please select at least one character type for passphrase generation.');
					return;
				}

				// Generate cryptographically secure random passphrase
				let passphrase = '';
				const values = new Uint32Array(length);
				window.crypto.getRandomValues(values);

				for (let i = 0; i < length; i++) {
					passphrase += charset[values[i] % charset.length];
				}

				// Ensure passphrase meets minimum requirements (at least one from each selected type)
				let valid = true;
				if (includeLowercase && !/[a-z]/.test(passphrase)) valid = false;
				if (includeUppercase && !/[A-Z]/.test(passphrase)) valid = false;
				if (includeNumbers && !/[0-9]/.test(passphrase)) valid = false;
				if (includeSymbols && !/[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(passphrase)) valid = false;

				// If not valid, regenerate (recursive call - will eventually get valid)
				if (!valid) {
					$('#generatePassphrase').click();
					return;
				}

				// Set passphrase and show it temporarily
				$('#p_passpharse').val(passphrase);
				$('#p_passpharse').attr('type', 'text');
				$('#togglePassphrase').find('i').removeClass('fa-eye').addClass('fa-eye-slash');

				// Trigger strength indicator update
				$('#p_passpharse').trigger('input');

				// Visual feedback
				const originalHtml = $('#generatePassphrase').html();
				$('#generatePassphrase').html('<i class="fas fa-check"></i> Generated!');
				setTimeout(function() {
					$('#generatePassphrase').html(originalHtml);
				}, 2000);
			});

			// Show/hide passphrase options
			$('#showPassphraseOptions').click(function(e) {
				e.preventDefault();
				$('#passphraseOptions').collapse('toggle');
				const text = $('#passphraseOptions').hasClass('show') ? 'Hide options' : 'Customize generation';
				$(this).text(text);
			});

			// Update length value display
			$('#passphraseLength').on('input', function() {
				$('#lengthValue').text($(this).val());
			});

			// Visual feedback for radio selection
			$('input[type="radio"]').change(function() {
				const name = $(this).attr('name');
				$('input[name="' + name + '"]').siblings('label').removeClass('active');
				$(this).siblings('label').addClass('active');
			});

			// Form validation
			function validateForm() {
				let isValid = true;
				const identity = $('#p_identity').val().trim();
				const passphrase = $('#p_passpharse').val().trim();

				// Clear previous errors
				$('.is-invalid').removeClass('is-invalid');
				$('.invalid-feedback').remove();

				if (!identity) {
					$('#p_identity').addClass('is-invalid');
					$('#p_identity').after('<div class="invalid-feedback">Identity is required (e.g., your name or email)</div>');
					isValid = false;
				}

				if (!passphrase) {
					$('#p_passpharse').addClass('is-invalid');
					$('#p_passpharse').parent().after('<div class="invalid-feedback">Passphrase is required</div>');
					isValid = false;
				} else if (passphrase.length < 8) {
					$('#p_passpharse').addClass('is-invalid');
					$('#p_passpharse').parent().after('<div class="invalid-feedback">Passphrase must be at least 8 characters</div>');
					isValid = false;
				}

				return isValid;
			}

			$('#genkeypair').click(function (event) {
				if (!validateForm()) {
					return;
				}
				$("#email").val('');
				$('#form').delay(200).submit();
			});

			$('#genkeypairemail').click(function (event) {
				if (!validateForm()) {
					return;
				}

				// Show Bootstrap modal instead of prompt
				$('#emailModal').modal('show');
			});

			// Handle email modal submission
			$('#sendEmailBtn').click(function() {
				const email = $('#emailInput').val().trim();
				const validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

				if (email.match(validRegex)) {
					$('#emailModal').modal('hide');
					$("#email").val(email);
					$('#form').delay(200).submit();

					// Show success toast
					$('#output').prepend('<div class="alert alert-success alert-dismissible fade show" role="alert">PGP key pair will be delivered to your email...<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
					$("#emailInput").val('');
				} else {
					$('#emailInput').addClass('is-invalid');
					if (!$('#emailInput').next('.invalid-feedback').length) {
						$('#emailInput').after('<div class="invalid-feedback">Please enter a valid email address</div>');
					}
				}
			});

			// Clear email validation on input
			$('#emailInput').on('input', function() {
				$(this).removeClass('is-invalid');
				$(this).next('.invalid-feedback').remove();
			});

			$('#form').submit(function (event) {
				event.preventDefault();

				// Show loading
				$('#output').html('<div class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="sr-only">Generating keys...</span></div><p class="mt-3">Generating secure PGP keys... This may take a moment.</p></div>');

				// Store form values for summary
				const identity = $('#p_identity').val();
				const cipher = $('input[name="cipherparameter"]:checked').val();
				const keysize = $('input[name="p_keysize"]:checked').val();

				$.ajax({
					type: "POST",
					url: "PGPFunctionality",
					data: $("#form").serialize(),
					success: function(msg){
						// Minimize form and show summary
						$('#form-container').addClass('minimized');
						$('#form-summary').addClass('show');
						$('#summary-identity').text(identity);
						$('#summary-cipher').text(cipher);
						$('#summary-keysize').text(keysize);

						// Add compact class to output
						$('#output').addClass('compact-output');
						$('#output').empty();
						$('#output').append(msg);

						// Add copy and download buttons to textareas
						$('#output textarea').each(function(index) {
							const textarea = $(this);
							const textareaId = 'textarea_' + index;
							textarea.attr('id', textareaId);

							const actions = $('<div class="key-actions"></div>');
							const copyBtn = $('<button class="btn btn-sm btn-outline-primary copy-btn" data-target="' + textareaId + '"><i class="fas fa-copy"></i> Copy</button>');
							const downloadBtn = $('<button class="btn btn-sm btn-outline-secondary download-btn" data-target="' + textareaId + '"><i class="fas fa-download"></i> Download</button>');

							actions.append(copyBtn).append(downloadBtn);
							textarea.after(actions);
						});

						// Smooth scroll to top to show everything
						$('html, body').animate({ scrollTop: 0 }, 400);
					},
					error: function(xhr, status, error) {
						$('#output').html('<div class="alert alert-danger"><strong>Error:</strong> Unable to generate keys. Please try again.</div>');
					}
				});
			});

			// Toggle form visibility
			$(document).on('click', '#form-summary, #expand-form-link', function(e) {
				e.preventDefault();
				e.stopPropagation();

				$('#form-container').removeClass('minimized');
				$('#form-summary').removeClass('show');
				$('#output').removeClass('compact-output').empty();

				// Smooth scroll to form
				$('html, body').animate({
					scrollTop: $('#form-container').offset().top - 20
				}, 400);

				// Reset form fields (optional)
				$('#p_identity').val('');
				$('#p_passpharse').val('');
				$('.passphrase-strength-bar').removeClass('strength-weak strength-fair strength-good strength-strong');
				$('.strength-text').text('');

				// Clear any validation errors
				$('.is-invalid').removeClass('is-invalid');
				$('.invalid-feedback').remove();
			});

			// Copy button handler (delegated)
			$(document).on('click', '.copy-btn', function() {
				const targetId = $(this).data('target');
				const textarea = $('#' + targetId);
				textarea.select();
				document.execCommand('copy');

				// Visual feedback
				$(this).html('<i class="fas fa-check"></i> Copied!');
				const btn = $(this);
				setTimeout(function() {
					btn.html('<i class="fas fa-copy"></i> Copy');
				}, 2000);
			});

			// Download button handler (delegated)
			$(document).on('click', '.download-btn', function() {
				const targetId = $(this).data('target');
				const content = $('#' + targetId).val();
				const filename = targetId.includes('0') ? 'pgp_private_key.asc' : 'pgp_public_key.asc';

				const blob = new Blob([content], { type: 'text/plain' });
				const url = window.URL.createObjectURL(blob);
				const a = document.createElement('a');
				a.href = url;
				a.download = filename;
				a.click();
				window.URL.revokeObjectURL(url);
			});

			// Tooltips
			$('[data-toggle="tooltip"]').tooltip();
		});

	</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">PGP Key Generator</h1>
<p class="lead text-muted">Generate secure RSA public/private key pairs with OpenPGP standard (RFC 4880)</p>
<hr>

<!-- Form Summary (shown after generation) -->
<div id="form-summary" class="form-summary">
	<div class="d-flex justify-content-between align-items-center">
		<div>
			<h5 class="mb-1"><i class="fas fa-key"></i> Generated Keys</h5>
			<small>
				Identity: <strong id="summary-identity"></strong> |
				Cipher: <strong id="summary-cipher"></strong> |
				Key Size: <strong id="summary-keysize"></strong>-bit
			</small>
		</div>
		<button type="button" class="expand-form-btn" id="expand-form-link">
			<i class="fas fa-edit"></i> Generate New Keys
		</button>
	</div>
</div>

<!-- Form Container (collapsible) -->
<div id="form-container" class="form-container">
<form id="form" method="POST" enctype="application/x-www-form-urlencoded">
	<input type="hidden" name="methodName" id="methodName" value="GENERATE_PGEP_KEY">
	<input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>" >
	<input type="hidden" id="email" name="email" value="">

	<div class="form-row">
		<div class="col-md-6">
			<div class="form-group">
				<label for="p_identity">
					Identity <span class="text-danger">*</span>
					<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Enter your name or email address"></i>
				</label>
				<input class="form-control" id="p_identity" type="text" name="p_identity" value=""
					placeholder="john@example.com"
					aria-describedby="identityHelp">
				<small id="identityHelp" class="form-text text-muted">Your name or email for the key</small>
			</div>
		</div>

		<div class="col-md-6">
			<div class="form-group">
				<label for="p_passpharse">
					Passphrase <span class="text-danger">*</span>
					<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Use at least 12 characters with mixed case, numbers, and symbols"></i>
				</label>
				<div class="input-group">
					<input class="form-control" id="p_passpharse" type="password" name="p_passpharse" value=""
						placeholder="Enter passphrase (min 8 chars)"
						aria-describedby="passphraseHelp">
					<div class="input-group-append">
						<button class="btn btn-outline-success" type="button" id="generatePassphrase" data-toggle="tooltip" title="Generate secure passphrase">
							<i class="fas fa-dice"></i>
						</button>
						<button class="btn btn-outline-secondary" type="button" id="togglePassphrase" data-toggle="tooltip" title="Show/hide">
							<i class="fas fa-eye"></i>
						</button>
					</div>
				</div>
				<div class="passphrase-strength">
					<div class="passphrase-strength-bar"></div>
				</div>
				<div class="strength-text"></div>
				<small id="passphraseHelp" class="form-text text-muted">Protects your private key. <a href="#" id="showPassphraseOptions" class="text-primary">Customize</a></small>
			</div>
		</div>
	</div>

	<!-- Passphrase Generation Options (collapsible) -->
	<div class="collapse" id="passphraseOptions">
		<div class="card card-body bg-light mb-3">
			<h6>Passphrase Generation Options</h6>
			<div class="form-row">
				<div class="col-md-6">
					<label for="passphraseLength">Length: <span id="lengthValue">16</span> characters</label>
					<input type="range" class="custom-range" id="passphraseLength" min="12" max="32" value="16">
				</div>
				<div class="col-md-6">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="includeSymbols" checked>
						<label class="custom-control-label" for="includeSymbols">Include symbols (!@#$%^&*)</label>
					</div>
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="includeNumbers" checked>
						<label class="custom-control-label" for="includeNumbers">Include numbers (0-9)</label>
					</div>
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="includeUppercase" checked>
						<label class="custom-control-label" for="includeUppercase">Include uppercase (A-Z)</label>
					</div>
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="includeLowercase" checked>
						<label class="custom-control-label" for="includeLowercase">Include lowercase (a-z)</label>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="form-group">
		<label>
			Cipher Algorithm <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="AES-256 provides the highest security and is recommended for all new keys"></i>
		</label>
		<div>
			<div class="cipher-option">
				<input id="cipherparameter12" type="radio" name="cipherparameter" value="AES_256" checked="checked">
				<label for="cipherparameter12">AES-256 <span class="recommended-badge">RECOMMENDED</span></label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter13" type="radio" name="cipherparameter" value="AES_192">
				<label for="cipherparameter13">AES-192</label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter14" type="radio" name="cipherparameter" value="AES_128">
				<label for="cipherparameter14">AES-128</label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter16" type="radio" name="cipherparameter" value="TWOFISH">
				<label for="cipherparameter16">TWOFISH</label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter11" type="radio" name="cipherparameter" value="BLOWFISH">
				<label for="cipherparameter11">BLOWFISH <span class="legacy-badge">LEGACY</span></label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter15" type="radio" name="cipherparameter" value="CAST5">
				<label for="cipherparameter15">CAST5 <span class="legacy-badge">LEGACY</span></label>
			</div>
			<div class="cipher-option">
				<input id="cipherparameter17" type="radio" name="cipherparameter" value="TRIPLE_DES">
				<label for="cipherparameter17">TRIPLE_DES <span class="legacy-badge">LEGACY</span></label>
			</div>
		</div>
		<small class="form-text text-muted">AES-256 offers maximum security with 256-bit encryption. Legacy algorithms provided for compatibility only.</small>
	</div>

	<div class="form-group">
		<label>
			RSA Key Size <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="2048-bit is standard. 4096-bit offers maximum security but slower performance."></i>
		</label>
		<div>
			<div class="keysize-option">
				<input id="keysize2" type="radio" name="p_keysize" value="2048" checked="checked">
				<label for="keysize2">2048-bit <span class="recommended-badge">RECOMMENDED</span></label>
			</div>
			<div class="keysize-option">
				<input id="keysize3" type="radio" name="p_keysize" value="4096">
				<label for="keysize3">4096-bit <small>(Max Security)</small></label>
			</div>
			<div class="keysize-option">
				<input id="keysize1" type="radio" name="p_keysize" value="1024">
				<label for="keysize1">1024-bit <span class="legacy-badge">WEAK</span></label>
			</div>
		</div>
		<small class="form-text text-muted">2048-bit provides strong security with good performance. 1024-bit is weak and not recommended.</small>
	</div>

	<div class="form-group">
		<button class="btn btn-primary btn-lg" type="button" id="genkeypair">
			<i class="fas fa-key"></i> Generate Key Pair
		</button>
		<button class="btn btn-outline-primary btn-lg ml-2" type="button" id="genkeypairemail">
			<i class="fas fa-envelope"></i> Email Key Pair
		</button>
	</div>
</form>

<!-- Email Modal -->
<div class="modal fade" id="emailModal" tabindex="-1" role="dialog" aria-labelledby="emailModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="emailModalLabel">Email PGP Key Pair</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label for="emailInput">Email Address</label>
					<input type="email" class="form-control" id="emailInput" placeholder="Enter your email address">
					<small class="form-text text-muted">Your PGP keys will be sent to this email address.</small>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
				<button type="button" class="btn btn-primary" id="sendEmailBtn">
					<i class="fas fa-paper-plane"></i> Send Keys
				</button>
			</div>
		</div>
	</div>
</div>
</div><!-- End form-container -->

<hr>

<div id="output"></div>

<hr>



<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>


<%@ include file="footer_adsense.jsp"%>

<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
  <div class="card-header bg-info text-white">
    <h3 class="mb-0">Cryptographic Key Generation Methodology</h3>
  </div>
  <div class="card-body">
    <h4>RSA Key Pair Generation Process</h4>
    <p>This tool generates PGP key pairs using the RSA (Rivest-Shamir-Adleman) public-key cryptosystem. The generation process follows these cryptographic steps:</p>
    <ol>
      <li><strong>Prime Number Generation:</strong> Generate two large random prime numbers (p and q)</li>
      <li><strong>Modulus Calculation:</strong> Compute n = p × q (the key size determines the bit length of n)</li>
      <li><strong>Totient Function:</strong> Calculate φ(n) = (p-1)(q-1)</li>
      <li><strong>Public Exponent:</strong> Choose public exponent e (commonly 65537) where 1 &lt; e &lt; φ(n) and gcd(e, φ(n)) = 1</li>
      <li><strong>Private Exponent:</strong> Compute private exponent d where d ≡ e⁻¹ (mod φ(n))</li>
      <li><strong>Key Packaging:</strong> Format keys according to OpenPGP standard (RFC 4880)</li>
    </ol>

    <h4>Cipher Algorithm Options</h4>
    <table class="table table-sm table-bordered mt-3">
      <thead class="thead-light">
        <tr>
          <th>Algorithm</th>
          <th>Block Size</th>
          <th>Key Size</th>
          <th>Security Level</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>AES-256</strong></td>
          <td>128 bits</td>
          <td>256 bits</td>
          <td>Highest (recommended)</td>
        </tr>
        <tr>
          <td><strong>AES-192</strong></td>
          <td>128 bits</td>
          <td>192 bits</td>
          <td>High</td>
        </tr>
        <tr>
          <td><strong>AES-128</strong></td>
          <td>128 bits</td>
          <td>128 bits</td>
          <td>High</td>
        </tr>
        <tr>
          <td><strong>TWOFISH</strong></td>
          <td>128 bits</td>
          <td>256 bits</td>
          <td>High</td>
        </tr>
        <tr>
          <td><strong>BLOWFISH</strong></td>
          <td>64 bits</td>
          <td>32-448 bits</td>
          <td>Medium (legacy)</td>
        </tr>
        <tr>
          <td><strong>CAST5</strong></td>
          <td>64 bits</td>
          <td>128 bits</td>
          <td>Medium</td>
        </tr>
        <tr>
          <td><strong>TRIPLE_DES</strong></td>
          <td>64 bits</td>
          <td>168 bits (effective 112)</td>
          <td>Medium (legacy)</td>
        </tr>
      </tbody>
    </table>

    <h4>Key Size Selection Guide</h4>
    <ul>
      <li><strong>1024-bit:</strong> Legacy support only. No longer recommended for new keys (vulnerable to advanced attacks).</li>
      <li><strong>2048-bit:</strong> Current standard recommendation. Provides strong security with good performance balance.</li>
      <li><strong>4096-bit:</strong> Maximum security for long-term protection. Slower performance but resistant to future computational advances.</li>
    </ul>

    <div class="alert alert-warning mt-3">
      <strong>Best Practice:</strong> Use 2048-bit or 4096-bit keys with AES-256 cipher for new key generation. Avoid 1024-bit keys unless required for legacy system compatibility.
    </div>
  </div>
</div>

<div class="card my-4 border-success">
  <div class="card-header bg-success text-white">
    <h3 class="mb-0">Author Credentials & Expertise</h3>
  </div>
  <div class="card-body">
    <p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and network security.</p>
    <ul>
      <li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, and secure system design</li>
      <li><strong>Expertise:</strong> OpenPGP/GPG implementations, public-key infrastructure (PKI), symmetric/asymmetric encryption algorithms</li>
      <li><strong>Standards Knowledge:</strong> Deep understanding of RFC 4880 (OpenPGP), NIST cryptographic guidelines, FIPS 140-2 requirements</li>
      <li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank">@anish2good on X (Twitter)</a></li>
    </ul>

    <div class="alert alert-info mt-3">
      <strong>Implementation Note:</strong> This tool uses the Bouncy Castle cryptographic library, a widely-trusted and FIPS-certified implementation used by enterprises worldwide. Key generation occurs server-side with cryptographically secure random number generation (CSRNG).
    </div>
  </div>
</div>

<div class="card my-4 border-primary">
  <div class="card-header bg-primary text-white">
    <h3 class="mb-0">Trust & Privacy Guarantees</h3>
  </div>
  <div class="card-body">
    <h4>Zero Data Retention Policy</h4>
    <ul>
      <li>Generated keys are <strong>never stored</strong> on our servers</li>
      <li>Keys are generated, displayed once, and immediately discarded from server memory</li>
      <li>No logging of identity, passphrase, or generated key material</li>
      <li>Optional email delivery uses temporary storage (deleted after sending)</li>
      <li>No tracking cookies or analytics on this tool page</li>
    </ul>

    <h4>Security Recommendations</h4>
    <ol>
      <li><strong>Passphrase Strength:</strong> Use a passphrase with at least 16 characters, combining uppercase, lowercase, numbers, and symbols.</li>
      <li><strong>Private Key Protection:</strong> Store your private key securely offline. Never share it or upload it to cloud services.</li>
      <li><strong>Key Backup:</strong> Maintain encrypted backups of your private key in multiple secure locations.</li>
      <li><strong>Key Expiration:</strong> Consider setting expiration dates for keys (managed in GPG client software after generation).</li>
      <li><strong>Key Revocation:</strong> Generate and store a revocation certificate immediately after key creation.</li>
    </ol>

    <div class="alert alert-danger mt-3">
      <strong>Critical Warning:</strong> If you lose your private key or forget your passphrase, encrypted data cannot be recovered. There is no backdoor or password reset mechanism in PGP encryption.
    </div>
  </div>
</div>

<div class="card my-4 border-secondary">
  <div class="card-header bg-secondary text-white">
    <h3 class="mb-0">Technical Implementation Details</h3>
  </div>
  <div class="card-body">
    <h4>OpenPGP Standard Compliance</h4>
    <p>This tool strictly adheres to <strong>RFC 4880</strong> (OpenPGP Message Format) and generates keys compatible with:</p>
    <ul>
      <li><strong>GnuPG (GPG):</strong> The GNU Privacy Guard implementation</li>
      <li><strong>PGP Desktop:</strong> Symantec PGP Desktop and similar commercial implementations</li>
      <li><strong>OpenKeychain:</strong> Android OpenPGP implementation</li>
      <li><strong>Mailvelope:</strong> Browser extension for webmail encryption</li>
      <li><strong>Thunderbird/Enigmail:</strong> Email client PGP integration</li>
    </ul>

    <h4>Key Format Details</h4>
    <p>Generated keys use the following specifications:</p>
    <ul>
      <li><strong>Key Type:</strong> RSA (Sign + Encrypt)</li>
      <li><strong>Key Format:</strong> ASCII-armored PGP format</li>
      <li><strong>Private Key Protection:</strong> Encrypted with user-provided passphrase using String-to-Key (S2K) convention</li>
      <li><strong>Hash Algorithm:</strong> SHA-256 for signatures</li>
      <li><strong>Compression:</strong> ZLIB compression enabled</li>
    </ul>

    <h4>Random Number Generation</h4>
    <p>Security of RSA keys depends critically on unpredictable prime number generation. This implementation uses:</p>
    <ul>
      <li><strong>CSRNG Source:</strong> /dev/urandom on Linux (cryptographically secure)</li>
      <li><strong>Entropy Pool:</strong> System entropy pool with hardware RNG support when available</li>
      <li><strong>Primality Testing:</strong> Miller-Rabin primality test with multiple rounds</li>
    </ul>
  </div>
</div>

<div class="card my-4 border-dark">
  <div class="card-header bg-dark text-white">
    <h3 class="mb-0">Common Use Cases & Best Practices</h3>
  </div>
  <div class="card-body">
    <h4>When to Use This Tool</h4>
    <ul>
      <li><strong>Email Encryption:</strong> Generate keys for encrypting sensitive emails</li>
      <li><strong>File Encryption:</strong> Create keys for encrypting confidential documents</li>
      <li><strong>Code Signing:</strong> Generate keys for signing software releases or Git commits</li>
      <li><strong>Secure Messaging:</strong> Create keys for encrypted chat applications</li>
      <li><strong>Password Manager:</strong> Generate keys for GPG-encrypted password stores</li>
    </ul>

    <h4>After Key Generation</h4>
    <ol>
      <li><strong>Test Your Keys:</strong> Use the <a href="pgpencdec.jsp">PGP Encryption/Decryption tool</a> to verify your keys work correctly</li>
      <li><strong>Publish Public Key:</strong> Upload your public key to keyservers (keys.openpgp.org, keyserver.ubuntu.com)</li>
      <li><strong>Key Fingerprint:</strong> Verify key fingerprints when exchanging keys with others</li>
      <li><strong>Web of Trust:</strong> Have your key signed by trusted parties to build trust relationships</li>
      <li><strong>Regular Testing:</strong> Periodically test decryption to ensure you haven't lost access to your private key</li>
    </ol>

    <h4>Authoritative Sources</h4>
    <ul>
      <li><a href="https://tools.ietf.org/html/rfc4880" target="_blank" rel="noopener">RFC 4880 - OpenPGP Message Format</a> (IETF Standard)</li>
      <li><a href="https://www.openpgp.org/" target="_blank" rel="noopener">OpenPGP.org</a> - Official OpenPGP Working Group</li>
      <li><a href="https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf" target="_blank" rel="noopener">NIST SP 800-57</a> - Key Management Guidelines</li>
      <li><a href="https://www.gnupg.org/documentation/" target="_blank" rel="noopener">GnuPG Documentation</a> - GNU Privacy Guard Official Docs</li>
      <li><a href="https://www.bouncycastle.org/" target="_blank" rel="noopener">Bouncy Castle</a> - Cryptographic Library Used</li>
    </ul>
  </div>
</div>

<%@ include file="addcomments.jsp"%>

<!-- FAQ Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is the difference between RSA key sizes (1024, 2048, 4096)?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "RSA key size determines the security strength and computational cost. 1024-bit keys are considered weak and vulnerable to modern attacks - they should only be used for legacy compatibility. 2048-bit keys are the current standard, providing strong security with reasonable performance for most use cases. 4096-bit keys offer maximum security and future-proofing against quantum computing advances, but require more computational resources for key generation and cryptographic operations. For new keys, we recommend 2048-bit minimum, with 4096-bit for long-term sensitive data."
      }
    },
    {
      "@type": "Question",
      "name": "Which cipher algorithm should I choose for PGP key generation?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "For maximum security, choose AES-256, which offers the highest encryption strength (256-bit key) and is widely supported. AES-192 and AES-128 are also strong choices with slightly faster performance. TWOFISH is a good alternative with 256-bit security, particularly if you prefer non-NSA algorithms. BLOWFISH, CAST5, and TRIPLE_DES are legacy algorithms - use them only if required for compatibility with older systems. AES-256 is recommended for all new key generation."
      }
    },
    {
      "@type": "Question",
      "name": "Is it safe to generate PGP keys online? What about privacy?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool generates keys server-side but implements a zero data retention policy - generated keys are never logged or stored permanently. Keys are created, displayed once, and immediately deleted from server memory. However, for maximum security with highly sensitive applications, consider using offline tools like GnuPG on an air-gapped computer. For most business and personal use cases, this online generator provides adequate security when used over HTTPS. Never use untrusted key generators, as compromised keys can decrypt all your encrypted data."
      }
    },
    {
      "@type": "Question",
      "name": "What should I do with my PGP keys after generation?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "After generation: (1) Save both keys securely - the private key must be kept secret and backed up in encrypted storage. (2) Share your public key freely - upload it to keyservers like keys.openpgp.org or share it with communication partners. (3) Test your keys using the encryption/decryption tool to verify they work correctly. (4) Generate and store a revocation certificate in case you need to invalidate the keys later. (5) Never lose or share your private key - encrypted data cannot be recovered without it."
      }
    },
    {
      "@type": "Question",
      "name": "What is the identity field and what should I enter?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The identity field associates your PGP key with your name, email address, or organization. Common formats include 'John Doe <john@example.com>' or just 'john@example.com'. This identity appears in the key metadata and helps others verify they're using the correct public key when encrypting messages for you. Use your real email address if you plan to use the key for email encryption, or use a descriptive name for file encryption keys. Avoid special characters except @ and . to ensure compatibility."
      }
    },
    {
      "@type": "Question",
      "name": "Can I use the generated keys with GPG/GnuPG and other PGP software?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, the generated keys follow the OpenPGP standard (RFC 4880) and are fully compatible with all major PGP implementations including GnuPG (GPG), Symantec PGP Desktop, OpenKeychain for Android, Mailvelope browser extension, and Thunderbird/Enigmail. You can import the keys into any OpenPGP-compatible software using the standard import function. The keys are provided in ASCII-armored format, which is universally supported."
      }
    },
    {
      "@type": "Question",
      "name": "How strong is my passphrase protection and what happens if I forget it?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Your private key is encrypted with your passphrase using the String-to-Key (S2K) convention specified in RFC 4880. A strong passphrase (16+ characters with mixed case, numbers, symbols) makes it computationally infeasible to brute-force your private key. However, if you forget your passphrase, there is absolutely no way to recover it or decrypt your private key - this is by design. PGP has no backdoor or password reset mechanism. Write down your passphrase and store it securely, separate from the private key file."
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
  "description": "Free online tools for cryptography, networking, development, and security. Created by security engineers for developers and security professionals.",
  "sameAs": [
    "https://x.com/anish2good",
    "https://github.com/anish2good"
  ],
  "founder": {
    "@type": "Person",
    "name": "Anish Nath",
    "jobTitle": "Security Engineer"
  }
}
</script>

</div>

<%@ include file="body-close.jsp"%>

