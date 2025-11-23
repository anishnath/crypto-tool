<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.pgppojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<!DOCTYPE html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Enhanced JSON-LD structured data -->
	<script type="application/ld+json">
	{
	  "@context": "https://schema.org",
	  "@type": "WebApplication",
	  "name": "RSA Encryption Tool Online – Generate RSA Keys & Encrypt/Decrypt",
	  "alternativeName": "Online RSA Key Generator and Encryption Tool",
	  "description": "Free online RSA encryption and decryption tool. Generate RSA key pairs (512, 1024, 2048, 4096-bit), perform RSA encryption and decryption with multiple cipher modes including PKCS1Padding and OAEP. No registration required.",
	  "url": "https://8gwifi.org/rsafunctions.jsp",
	  "image": "https://8gwifi.org/images/site/rsa.png",
	  "applicationCategory": "UtilityApplication",
	  "applicationSubCategory": "Cryptography Tool",
	  "operatingSystem": "Any (Web-based)",
	  "browserRequirements": "Requires JavaScript",
	  "datePublished": "2017-09-25",
	  "dateModified": "2025-01-21",
	  "offers": {
	    "@type": "Offer",
	    "price": "0",
	    "priceCurrency": "USD",
	    "availability": "https://schema.org/InStock"
	  },
	  "featureList": [
	    "Generate RSA key pairs (512, 1024, 2048, 4096-bit)",
	    "RSA encryption with public key",
	    "RSA decryption with private key",
	    "Multiple RSA cipher modes",
	    "OAEP padding support",
	    "PEM format key output",
	    "Base64 encoded output",
	    "Copy keys and results to clipboard",
	    "Real-time encryption and decryption",
	    "No registration required",
	    "Free forever"
	  ],
	  "author": {
	    "@type": "Person",
	    "name": "Anish Nath",
	    "url": "https://8gwifi.org",
	    "jobTitle": "Security Engineer",
	    "sameAs": "https://twitter.com/anish2good"
	  },
	  "provider": {
	    "@type": "Organization",
	    "name": "8gwifi.org",
	    "url": "https://8gwifi.org"
	  }
	}
	</script>

	<!-- FAQPage Schema -->
	<script type="application/ld+json">
	{
	  "@context": "https://schema.org",
	  "@type": "FAQPage",
	  "mainEntity": [
	    {
	      "@type": "Question",
	      "name": "What is RSA encryption?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "RSA encryption is an asymmetric cryptography algorithm that uses two keys: a public key for encryption and a private key for decryption. Named after its inventors Rivest, Shamir, and Adleman, RSA is widely used for secure data transmission and digital signatures."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "How do I generate RSA keys online?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "Select your desired key size (512, 1024, 2048, or 4096 bits) using the key size buttons. The tool automatically generates a new RSA key pair with both public and private keys in PEM format. Keys are stored in your session for the current encryption/decryption operations."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "What RSA cipher modes are supported?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "This tool supports multiple RSA cipher modes including RSA, RSA/ECB/PKCS1Padding, RSA/None/PKCS1Padding, RSA/NONE/OAEPWithSHA1AndMGF1Padding, RSA/ECB/OAEPWithSHA-1AndMGF1Padding, and RSA/ECB/OAEPWithSHA-256AndMGF1Padding. OAEP padding provides enhanced security compared to PKCS1Padding."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "What's the maximum message size for RSA encryption?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "The maximum message size depends on the key size and padding scheme. For 1024-bit keys with PKCS1Padding, you can encrypt up to 117 bytes. For 2048-bit keys, the limit is 245 bytes. For larger messages, use hybrid encryption (RSA for key exchange, AES for data)."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "Is this RSA encryption tool secure?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "All encryption and decryption operations are performed in your browser or on our secure server without storing your keys or messages. We recommend using 2048-bit or 4096-bit keys for production use. For highly sensitive data, consider using this tool offline or generating keys locally."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "Can I decrypt a message with the public key?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "No, RSA decryption requires the private key. The public key is used only for encryption. This asymmetric property is fundamental to RSA and enables secure communication where anyone can encrypt messages using your public key, but only you can decrypt them with your private key."
	      }
	    }
	  ]
	}
	</script>

	<!-- HowTo Schema -->
	<script type="application/ld+json">
	{
	  "@context": "https://schema.org",
	  "@type": "HowTo",
	  "name": "How to Encrypt and Decrypt Messages with RSA",
	  "description": "Step-by-step guide to encrypting and decrypting messages using RSA encryption with this online tool.",
	  "image": "https://8gwifi.org/images/site/rsa.png",
	  "totalTime": "PT2M",
	  "step": [
	    {
	      "@type": "HowToStep",
	      "position": 1,
	      "name": "Select Key Size",
	      "text": "Choose your desired RSA key size (512, 1024, 2048, or 4096 bits). For production use, select 2048-bit or higher for adequate security.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click on one of the key size buttons (512, 1024, 2048, or 4096) in the Configuration section."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 2,
	      "name": "Choose Operation and Cipher Mode",
	      "text": "Select whether you want to encrypt or decrypt, then choose the RSA cipher mode. OAEP padding modes provide better security than PKCS1Padding.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click the Encrypt or Decrypt button, then select a cipher mode from the dropdown (e.g., RSA/ECB/PKCS1Padding or RSA/ECB/OAEPWithSHA-256AndMGF1Padding)."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 3,
	      "name": "Enter Your Message",
	      "text": "Type or paste your message in the message textarea. For encryption, enter plain text. For decryption, enter the Base64-encoded ciphertext.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Type your message in the Message textarea. Remember the size limits: 117 bytes for 1024-bit keys, 245 bytes for 2048-bit keys."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 4,
	      "name": "Process and View Results",
	      "text": "Click the Process button to encrypt or decrypt your message. The result will appear in the Result section with the encrypted/decrypted output, algorithm details, and a copy button.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click the blue Process button. Your result will appear in the right column with operation details and a Copy button to easily copy the result to your clipboard."
	      }
	    }
	  ]
	}
	</script>

	<title>RSA Encryption Tool Online – Generate RSA Keys & Encrypt/Decrypt | 8gwifi.org</title>
	<meta name="keywords" content="rsa encryption online, rsa decryption online, online rsa key generator, rsa key pair generator, rsa encrypt decrypt, RSA/ECB/PKCS1Padding, RSA/OAEP, rsa public key, rsa private key">
	<meta name="description" content="Free online RSA encryption and decryption tool. Generate RSA key pairs (512, 1024, 2048, 4096-bit), encrypt and decrypt messages with RSA/ECB/PKCS1Padding, OAEP padding. No registration required.">
	<meta name="robots" content="index,follow">
	<meta name="googlebot" content="index,follow">

	<%@ include file="header-script.jsp"%>
	<%@ include file="pgp-menu-nav.jsp"%>

	<%
		String pubKey = "";
		String privKey = "";
		String checkedKey="1024";
		boolean k1=false;
		boolean k2=false;
		boolean k3=false;
		boolean k4=false;

		if (request.getSession().getAttribute("pubkey")==null) {
			Gson gson = new Gson();
			DefaultHttpClient httpClient = new DefaultHttpClient();
			String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/" + 1024;

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
			pgppojo pgppojo = (pgppojo) gson.fromJson(content.toString(), pgppojo.class);

			pubKey = pgppojo.getPubliceKey();
			privKey = pgppojo.getPrivateKey();
			checkedKey = "1024";
		}
		else {
			pubKey = (String)request.getSession().getAttribute("pubkey");
			privKey = (String)request.getSession().getAttribute("privKey");
			checkedKey = (String)request.getSession().getAttribute("keysize");
			// Default to 1024 if session keysize is null or invalid
			if (checkedKey == null || checkedKey.isEmpty()) {
				checkedKey = "1024";
			}
		}

		if("512".equals(checkedKey)) { k1=true; }
		if("1024".equals(checkedKey)) { k2=true; }
		if("2048".equals(checkedKey)) { k3=true; }
		if("4096".equals(checkedKey)) { k4=true; }
	%>

