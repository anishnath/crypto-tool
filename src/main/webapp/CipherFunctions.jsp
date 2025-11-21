<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="sun.misc.BASE64Encoder" %>
<%@ page import="sun.misc.BASE64Decoder" %>
<!DOCTYPE html>
<html>
<head>
	<title>Cipher Tool Online – AES, DES, Blowfish & 100+ Algorithms Free | 8gwifi.org</title>

	<!-- JSON-LD markup -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Cipher Tool Online – AES, DES, Blowfish & 100+ Algorithms",
  "alternativeName": "Online Cipher Encryption Decryption Tool",
  "description": "Free online cipher tool supporting 100+ encryption algorithms including AES, DES, Blowfish, Twofish, ChaCha20, Camellia, and more. Test cipher modes (CBC, ECB, GCM, CFB, OFB) with custom keys. Generate random keys, share configurations, and learn cryptography.",
  "url": "https://8gwifi.org/CipherFunctions.jsp",
  "image": "https://8gwifi.org/images/site/cipher.png",
  "applicationCategory": "SecurityApplication",
  "applicationSubCategory": "Encryption Tool",
  "operatingSystem": "Any (Web-based)",
  "browserRequirements": "Requires JavaScript. Works in Chrome, Firefox, Safari, Edge.",
  "datePublished": "2017-09-25",
  "dateModified": "2025-01-21",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock"
  },
  "featureList": [
    "100+ cipher algorithms: AES, DES, Blowfish, Twofish, ChaCha20, Camellia, Serpent",
    "AES encryption (128/192/256-bit) with CBC, GCM, ECB modes",
    "DES and Triple DES (3DES/DESede) encryption",
    "Blowfish and Twofish block ciphers",
    "ChaCha20 stream cipher",
    "Multiple cipher modes: CBC, ECB, GCM, CFB, OFB, CTR",
    "PKCS5Padding and NoPadding options",
    "Custom secret key input (hexadecimal)",
    "Cryptographically secure random key generation",
    "Share configuration via URL",
    "Instant encrypt/decrypt processing",
    "Real-time key length calculator",
    "No registration or login required",
    "Free forever with no limits",
    "Educational cipher algorithm reference",
    "Test encryption implementations",
    "Compare cipher algorithms",
    "JSON response format for automation"
  ],
  "author": {
    "@type": "Person",
    "name": "Anish Nath",
    "url": "https://8gwifi.org",
    "jobTitle": "Security Engineer & Cryptography Specialist",
    "sameAs": "https://twitter.com/anish2good",
    "knowsAbout": [
      "Cryptography",
      "AES Encryption",
      "DES Encryption",
      "Blowfish Cipher",
      "Twofish Cipher",
      "ChaCha20",
      "Cipher Algorithms",
      "Block Ciphers",
      "Stream Ciphers",
      "Symmetric Encryption"
    ]
  },
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org",
    "logo": "https://8gwifi.org/images/logo.png",
    "description": "Free online cryptography, security, and network tools for developers and security professionals.",
    "founder": {
      "@type": "Person",
      "name": "Anish Nath"
    }
  },
  "potentialAction": {
    "@type": "UseAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://8gwifi.org/CipherFunctions.jsp?cipher={cipher}&message={message}&key={key}&operation={operation}",
      "actionPlatform": [
        "http://schema.org/DesktopWebPlatform",
        "http://schema.org/MobileWebPlatform"
      ]
    }
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
      "name": "What cipher algorithms are supported by this online tool?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Over 100 cipher algorithms including AES (128/192/256-bit), DES, Triple DES (3DES/DESede), Blowfish, Twofish, ChaCha20, Serpent, CAST5/6, Camellia, IDEA, RC2/5/6, Rijndael, ARIA, SEED, SM4, and many more. Supports multiple modes (CBC, ECB, GCM, CFB, OFB) with PKCS5Padding and NoPadding options."
      }
    },
    {
      "@type": "Question",
      "name": "Is this cipher tool free to use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, completely free with no registration, login, or payment required. All 100+ cipher algorithms and modes are available at no cost for testing, education, and development purposes. No limits on usage."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between AES CBC and ECB modes?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "CBC (Cipher Block Chaining) mode uses an initialization vector (IV) and chains blocks together, making each encrypted block dependent on previous blocks. This provides better security. ECB (Electronic Codebook) mode encrypts each block independently, which is less secure as identical plaintext blocks produce identical ciphertext. CBC or GCM modes are strongly recommended over ECB."
      }
    },
    {
      "@type": "Question",
      "name": "How do I generate a random encryption key?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Click the 'Generate' button next to the Secret Key field and select your desired key length (128-bit, 192-bit, or 256-bit for AES). The tool uses cryptographically secure random generation (crypto.getRandomValues) to create strong hexadecimal keys suitable for encryption."
      }
    },
    {
      "@type": "Question",
      "name": "Can I share my cipher configuration with others?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, click the 'Share Configuration URL' button to generate a shareable link containing your cipher algorithm, message, and key. Others can open this URL to test with the same configuration. Note: For security, generate new keys for production use after sharing test configurations."
      }
    },
    {
      "@type": "Question",
      "name": "What key length should I use for AES encryption?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "AES-128 (16 bytes/32 hex characters) is sufficient for most applications. AES-192 (24 bytes/48 hex) offers higher security. AES-256 (32 bytes/64 hex) provides maximum security and is recommended for highly sensitive data or long-term protection. All AES key lengths are currently considered secure."
      }
    },
    {
      "@type": "Question",
      "name": "Is this tool suitable for production encryption?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool is designed for testing, education, development, and algorithm comparison. For production encryption, use established cryptography libraries in your programming language (OpenSSL, Bouncy Castle, etc.) with proper key management, secure storage, and industry best practices."
      }
    },
    {
      "@type": "Question",
      "name": "Which cipher algorithm is most secure?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "AES (Advanced Encryption Standard) with 256-bit keys is currently the most widely trusted and secure algorithm for general use. ChaCha20 is an excellent modern alternative, especially for software implementations. Avoid DES (broken) and 3DES (deprecated). For new applications, use AES-GCM or ChaCha20-Poly1305 for authenticated encryption."
      }
    }
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Encrypt and Decrypt Messages with 100+ Cipher Algorithms Online",
  "description": "Step-by-step guide to test cipher encryption and decryption with AES, DES, Blowfish, and other algorithms online for free",
  "totalTime": "PT2M",
  "tool": {
    "@type": "HowToTool",
    "name": "Web browser with JavaScript enabled"
  },
  "step": [
    {
      "@type": "HowToStep",
      "name": "Select cipher algorithm",
      "text": "Choose from 100+ cipher algorithms like AES/CBC/PKCS5PADDING (recommended), AES/GCM, DES, Blowfish, Twofish, or ChaCha20 from the dropdown menu",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Enter your message",
      "text": "Type your plaintext message in the text area to encrypt, or paste Base64/hex ciphertext to decrypt",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Provide or generate secret key",
      "text": "Enter your encryption key in hexadecimal format, or click 'Generate' button to create a cryptographically secure random key (128-bit, 192-bit, or 256-bit for AES)",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Select operation",
      "text": "Choose 'Encrypt' to encrypt your plaintext message, or 'Decrypt' to decrypt ciphertext back to plaintext",
      "position": 4
    },
    {
      "@type": "HowToStep",
      "name": "View encryption result",
      "text": "Click the Encrypt/Decrypt button. The result appears instantly with operation details, original message, encrypted/decrypted output, and technical information (salt, IV for applicable ciphers)",
      "position": 5
    },
    {
      "@type": "HowToStep",
      "name": "Copy or share configuration",
      "text": "Copy the result using the Copy button, or click 'Share Configuration URL' to generate a shareable link for testing and collaboration",
      "position": 6
    }
  ]
}
</script>

	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Free online cipher tool supporting 100+ encryption algorithms including AES, DES, Blowfish, Twofish, ChaCha20. Test cipher modes (CBC, GCM, ECB), generate random keys, and share configurations. Educational encryption/decryption tool for developers." />
	<meta name="keywords" content="cipher tool online, aes encryption online, des encryption, blowfish cipher, encryption tool, decrypt online, aes cbc, aes gcm, twofish, chacha20, cipher algorithm, encryption decryption, crypto tool, test encryption, aes 256, online cipher, free encryption tool" />
	<meta name="author" content="Anish Nath" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>


	<script type="text/javascript">
		$(document).ready(function() {

			// Character counter for message
			function updateCharCount() {
				var count = $('#plaintext').val().length;
				$('#charCount').text(count);
			}

			// Key length calculator
			function updateKeyLength() {
				var key = $('#secretkey').val().trim();
				var hexLength = key.length;
				var byteLength = Math.floor(hexLength / 2);
				$('#keyLength').text(byteLength);
				$('#keyHexLength').text(hexLength);
			}

			// Update button text based on operation
			function updateButtonText() {
				var operation = $('input[name="encryptorDecrypt"]:checked').val();
				if (operation === 'encrypt') {
					$('#submitText').html('Encrypt Message');
				} else {
					$('#submitText').html('Decrypt Message');
				}
			}

			// Load configuration from URL parameters
			function loadFromUrl() {
				var urlParams = new URLSearchParams(window.location.search);

				if (urlParams.has('cipher')) {
					$('#cipherparameternew').val(urlParams.get('cipher'));
				}

				if (urlParams.has('message')) {
					$('#plaintext').val(decodeURIComponent(urlParams.get('message')));
					updateCharCount();
				}

				if (urlParams.has('key')) {
					$('#secretkey').val(urlParams.get('key'));
					updateKeyLength();
				}

				if (urlParams.has('operation')) {
					var operation = urlParams.get('operation');
					if (operation === 'decrypt') {
						$('#decrypt').prop('checked', true);
					} else {
						$('#encrypt').prop('checked', true);
					}
					updateButtonText();
				}

				// Show notification if parameters were loaded
				if (urlParams.has('cipher') || urlParams.has('message') || urlParams.has('key')) {
					var notification = $('<div class="alert alert-info alert-dismissible fade show mt-3" role="alert">' +
						'<i class="fas fa-info-circle"></i> <strong>Configuration loaded from URL</strong>' +
						'<button type="button" class="close" data-dismiss="alert">' +
						'<span>&times;</span></button></div>');
					$('#output').html(notification);
				}
			}

			// Generate shareable URL
			function generateShareUrl() {
				var cipher = $('#cipherparameternew').val();
				var message = $('#plaintext').val();
				var key = $('#secretkey').val();
				var operation = $('input[name="encryptorDecrypt"]:checked').val();

				// Validate that we have content to share
				if (!message && !key) {
					$('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> Please enter a message or secret key to generate a shareable URL.</div>');
					return;
				}

				// Build URL with parameters
				var baseUrl = window.location.origin + window.location.pathname;
				var params = new URLSearchParams();

				params.append('cipher', cipher);
				if (message) {
					params.append('message', encodeURIComponent(message));
				}
				if (key) {
					params.append('key', key);
				}
				params.append('operation', operation);

				var shareUrl = baseUrl + '?' + params.toString();

				// Display the URL
				$('#shareUrl').val(shareUrl);
				$('#shareAlert').slideDown();

				// Scroll to share alert
				$('html, body').animate({
					scrollTop: $('#shareAlert').offset().top - 100
				}, 500);
			}

			// Input validation
			function validateInputs() {
				var plaintext = $('#plaintext').val().trim();
				var secretkey = $('#secretkey').val().trim();

				if (plaintext === '') {
					$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> Message is required</div>');
					return false;
				}

				if (secretkey === '') {
					$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> Secret key is required</div>');
					return false;
				}

				return true;
			}

			// Initialize counters
			updateCharCount();
			updateKeyLength();
			updateButtonText();

			// Load configuration from URL if parameters exist
			loadFromUrl();

			// Update character count on input
			$('#plaintext').on('input', function() {
				updateCharCount();
			});

			// Update key length on input
			$('#secretkey').on('input', function() {
				updateKeyLength();
			});

			// Update button text when operation changes
			$('input[name="encryptorDecrypt"]').change(function() {
				updateButtonText();
			});

			// Share button click handler
			$('#shareButton').click(function() {
				generateShareUrl();
			});

			// Copy share URL button
			$('#copyShareUrl').click(function() {
				var shareUrl = $('#shareUrl').val();
				var tempInput = $('<input>');
				$('body').append(tempInput);
				tempInput.val(shareUrl).select();
				document.execCommand('copy');
				tempInput.remove();

				// Show success feedback
				var originalHtml = $(this).html();
				$(this).html('<i class="fas fa-check"></i> Copied!');
				var btn = $(this);
				setTimeout(function() {
					btn.html(originalHtml);
				}, 2000);
			});

			$('#genkeypair').click(function (event) {
				if (!validateInputs()) {
					return;
				}
				$('#genkeypair').prop('disabled', true);
				$('#form').submit();
			});

			$('#cipherparameternew').change(function(event) {
				if ($('#plaintext').val().trim() !== '' && $('#secretkey').val().trim() !== '') {
					$('#form').delay(200).submit();
				}
			});

			$('#plaintext').keyup(function(event) {
				// Auto-submit removed for better UX
			});

			$('#secretkey').keyup(function(event) {
				// Auto-submit removed for better UX
			});

			$('#encrypt').click(function(event) {
				updateButtonText();
			});

			$('#decrypt').click(function(event) {
				var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
				if (text != null && text.trim() !== '') {
					$("#plaintext").val(text);
					updateCharCount();
				}
				updateButtonText();
			});

			$('#form').submit(function(event) {
				event.preventDefault();
				$('#output').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Processing...</div>');

				$.ajax({
					type : "POST",
					url : "CipherFunctionality",
					data : $("#form").serialize(),
					dataType: 'json',
					success : function(response) {
						$('#output').empty();
						$('#genkeypair').prop('disabled', false);

						if (response.success) {
							// Success case - render result beautifully
							var html = '<div class="card border-success">';
							html += '<div class="card-header bg-success text-white">';
							html += '<i class="fas fa-check-circle"></i> <strong>Operation Successful</strong>';
							html += '</div>';
							html += '<div class="card-body">';

							// Operation details
							html += '<div class="row mb-3">';
							html += '<div class="col-md-4">';
							html += '<p class="mb-1"><strong><i class="fas fa-cog text-primary"></i> Operation:</strong></p>';
							html += '<p class="text-muted">' + response.operation.toUpperCase() + '</p>';
							html += '</div>';
							html += '<div class="col-md-8">';
							html += '<p class="mb-1"><strong><i class="fas fa-lock text-primary"></i> Algorithm:</strong></p>';
							html += '<p class="text-muted"><code>' + response.algorithm + '</code></p>';
							html += '</div>';
							html += '</div>';

							// Original message
							html += '<div class="mb-3">';
							html += '<label class="font-weight-bold"><i class="fas fa-file-alt text-info"></i> Original Message:</label>';
							html += '<textarea class="form-control" readonly rows="2" style="font-family: monospace; font-size: 12px;">' + response.originalMessage + '</textarea>';
							html += '</div>';

							// Result
							html += '<div class="mb-3">';
							html += '<label class="font-weight-bold"><i class="fas fa-check-circle text-success"></i> Result:</label>';
							html += '<textarea id="encrypedmessagetextarea" name="encrypedmessagetextarea" class="form-control" readonly rows="5" style="font-family: monospace; font-size: 12px;">' + response.message + '</textarea>';
							html += '<button type="button" class="btn btn-sm btn-success mt-2" onclick="copyResult()"><i class="fas fa-copy"></i> Copy Result</button>';
							html += '</div>';

							// Salt and IV if present
							if (response.salt) {
								html += '<div class="alert alert-info mb-2">';
								html += '<p class="mb-1"><strong><i class="fas fa-key"></i> 20-bit Salt:</strong></p>';
								html += '<code style="font-size: 11px;">' + response.salt + '</code>';
								html += '</div>';
							}

							if (response.iv) {
								html += '<div class="alert alert-info mb-0">';
								html += '<p class="mb-1"><strong><i class="fas fa-random"></i> 16-bit Initial Vector (IV):</strong></p>';
								html += '<code style="font-size: 11px;">' + response.iv + '</code>';
								html += '</div>';
							}

							html += '</div>';
							html += '</div>';

							$('#output').html(html);
						} else {
							// Error case - render error beautifully
							var html = '<div class="alert alert-danger">';
							html += '<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Operation Failed</h6>';
							html += '<hr>';
							html += '<p class="mb-2"><strong>Error:</strong> ' + response.errorMessage + '</p>';

							if (response.algorithm) {
								html += '<p class="mb-1"><strong>Algorithm:</strong> <code>' + response.algorithm + '</code></p>';
							}

							if (response.operation) {
								html += '<p class="mb-1"><strong>Operation:</strong> ' + response.operation.toUpperCase() + '</p>';
							}

							if (response.originalMessage) {
								html += '<details class="mt-2">';
								html += '<summary style="cursor: pointer;"><strong>Show Input Message</strong></summary>';
								html += '<pre class="mt-2 p-2 bg-light border rounded" style="font-size: 11px;">' + response.originalMessage + '</pre>';
								html += '</details>';
							}

							html += '</div>';
							$('#output').html(html);
						}
					},
					error : function(xhr, status, error) {
						$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Request Failed:</strong> ' + error + '</div>');
						$('#genkeypair').prop('disabled', false);
					}
				});
			});
		});

		// Copy result function
		function copyResult() {
			var result = document.getElementById('encrypedmessagetextarea');
			if (result) {
				result.select();
				document.execCommand('copy');

				// Show success message
				var copyBtn = event.target.closest('button');
				var originalHtml = copyBtn.innerHTML;
				copyBtn.innerHTML = '<i class="fas fa-check"></i> Copied!';
				copyBtn.classList.remove('btn-success');
				copyBtn.classList.add('btn-success');

				setTimeout(function() {
					copyBtn.innerHTML = originalHtml;
				}, 2000);
			}
		}

		// Generate random hexadecimal key
		function generateKey(byteLength) {
			// Generate cryptographically secure random bytes
			var hexChars = '0123456789abcdef';
			var hexKey = '';

			// Use crypto.getRandomValues for secure random generation
			if (window.crypto && window.crypto.getRandomValues) {
				var randomBytes = new Uint8Array(byteLength);
				window.crypto.getRandomValues(randomBytes);

				for (var i = 0; i < randomBytes.length; i++) {
					var byte = randomBytes[i];
					hexKey += hexChars[(byte >> 4) & 0xF];
					hexKey += hexChars[byte & 0xF];
				}
			} else {
				// Fallback to Math.random (less secure, but better than nothing)
				for (var i = 0; i < byteLength * 2; i++) {
					hexKey += hexChars[Math.floor(Math.random() * 16)];
				}
			}

			// Set the generated key
			$('#secretkey').val(hexKey);

			// Update key length display
			updateKeyLength();

			// Show success feedback
			$('#secretkey').effect('highlight', {color: '#d4edda'}, 1000);
		}
	</script>
