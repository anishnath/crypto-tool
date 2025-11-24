<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
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
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Enhanced JSON-LD structured data -->
	<script type="application/ld+json">
	{
	  "@context": "https://schema.org",
	  "@type": "WebApplication",
	  "name": "RSA Signature Tool Online – Sign & Verify Messages",
	  "alternativeName": "Online RSA Digital Signature Generator and Verifier",
	  "description": "Free online RSA digital signature tool. Generate RSA key pairs (512, 1024, 2048, 4096-bit), create digital signatures and verify signatures with multiple algorithms including SHA256withRSA, RSASSA-PSS, and more. No registration required.",
	  "url": "https://8gwifi.org/rsasignverifyfunctions.jsp",
	  "image": "https://8gwifi.org/images/site/rsasig.png",
	  "applicationCategory": "UtilityApplication",
	  "applicationSubCategory": "Cryptography Tool",
	  "operatingSystem": "Any (Web-based)",
	  "browserRequirements": "Requires JavaScript",
	  "datePublished": "2018-10-27",
	  "dateModified": "2025-01-21",
	  "offers": {
	    "@type": "Offer",
	    "price": "0",
	    "priceCurrency": "USD",
	    "availability": "https://schema.org/InStock"
	  },
	  "featureList": [
	    "Generate RSA key pairs (512, 1024, 2048, 4096-bit)",
	    "Sign messages with private key",
	    "Verify signatures with public key",
	    "Multiple signature algorithms (SHA256withRSA, SHA1withRSA, SHA384withRSA, SHA512withRSA)",
	    "RSASSA-PSS signature scheme support",
	    "RSASSA-PKCS1-v1_5 support",
	    "Base64 encoded signature output",
	    "Copy signatures to clipboard",
	    "Real-time signing and verification",
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
	      "name": "What is RSA digital signature?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "An RSA digital signature is a cryptographic mechanism that allows you to sign a message with your private key to prove authenticity and integrity. Anyone can verify the signature using your public key. Unlike encryption, signing uses the private key to create the signature, and the public key to verify it."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "How do I sign a message with RSA?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "To sign a message: 1) Generate or provide an RSA key pair, 2) Select 'Generate Signature' operation, 3) Choose a signature algorithm (SHA256withRSA recommended), 4) Enter your message, 5) Click Process. The tool creates a hash of your message and encrypts it with your private key, producing a Base64-encoded signature."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "What signature algorithms are supported?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "This tool supports multiple RSA signature algorithms including SHA256withRSA (recommended), SHA1withRSA, SHA384withRSA, SHA512withRSA, MD5withRSA, RSASSA-PSS, SHA1WithRSA/PSS, SHA224WithRSA/PSS, SHA384WithRSA/PSS, and SHA1withRSAandMGF1. SHA256withRSA and SHA384withRSA are recommended for modern applications."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "What's the difference between RSASSA-PSS and RSASSA-PKCS1-v1_5?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "RSASSA-PKCS1-v1_5 is the older deterministic signature scheme, while RSASSA-PSS (Probabilistic Signature Scheme) is newer and more secure with a formal security proof. PSS uses random padding and is recommended for new applications, though PKCS1-v1_5 remains widely used for compatibility with existing systems."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "How do I verify an RSA signature?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "To verify a signature: 1) Ensure you have the signer's public key, 2) Select 'Verify Signature' operation, 3) Enter the original message, 4) Paste the Base64-encoded signature, 5) Select the same algorithm used for signing, 6) Click Process. The tool will indicate whether the signature is valid or invalid."
	      }
	    },
	    {
	      "@type": "Question",
	      "name": "Can I verify a signature without the private key?",
	      "acceptedAnswer": {
	        "@type": "Answer",
	        "text": "Yes! Signature verification only requires the public key, not the private key. This is a fundamental property of digital signatures - anyone can verify a signature using the public key, but only the private key holder can create valid signatures. This ensures non-repudiation and authenticity."
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
	  "name": "How to Sign and Verify Messages with RSA",
	  "description": "Step-by-step guide to creating and verifying RSA digital signatures using this online tool.",
	  "image": "https://8gwifi.org/images/site/rsasig.png",
	  "totalTime": "PT2M",
	  "step": [
	    {
	      "@type": "HowToStep",
	      "position": 1,
	      "name": "Select Key Size",
	      "text": "Choose your desired RSA key size (512, 1024, 2048, or 4096 bits). For production use, select 2048-bit or higher for adequate security.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click on one of the key size buttons (512, 1024, 2048, or 4096) in the Configuration section and click Generate New Keys."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 2,
	      "name": "Choose Operation and Algorithm",
	      "text": "Select whether you want to sign or verify a message, then choose the signature algorithm. SHA256withRSA is recommended for most applications.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click the Sign or Verify button, then select a signature algorithm from the dropdown (e.g., SHA256withRSA or RSASSA-PSS)."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 3,
	      "name": "Enter Your Message",
	      "text": "Type or paste your message in the message textarea. For signing, enter the original message. For verification, enter both the message and the Base64-encoded signature.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Type your message in the Message textarea. If verifying, also paste the signature in the Signature field."
	      }
	    },
	    {
	      "@type": "HowToStep",
	      "position": 4,
	      "name": "Process and View Results",
	      "text": "Click the Process button to sign or verify. The result will show the signature (for signing) or validation status (for verification) with algorithm details.",
	      "itemListElement": {
	        "@type": "HowToDirection",
	        "text": "Click the blue Process button. Your signature or verification result will appear in the right column with a Copy button and additional actions."
	      }
	    }
	  ]
	}
	</script>

	<title>RSA Signature Tool Online – Sign & Verify Messages | 8gwifi.org</title>
	<meta name="keywords" content="rsa signature online, rsa sign verify online, digital signature generator, rsa signature verification, SHA256withRSA, RSASSA-PSS, rsa sign message, verify rsa signature online">
	<meta name="description" content="Free online RSA digital signature tool. Sign messages with private key and verify signatures with public key. Supports SHA256withRSA, SHA1withRSA, RSASSA-PSS, SHA384withRSA. No registration required.">
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
			<h1 class="mb-1">RSA Signature Tool <small class="text-muted">Sign & Verify Messages</small></h1>
			<hr class="mt-2 mb-3">

		<div class="row">
			<!-- LEFT: Configuration & Input -->
			<div class="col-lg-4">
				<div class="card mb-3">
					<div class="card-header bg-dark text-white py-2">
						<strong><i class="fas fa-cog"></i> Configuration</strong>
					</div>
					<div class="card-body p-3">
						<!-- Key Size (separate form) -->
						<form id="keySizeForm" method="GET" action="RSAFunctionality?q=setNeKey">
							<input type="hidden" name="rsasignverifyfunctions" value="rsasignverifyfunctions">
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

						<!-- Main Form starts after keySizeForm to avoid nesting -->
						<form id="rsaSignForm">
							<input type="hidden" name="methodName" value="RSA_SIGN_VERIFY_MESSAGEE">

						<!-- Operation -->
						<label class="mb-2"><strong>Operation:</strong></label>
						<div class="btn-group btn-block mb-3" data-toggle="buttons" role="group">
							<label class="btn btn-outline-success py-2 active">
								<input type="radio" id="signRadio" name="encryptdecryptparameter" value="decryprt" checked> <i class="fas fa-pen"></i> Sign
							</label>
							<label class="btn btn-outline-info py-2">
								<input type="radio" id="verifyRadio" name="encryptdecryptparameter" value="encrypt"> <i class="fas fa-check-circle"></i> Verify
							</label>
						</div>

						<!-- Signature Algorithm -->
						<label class="mb-2"><strong>Signature Algorithm:</strong></label>
						<select class="form-control mb-3" id="algorithmSelect" name="cipherparameter">
							<option value="SHA256withRSA" selected>SHA256withRSA (Recommended)</option>
							<option value="SHA1WithRSA/PSS">RSASSA-PSS</option>
							<option value="SHA1WithRSA/PSS">SHA1WithRSA/PSS</option>
							<option value="SHA224WithRSA/PSS">SHA224WithRSA/PSS</option>
							<option value="SHA384WithRSA/PSS">SHA384WithRSA/PSS</option>
							<option value="SHA384WithRSA/PSS">SHA1withRSAandMGF1</option>
							<option value="sha1WithRSA">SHA1withRSA</option>
							<option value="sha384WithRSA">SHA384withRSA</option>
							<option value="sha512WithRSA">SHA512withRSA</option>
							<option value="md2WithRSA">MD2withRSA (Deprecated)</option>
							<option value="md5WithRSA">MD5withRSA (Deprecated)</option>
						</select>

						<!-- Message -->
						<label class="mb-2"><strong>Message:</strong></label>
						<textarea class="form-control mb-2" id="message" name="message" rows="5" style="font-family: monospace; font-size: 13px;" placeholder="Enter your message to sign or verify..."></textarea>

						<!-- Signature (for verification) -->
						<label class="mb-2"><strong>Signature (Base64):</strong></label>
						<textarea class="form-control mb-2" id="signature" name="signature" rows="3" style="font-family: monospace; font-size: 12px;" placeholder="Paste signature here for verification..."></textarea>
						<small class="text-muted d-block mb-3">Required only for signature verification</small>

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
		</form>

			<!-- RIGHT: Output -->
			<div class="col-lg-4">
				<div class="card mb-3">
					<div class="card-header bg-info text-white py-2">
						<strong><i class="fas fa-file-signature"></i> Result</strong>
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

	// RSA Signature Form submission with validation and HTML response parsing
	$('#rsaSignForm').submit(function(e) {
		e.preventDefault();

		// Get operation
		const operation = $('input[name="encryptdecryptparameter"]:checked').val();
		const message = $('#message').val().trim();
		const signature = $('#signature').val().trim();
		const publicKey = $('#publickeyparam').val().trim();
		const privateKey = $('#privatekeyparam').val().trim();
		const algorithm = $('#algorithmSelect').val();

		// Validation
		if (!message) {
			$('#output').html(`
				<div class="alert alert-danger">
					<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Validation Error</h6>
					<p class="mb-0">Message is required.</p>
				</div>
			`);
			$('#message').focus();
			return;
		}

		if (operation === 'encrypt') {
			// Verify operation
			if (!signature) {
				$('#output').html(`
					<div class="alert alert-danger">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Validation Error</h6>
						<p class="mb-0">Signature is required for verification.</p>
					</div>
				`);
				$('#signature').focus();
				return;
			}
			if (!publicKey) {
				$('#output').html(`
					<div class="alert alert-danger">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Validation Error</h6>
						<p class="mb-0">Public key is required for verification.</p>
					</div>
				`);
				return;
			}
		} else {
			// Sign operation
			if (!privateKey) {
				$('#output').html(`
					<div class="alert alert-danger">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Validation Error</h6>
						<p class="mb-0">Private key is required for signing.</p>
					</div>
				`);
				return;
			}
		}

		$('#output').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Processing...</div>');

		// Manually build form data to ensure keys are included
		const formData = {
			methodName: 'RSA_SIGN_VERIFY_MESSAGEE',
			encryptdecryptparameter: operation,
			cipherparameter: algorithm,
			message: message,
			signature: signature,
			publickeyparam: publicKey,
			privatekeyparam: privateKey
		};

		// Debug logging
		console.log('Submitting form with data:', {
			operation: operation,
			algorithm: algorithm,
			hasMessage: !!message,
			hasSignature: !!signature,
			hasPublicKey: !!publicKey,
			hasPrivateKey: !!privateKey
		});

		$.ajax({
			type: 'POST',
			url: 'RSAFunctionality',
			data: formData,
			dataType: 'json',
			success: function(response) {
				console.log('Received JSON response:', response);
				renderOutput(response);
			},
			error: function(xhr, status, error) {
				console.error('AJAX error:', {status: xhr.status, error: error, responseText: xhr.responseText});

				// Try to parse JSON error response
				let errorMessage = error;
				try {
					const errorResponse = JSON.parse(xhr.responseText);
					if (errorResponse.errorMessage) {
						errorMessage = errorResponse.errorMessage;
					}
				} catch(e) {
					// Not JSON, use default error
				}

				$('#output').html(`
					<div class="alert alert-danger">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Error</h6>
						<p class="mb-0">Request failed: ${errorMessage}</p>
						<p class="small mb-0">Status: ${xhr.status}</p>
						<details class="mt-2">
							<summary class="text-primary" style="cursor: pointer;">Show response</summary>
							<pre class="mt-2 p-2 bg-light" style="font-size: 10px; max-height: 200px; overflow: auto;">${xhr.responseText ? xhr.responseText.substring(0, 500) : 'No response text'}</pre>
						</details>
					</div>
				`);
			}
		});
	});

	function renderOutput(response) {
		console.log('Rendering output for response:', response);
		// Handle JSON response
		if (response && typeof response === 'object') {
			if (response.success) {
				const isSign = response.operation === 'sign';
				const result = isSign ? response.base64Encoded : response.message;

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
							<p class="mb-1"><strong><i class="fas fa-file-alt"></i> Original Message:</strong></p>
							<pre class="bg-light p-2 rounded" style="font-size: 12px; max-height: 150px; overflow-y: auto;">${response.originalMessage}</pre>
						</div>
					`;
				}

				if (isSign) {
					html += `
							<div class="mb-3">
								<p class="mb-1"><strong><i class="fas fa-signature"></i> Signature (Base64):</strong></p>
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
										<i class="fas fa-exchange-alt"></i> Use for Verification
									</button>
									<button class="btn btn-outline-info btn-sm" type="button" id="shareUrl">
										<i class="fas fa-share-alt"></i> Share URL
									</button>
								</div>
							</div>
					`;
				} else {
					// Verification result - check message field for VALID/INVALID
					const isValid = result === 'VALID' || response.base64Encoded?.toLowerCase().includes('passed');
					html += `
							<div class="mb-3">
								<div class="alert ${isValid ? 'alert-success' : 'alert-danger'}">
									<h5 class="alert-heading">
										<i class="fas ${isValid ? 'fa-check-circle' : 'fa-times-circle'}"></i>
										Signature ${isValid ? 'Valid' : 'Invalid'}
									</h5>
									<p class="mb-0">
										${isValid ?
											'The signature is valid. The message has not been tampered with and was signed by the holder of the private key.' :
											'The signature is invalid. The message may have been modified or the signature does not match the provided public key.'}
									</p>
								</div>
							</div>
					`;
				}

				html += `
						</div>
					</div>
				`;

				$('#output').html(html);

				if (isSign) {
					$('#copyResult').click(function() {
						const text = $('#resultText').val();
						navigator.clipboard.writeText(text).then(() => {
							$(this).html('<i class="fas fa-check"></i> Copied!');
							setTimeout(() => $(this).html('<i class="fas fa-copy"></i> Copy'), 1500);
						});
					});

					// Auto-swap: Copy signature to verification field
					$('#swapResult').click(function() {
						const result = $('#resultText').val();
						$('#signature').val(result);

						// Switch operation to verify
						$('#verifyRadio').prop('checked', true).parent().addClass('active');
						$('#signRadio').prop('checked', false).parent().removeClass('active');

						// Visual feedback
						$(this).html('<i class="fas fa-check"></i> Swapped!');
						setTimeout(() => {
							$(this).html('<i class="fas fa-exchange-alt"></i> Use for Verification');
						}, 1500);

						// Scroll to signature input
						$('html, body').animate({
							scrollTop: $('#signature').offset().top - 100
						}, 500);
					});

					// Share URL
					$('#shareUrl').click(function() {
						const result = $('#resultText').val();
						const operation = response.operation;
						const algorithm = response.algorithm;
						const message = $('#message').val();
						const publicKey = $('#publickeyparam').val();
						const privateKey = $('#privatekeyparam').val();

						// Create URL parameters
						const params = new URLSearchParams({
							msg: message,
							sig: result,
							op: 'verify',
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
										<li><strong>Message:</strong> The original message</li>
										<li><strong>Signature:</strong> The digital signature</li>
										<li><strong>Algorithm:</strong> The signature algorithm used</li>
									</ul>
								</div>
								<div class="alert alert-danger mb-3">
									<strong><i class="fas fa-skull-crossbones"></i> CRITICAL SECURITY WARNING:</strong>
									<p class="mb-2"><strong>You are about to share your PRIVATE KEY via URL!</strong></p>
									<ul class="mb-0">
										<li>Anyone with this URL can create valid signatures in your name</li>
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
										<li><strong>Message:</strong> The original message</li>
										<li><strong>Signature:</strong> The digital signature</li>
										<li><strong>Algorithm:</strong> The signature algorithm used</li>
										<li><strong>NOT Included:</strong> Your private key (kept secure)</li>
									</ul>
								</div>
								<div class="alert alert-info mb-3">
									<strong><i class="fas fa-info-circle"></i> Security Reminder:</strong>
									<p class="mb-0">This URL contains your public key, message, and signature.</p>
									<ul class="mb-0 mt-2">
										<li>The URL will be very long (RSA keys are 1000+ characters)</li>
										<li>Anyone with this URL can verify the signature</li>
										<li>Your private key remains secure</li>
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
				}

			} else {
				$('#output').html(`
					<div class="alert alert-danger mt-3">
						<h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Failed</h6>
						<p class="mb-2"><strong>Operation:</strong> ${response.operation || 'Unknown'}</p>
						<p class="mb-2"><strong>Algorithm:</strong> ${response.algorithm || 'Unknown'}</p>
						<p class="mb-0"><strong>Error:</strong> ${response.errorMessage || 'Unknown error occurred'}</p>
					</div>
				`);
			}
		}
	}

	// Handle URL parameters for Share URL feature
	const urlParams = new URLSearchParams(window.location.search);
	if (urlParams.has('msg') || urlParams.has('sig')) {
		if (urlParams.has('msg')) {
			$('#message').val(urlParams.get('msg'));
		}

		if (urlParams.has('sig')) {
			$('#signature').val(urlParams.get('sig'));
		}

		// Set operation to verify if signature is present
		if (urlParams.has('sig')) {
			$('#verifyRadio').prop('checked', true).parent().addClass('active');
			$('#signRadio').prop('checked', false).parent().removeClass('active');
		} else if (urlParams.get('op') === 'sign') {
			$('#signRadio').prop('checked', true).parent().addClass('active');
			$('#verifyRadio').prop('checked', false).parent().removeClass('active');
		}

		// Set algorithm if provided
		if (urlParams.has('algo')) {
			$('#algorithmSelect').val(urlParams.get('algo'));
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

			<!-- How RSA Signatures Work -->
			<section class="card mb-4">
				<div class="card-header bg-primary text-white">
					<h2 class="h5 mb-0"><i class="fas fa-cogs"></i> How RSA Digital Signatures Work</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-4">
							<h3 class="h6"><i class="fas fa-key text-success"></i> Key Generation</h3>
							<p>RSA signatures use the same key pair as RSA encryption: a public key for verification and a private key for signing. The key pair is generated by selecting two large prime numbers and computing mathematical relationships between them.</p>
							<ul class="small">
								<li><strong>512-bit:</strong> Weak, only for testing</li>
								<li><strong>1024-bit:</strong> Deprecated, avoid for production</li>
								<li><strong>2048-bit:</strong> Recommended minimum</li>
								<li><strong>4096-bit:</strong> High security for long-term use</li>
							</ul>
						</div>
						<div class="col-md-4">
							<h3 class="h6"><i class="fas fa-pen text-info"></i> Signing Process</h3>
							<p><strong>How Signing Works:</strong></p>
							<ol class="small">
								<li>The message is hashed using a cryptographic hash function (e.g., SHA-256)</li>
								<li>The hash is encrypted using your private key</li>
								<li>The encrypted hash becomes the digital signature</li>
								<li>The signature is Base64-encoded for transmission</li>
							</ol>
							<div class="alert alert-info small mb-0">
								<i class="fas fa-info-circle"></i> Signing uses your private key, unlike encryption which uses the public key.
							</div>
						</div>
						<div class="col-md-4">
							<h3 class="h6"><i class="fas fa-check-circle text-success"></i> Verification Process</h3>
							<p><strong>How Verification Works:</strong></p>
							<ol class="small">
								<li>The signature is decrypted using the public key, revealing the hash</li>
								<li>The message is independently hashed using the same algorithm</li>
								<li>The two hashes are compared</li>
								<li>If they match, the signature is valid</li>
							</ol>
							<div class="alert alert-success small mb-0">
								<i class="fas fa-shield-alt"></i> Anyone can verify a signature using the public key, ensuring non-repudiation.
							</div>
						</div>
					</div>
					<hr class="my-3">
					<h3 class="h6"><i class="fas fa-shield-alt text-primary"></i> Signature Schemes</h3>
					<div class="row small">
						<div class="col-md-6">
							<strong>RSASSA-PKCS1-v1_5:</strong> The classic deterministic signature scheme standardized in PKCS#1 v1.5. Widely supported and compatible with existing systems. Uses deterministic padding which means the same message always produces the same signature with the same key.
						</div>
						<div class="col-md-6">
							<strong>RSASSA-PSS:</strong> Probabilistic Signature Scheme with a formal security proof. Uses random padding, so the same message produces different signatures each time. More secure and recommended for new applications, but requires newer implementations.
						</div>
					</div>
				</div>
			</section>

			<!-- Common Use Cases -->
			<section class="card mb-4">
				<div class="card-header bg-success text-white">
					<h2 class="h5 mb-0"><i class="fas fa-lightbulb"></i> Common Use Cases for RSA Signatures</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-file-contract fa-2x text-primary mb-2"></i>
								<h3 class="h6">Document Signing</h3>
								<p class="small">Sign contracts, PDFs, and legal documents to prove authenticity and prevent tampering. Digital signatures provide legal validity in many jurisdictions.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-code fa-2x text-success mb-2"></i>
								<h3 class="h6">Code Signing</h3>
								<p class="small">Sign software binaries, executables, and scripts to verify publisher identity and ensure code hasn't been modified. Essential for app stores and enterprise software.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-envelope-open-text fa-2x text-info mb-2"></i>
								<h3 class="h6">Email Signing (S/MIME, PGP)</h3>
								<p class="small">Sign emails to prove sender identity and message integrity. S/MIME and PGP use RSA signatures to combat phishing and email spoofing.</p>
							</div>
						</div>
						<div class="col-md-3 mb-3">
							<div class="text-center">
								<i class="fas fa-server fa-2x text-warning mb-2"></i>
								<h3 class="h6">API Authentication</h3>
								<p class="small">Sign API requests to prove they came from an authorized source. Used in OAuth, JWT tokens, and webhook verification.</p>
							</div>
						</div>
					</div>
					<div class="alert alert-info small mb-0">
						<i class="fas fa-info-circle"></i> <strong>Pro Tip:</strong> RSA signatures provide both authentication (proof of identity) and integrity (proof message wasn't modified). Unlike MACs (Message Authentication Codes), RSA signatures also provide non-repudiation - the signer cannot deny creating the signature.
					</div>
				</div>
			</section>

			<!-- Security Best Practices -->
			<section class="card mb-4">
				<div class="card-header bg-warning text-dark">
					<h2 class="h5 mb-0"><i class="fas fa-exclamation-triangle"></i> Security Best Practices for RSA Signatures</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-6">
							<h3 class="h6 text-success"><i class="fas fa-check-circle"></i> Do's</h3>
							<ul class="small">
								<li>Use <strong>2048-bit or larger</strong> keys for production signatures</li>
								<li>Use <strong>SHA-256 or stronger</strong> hash algorithms (avoid MD5, SHA-1)</li>
								<li>Consider <strong>RSASSA-PSS</strong> for new applications (stronger security proof)</li>
								<li>Keep your <strong>private signing key secure</strong> - never share it</li>
								<li>Include <strong>timestamps</strong> in signatures for long-term validity</li>
								<li>Use <strong>hardware security modules (HSMs)</strong> for high-value signing keys</li>
								<li>Rotate keys periodically according to your security policy</li>
								<li>Verify signatures before trusting signed data</li>
							</ul>
						</div>
						<div class="col-md-6">
							<h3 class="h6 text-danger"><i class="fas fa-times-circle"></i> Don'ts</h3>
							<ul class="small">
								<li>Don't use <strong>MD5 or SHA-1</strong> for new signatures (collision vulnerabilities)</li>
								<li>Don't use <strong>512-bit or 1024-bit keys</strong> in production</li>
								<li>Don't share your <strong>private signing key</strong> with anyone</li>
								<li>Don't reuse signing keys across different applications or contexts</li>
								<li>Don't sign untrusted or unvalidated data blindly</li>
								<li>Don't assume signatures alone provide confidentiality (they don't)</li>
								<li>Don't ignore signature verification failures</li>
								<li>Don't use the same key pair for both signing and encryption</li>
							</ul>
						</div>
					</div>
				</div>
			</section>

			<!-- Why Trust This Tool -->
			<section class="card mb-4">
				<div class="card-header bg-info text-white">
					<h2 class="h5 mb-0"><i class="fas fa-shield-alt"></i> Why Trust This RSA Signature Tool?</h2>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-user-lock fa-3x text-primary mb-2"></i>
							<h3 class="h6">No Data Storage</h3>
							<p class="small">Your keys, messages, and signatures are processed in-session only. We don't log, store, or transmit your cryptographic data to third parties.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-code fa-3x text-success mb-2"></i>
							<h3 class="h6">Open Standards</h3>
							<p class="small">Built on standard Java Cryptography Architecture (JCA) implementing PKCS#1 specifications. No proprietary or unverified algorithms.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-graduation-cap fa-3x text-info mb-2"></i>
							<h3 class="h6">Educational Focus</h3>
							<p class="small">Designed for learning, testing, and development. Perfect for understanding RSA signature concepts, algorithms, and verification processes.</p>
						</div>
						<div class="col-md-3 text-center mb-3">
							<i class="fas fa-clock fa-3x text-warning mb-2"></i>
							<h3 class="h6">Active Since 2010</h3>
							<p class="small">Part of 8gwifi.org's suite of cryptography tools, serving developers and security professionals worldwide since 2010.</p>
						</div>
					</div>
					<hr>
					<div class="small">
						<p class="mb-2"><strong><i class="fas fa-user-tie"></i> About the Developer:</strong> This tool is developed and maintained by <strong>Anish Nath</strong>, a Security Engineer with extensive expertise in cryptography, PKI, digital signatures, and secure application development. Anish has created multiple open-source security tools and regularly publishes technical content on cryptographic implementations.</p>
						<p class="mb-0"><i class="fas fa-link"></i> <strong>Connect:</strong>
							<a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="text-primary">Twitter</a>
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
										<i class="fas fa-chevron-down"></i> What is an RSA digital signature and how does it work?
									</button>
								</h3>
							</div>
							<div id="faq1collapse" class="collapse show" data-parent="#faqAccordion">
								<div class="card-body small">
									An RSA digital signature is a cryptographic mechanism that allows you to sign a message with your private key to prove authenticity and integrity. The signature is created by hashing the message and encrypting the hash with your private key. Anyone can verify the signature using your public key by decrypting it and comparing the hash. Unlike encryption (which uses public key to encrypt), signing uses the private key to create the signature.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq2">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq2collapse">
										<i class="fas fa-chevron-down"></i> How do I sign a message with this tool?
									</button>
								</h3>
							</div>
							<div id="faq2collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									To sign a message: 1) Generate or provide an RSA key pair using the key size selector, 2) Select the "Sign" operation button, 3) Choose a signature algorithm (SHA256withRSA is recommended), 4) Enter your message in the message field, 5) Click the "Process" button. The tool will generate a Base64-encoded signature that you can copy and share along with your message and public key.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq3">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq3collapse">
										<i class="fas fa-chevron-down"></i> What signature algorithms are supported?
									</button>
								</h3>
							</div>
							<div id="faq3collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									This tool supports multiple RSA signature algorithms: SHA256withRSA (recommended), SHA1withRSA, SHA384withRSA, SHA512withRSA, MD5withRSA, MD2withRSA, and RSASSA-PSS variants (SHA1WithRSA/PSS, SHA224WithRSA/PSS, SHA384WithRSA/PSS, SHA1withRSAandMGF1). SHA256withRSA and SHA384withRSA are recommended for modern applications. Avoid MD5 and SHA-1 for new implementations due to known vulnerabilities.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq4">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq4collapse">
										<i class="fas fa-chevron-down"></i> What's the difference between RSASSA-PSS and RSASSA-PKCS1-v1_5?
									</button>
								</h3>
							</div>
							<div id="faq4collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									RSASSA-PKCS1-v1_5 is the older, deterministic signature scheme where the same message always produces the same signature. RSASSA-PSS (Probabilistic Signature Scheme) is newer and more secure, using random padding so signatures are different each time. PSS has a formal security proof and is recommended for new applications, though PKCS1-v1_5 is still widely used for compatibility with existing systems.
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq5">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq5collapse">
										<i class="fas fa-chevron-down"></i> How do I verify an RSA signature?
									</button>
								</h3>
							</div>
							<div id="faq5collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									To verify a signature: 1) Ensure you have the signer's public key in the Public Key field, 2) Select the "Verify" operation button, 3) Enter the original message, 4) Paste the Base64-encoded signature in the Signature field, 5) Select the same signature algorithm that was used for signing, 6) Click "Process". The tool will indicate whether the signature is valid (authentic and unmodified) or invalid (potentially tampered or incorrect key).
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-header p-2" id="faq6">
								<h3 class="mb-0">
									<button class="btn btn-link btn-block text-left small collapsed" type="button" data-toggle="collapse" data-target="#faq6collapse">
										<i class="fas fa-chevron-down"></i> Can I verify a signature without the private key?
									</button>
								</h3>
							</div>
							<div id="faq6collapse" class="collapse" data-parent="#faqAccordion">
								<div class="card-body small">
									Yes! Signature verification only requires the public key, not the private key. This is a fundamental property of digital signatures - anyone can verify a signature using the public key, but only the private key holder can create valid signatures. This asymmetry ensures non-repudiation (the signer cannot deny signing) and authenticity (you can prove who signed it).
								</div>
							</div>
						</div>

					</div>
				</div>
			</section>

			<!-- Technical Details Section -->
			<section class="card mb-4">
				<div class="card-header bg-dark text-white">
					<h2 class="h5 mb-0"><i class="fas fa-book"></i> RSA Digital Signatures - Technical Details & Implementation</h2>
				</div>
				<div class="card-body">
					<p>The <strong>Rivest-Shamir-Adleman (RSA)</strong> algorithm is one of the most widely used public-key cryptography methods. RSA digital signatures provide authentication, integrity, and non-repudiation by using asymmetric key pairs.</p>

					<h3 class="h6 mt-3"><i class="fas fa-calculator text-primary"></i> Mathematical Foundation</h3>
					<div class="row">
						<div class="col-md-6">
							<h4 class="small font-weight-bold">Signing Process</h4>
							<ol class="small mb-0">
								<li>Compute hash: <code>h = Hash(message)</code></li>
								<li>Apply padding: <code>m = Pad(h)</code></li>
								<li>Sign with private key: <code>s = m<sup>d</sup> mod n</code></li>
								<li>Encode signature: <code>signature = Base64(s)</code></li>
							</ol>
						</div>
						<div class="col-md-6">
							<h4 class="small font-weight-bold">Verification Process</h4>
							<ol class="small mb-0">
								<li>Decode signature: <code>s = Base64Decode(signature)</code></li>
								<li>Apply public key: <code>m' = s<sup>e</sup> mod n</code></li>
								<li>Extract hash: <code>h' = Unpad(m')</code></li>
								<li>Verify: <code>h' == Hash(message)</code></li>
							</ol>
						</div>
					</div>
					<p class="small mt-2 mb-0"><em>Where: d = private exponent, e = public exponent (usually 65537), n = modulus</em></p>

					<hr class="my-3">

					<h3 class="h6 mt-3"><i class="fas fa-shield-alt text-success"></i> RSA Signature Schemes (PKCS#1)</h3>
					<div class="row">
						<div class="col-md-6">
							<div class="card border-primary mb-3">
								<div class="card-header bg-primary text-white py-2">
									<strong>RSASSA-PKCS1-v1_5</strong>
								</div>
								<div class="card-body p-2">
									<ul class="small mb-0">
										<li><strong>Type:</strong> Deterministic</li>
										<li><strong>Padding:</strong> PKCS#1 v1.5</li>
										<li><strong>Security:</strong> Widely tested, no known practical attacks</li>
										<li><strong>Use Case:</strong> Legacy compatibility, TLS, X.509 certificates</li>
										<li><strong>Algorithm Names:</strong> SHA256withRSA, SHA384withRSA, SHA512withRSA</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="card border-success mb-3">
								<div class="card-header bg-success text-white py-2">
									<strong>RSASSA-PSS</strong>
								</div>
								<div class="card-body p-2">
									<ul class="small mb-0">
										<li><strong>Type:</strong> Probabilistic (random salt)</li>
										<li><strong>Padding:</strong> PSS (Probabilistic Signature Scheme)</li>
										<li><strong>Security:</strong> Formal security proof, recommended for new apps</li>
										<li><strong>Use Case:</strong> Modern applications, enhanced security</li>
										<li><strong>Algorithm Names:</strong> RSASSA-PSS, SHA256WithRSA/PSS</li>
									</ul>
								</div>
							</div>
						</div>
					</div>

					<div class="alert alert-info small mb-3">
						<strong><i class="fas fa-info-circle"></i> Key Difference:</strong> PKCS1-v1_5 produces the same signature every time for the same message and key, while PSS adds random salt making each signature unique even for identical inputs.
					</div>

					<hr class="my-3">

					<h3 class="h6 mt-3"><i class="fas fa-code text-warning"></i> Code Examples - Sign & Verify</h3>

					<div class="card">
						<div class="card-body p-0">
							<!-- Nav tabs -->
							<ul class="nav nav-tabs" id="codeExampleTabs" role="tablist">
								<li class="nav-item">
									<a class="nav-link active" id="python-tab" data-toggle="tab" href="#python" role="tab" aria-controls="python" aria-selected="true">
										<i class="fab fa-python"></i> Python
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="java-tab" data-toggle="tab" href="#java" role="tab" aria-controls="java" aria-selected="false">
										<i class="fab fa-java"></i> Java
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="nodejs-tab" data-toggle="tab" href="#nodejs" role="tab" aria-controls="nodejs" aria-selected="false">
										<i class="fab fa-node-js"></i> Node.js
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="go-tab" data-toggle="tab" href="#go" role="tab" aria-controls="go" aria-selected="false">
										<i class="fas fa-code"></i> Go
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="openssl-tab" data-toggle="tab" href="#openssl" role="tab" aria-controls="openssl" aria-selected="false">
										<i class="fas fa-terminal"></i> OpenSSL
									</a>
								</li>
							</ul>

							<!-- Tab panes -->
							<div class="tab-content p-3">
								<!-- Python Tab -->
								<div class="tab-pane fade show active" id="python" role="tabpanel" aria-labelledby="python-tab">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<strong class="text-muted small">Python (using cryptography library)</strong>
										<button class="btn btn-sm btn-outline-secondary" onclick="copyCode('python-code')">
											<i class="fas fa-copy"></i> Copy
										</button>
									</div>
<pre id="python-code" class="mb-0" style="font-size: 11px; background: #f8f9fa; padding: 15px; border-radius: 4px; overflow-x: auto; border: 1px solid #dee2e6;"><code>from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa, padding

# Generate RSA key pair
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
public_key = private_key.public_key()

# Sign message
message = b"Hello, World!"
signature = private_key.sign(
    message,
    padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),
    hashes.SHA256()
)
print(f"Signature (hex): {signature.hex()[:64]}...")

# Verify signature
try:
    public_key.verify(
        signature,
        message,
        padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),
        hashes.SHA256()
    )
    print("✓ Signature is valid")
except Exception:
    print("✗ Signature is invalid")
</code></pre>
									<div class="alert alert-info small mt-2 mb-0">
										<strong>Install:</strong> <code>pip install cryptography</code>
									</div>
								</div>

								<!-- Java Tab -->
								<div class="tab-pane fade" id="java" role="tabpanel" aria-labelledby="java-tab">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<strong class="text-muted small">Java (using java.security)</strong>
										<button class="btn btn-sm btn-outline-secondary" onclick="copyCode('java-code')">
											<i class="fas fa-copy"></i> Copy
										</button>
									</div>
<pre id="java-code" class="mb-0" style="font-size: 11px; background: #f8f9fa; padding: 15px; border-radius: 4px; overflow-x: auto; border: 1px solid #dee2e6;"><code>import java.security.*;
import java.util.Base64;

public class RSASignatureExample {
    public static void main(String[] args) throws Exception {
        // Generate RSA key pair
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair keyPair = keyGen.generateKeyPair();

        // Sign message
        String message = "Hello, World!";
        Signature sign = Signature.getInstance("SHA256withRSA");
        sign.initSign(keyPair.getPrivate());
        sign.update(message.getBytes("UTF-8"));
        byte[] signature = sign.sign();
        System.out.println("Signature: " + Base64.getEncoder().encodeToString(signature));

        // Verify signature
        Signature verify = Signature.getInstance("SHA256withRSA");
        verify.initVerify(keyPair.getPublic());
        verify.update(message.getBytes("UTF-8"));
        boolean isValid = verify.verify(signature);
        System.out.println("Valid: " + isValid);
    }
}
</code></pre>
									<div class="alert alert-info small mt-2 mb-0">
										<strong>Note:</strong> No external dependencies required - uses built-in java.security package
									</div>
								</div>

								<!-- Node.js Tab -->
								<div class="tab-pane fade" id="nodejs" role="tabpanel" aria-labelledby="nodejs-tab">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<strong class="text-muted small">Node.js (using crypto module)</strong>
										<button class="btn btn-sm btn-outline-secondary" onclick="copyCode('nodejs-code')">
											<i class="fas fa-copy"></i> Copy
										</button>
									</div>
<pre id="nodejs-code" class="mb-0" style="font-size: 11px; background: #f8f9fa; padding: 15px; border-radius: 4px; overflow-x: auto; border: 1px solid #dee2e6;"><code>const crypto = require('crypto');

// Generate RSA key pair
const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: { type: 'spki', format: 'pem' },
    privateKeyEncoding: { type: 'pkcs8', format: 'pem' }
});

// Sign message
const message = 'Hello, World!';
const sign = crypto.createSign('SHA256');
sign.update(message);
sign.end();
const signature = sign.sign(privateKey, 'base64');
console.log('Signature:', signature.substring(0, 64) + '...');

// Verify signature
const verify = crypto.createVerify('SHA256');
verify.update(message);
verify.end();
const isValid = verify.verify(publicKey, signature, 'base64');
console.log('Valid:', isValid);
</code></pre>
									<div class="alert alert-info small mt-2 mb-0">
										<strong>Note:</strong> Built-in crypto module (Node.js 10.12+) - no installation needed
									</div>
								</div>

								<!-- Go Tab -->
								<div class="tab-pane fade" id="go" role="tabpanel" aria-labelledby="go-tab">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<strong class="text-muted small">Go (using crypto/rsa)</strong>
										<button class="btn btn-sm btn-outline-secondary" onclick="copyCode('go-code')">
											<i class="fas fa-copy"></i> Copy
										</button>
									</div>
<pre id="go-code" class="mb-0" style="font-size: 11px; background: #f8f9fa; padding: 15px; border-radius: 4px; overflow-x: auto; border: 1px solid #dee2e6;"><code>package main

import (
    "crypto"
    "crypto/rand"
    "crypto/rsa"
    "crypto/sha256"
    "encoding/base64"
    "fmt"
)

func main() {
    // Generate RSA key pair
    privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
    publicKey := &privateKey.PublicKey

    // Sign message
    message := []byte("Hello, World!")
    hashed := sha256.Sum256(message)
    signature, _ := rsa.SignPKCS1v15(rand.Reader, privateKey, crypto.SHA256, hashed[:])
    fmt.Printf("Signature: %s...\n", base64.StdEncoding.EncodeToString(signature)[:64])

    // Verify signature
    err := rsa.VerifyPKCS1v15(publicKey, crypto.SHA256, hashed[:], signature)
    if err != nil {
        fmt.Println("✗ Signature is invalid")
    } else {
        fmt.Println("✓ Signature is valid")
    }
}
</code></pre>
									<div class="alert alert-info small mt-2 mb-0">
										<strong>Run:</strong> <code>go run main.go</code> - uses standard library packages
									</div>
								</div>

								<!-- OpenSSL Tab -->
								<div class="tab-pane fade" id="openssl" role="tabpanel" aria-labelledby="openssl-tab">
									<div class="d-flex justify-content-between align-items-center mb-2">
										<strong class="text-muted small">OpenSSL Command Line</strong>
										<button class="btn btn-sm btn-outline-secondary" onclick="copyCode('openssl-code')">
											<i class="fas fa-copy"></i> Copy
										</button>
									</div>
<pre id="openssl-code" class="mb-0" style="font-size: 11px; background: #f8f9fa; padding: 15px; border-radius: 4px; overflow-x: auto; border: 1px solid #dee2e6;"><code># Generate RSA private key
openssl genrsa -out private_key.pem 2048

# Extract public key
openssl rsa -in private_key.pem -pubout -out public_key.pem

# Sign a message (file)
echo "Hello, World!" > message.txt
openssl dgst -sha256 -sign private_key.pem -out signature.bin message.txt

# Convert signature to Base64
base64 signature.bin > signature.b64

# Verify signature
openssl dgst -sha256 -verify public_key.pem -signature signature.bin message.txt
# Output: Verified OK
</code></pre>
									<div class="alert alert-info small mt-2 mb-0">
										<strong>Requirement:</strong> OpenSSL installed on your system
									</div>
								</div>
							</div>
						</div>
					</div>

					<script>
					function copyCode(elementId) {
						const codeElement = document.getElementById(elementId);
						const code = codeElement.textContent;
						navigator.clipboard.writeText(code).then(() => {
							// Find the button that was clicked
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
						});
					}
					</script>

					<div class="alert alert-light small mt-3 mb-0">
                        <h3 class="h6 mt-3"><i class="fas fa-shield-alt text-success"></i> Standards & References</h3>
						<ul class="mb-0 mt-2" style="line-height: 1.8;">
							<li>
								<strong><a href="https://tools.ietf.org/html/rfc8017" target="_blank" rel="noopener" class="text-primary">RFC 8017</a>:</strong>
								PKCS #1: RSA Cryptography Specifications Version 2.2 (IETF)
							</li>
							<li>
								<strong><a href="https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf" target="_blank" rel="noopener" class="text-primary">FIPS 186-5</a>:</strong>
								Digital Signature Standard (DSS) - Latest version (NIST)
							</li>
							<li>
								<strong><a href="https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final" target="_blank" rel="noopener" class="text-primary">NIST SP 800-57</a>:</strong>
								Recommendation for Key Management (Part 1, Rev. 5)
							</li>
							<li>
								<strong><a href="https://csrc.nist.gov/publications/detail/sp/800-131a/rev-2/final" target="_blank" rel="noopener" class="text-primary">NIST SP 800-131A</a>:</strong>
								Transitioning the Use of Cryptographic Algorithms and Key Lengths
							</li>
							<li>
								<strong><a href="https://www.iso.org/standard/54956.html" target="_blank" rel="noopener" class="text-primary">ISO/IEC 9796-2:2010</a>:</strong>
								Digital signature schemes giving message recovery — Part 2: Integer factorization based mechanisms
							</li>
							<li>
								<strong><a href="https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf" target="_blank" rel="noopener" class="text-primary">Twenty Years of Attacks on RSA</a>:</strong>
								Comprehensive survey paper by Dan Boneh (Stanford)
							</li>
						</ul>
					</div>
				</div>
			</section>

		</div>
	</div>
</div>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

</div>
<%@ include file="body-close.jsp"%>