</head>

<%@ include file="body-script.jsp"%>

<div class="container-fluid">
	<div class="row">
		<div class="col-12">
			<!-- Compact Header -->
			<h1 class="mb-1">RSA Encryption Tool <small class="text-muted">Encrypt & Decrypt Messages</small></h1>
			<hr class="mt-2 mb-3">

		<div class="row">
			<!-- LEFT: Configuration & Input -->
			<div class="col-lg-4">
				<div class="card mb-3">
					<div class="card-header bg-dark text-white py-2">
						<strong><i class="fas fa-cog"></i> Configuration</strong>
					</div>
					<div class="card-body p-3">
						<!-- Key Size -->
						<form id="keySizeForm" method="GET" action="RSAFunctionality?q=setNeKey">
							<label class="mb-2"><strong>Key Size:</strong></label>
							<div class="btn-group btn-block mb-2" data-toggle="buttons" role="group">
								<label class="btn btn-outline-secondary py-2 <% if(k1) { %>active<% } %>">
									<input type="radio" id="keysize1" name="keysize" value="512" <% if(k1) { %>checked<% } %>> 512
								</label>
								<label class="btn btn-outline-secondary py-2 <% if(k2) { %>active<% } %>">
									<input type="radio" id="keysize2" name="keysize" value="1024" <% if(k2) { %>checked<% } %>> 1024
								</label>
								<label class="btn btn-outline-secondary py-2 <% if(k3) { %>active<% } %>">
									<input type="radio" id="keysize3" name="keysize" value="2048" <% if(k3) { %>checked<% } %>> 2048
								</label>
								<label class="btn btn-outline-secondary py-2 <% if(k4) { %>active<% } %>">
									<input type="radio" id="keysize4" name="keysize" value="4096" <% if(k4) { %>checked<% } %>> 4096
								</label>
							</div>
							<button type="submit" class="btn btn-success btn-block mb-3">
								<i class="fas fa-sync-alt"></i> Generate New Keys
							</button>
						</form>

	<form id="rsaForm">
		<input type="hidden" name="methodName" value="CALCULATE_RSA">

						<!-- Operation -->
						<label class="mb-2"><strong>Operation:</strong></label>
						<div class="btn-group btn-block mb-3" data-toggle="buttons" role="group">
							<label class="btn btn-outline-success py-2 active">
								<input type="radio" id="encryptRadio" name="encryptdecryptparameter" value="encrypt" checked> <i class="fas fa-lock"></i> Encrypt
							</label>
							<label class="btn btn-outline-info py-2">
								<input type="radio" id="decryptRadio" name="encryptdecryptparameter" value="decryprt"> <i class="fas fa-unlock"></i> Decrypt
							</label>
						</div>

						<!-- Cipher Mode -->
						<label class="mb-2"><strong>Cipher Mode:</strong></label>
						<select class="form-control mb-3" id="cipherSelect" name="cipherparameter">
							<option value="RSA" selected>RSA</option>
							<option value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding</option>
							<option value="RSA/None/PKCS1Padding">RSA/None/PKCS1Padding</option>
							<option value="RSA/NONE/OAEPWithSHA1AndMGF1Padding">RSA/NONE/OAEPWithSHA1AndMGF1Padding</option>
							<option value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding</option>
							<option value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">RSA/ECB/OAEPWithSHA-256AndMGF1Padding</option>
						</select>

						<!-- Message -->
						<label class="mb-2"><strong>Message:</strong></label>
						<textarea class="form-control mb-2" id="message" name="message" rows="6" style="font-family: monospace; font-size: 13px;" placeholder="Enter your message here..."></textarea>
						<small class="text-muted d-block mb-3">Max: 117 bytes (1024-bit), 245 bytes (2048-bit)</small>

						<!-- Submit -->
						<button type="submit" class="btn btn-primary btn-block btn-lg">
							<i class="fas fa-play"></i> Process
						</button>
					</div>
				</div>
			</div>

			<!-- MIDDLE: RSA Keys -->
			<div class="col-lg-4">
				<div class="card mb-3">
					<div class="card-header bg-success text-white py-2">
						<strong><i class="fas fa-key"></i> RSA Keys</strong>
						<button class="btn btn-sm btn-light float-right py-0 px-2" type="button" id="toggleKeys">
							<i class="fas fa-eye"></i>
						</button>
					</div>
					<div class="card-body p-3" id="keysSection">
						<label class="mb-1"><strong>Public Key:</strong></label>
						<div class="input-group input-group-sm mb-2">
							<textarea class="form-control" id="publickeyparam" name="publickeyparam" rows="16" style="font-family: monospace; font-size: 9px;"><%= pubKey %></textarea>
							<div class="input-group-append">
								<button class="btn btn-outline-secondary" type="button" id="copyPublic">
									<i class="fas fa-copy"></i>
								</button>
							</div>
						</div>

						<label class="mb-1"><strong>Private Key:</strong></label>
						<div class="input-group input-group-sm mb-3">
							<textarea class="form-control" id="privatekeyparam" name="privatekeyparam" rows="16" style="font-family: monospace; font-size: 9px;"><%= privKey %></textarea>
							<div class="input-group-append">
								<button class="btn btn-outline-secondary" type="button" id="copyPrivate">
									<i class="fas fa-copy"></i>
								</button>
							</div>
						</div>

						<!-- Copy Both Keys Button -->
						<button class="btn btn-warning btn-block btn-sm" type="button" id="copyBothKeys">
							<i class="fas fa-copy"></i> Copy Both Keys
						</button>
					</div>
				</div>
			</div>

			<!-- RIGHT: Output -->
			<div class="col-lg-4">
				<div class="card mb-3">
					<div class="card-header bg-info text-white py-2">
						<strong><i class="fas fa-output"></i> Result</strong>
					</div>
					<div class="card-body p-3">
						<div id="output" style="min-height: 400px;">
							<div class="text-center text-muted py-5">
								<i class="fas fa-arrow-left fa-3x mb-3"></i>
								<p>Configure and click Process to see results</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>