</head>

<%@ include file="body-script.jsp"%>

<div class="text-center mb-4">
	<h1 class="mb-2">Cipher Tool Online – Test 100+ Encryption Algorithms Free</h1>
	<p class="lead text-muted mb-3">Free cipher encryption tool supporting AES, DES, Blowfish, Twofish, ChaCha20, Camellia & more. Test cipher modes (CBC, GCM, ECB), generate random keys, and share configurations.</p>
	<div class="d-flex justify-content-center flex-wrap">
		<span class="badge badge-success badge-pill px-3 py-2 m-1"><i class="fas fa-shield-alt"></i> 100+ Algorithms</span>
		<span class="badge badge-primary badge-pill px-3 py-2 m-1"><i class="fas fa-lock"></i> AES, DES, Blowfish</span>
		<span class="badge badge-info badge-pill px-3 py-2 m-1"><i class="fas fa-cog"></i> Multiple Modes</span>
		<span class="badge badge-warning badge-pill px-3 py-2 m-1"><i class="fas fa-user-secret"></i> Free & No Login</span>
	</div>
</div>

<!-- Trust Banner -->
<div class="alert alert-light border mb-4">
	<div class="row text-center small">
		<div class="col-md-3 col-6 mb-2 mb-md-0">
			<i class="fas fa-key text-primary"></i> <strong>Custom Keys:</strong> Use your own secret keys
		</div>
		<div class="col-md-3 col-6 mb-2 mb-md-0">
			<i class="fas fa-bolt text-success"></i> <strong>Instant:</strong> Real-time encryption/decryption
		</div>
		<div class="col-md-3 col-6">
			<i class="fas fa-graduation-cap text-info"></i> <strong>Educational:</strong> Learn cipher algorithms
		</div>
		<div class="col-md-3 col-6">
			<i class="fas fa-code text-warning"></i> <strong>Testing:</strong> Test cipher implementations
		</div>
	</div>
