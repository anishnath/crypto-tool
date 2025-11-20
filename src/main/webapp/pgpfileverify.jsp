<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
	<title>PGP Signature Verification Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Free online PGP signature verification tool. Verify PGP/GPG signed files and messages using public keys. OpenPGP (RFC 4880) compliant. Validate file integrity and authenticity. No data retention.">
	<meta name="keywords" content="pgp signature verification, verify pgp signature, gpg verify signature, openpgp verification, file integrity check, digital signature validation, pgp message verification">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgpfileverify.jsp">
	<meta property="og:title" content="PGP Signature Verification Online – Free | 8gwifi.org">
	<meta property="og:description" content="Free online PGP signature verification tool. Verify PGP/GPG signed files using public keys. OpenPGP standard compliant. Validate file integrity and authenticity.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgpv.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgpfileverify.jsp">
	<meta name="twitter:title" content="PGP Signature Verification Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Free online PGP signature verification. Verify signed files with public keys. OpenPGP compliant.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgpv.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Signature Verification Online – Free",
  "description" : "Free online PGP signature verification tool implementing OpenPGP standard (RFC 4880). Verify digital signatures on PGP-signed files and messages using public keys. Ensures file integrity and authenticity verification.",
  "url" : "https://8gwifi.org/pgpfileverify.jsp",
  "image" : "https://8gwifi.org/images/site/pgpv.png",
  "screenshot" : "https://8gwifi.org/images/site/pgpv.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "UtilitiesApplication"],
  "applicationSubCategory" : "Signature Verification Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer"
  },
  "datePublished" : "2018-12-02",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "Verify PGP/GPG digital signatures on files",
    "Validate message authenticity using public keys",
    "OpenPGP standard (RFC 4880) compliant",
    "File integrity verification",
    "No data retention - secure verification",
    "Support for armored PGP messages"
  ]
}
</script>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Signature Verification Online – Free",
  "description": "Verify PGP/GPG digital signatures on files and messages using public keys online.",
  "url": "https://8gwifi.org/pgpfileverify.jsp",
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
        "name": "PGP Signature Verification",
        "item": "https://8gwifi.org/pgpfileverify.jsp"
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
  "name": "How to Verify PGP Signatures Online",
  "description": "Step-by-step guide to verifying PGP/GPG digital signatures on files using public keys.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Upload Signed File",
      "text": "Upload the PGP-signed file (armored message) that you want to verify. The file should contain a digital signature created with someone's private key.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Provide Public Key",
      "text": "Paste the PGP public key of the person who signed the file. This public key must match the private key used to create the signature.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Verify Signature",
      "text": "Click 'Submit' to verify the signature. The tool will check if the file was signed by the holder of the corresponding private key and hasn't been tampered with.",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Review Results",
      "text": "The verification result will show if the signature is valid (file is authentic and unmodified) or invalid (file has been tampered with or signed by a different key).",
      "position": 4
    }
  ]
}
</script>

	<style>
		/* CLS optimization - reserved space for output */
		#output {
			min-height: 150px;
			transition: all 0.3s ease;
		}
		#output:empty {
			min-height: 0;
		}
		#output > * {
			animation: fadeIn 0.3s ease-in;
		}

		/* Ensure alert boxes have consistent height */
		#output .alert {
			min-height: 120px;
		}

		/* Fixed height for card examples */
		#output .card pre {
			max-height: 300px;
			overflow-y: auto;
		}

		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		/* Loading spinner fixed height */
		.verification-loading {
			height: 200px;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-direction: column;
		}

		/* Validation feedback styles */
		.is-valid-custom {
			border-color: #28a745 !important;
		}
		.is-invalid-custom {
			border-color: #dc3545 !important;
		}
		.validation-feedback {
			display: block;
			margin-top: 0.25rem;
			font-size: 0.875rem;
		}
		.validation-feedback.valid-feedback {
			color: #28a745;
		}
		.validation-feedback.invalid-feedback {
			color: #dc3545;
		}
	</style>

	<script type="text/javascript">
		$(document).ready(function() {
			// Enable tooltips
			$('[data-toggle="tooltip"]').tooltip();

			// Update file input label when file is selected
			$('#file').on('change', function() {
				const fileName = $(this).val().split('\\').pop();
				$(this).next('.custom-file-label').html(fileName || 'Choose PGP signed file...');
			});

			// Real-time validation for public key
			function validatePublicKey() {
				const $textarea = $('#pKey');
				const value = $textarea.val().trim();
				const $feedback = $('#pKeyFeedback');

				if (value.length === 0) {
					// Empty - remove validation classes
					$textarea.removeClass('is-valid-custom is-invalid-custom');
					$feedback.html('').removeClass('valid-feedback invalid-feedback');
				} else if (value.includes('-----BEGIN PGP PUBLIC KEY BLOCK-----') && value.includes('-----END PGP PUBLIC KEY BLOCK-----')) {
					// Valid PGP public key format
					$textarea.removeClass('is-invalid-custom').addClass('is-valid-custom');
					$feedback.html('<i class="fas fa-check-circle"></i> Valid PGP public key format').removeClass('invalid-feedback').addClass('valid-feedback');
				} else {
					// Invalid format
					$textarea.removeClass('is-valid-custom').addClass('is-invalid-custom');
					$feedback.html('<i class="fas fa-times-circle"></i> Invalid format. Key must include BEGIN and END PGP PUBLIC KEY BLOCK headers').removeClass('valid-feedback').addClass('invalid-feedback');
				}
			}

			$('#pKey').on('input', validatePublicKey);

			// Validate on page load (for default key)
			validatePublicKey();

			// Download example file as .asc
			$('#downloadExampleBtn').on('click', function() {
				const $btn = $(this);
				const content = $('#samplePGPFile').val();

				// Create blob and download link
				const blob = new Blob([content], { type: 'text/plain' });
				const url = window.URL.createObjectURL(blob);
				const a = document.createElement('a');
				a.href = url;
				a.download = 'example-pgp-signed-message.asc';
				document.body.appendChild(a);
				a.click();

				// Cleanup
				window.URL.revokeObjectURL(url);
				document.body.removeChild(a);

				// Visual feedback
				const originalHtml = $btn.html();
				$btn.html('<i class="fas fa-check"></i> Downloaded!');
				$btn.removeClass('btn-outline-success').addClass('btn-success');

				setTimeout(function() {
					$btn.html(originalHtml);
					$btn.removeClass('btn-success').addClass('btn-outline-success');
				}, 2000);
			});

			// Copy example file to clipboard
			$('#copyExampleBtn').on('click', function() {
				const $btn = $(this);
				const $textarea = $('#samplePGPFile');

				$textarea.select();
				document.execCommand('copy');

				// Visual feedback
				const originalHtml = $btn.html();
				$btn.html('<i class="fas fa-check"></i> Copied!');
				$btn.removeClass('btn-outline-secondary').addClass('btn-success');

				setTimeout(function() {
					$btn.html(originalHtml);
					$btn.removeClass('btn-success').addClass('btn-outline-secondary');
				}, 2000);
			});

			// Form submission with validation
			$('#form1').submit(function(event) {
				event.preventDefault();

				// Validate file is selected
				const fileInput = $('#file')[0];
				if (!fileInput.files || fileInput.files.length === 0) {
					$('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> Please select a PGP signed file to verify.</div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
					return false;
				}

				// Validate public key is provided
				const publicKey = $('#pKey').val().trim();
				if (!publicKey || publicKey.length === 0) {
					$('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> Please provide the signer\'s public key.</div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
					return false;
				}

				// Validate public key format
				if (!publicKey.includes('-----BEGIN PGP PUBLIC KEY BLOCK-----') || !publicKey.includes('-----END PGP PUBLIC KEY BLOCK-----')) {
					$('#output').html('<div class="alert alert-danger"><i class="fas fa-times-circle"></i> <strong>Invalid Public Key Format:</strong> The public key must contain <code>-----BEGIN PGP PUBLIC KEY BLOCK-----</code> and <code>-----END PGP PUBLIC KEY BLOCK-----</code> headers. Please check your key and try again.</div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
					return false;
				}

				// Validate file content (read and check PGP format)
				const file = fileInput.files[0];
				const reader = new FileReader();

				reader.onload = function(e) {
					const fileContent = e.target.result;

					// Check if file contains PGP message or signature markers
					const isPGPMessage = fileContent.includes('-----BEGIN PGP MESSAGE-----') && fileContent.includes('-----END PGP MESSAGE-----');
					const isPGPSignature = fileContent.includes('-----BEGIN PGP SIGNATURE-----') && fileContent.includes('-----END PGP SIGNATURE-----');
					const isPGPSignedMessage = fileContent.includes('-----BEGIN PGP SIGNED MESSAGE-----');

					if (!isPGPMessage && !isPGPSignature && !isPGPSignedMessage) {
						$('#output').html('<div class="alert alert-danger"><i class="fas fa-times-circle"></i> <strong>Invalid PGP File Format:</strong> The uploaded file does not appear to be a valid PGP signed file. It should contain one of the following:<ul class="mt-2 mb-0"><li><code>-----BEGIN PGP MESSAGE-----</code></li><li><code>-----BEGIN PGP SIGNATURE-----</code></li><li><code>-----BEGIN PGP SIGNED MESSAGE-----</code></li></ul><p class="mt-2 mb-0">Please upload a valid PGP-signed file (armored format).</p></div>');
						$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
						return false;
					}

					// All validations passed, proceed with submission
					$('#output').html('<div class="verification-loading"><div class="spinner-border text-primary" role="status"><span class="sr-only">Verifying signature...</span></div><p class="mt-3">Verifying PGP signature... Please wait.</p></div>');

					const formData = new FormData($('#form1')[0]);
					$.ajax({
						type : "POST",
						url : "PGPFunctionality",
						processData: false,
						contentType: false,
						data : formData,
						success : function(msg) {
							$('#output').empty();
							$('#output').append(msg);

							// Smooth scroll to results
							$('html, body').animate({
								scrollTop: $('#output').offset().top - 100
							}, 400);
						},
						error: function() {
							$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> Unable to verify signature. Please try again.</div>');
						}
					});
				};

				reader.onerror = function() {
					$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> Unable to read the uploaded file. Please try again.</div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
				};

				// Read the file as text
				reader.readAsText(file);
			});
		});
	</script>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">PGP Signature Verification</h1>
<p class="lead text-muted">Verify PGP/GPG signed files and messages for authenticity and integrity</p>
<hr>

<form id="form1" action="PGPFunctionality" name="form1" enctype="multipart/form-data" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="VERIFY_PGP_FILE">

	<div class="form-group">
		<label for="file">
			<i class="fas fa-file-upload text-primary"></i> <strong>PGP Signed File</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Upload the PGP-signed file (armored message) to verify"></i>
		</label>
		<div class="custom-file">
			<input type="file" class="custom-file-input" id="file" name="file" accept=".asc,.gpg,.pgp,.txt" required>
			<label class="custom-file-label" for="file">Choose PGP signed file...</label>
		</div>
		<small class="form-text text-muted">Supported formats: .asc, .gpg, .pgp, .txt (armored PGP messages)</small>
	</div>

	<%
		String pKey =(String)session.getAttribute("pKey");
		if(null==pKey || pKey.trim().length()==0)
		{
			pKey="-----BEGIN PGP PUBLIC KEY BLOCK-----\n" +
					"Version: BCPG v1.58\n" +
					"\n" +
					"mI0EWiDkcQEEANhVhYz3NAbRhpQST2vqsV3nIg9Zx6lWY6viB/wBkbs14KLGPX8D\n" +
					"DLBkfGonRtknGIU+0cUEnyNvxE5K5VvRMrqeGzusz+iG3jX9zRomeQtOKL9xQJEJ\n" +
					"fqJ/Y09KbiZy37x85FAlmmfh7xsxHHLN4zZqbDArLBOTKDDk9C2vQ0Y/ABEBAAG0\n" +
					"BWFuaXNoiJwEEAECAAYFAlog5HEACgkQlN3e89Fl/7YDuQQA0TTw0iYX9kBmMXGF\n" +
					"CCWEZyJAhqueYDFhJ29+fvcKLN37Agn595oC8/h3mjylyEeaIsdkVL8rVUzexji6\n" +
					"esiHZyWoDvzti8cqq5kp146gkYOSEoBiTkGN9Lds1qvDrOZDWvD1HtAWBhDNc/kH\n" +
					"d/4//xH/VMk12zxr/8WLJ9lU6rs=\n" +
					"=c9OB\n" +
					"-----END PGP PUBLIC KEY BLOCK-----";
		}
	%>

	<div class="form-group">
		<label for="pKey">
			<i class="fas fa-key text-success"></i> <strong>Signer's Public Key</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Paste the PGP public key of the person who signed the file"></i>
		</label>
		<textarea class="form-control" name="pKey" id="pKey" rows="8" style="font-family: 'Courier New', monospace; font-size: 12px;" required><%=pKey%></textarea>
		<div id="pKeyFeedback" class="validation-feedback"></div>
		<small class="form-text text-muted">The public key must match the private key used to sign the file</small>
	</div>

	<div class="form-group">
		<button type="submit" class="btn btn-primary btn-lg">
			<i class="fas fa-check-circle"></i> Verify Signature
		</button>
		<button type="button" class="btn btn-outline-info btn-lg ml-2" data-toggle="collapse" data-target="#exampleSection">
			<i class="fas fa-file-code"></i> View Example File
		</button>
	</div>
</form>

<!-- Collapsible Example Section -->
<div class="collapse" id="exampleSection">
	<div class="card card-body bg-light mb-3">
		<h5><i class="fas fa-lightbulb text-warning"></i> Example PGP Signed Message</h5>
		<p class="text-muted small">This is an example of a PGP-signed file. You can download it as a .asc file or copy the text and upload it for testing.</p>
		<div class="position-relative">
			<textarea class="form-control" readonly id="samplePGPFile" rows="12" style="font-family: 'Courier New', monospace; font-size: 11px;">-----BEGIN PGP MESSAGE-----
Version: BCPG v1.58

owJ4nNWWS2gTQRjH09YqLdSKF7UUjcGDgjubpC3UuE2pUKHQ1qJipVrKZDPZTrqZ
WXc2jyKoaBXxUAtt0auKICLUg+hBVLwJFh948qCCCOJFlB70Vmc3r9lm+7goeElm
vu8/M7/vv7MzO9VQ46uumvnwceEtWnxY9fLFQGyDQVMgl9KHmqWcYpg0iVTLz/uE
dQRGLcuIyHIKZhAB0IDqKALU1OSBQ31yKwiCYCCvjOQYLqmz2SzItji6cDAYko/3
9R7hA1NQwoRZkKgoUO/38xER5oR7qQotTMkalvMvp3ACUqZ1JDgSBDkWD0T5EkqK
xpF+DJmMzx51JlBkV8wWaSZNGz3xKJ8GtGtZnMCKXIzZeWhaOAFVi3dVc9ywqCIL
IVvBMcaghokWzUJTkctdO5kpLBWyl5cO9vR39SpyRlifwBQqzOzvs8vwD6IYNAxF
djK2JG3q0WUqV2Q7aYviyEAkjoiKEbMDYmg8HxCqTaYJtlyFOmmhsoLCXasjKtK3
gHYQchXjpJlKDRS1EOOj8+08jbwUx4NvCaXKtyZLE5DkS6DxClwPaEcoMWRyKi/4
JSUc7u7t7jrSXVGEF+7fR9aRp+F/nTkJMzAHsgyYbC3AzGwJhSRo4P/KYFXHiPwT
f11HSoymeUKFzNLRElgRMqYampSMj4XaKKlkFE6RtnYBzBuo1Kirc7HV8b6IVjhF
7JOFm2pQwv0RN4CtF0gcnYeJtixTOmTbQFgA5KmVEUXAcngNDgpit41jOOdppDDA
282ywPvfVUkxKP4qOyXJuaGYfVBniIkMyrBFzXHA/S2xyEkah5KFU6jc8ktSacpV
LCmNWc0LQbiyDWGwD7RW+uDx5CoB3Rvefjc1SjUd8YrjCGjMfgjLbvp8etnNHub3
S3iF3V7vYixce0osjfXiTAlMoN5fvmAVuRxxRhfE/NLOf/hE6y/fWuerqvY11FYP
+b9uWd8MCWajvvq6TcWPpppAzeKJo+t3nH2yfX5+4JPv5c+Tz87Pbkw0m4+a3kvb
Lr85MDn1ZDo5d/NiYqT29+3grcbgA7z//bvZ6Q8z1+cu3hsKDN+/23jp9Ozzc8NX
L3TunXx8I7Lr4Z5tY98fjW6NvRocrHkNMxPXgNk5EZH7P29u+Xaq48fCzS+/TtTe
vXJn8EzT7t9P/wBbfxTc
=MQ43
-----END PGP MESSAGE-----</textarea>
			<div class="position-absolute" style="top: 10px; right: 10px;">
				<button type="button" class="btn btn-sm btn-outline-success" id="downloadExampleBtn" data-toggle="tooltip" title="Download as .asc file">
					<i class="fas fa-download"></i> Download
				</button>
				<button type="button" class="btn btn-sm btn-outline-secondary ml-1" id="copyExampleBtn" data-toggle="tooltip" title="Copy to clipboard">
					<i class="fas fa-copy"></i> Copy
				</button>
			</div>
		</div>
	</div>
</div>

<div id="output">
	<!-- Results will be displayed here via AJAX -->
</div>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
  <div class="card-header bg-info text-white">
    <h3 class="mb-0">PGP Signature Verification Explained</h3>
  </div>
  <div class="card-body">
    <h4>How PGP Digital Signatures Work</h4>
    <p>PGP (Pretty Good Privacy) digital signatures provide cryptographic proof that a file or message was created by a specific person and hasn't been tampered with. The verification process involves:</p>
    <ol>
      <li><strong>Signature Creation:</strong> The sender creates a hash of the file/message and encrypts it with their private key</li>
      <li><strong>File Distribution:</strong> The signed file (containing both message and encrypted hash) is shared</li>
      <li><strong>Verification:</strong> Recipient uses sender's public key to decrypt the hash and compare it with a newly computed hash</li>
      <li><strong>Result:</strong> If hashes match, the signature is valid - proving authenticity and integrity</li>
    </ol>

    <h4>Why Verify PGP Signatures?</h4>
    <ul>
      <li><strong>Authenticity:</strong> Confirms the file was signed by the holder of the corresponding private key</li>
      <li><strong>Integrity:</strong> Ensures the file hasn't been modified since signing</li>
      <li><strong>Non-repudiation:</strong> Signer cannot deny having signed the file</li>
      <li><strong>Trust:</strong> Essential for software downloads, secure communications, and legal documents</li>
    </ul>

    <div class="alert alert-warning mt-3">
      <strong>Important:</strong> A valid signature only proves the file was signed by someone with the private key. Always verify the public key belongs to the claimed person through trusted channels (key fingerprints, keyservers, web of trust).
    </div>
  </div>
</div>

<div class="card my-4 border-success">
  <div class="card-header bg-success text-white">
    <h3 class="mb-0">Author Credentials & Expertise</h3>
  </div>
  <div class="card-body">
    <p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and digital signatures.</p>
    <ul>
      <li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, and PKI systems</li>
      <li><strong>Expertise:</strong> OpenPGP/GPG implementations, digital signature verification, certificate validation</li>
      <li><strong>Standards Knowledge:</strong> Deep understanding of RFC 4880 (OpenPGP), X.509, digital signature algorithms</li>
      <li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank">@anish2good on X (Twitter)</a></li>
    </ul>

    <div class="alert alert-info mt-3">
      <strong>Implementation Note:</strong> This tool uses Bouncy Castle cryptographic library for signature verification, following OpenPGP standards strictly. No uploaded files or keys are stored on our servers.
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
      <li>Uploaded files are <strong>never stored</strong> on our servers</li>
      <li>Files are processed in memory and immediately discarded after verification</li>
      <li>Public keys used for verification are not logged or retained</li>
      <li>No tracking cookies or analytics on this verification tool</li>
      <li>All processing happens server-side with immediate cleanup</li>
    </ul>

    <h4>Common Use Cases</h4>
    <ul>
      <li><strong>Software Verification:</strong> Verify downloaded software packages haven't been tampered with</li>
      <li><strong>Email Authentication:</strong> Confirm signed emails are from the claimed sender</li>
      <li><strong>Document Validation:</strong> Verify legal documents and contracts</li>
      <li><strong>Code Signing:</strong> Validate Git commits, release packages, and code integrity</li>
      <li><strong>Secure Communications:</strong> Verify messages in end-to-end encrypted systems</li>
    </ul>

    <h4>Authoritative Sources</h4>
    <ul>
      <li><a href="https://tools.ietf.org/html/rfc4880" target="_blank" rel="noopener">RFC 4880 - OpenPGP Message Format</a> (IETF Standard)</li>
      <li><a href="https://www.openpgp.org/" target="_blank" rel="noopener">OpenPGP.org</a> - Official OpenPGP Working Group</li>
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
      "name": "What is PGP signature verification?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "PGP signature verification is the process of checking a digital signature on a file or message to confirm: (1) the file was signed by someone with the corresponding private key, and (2) the file hasn't been modified since signing. It uses public-key cryptography where the signer uses their private key to create the signature, and anyone can verify it using the signer's public key."
      }
    },
    {
      "@type": "Question",
      "name": "How do I verify a PGP signature online?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To verify a PGP signature: (1) Upload the PGP-signed file (armored message containing both the message and signature), (2) Paste the signer's PGP public key into the provided field, (3) Click Submit to verify. The tool will tell you if the signature is valid (authentic and unmodified) or invalid (tampered with or wrong key)."
      }
    },
    {
      "@type": "Question",
      "name": "What does a valid PGP signature prove?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "A valid PGP signature proves two things: (1) Authenticity - the file was signed by someone possessing the private key corresponding to the public key you used for verification, and (2) Integrity - the file content has not been altered since it was signed. However, you must independently verify that the public key actually belongs to the claimed person."
      }
    },
    {
      "@type": "Question",
      "name": "Why does signature verification fail?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Signature verification fails when: (1) The file has been modified after signing, (2) Wrong public key is used (doesn't match the private key used for signing), (3) The signature format is corrupted or incomplete, (4) The signed file is not a valid PGP message format. Make sure you're using the correct public key from the actual signer and the file hasn't been edited."
      }
    },
    {
      "@type": "Question",
      "name": "Is online PGP signature verification secure?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, for verification purposes. This tool implements OpenPGP standard (RFC 4880) correctly and uses Bouncy Castle cryptographic library. We don't store uploaded files or keys - everything is processed in memory and immediately discarded. However, never upload files containing sensitive information that shouldn't be temporarily on a server. For maximum security with highly sensitive files, use offline tools like GPG on an air-gapped computer."
      }
    },
    {
      "@type": "Question",
      "name": "What file formats are supported for signature verification?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool supports PGP armored message files (text format beginning with '-----BEGIN PGP MESSAGE-----' and ending with '-----END PGP MESSAGE-----'). These files contain both the message/file content and the digital signature in a text-based format compatible with OpenPGP standard (RFC 4880), GPG, and other PGP implementations."
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