</div>

<script>
$(document).ready(function() {
	// Toggle keys visibility
	$('#toggleKeys').click(function() {
		$('#keysSection').slideToggle();
		$(this).find('i').toggleClass('fa-eye fa-eye-slash');
	});

	// Copy buttons
	$('#copyPublic').click(function() {
		copyToClipboard($('#publickeyparam').val(), $(this));
	});

	$('#copyPrivate').click(function() {
		copyToClipboard($('#privatekeyparam').val(), $(this));
	});

	// Copy Both Keys button
	$('#copyBothKeys').click(function() {
		const publicKey = $('#publickeyparam').val();
		const privateKey = $('#privatekeyparam').val();
		const bothKeys = '=== PUBLIC KEY ===\n' + publicKey + '\n\n=== PRIVATE KEY ===\n' + privateKey;

		navigator.clipboard.writeText(bothKeys).then(() => {
			const originalHTML = $(this).html();
			$(this).html('<i class="fas fa-check"></i> Copied!');
			setTimeout(() => $(this).html(originalHTML), 1500);
		});
	});

	function copyToClipboard(text, btn) {
		navigator.clipboard.writeText(text).then(() => {
			const originalHTML = btn.html();
			btn.html('<i class="fas fa-check"></i>');
			setTimeout(() => btn.html(originalHTML), 1500);
		});
	}

	// Generate Keys button - show spinner on submit
	$('#keySizeForm').submit(function() {
		var btn = $(this).find('button[type="submit"]');
		btn.html('<i class="fas fa-spinner fa-spin"></i> Generating...').prop('disabled', true);
	});

	// RSA Form submission with JSON parsing
	$('#rsaForm').submit(function(e) {
		e.preventDefault();

		$('#output').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Processing...</div>');

		$.ajax({
			type: 'POST',
			url: 'RSAFunctionality',
			data: $(this).serialize(),
			dataType: 'json',
			success: function(response) {
				renderOutput(response);
			},
			error: function(xhr, status, error) {
				$('#output').html(`
					<div class="alert alert-danger">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Error</h6>
						<p class="mb-0">Request failed: ${error}</p>
					</div>
				`);
			}
		});
	});

	function renderOutput(response) {
		if (response.success) {
			const isEncrypt = response.operation === 'encrypt';
			const result = isEncrypt ? response.base64Encoded : response.message;

			let html = `
				<div class="card border-success mt-3">
					<div class="card-header bg-success text-white">
						<strong><i class="fas fa-check-circle"></i> Success</strong>
					</div>
					<div class="card-body">
						<div class="row mb-3">
							<div class="col-md-4">
								<p class="mb-1"><strong><i class="fas fa-cog"></i> Operation:</strong></p>
								<p class="text-muted">${response.operation.toUpperCase()}</p>
							</div>
							<div class="col-md-8">
								<p class="mb-1"><strong><i class="fas fa-shield-alt"></i> Algorithm:</strong></p>
								<p class="text-muted">${response.algorithm}</p>
							</div>
						</div>
			`;

			if (response.originalMessage) {
				html += `
					<div class="mb-3">
						<p class="mb-1"><strong><i class="fas fa-file-alt"></i> Original:</strong></p>
						<pre class="bg-light p-2 rounded" style="font-size: 12px;">${response.originalMessage}</pre>
					</div>
				`;
			}

			html += `
						<div class="mb-3">
							<p class="mb-1"><strong><i class="fas fa-key"></i> Result:</strong></p>
							<div class="input-group mb-2">
								<textarea class="form-control" id="resultText" rows="6" style="font-family: monospace; font-size: 12px;" readonly>${result}</textarea>
								<div class="input-group-append">
									<button class="btn btn-success" type="button" id="copyResult">
										<i class="fas fa-copy"></i> Copy
									</button>
								</div>
							</div>
							<div class="btn-group btn-block" role="group">
								<button class="btn btn-outline-primary btn-sm" type="button" id="swapResult">
									<i class="fas fa-exchange-alt"></i> ${isEncrypt ? 'Use for Decryption' : 'Use for Encryption'}
								</button>
								<button class="btn btn-outline-info btn-sm" type="button" id="shareUrl">
									<i class="fas fa-share-alt"></i> Share URL
								</button>
							</div>
						</div>
					</div>
				</div>
			`;

			$('#output').html(html);

			$('#copyResult').click(function() {
				const text = $('#resultText').val();
				navigator.clipboard.writeText(text).then(() => {
					$(this).html('<i class="fas fa-check"></i> Copied!');
					setTimeout(() => $(this).html('<i class="fas fa-copy"></i> Copy'), 1500);
				});
			});

			// Auto-swap: Copy result to input and switch operation
			$('#swapResult').click(function() {
				const result = $('#resultText').val();
				$('#message').val(result);

				// Switch operation
				if (isEncrypt) {
					$('#decryptRadio').prop('checked', true).parent().addClass('active');
					$('#encryptRadio').prop('checked', false).parent().removeClass('active');
				} else {
					$('#encryptRadio').prop('checked', true).parent().addClass('active');
					$('#decryptRadio').prop('checked', false).parent().removeClass('active');
				}

				// Visual feedback
				$(this).html('<i class="fas fa-check"></i> Swapped!');
				setTimeout(() => {
					$(this).html('<i class="fas fa-exchange-alt"></i> ' + (isEncrypt ? 'Use for Decryption' : 'Use for Encryption'));
				}, 1500);

				// Scroll to message input
				$('html, body').animate({
					scrollTop: $('#message').offset().top - 100
				}, 500);
			});

			// Share URL: Open modal with shareable URL and keys
			$('#shareUrl').click(function() {
				const result = $('#resultText').val();
				const operation = response.operation;
				const algorithm = response.algorithm;
				const publicKey = $('#publickeyparam').val();
				const privateKey = $('#privatekeyparam').val();

				// Create URL parameters
				const params = new URLSearchParams({
					msg: result,
					op: operation === 'encrypt' ? 'decrypt' : 'encrypt',
					algo: algorithm
				});

				// Add keys based on what's available
				let includesPrivateKey = false;
				if (publicKey && publicKey.trim()) {
					params.append('pubkey', publicKey);
				}
				if (privateKey && privateKey.trim()) {
					params.append('privkey', privateKey);
					includesPrivateKey = true;
				}

				const shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

				// Update modal warning based on content
				if (includesPrivateKey) {
					$('#shareWarningContent').html(`
						<div class="alert alert-danger mb-3">
							<strong><i class="fas fa-exclamation-triangle"></i> DANGER: Private Key Included!</strong>
							<ul class="mb-0 mt-2">
								<li><strong>Public Key:</strong> Included and safe to share</li>
								<li><strong class="text-danger">Private Key:</strong> INCLUDED - This is highly sensitive!</li>
								<li><strong>Encrypted Message:</strong> The result of your operation</li>
								<li><strong>Algorithm:</strong> The cipher mode used</li>
							</ul>
						</div>
						<div class="alert alert-danger mb-3">
							<strong><i class="fas fa-skull-crossbones"></i> CRITICAL SECURITY WARNING:</strong>
							<p class="mb-2"><strong>You are about to share your PRIVATE KEY via URL!</strong></p>
							<ul class="mb-0">
								<li>Anyone with this URL can decrypt ALL messages encrypted with your public key</li>
								<li>This is generally considered VERY UNSAFE</li>
								<li>Only share this in trusted, secure channels (e.g., encrypted messaging)</li>
								<li>Consider regenerating keys after sharing</li>
							</ul>
						</div>
					`);
				} else {
					$('#shareWarningContent').html(`
						<div class="alert alert-warning mb-3">
							<strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
							<ul class="mb-0 mt-2">
								<li><strong>Public Key:</strong> ${publicKey && publicKey.trim() ? 'Included - Safe to share' : 'Not included'}</li>
								<li><strong>Encrypted Message:</strong> The result of your operation</li>
								<li><strong>Algorithm:</strong> The cipher mode used</li>
								<li><strong>NOT Included:</strong> Your private key (kept secure)</li>
							</ul>
						</div>
						<div class="alert alert-info mb-3">
							<strong><i class="fas fa-info-circle"></i> Security Reminder:</strong>
							<p class="mb-0">This URL contains your public RSA key and encrypted content.</p>
							<ul class="mb-0 mt-2">
								<li>The URL will be very long (RSA keys are 1000+ characters)</li>
								<li>Anyone with this URL can see your public key</li>
								<li>The encrypted message is visible but unreadable without the private key</li>
							</ul>
						</div>
					`);
				}

				// Set URL in modal and show it
				$('#shareUrlText').val(shareUrl);
				$('#shareUrlModal').modal('show');
			});

			// Copy Share URL from modal
			$('#copyShareUrl').click(function() {
				const shareUrl = $('#shareUrlText').val();
				navigator.clipboard.writeText(shareUrl).then(() => {
					$(this).html('<i class="fas fa-check"></i> Copied!');
					setTimeout(() => {
						$(this).html('<i class="fas fa-copy"></i> Copy');
					}, 1500);
				});
			});

		} else {
			$('#output').html(`
				<div class="alert alert-danger mt-3">
					<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Failed</h6>
					<p class="mb-2"><strong>Operation:</strong> ${response.operation || 'Unknown'}</p>
					<p class="mb-2"><strong>Algorithm:</strong> ${response.algorithm || 'Unknown'}</p>
					<p class="mb-0"><strong>Error:</strong> ${response.errorMessage}</p>
				</div>
			`);
		}
	}

	// Handle URL parameters for Share URL feature
	const urlParams = new URLSearchParams(window.location.search);
	if (urlParams.has('msg')) {
		$('#message').val(urlParams.get('msg'));

		// Set operation
		if (urlParams.get('op') === 'decrypt') {
			$('#decryptRadio').prop('checked', true).parent().addClass('active');
			$('#encryptRadio').prop('checked', false).parent().removeClass('active');
		}

		// Set algorithm if provided
		if (urlParams.has('algo')) {
			$('#cipherSelect').val(urlParams.get('algo'));
		}

		// Set public key if provided
		if (urlParams.has('pubkey')) {
			$('#publickeyparam').val(urlParams.get('pubkey'));
			// Highlight the public key field
			$('#publickeyparam').addClass('border-success');
			setTimeout(() => {
				$('#publickeyparam').removeClass('border-success');
			}, 3000);
		}

		// Set private key if provided (with warning)
		if (urlParams.has('privkey')) {
			$('#privatekeyparam').val(urlParams.get('privkey'));
			// Highlight the private key field with warning color
			$('#privatekeyparam').addClass('border-danger');
			setTimeout(() => {
				$('#privatekeyparam').removeClass('border-danger');
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

		// Visual highlight for message
		$('#message').addClass('border-primary').focus();
		setTimeout(() => {
			$('#message').removeClass('border-primary');
		}, 2000);
	}
});
</script>

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

<!-- E-E-A-T Sections -->
<div class="container-fluid mt-4">
	<div class="row">
		<div class="col-12">

			<!-- How RSA Encryption Works -->
			<section class="card mb-4">
				<div class="card-header bg-primary text-white">
					<h2 class="h5 mb-0"><i class="fas fa-cogs"></i> How RSA Encryption Works</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-6">
							<h3 class="h6"><i class="fas fa-key text-success"></i> RSA Key Generation</h3>
							<p>RSA keys are generated by selecting two large prime numbers and computing their product (modulus). The public key consists of the modulus and public exponent (typically 65537), while the private key includes the modulus and private exponent derived from the primes.</p>
							<ul class="small">
								<li><strong>512-bit:</strong> Weak, only for testing</li>
								<li><strong>1024-bit:</strong> Deprecated, avoid for production</li>
								<li><strong>2048-bit:</strong> Recommended minimum for production use</li>
								<li><strong>4096-bit:</strong> High security, slower performance</li>
							</ul>
						</div>
						<div class="col-md-6">
							<h3 class="h6"><i class="fas fa-lock text-info"></i> Encryption & Decryption</h3>
							<p><strong>Encryption:</strong> Uses the public key to transform plaintext into ciphertext. The mathematical operation ensures that only the corresponding private key can decrypt the message.</p>
							<p><strong>Decryption:</strong> Uses the private key to recover the original plaintext from ciphertext. The asymmetric nature ensures secure communication without pre-shared secrets.</p>
							<div class="alert alert-warning small mb-0">
								<i class="fas fa-exclamation-triangle"></i> <strong>Message Size Limits:</strong> RSA can only encrypt data smaller than the key size. For larger data, use hybrid encryption (RSA for key exchange, AES for data).
							</div>
						</div>
					</div>
					<hr class="my-3">
					<h3 class="h6"><i class="fas fa-shield-alt text-primary"></i> Padding Schemes</h3>
					<div class="row small">
						<div class="col-md-4">
							<strong>PKCS1Padding:</strong> Classic padding scheme, vulnerable to padding oracle attacks. Use only for legacy compatibility.
						</div>
						<div class="col-md-4">
							<strong>OAEP (SHA-1):</strong> Optimal Asymmetric Encryption Padding with SHA-1. More secure than PKCS1 but SHA-1 is deprecated.
						</div>
						<div class="col-md-4">
							<strong>OAEP (SHA-256):</strong> Recommended modern padding with SHA-256. Provides the best security against chosen-ciphertext attacks.
						</div>
					</div>
				</div>
			</section>

			<!-- Common Use Cases -->
			<section class="card mb-4">
				<div class="card-header bg-success text-white">
					<h2 class="h5 mb-0"><i class="fas fa-lightbulb"></i> Common Use Cases for RSA Encryption</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-envelope fa-2x text-primary mb-2"></i>
								<h3 class="h6">Secure Email</h3>
								<p class="small">Encrypt email contents or attachments using recipient's public key. Only they can decrypt with their private key.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-key fa-2x text-success mb-2"></i>
								<h3 class="h6">Key Exchange</h3>
								<p class="small">Securely exchange symmetric keys (AES, DES) over insecure channels by encrypting them with RSA.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-signature fa-2x text-info mb-2"></i>
								<h3 class="h6">Digital Signatures</h3>
								<p class="small">Sign documents by encrypting a hash with your private key. Others verify with your public key.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-certificate fa-2x text-warning mb-2"></i>
								<h3 class="h6">SSL/TLS Certificates</h3>
								<p class="small">RSA keys are embedded in X.509 certificates used for HTTPS and secure connections.</p>
							</div>
						</div>
					</div>
					<div class="alert alert-info small mb-0">
						<i class="fas fa-info-circle"></i> <strong>Pro Tip:</strong> For encrypting large files or messages, use hybrid encryption: generate a random AES key, encrypt your data with AES, then encrypt the AES key with RSA. This combines RSA's key exchange security with AES's speed.
					</div>
				</div>
			</section>

			<!-- Security Best Practices -->
			<section class="card mb-4">
				<div class="card-header bg-warning text-dark">
					<h2 class="h5 mb-0"><i class="fas fa-exclamation-triangle"></i> Security Best Practices</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-6">
							<h3 class="h6 text-success"><i class="fas fa-check-circle"></i> Do's</h3>
							<ul class="small">
								<li>Use <strong>2048-bit or larger</strong> keys for production</li>
								<li>Use <strong>OAEP padding</strong> with SHA-256 for new applications</li>
								<li>Keep your <strong>private key secure</strong> and never share it</li>
								<li>Use <strong>hybrid encryption</strong> for messages larger than key size</li>
								<li>Rotate keys periodically according to your security policy</li>
								<li>Use this tool for <strong>testing and learning</strong> purposes</li>
								<li>Generate keys offline for highly sensitive production use</li>
							</ul>
						</div>
						<div class="col-md-6">
							<h3 class="h6 text-danger"><i class="fas fa-times-circle"></i> Don'ts</h3>
							<ul class="small">
								<li>Don't use <strong>512-bit or 1024-bit keys</strong> in production</li>
								<li>Don't use <strong>PKCS1Padding</strong> for new applications (use OAEP)</li>
								<li>Don't encrypt large files directly with RSA (size limits apply)</li>
								<li>Don't share your <strong>private key</strong> with anyone</li>
								<li>Don't reuse the same key pair across different applications</li>
								<li>Don't use this tool for encrypting highly classified data</li>
								<li>Don't assume RSA alone provides message integrity (use signatures)</li>
							</ul>
						</div>
					</div>
				</div>
			</section>

			<!-- Why Trust This Tool -->
			<section class="card mb-4">
				<div class="card-header bg-info text-white">
					<h2 class="h5 mb-0"><i class="fas fa-shield-alt"></i> Why Trust This RSA Tool?</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-user-lock fa-3x text-primary mb-2"></i>
							<h3 class="h6">No Data Storage</h3>
							<p class="small">Your keys and messages are processed in-session only. We don't log, store, or transmit your cryptographic data to third parties.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-code fa-3x text-success mb-2"></i>
							<h3 class="h6">Open Standards</h3>
							<p class="small">Built on standard Java Cryptography Architecture (JCA) using well-tested RSA implementations. No proprietary or unverified algorithms.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-graduation-cap fa-3x text-info mb-2"></i>
							<h3 class="h6">Educational Focus</h3>
							<p class="small">Designed for learning, testing, and development. Perfect for understanding RSA concepts, cipher modes, and cryptographic operations.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-clock fa-3x text-warning mb-2"></i>
							<h3 class="h6">Active Since 2017</h3>
							<p class="small">Part of 8gwifi.org's suite of cryptography tools, serving developers and security professionals since 2017.</p>
						</div>
					</div>
					<hr>
					<div class="small">
						<p class="mb-2"><strong><i class="fas fa-user-tie"></i> About the Developer:</strong> This tool is developed and maintained by <strong>Anish Nath</strong>, a Security Engineer with expertise in cryptography, PKI, and secure application development. Anish has created multiple open-source security tools and regularly publishes technical content on cryptographic implementations.</p>
						<p class="mb-0"><i class="fas fa-link"></i> <strong>Connect:</strong>
							<a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="text-primary">Twitter</a> |
						</p>
					</div>
				</div>
			</section>

			<!-- FAQ Section -->
			<section class="card mb-4">
				<div class="card-header bg-secondary text-white">
					<h2 class="h5 mb-0"><i class="fas fa-question-circle"></i> Frequently Asked Questions</h2>
				</div>
				<div class="card-body">
					<div class="accordion" id="faqAccordion">

						<div class="card">
							<div class="card-header p-2" id="faq1">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small" type="button" data-toggle="collapse" data-target="#faq1collapse">
										<i class="fas fa-chevron-down"></i> What is RSA encryption and how does it work?
									</button>
								</h3>
							</div>
							<div id="faq1collapse" class="collapse show" data-parent="#faqAccordion">
								<div class="card-body small">
									RSA encryption is an asymmetric cryptography algorithm that uses two keys: a public key for encryption and a private key for decryption. Named after its inventors Rivest, Shamir, and Adleman, RSA is widely used for secure data transmission and digital signatures. The security is based on the mathematical difficulty of factoring large prime numbers.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq2">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq2collapse">
										<i class="fas fa-chevron-down"></i> How do I generate RSA keys with this tool?
									</button>
								</h3>
							</div>
							<div id="faq2collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									Simply select your desired key size (512, 1024, 2048, or 4096 bits) using the key size buttons in the Configuration section. The tool automatically generates a new RSA key pair with both public and private keys in PEM format. The keys are stored in your session for use in encryption/decryption operations.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq3">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq3collapse">
										<i class="fas fa-chevron-down"></i> What RSA cipher modes are supported?
									</button>
								</h3>
							</div>
							<div id="faq3collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									This tool supports multiple RSA cipher modes: RSA (default), RSA/ECB/PKCS1Padding, RSA/None/PKCS1Padding, RSA/NONE/OAEPWithSHA1AndMGF1Padding, RSA/ECB/OAEPWithSHA-1AndMGF1Padding, and RSA/ECB/OAEPWithSHA-256AndMGF1Padding. OAEP padding modes provide enhanced security compared to PKCS1Padding and are recommended for new applications.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq4">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq4collapse">
										<i class="fas fa-chevron-down"></i> What's the maximum message size for RSA encryption?
									</button>
								</h3>
							</div>
							<div id="faq4collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									The maximum message size depends on the key size and padding scheme. For 1024-bit keys with PKCS1Padding, you can encrypt up to 117 bytes. For 2048-bit keys, the limit is 245 bytes. For 4096-bit keys, the limit is approximately 501 bytes. For larger messages, use hybrid encryption where you encrypt data with AES and encrypt the AES key with RSA.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq5">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq5collapse">
										<i class="fas fa-chevron-down"></i> Is this RSA encryption tool secure for production use?
									</button>
								</h3>
							</div>
							<div id="faq5collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									All encryption and decryption operations are performed securely without storing your keys or messages permanently. However, we recommend using 2048-bit or 4096-bit keys for production use. For highly sensitive data, consider generating keys offline and using this tool only for testing and educational purposes. Always follow your organization's security policies.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq6">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq6collapse">
										<i class="fas fa-chevron-down"></i> Can I decrypt a message with the public key?
									</button>
								</h3>
							</div>
							<div id="faq6collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									No, RSA decryption requires the private key. The public key is used only for encryption. This asymmetric property is fundamental to RSA and enables secure communication where anyone can encrypt messages using your public key, but only you (the private key holder) can decrypt them. This eliminates the need for secure key exchange.
								</div>
							</div>
						</div>

					</div>
				</div>
			</section>

		</div>
	</div>
</div>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
</div>

</div>
<%@ include file="body-close.jsp"%>