</div>



<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<!-- Compact Main Form -->
<div class="card shadow-sm">
	<div class="card-body">
		<h5 class="card-title mb-4"><i class="fas fa-cogs text-primary"></i> Cipher Encryption/Decryption Tool</h5>

<form class="form-horizontal" id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CIPHERBLOCK_NEW">

	<div class="row">
		<!-- Left Column: Cipher Selection & Message -->
		<div class="col-md-6">
			<div class="form-group">
				<label for="cipherparameternew"><i class="fas fa-list-ul text-primary"></i> Cipher Algorithm <span class="text-danger">*</span></label>
				<select name="cipherparameternew" id="cipherparameternew" class="form-control" style="font-family: monospace; font-size: 13px;">
					<option selected value="<%="AES/CBC/PKCS5PADDING"%>">AES/CBC/PKCS5PADDING</option>
					<%
						String[] validList = { "AES","AES/CBC/NOPADDING","AES/ECB/NOPADDING","AES/ECB/PKCS5PADDING","AES_128/CBC/NOPADDING","AES_128/CFB/NOPADDING","AES_128/ECB/NOPADDING","AES_128/GCM/NOPADDING","AES_128/OFB/NOPADDING","AES_192/CBC/NOPADDING","AES_192/CFB/NOPADDING","AES_192/ECB/NOPADDING","AES_192/GCM/NOPADDING","AES_192/OFB/NOPADDING","AES_256/CBC/NOPADDING","AES_256/CFB/NOPADDING","AES_256/ECB/NOPADDING","AES_256/GCM/NOPADDING","AES_256/OFB/NOPADDING","ARIA","BLOWFISH","CAMELLIA","CAST5","CAST6","CHACHA","DES","DES/CBC/NOPADDING","DES/CBC/PKCS5PADDING","DES/ECB/NOPADDING","DES/ECB/PKCS5PADDING","DESEDE","DESEDE/CBC/NOPADDING","DESEDE/CBC/PKCS5PADDING","DESEDE/ECB/NOPADDING","DESEDE/ECB/PKCS5PADDING","GCM","GOST28147","GRAIN128","GRAINV1","HC128","HC256","IDEA","NOEKEON","PBEWITHMD2ANDDES","PBEWITHMD5AND128BITAES-CBC-OPENSSL","PBEWITHMD5AND192BITAES-CBC-OPENSSL","PBEWITHMD5AND256BITAES-CBC-OPENSSL","PBEWITHMD5ANDDES","PBEWITHMD5ANDRC2","PBEWITHSHA1ANDDES","PBEWITHSHA1ANDRC2","PBEWITHSHA256AND128BITAES-CBC-BC","PBEWITHSHA256AND192BITAES-CBC-BC","PBEWITHSHA256AND256BITAES-CBC-BC","PBEWITHSHAAND128BITAES-CBC-BC","PBEWITHSHAAND128BITRC2-CBC","PBEWITHSHAAND128BITRC4","PBEWITHSHAAND192BITAES-CBC-BC","PBEWITHSHAAND2-KEYTRIPLEDES-CBC","PBEWITHSHAAND256BITAES-CBC-BC","PBEWITHSHAAND3-KEYTRIPLEDES-CBC","PBEWITHSHAAND40BITRC2-CBC","PBEWITHSHAAND40BITRC4","PBEWITHSHAANDIDEA-CBC","PBEWITHSHAANDTWOFISH-CBC","PBEWITHHMACSHA1ANDAES_128","PBEWITHHMACSHA1ANDAES_256","PBEWITHHMACSHA224ANDAES_128","PBEWITHHMACSHA224ANDAES_256","PBEWITHHMACSHA256ANDAES_128","PBEWITHHMACSHA256ANDAES_256","PBEWITHHMACSHA384ANDAES_128","PBEWITHHMACSHA384ANDAES_256","PBEWITHHMACSHA512ANDAES_128","PBEWITHHMACSHA512ANDAES_256","PBEWITHMD5ANDDES","PBEWITHMD5ANDTRIPLEDES","PBEWITHSHA1ANDDESEDE","PBEWITHSHA1ANDRC2_128","PBEWITHSHA1ANDRC2_40","PBEWITHSHA1ANDRC4_128","PBEWITHSHA1ANDRC4_40","RC2","RC5","RC6","RIJNDAEL","SALSA20","SEED","SHACAL-2","SKIPJACK","SM4","SERPENT","SHACAL2","TEA","THREEFISH-1024","THREEFISH-256","THREEFISH-512","TNEPRES","TWOFISH","VMPC","VMPC-KSA3","XTEA" };
						for (int i = 0; i < validList.length; i++) {
							String param = validList[i];
					%>
					<option value="<%=param%>"><%=param%></option>
					<%	} %>
				</select>
			</div>

			<div class="form-group">
				<label for="plaintext"><i class="fas fa-file-alt text-success"></i> Message <span class="text-danger">*</span></label>
				<small class="form-text text-muted mb-2">Plaintext to encrypt or Base64/hex to decrypt</small>
				<textarea class="form-control" rows="6" name="plaintext" placeholder="Type your message here..." id="plaintext" style="font-family: monospace; font-size: 13px;"></textarea>
				<small class="form-text text-muted"><span id="charCount">0</span> characters</small>
			</div>
		</div>

		<!-- Right Column: Secret Key & Operation -->
		<div class="col-md-6">
			<div class="form-group">
				<label for="secretkey"><i class="fas fa-key text-warning"></i> Secret Key (Hex) <span class="text-danger">*</span></label>
				<small class="form-text text-muted mb-2">
					<i class="fas fa-info-circle"></i> AES-128: 32 hex | AES-192: 48 hex | AES-256: 64 hex
				</small>
				<div class="input-group">
					<input type="text" class="form-control" name="secretkey" id="secretkey" placeholder="2b7e151628aed2a6abf71589" value="2b7e151628aed2a6abf71589" style="font-family: monospace; font-size: 13px;">
					<div class="input-group-append">
						<button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<i class="fas fa-random"></i> Generate
						</button>
						<div class="dropdown-menu dropdown-menu-right">
							<a class="dropdown-item" href="#" onclick="generateKey(16); return false;">
								<i class="fas fa-key"></i> 128-bit (32 hex chars)
							</a>
							<a class="dropdown-item" href="#" onclick="generateKey(24); return false;">
								<i class="fas fa-key"></i> 192-bit (48 hex chars)
							</a>
							<a class="dropdown-item" href="#" onclick="generateKey(32); return false;">
								<i class="fas fa-key"></i> 256-bit (64 hex chars)
							</a>
							<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="#" onclick="generateKey(8); return false;">
								<i class="fas fa-key"></i> 64-bit (16 hex chars) - DES
							</a>
						</div>
					</div>
				</div>
				<small class="form-text text-muted">Length: <span id="keyLength">24</span> bytes (<span id="keyHexLength">48</span> hex chars)</small>
			</div>

			<div class="form-group">
				<label><i class="fas fa-exchange-alt text-info"></i> Operation</label>
				<div>
					<div class="custom-control custom-radio custom-control-inline">
						<input checked="checked" class="custom-control-input" id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">
						<label class="custom-control-label" for="encrypt"><i class="fas fa-lock"></i> Encrypt</label>
					</div>
					<div class="custom-control custom-radio custom-control-inline">
						<input class="custom-control-input" id="decrypt" type="radio" name="encryptorDecrypt" value="decrypt">
						<label class="custom-control-label" for="decrypt"><i class="fas fa-unlock"></i> Decrypt</label>
					</div>
				</div>
			</div>

			<!-- Quick Tips Box -->
			<div class="alert alert-light border" style="font-size: 13px;">
				<strong><i class="fas fa-lightbulb text-warning"></i> Quick Tips:</strong>
				<ul class="mb-0 mt-2 pl-3" style="font-size: 12px;">
					<li><strong>CBC/GCM:</strong> Recommended for security</li>
					<li><strong>ECB:</strong> Not recommended (insecure)</li>
					<li><strong>Key format:</strong> Hexadecimal only</li>
					<li><strong>DES:</strong> Obsolete, use AES</li>
				</ul>
			</div>

			<button class="btn btn-primary btn-lg btn-block mt-3" type="button" id="genkeypair" name="submit" style="border-radius: 8px;">
				<i class="fas fa-play-circle"></i> <span id="submitText">Encrypt Message</span>
			</button>

			<button class="btn btn-outline-info btn-block mt-2" type="button" id="shareButton" style="border-radius: 8px;">
				<i class="fas fa-share-alt"></i> Share Configuration URL
			</button>
		</div>
	</div>

	<!-- Share URL Modal/Alert -->
	<div id="shareAlert" class="alert alert-success mt-3" style="display: none;">
		<h6 class="alert-heading"><i class="fas fa-link"></i> Shareable URL Generated</h6>
		<hr>
		<div class="input-group">
			<input type="text" class="form-control" id="shareUrl" readonly style="font-family: monospace; font-size: 12px;">
			<div class="input-group-append">
				<button class="btn btn-success" type="button" id="copyShareUrl">
					<i class="fas fa-copy"></i> Copy
				</button>
			</div>
		</div>
		<small class="text-muted mt-2 d-block">
			<i class="fas fa-info-circle"></i> Share this URL to let others test with the same configuration (cipher, key, and message).
		</small>
	</div>

	<div id="output" class="mt-4"></div>

</form>
	</div>
</div>

<!-- Common Use Cases Section -->
<div class="card shadow-sm mb-4 mt-4">
	<div class="card-body">
		<h5 class="card-title mb-3"><i class="fas fa-lightbulb text-warning"></i> Common Use Cases</h5>
		<div class="row">
			<div class="col-md-6">
				<ul class="list-unstyled">
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Learning Cryptography:</strong> Understand how different cipher algorithms work</li>
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Testing Implementations:</strong> Verify your encryption/decryption code</li>
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Algorithm Comparison:</strong> Compare output of different cipher modes</li>
				</ul>
			</div>
			<div class="col-md-6">
				<ul class="list-unstyled">
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Development:</strong> Quick testing during cipher integration</li>
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Security Research:</strong> Analyze cipher behavior and patterns</li>
					<li class="mb-2"><i class="fas fa-check-circle text-success"></i> <strong>Educational Projects:</strong> Demonstrate encryption concepts</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- Key Features Section -->
<div class="card shadow-sm mb-4">
	<div class="card-body">
		<h5 class="card-title mb-3"><i class="fas fa-star text-primary"></i> Key Features</h5>
		<div class="row">
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-shield-alt text-primary mr-2 mt-1"></i>
					<div>
						<strong>100+ Algorithms</strong>
						<p class="text-muted small mb-0">AES, DES, Blowfish, Twofish, Serpent, CAST, Camellia, and many more</p>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-cog text-success mr-2 mt-1"></i>
					<div>
						<strong>Multiple Modes</strong>
						<p class="text-muted small mb-0">CBC, ECB, GCM, CFB, OFB with PKCS5Padding or NoPadding</p>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-key text-info mr-2 mt-1"></i>
					<div>
						<strong>Custom Keys</strong>
						<p class="text-muted small mb-0">Use your own secret keys in hexadecimal format</p>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-bolt text-warning mr-2 mt-1"></i>
					<div>
						<strong>Instant Results</strong>
						<p class="text-muted small mb-0">Real-time encryption and decryption processing</p>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-graduation-cap text-primary mr-2 mt-1"></i>
					<div>
						<strong>Educational</strong>
						<p class="text-muted small mb-0">Learn cipher algorithms and cryptographic concepts</p>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="d-flex align-items-start">
					<i class="fas fa-gift text-success mr-2 mt-1"></i>
					<div>
						<strong>Free Forever</strong>
						<p class="text-muted small mb-0">No registration, no limits, completely free</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- About the Developer E-E-A-T Section -->
<div class="card shadow-sm mb-4 border-primary">
	<div class="card-body">
		<div class="row align-items-center">
			<div class="col-md-8">
				<h5 class="card-title mb-2"><i class="fas fa-user-shield text-primary"></i> About the Developer</h5>
				<p class="mb-2">
					<strong>Anish Nath</strong> – Security Engineer & Cryptography Specialist
					<a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="ml-2">
						<i class="fab fa-twitter text-primary"></i> @anish2good
					</a>
				</p>
				<div class="d-flex flex-wrap">
					<span class="badge badge-primary mr-2 mb-2"><i class="fas fa-shield-alt"></i> Cryptography</span>
					<span class="badge badge-primary mr-2 mb-2"><i class="fas fa-lock"></i> Cipher Algorithms</span>
					<span class="badge badge-primary mr-2 mb-2"><i class="fas fa-code"></i> Security Engineering</span>
					<span class="badge badge-primary mr-2 mb-2"><i class="fas fa-key"></i> AES & DES Expert</span>
					<span class="badge badge-primary mr-2 mb-2"><i class="fas fa-laptop-code"></i> Block Ciphers</span>
				</div>
			</div>
			<div class="col-md-4 text-center">
				<div class="bg-light p-3 rounded">
					<i class="fas fa-tools fa-3x text-primary mb-2"></i>
					<p class="small text-muted mb-0">Creator of 8gwifi.org cryptography tools</p>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Why Trust This Tool Section -->
<div class="card shadow-sm mb-4 bg-light">
	<div class="card-body">
		<h5 class="card-title mb-3"><i class="fas fa-check-circle text-success"></i> Why Trust This Tool?</h5>
		<div class="row">
			<div class="col-md-4 mb-3">
				<div class="text-center">
					<i class="fas fa-code fa-2x text-primary mb-2"></i>
					<h6>100+ Algorithms</h6>
					<p class="small text-muted mb-0">Comprehensive cipher support including AES, DES, Blowfish, Twofish, Serpent, and many more with various modes and padding options.</p>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="text-center">
					<i class="fas fa-graduation-cap fa-2x text-success mb-2"></i>
					<h6>Educational Focus</h6>
					<p class="small text-muted mb-0">Designed for learning and testing. Perfect for students, developers, and security researchers exploring cryptography.</p>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="text-center">
					<i class="fas fa-gift fa-2x text-warning mb-2"></i>
					<h6>Always Free</h6>
					<p class="small text-muted mb-0">No registration, no hidden fees, no limits. All cipher algorithms and modes available at no cost.</p>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- How It Works Section -->
<div class="card shadow-sm mb-4">
	<div class="card-body">
		<h5 class="card-title mb-3"><i class="fas fa-info-circle text-info"></i> How It Works</h5>
		<div class="row">
			<div class="col-md-3 col-6 mb-3">
				<div class="text-center">
					<div class="bg-light p-3 rounded">
						<i class="fas fa-list-ul fa-2x text-primary mb-2"></i>
						<h6 class="mb-1">1. Select Cipher</h6>
						<p class="small text-muted mb-0">Choose from 100+ algorithms</p>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-6 mb-3">
				<div class="text-center">
					<div class="bg-light p-3 rounded">
						<i class="fas fa-keyboard fa-2x text-success mb-2"></i>
						<h6 class="mb-1">2. Enter Message</h6>
						<p class="small text-muted mb-0">Type your plaintext</p>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-6 mb-3">
				<div class="text-center">
					<div class="bg-light p-3 rounded">
						<i class="fas fa-key fa-2x text-warning mb-2"></i>
						<h6 class="mb-1">3. Provide Key</h6>
						<p class="small text-muted mb-0">Hex format secret key</p>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-6 mb-3">
				<div class="text-center">
					<div class="bg-light p-3 rounded">
						<i class="fas fa-lock fa-2x text-info mb-2"></i>
						<h6 class="mb-1">4. Encrypt/Decrypt</h6>
						<p class="small text-muted mb-0">Get instant results</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Cipher Modes & Best Practices -->
<div class="card shadow-sm mb-4 bg-light">
	<div class="card-body">
		<h5 class="card-title mb-3"><i class="fas fa-lightbulb text-warning"></i> Cipher Modes & Best Practices</h5>
		<div class="row">
			<div class="col-md-6">
				<h6 class="text-success"><i class="fas fa-check-circle"></i> Recommended Modes:</h6>
				<ul class="small">
					<li><strong>CBC (Cipher Block Chaining):</strong> Good security, uses IV for randomization</li>
					<li><strong>GCM (Galois/Counter Mode):</strong> Authenticated encryption, best for new applications</li>
					<li><strong>CFB/OFB:</strong> Stream cipher modes, good for streaming data</li>
					<li><strong>CTR (Counter Mode):</strong> Parallelizable, good performance</li>
				</ul>
			</div>
			<div class="col-md-6">
				<h6 class="text-danger"><i class="fas fa-exclamation-triangle"></i> Not Recommended:</h6>
				<ul class="small">
					<li><strong>ECB (Electronic Codebook):</strong> Insecure! Identical blocks produce identical ciphertext, revealing patterns</li>
					<li><strong>DES:</strong> Obsolete 56-bit key, easily broken. Use AES instead</li>
					<li><strong>RC4:</strong> Known vulnerabilities, deprecated</li>
					<li><strong>NOPADDING with non-block-size data:</strong> Will fail, use PKCS5Padding</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="cipher-functions-writeups.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<%@ include file="addcomments.jsp"%>

</div>

<script type="text/javascript">

	<%

        String text = (String)request.getParameter("text");
        String pass = (String)request.getParameter("pass");
        String cipherparam = (String)request.getParameter("cipherparam");
        String mode = (String)request.getParameter("mode");


        if(null == cipherparam || cipherparam.trim().length()==0)
        {
            cipherparam="AES/CBC/PKCS5PADDING";
        }

        if (text!=null & pass!=null & mode!=null )
        {

			text = text.replace(" ","+");
			pass = pass.replace(" ","+");


			pass = new String(new BASE64Decoder().decodeBuffer(pass));


            if("decrypt".equalsIgnoreCase(mode.trim()))
            {



    %>

					document.getElementById("plaintext").value = "<%=text%>";
					document.getElementById("decrypt").checked = true;
					document.getElementById("secretkey").value = "<%=pass%>";

	         <%
					String[] validList2 = { "AES/CBC/PKCS5PADDING", "AES","AES/CBC/NOPADDING","AES/ECB/NOPADDING","AES/ECB/PKCS5PADDING","AES_128/CBC/NOPADDING","AES_128/CFB/NOPADDING","AES_128/ECB/NOPADDING","AES_128/GCM/NOPADDING","AES_128/OFB/NOPADDING","AES_192/CBC/NOPADDING","AES_192/CFB/NOPADDING","AES_192/ECB/NOPADDING","AES_192/GCM/NOPADDING","AES_192/OFB/NOPADDING","AES_256/CBC/NOPADDING","AES_256/CFB/NOPADDING","AES_256/ECB/NOPADDING","AES_256/GCM/NOPADDING","AES_256/OFB/NOPADDING","ARIA","BLOWFISH","CAMELLIA","CAST5","CAST6","CHACHA","DES","DES/CBC/NOPADDING","DES/CBC/PKCS5PADDING","DES/ECB/NOPADDING","DES/ECB/PKCS5PADDING","DESEDE","DESEDE/CBC/NOPADDING","DESEDE/CBC/PKCS5PADDING","DESEDE/ECB/NOPADDING","DESEDE/ECB/PKCS5PADDING","GCM","GOST28147","GRAIN128","GRAINV1","HC128","HC256","IDEA","NOEKEON","PBEWITHMD2ANDDES","PBEWITHMD5AND128BITAES-CBC-OPENSSL","PBEWITHMD5AND192BITAES-CBC-OPENSSL","PBEWITHMD5AND256BITAES-CBC-OPENSSL","PBEWITHMD5ANDDES","PBEWITHMD5ANDRC2","PBEWITHSHA1ANDDES","PBEWITHSHA1ANDRC2","PBEWITHSHA256AND128BITAES-CBC-BC","PBEWITHSHA256AND192BITAES-CBC-BC","PBEWITHSHA256AND256BITAES-CBC-BC","PBEWITHSHAAND128BITAES-CBC-BC","PBEWITHSHAAND128BITRC2-CBC","PBEWITHSHAAND128BITRC4","PBEWITHSHAAND192BITAES-CBC-BC","PBEWITHSHAAND2-KEYTRIPLEDES-CBC","PBEWITHSHAAND256BITAES-CBC-BC","PBEWITHSHAAND3-KEYTRIPLEDES-CBC","PBEWITHSHAAND40BITRC2-CBC","PBEWITHSHAAND40BITRC4","PBEWITHSHAANDIDEA-CBC","PBEWITHSHAANDTWOFISH-CBC","PBEWITHHMACSHA1ANDAES_128","PBEWITHHMACSHA1ANDAES_256","PBEWITHHMACSHA224ANDAES_128","PBEWITHHMACSHA224ANDAES_256","PBEWITHHMACSHA256ANDAES_128","PBEWITHHMACSHA256ANDAES_256","PBEWITHHMACSHA384ANDAES_128","PBEWITHHMACSHA384ANDAES_256","PBEWITHHMACSHA512ANDAES_128","PBEWITHHMACSHA512ANDAES_256","PBEWITHMD5ANDDES","PBEWITHMD5ANDTRIPLEDES","PBEWITHSHA1ANDDESEDE","PBEWITHSHA1ANDRC2_128","PBEWITHSHA1ANDRC2_40","PBEWITHSHA1ANDRC4_128","PBEWITHSHA1ANDRC4_40","RC2","RC5","RC6","RIJNDAEL","SALSA20","SEED","SHACAL-2","SKIPJACK","SM4","SERPENT","SHACAL2","TEA","THREEFISH-1024","THREEFISH-256","THREEFISH-512","TNEPRES","TWOFISH","VMPC","VMPC-KSA3","XTEA" };
					for (int i = 0; i < validList2.length; i++) {
						String param = validList2[i];
						if(cipherparam.equalsIgnoreCase(param))
						{

			%>
						document.getElementById("cipherparameternew").selectedIndex = <%=i%>

				<%
                       } // End IF
                       }  // End for
               %>


	<%--$("#plaintext").val('<%=text%>');--%>
	<%--$("#cipherparameternew").val('<%=cipherparam%>');--%>
	<%--$("#decrypt").val('decrypt');--%>
	<%--$("#secretkey").val('<%=pass%>');--%>


	//document.getElementById("form").submit();

	<%
            }

             if("encrypt".equalsIgnoreCase(mode.trim()))
            {

             %>


            	document.getElementById("plaintext").value = '<%=text%>'
				document.getElementById("encrypt").checked = true;
				document.getElementById("secretkey").value = '<%=pass%>';

	<%
       String[] validList2 = { "AES/CBC/PKCS5PADDING", "AES","AES/CBC/NOPADDING","AES/ECB/NOPADDING","AES/ECB/PKCS5PADDING","AES_128/CBC/NOPADDING","AES_128/CFB/NOPADDING","AES_128/ECB/NOPADDING","AES_128/GCM/NOPADDING","AES_128/OFB/NOPADDING","AES_192/CBC/NOPADDING","AES_192/CFB/NOPADDING","AES_192/ECB/NOPADDING","AES_192/GCM/NOPADDING","AES_192/OFB/NOPADDING","AES_256/CBC/NOPADDING","AES_256/CFB/NOPADDING","AES_256/ECB/NOPADDING","AES_256/GCM/NOPADDING","AES_256/OFB/NOPADDING","ARIA","BLOWFISH","CAMELLIA","CAST5","CAST6","CHACHA","DES","DES/CBC/NOPADDING","DES/CBC/PKCS5PADDING","DES/ECB/NOPADDING","DES/ECB/PKCS5PADDING","DESEDE","DESEDE/CBC/NOPADDING","DESEDE/CBC/PKCS5PADDING","DESEDE/ECB/NOPADDING","DESEDE/ECB/PKCS5PADDING","GCM","GOST28147","GRAIN128","GRAINV1","HC128","HC256","IDEA","NOEKEON","PBEWITHMD2ANDDES","PBEWITHMD5AND128BITAES-CBC-OPENSSL","PBEWITHMD5AND192BITAES-CBC-OPENSSL","PBEWITHMD5AND256BITAES-CBC-OPENSSL","PBEWITHMD5ANDDES","PBEWITHMD5ANDRC2","PBEWITHSHA1ANDDES","PBEWITHSHA1ANDRC2","PBEWITHSHA256AND128BITAES-CBC-BC","PBEWITHSHA256AND192BITAES-CBC-BC","PBEWITHSHA256AND256BITAES-CBC-BC","PBEWITHSHAAND128BITAES-CBC-BC","PBEWITHSHAAND128BITRC2-CBC","PBEWITHSHAAND128BITRC4","PBEWITHSHAAND192BITAES-CBC-BC","PBEWITHSHAAND2-KEYTRIPLEDES-CBC","PBEWITHSHAAND256BITAES-CBC-BC","PBEWITHSHAAND3-KEYTRIPLEDES-CBC","PBEWITHSHAAND40BITRC2-CBC","PBEWITHSHAAND40BITRC4","PBEWITHSHAANDIDEA-CBC","PBEWITHSHAANDTWOFISH-CBC","PBEWITHHMACSHA1ANDAES_128","PBEWITHHMACSHA1ANDAES_256","PBEWITHHMACSHA224ANDAES_128","PBEWITHHMACSHA224ANDAES_256","PBEWITHHMACSHA256ANDAES_128","PBEWITHHMACSHA256ANDAES_256","PBEWITHHMACSHA384ANDAES_128","PBEWITHHMACSHA384ANDAES_256","PBEWITHHMACSHA512ANDAES_128","PBEWITHHMACSHA512ANDAES_256","PBEWITHMD5ANDDES","PBEWITHMD5ANDTRIPLEDES","PBEWITHSHA1ANDDESEDE","PBEWITHSHA1ANDRC2_128","PBEWITHSHA1ANDRC2_40","PBEWITHSHA1ANDRC4_128","PBEWITHSHA1ANDRC4_40","RC2","RC5","RC6","RIJNDAEL","SALSA20","SEED","SHACAL-2","SKIPJACK","SM4","SERPENT","SHACAL2","TEA","THREEFISH-1024","THREEFISH-256","THREEFISH-512","TNEPRES","TWOFISH","VMPC","VMPC-KSA3","XTEA" };
       for (int i = 0; i < validList2.length; i++) {
           String param = validList2[i];
           if(cipherparam.equalsIgnoreCase(param))
           {

%>
	document.getElementById("cipherparameternew").selectedIndex = <%=i%>

	<%
           } // End IF
           }  // End for
   %>


	<%   }


   }


%>

</script>

<%@ include file="body-close.jsp"%>

