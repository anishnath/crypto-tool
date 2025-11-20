<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Download PGP Encrypted File Online – Free | 8gwifi.org</title>
	<meta name="description" content="Download and decrypt PGP encrypted files online. Secure file download with OpenPGP decryption. Access encrypted files shared via PGP transfer. Free PGP file retrieval and decryption tool.">
	<meta name="keywords" content="pgp file download, encrypted file download, pgp decrypt download, openpgp file retrieval, pgp asc file download, decrypt pgp file online, secure file download">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgp-download.jsp">
	<meta property="og:title" content="Download PGP Encrypted File Online – Free | 8gwifi.org">
	<meta property="og:description" content="Download and decrypt PGP encrypted files. Secure file retrieval with OpenPGP decryption support.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgp-download.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgp-download.jsp">
	<meta name="twitter:title" content="Download PGP Encrypted File Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Download and decrypt PGP encrypted files with OpenPGP support.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgp-download.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<script src="https://unpkg.com/openpgp@4.10.10/dist/openpgp.min.js"></script>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "Download PGP Encrypted File Online – Free",
  "description" : "Download and decrypt PGP encrypted files online. Secure file retrieval service with OpenPGP decryption support. Download encrypted .asc files and decrypt them with your private key. Client-side decryption ensures privacy.",
  "url" : "https://8gwifi.org/pgp-download.jsp",
  "image" : "https://8gwifi.org/images/site/pgp-download.png",
  "screenshot" : "https://8gwifi.org/images/site/pgp-download.png",
  "applicationCategory" : ["SecurityApplication", "FileTransferApplication", "CryptographyApplication"],
  "applicationSubCategory" : "Encrypted File Download and Decryption",
  "browserRequirements" : "Requires JavaScript and OpenPGP.js. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer"
  },
  "datePublished" : "2023-11-21",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "Download PGP encrypted files (.asc format)",
    "Client-side decryption using OpenPGP.js",
    "Secure file retrieval with private key",
    "No server-side decryption - privacy preserved",
    "Direct download of encrypted or decrypted files"
  ]
}
	</script>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Download PGP Encrypted File Online – Free",
  "description": "Download and decrypt PGP encrypted files online.",
  "url": "https://8gwifi.org/pgp-download.jsp",
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
        "name": "PGP File Download",
        "item": "https://8gwifi.org/pgp-download.jsp"
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
  "name": "How to Download and Decrypt PGP Encrypted Files",
  "description": "Step-by-step guide to downloading and decrypting PGP encrypted files using your private key.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Access Download Link",
      "text": "Use the secure download link provided in your email notification to access the encrypted file.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Download Encrypted File",
      "text": "Click 'Download ASC File' to save the encrypted file to your device. The file has a .asc extension and is encrypted with your PGP public key.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Decrypt File (Optional)",
      "text": "Click 'Decrypt & Download' to decrypt the file in your browser. Upload your PGP private key file (.asc) and enter your passphrase.",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Download Decrypted File",
      "text": "The decrypted file will be downloaded automatically. Decryption happens client-side in your browser for maximum security.",
      "position": 4
    }
  ]
}
	</script>

	<style>
		/* Validation feedback */
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

		/* Button state */
		.btn:disabled {
			opacity: 0.6;
			cursor: not-allowed;
		}

		/* Alert animations */
		.alert {
			animation: fadeIn 0.3s ease-in;
		}
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		/* File card highlight */
		.file-card {
			border: 2px solid #28a745;
			background-color: #f8fff9;
		}

		/* Custom file input */
		.custom-file-label::after {
			content: "Browse";
		}
	</style>

</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">PGP Encrypted File Download</h1>
<p class="lead text-muted">Download and decrypt PGP encrypted files securely</p>
<hr>

<%-- Access the presigned URL from the session --%>
<%
	String presignedUrl = (String) session.getAttribute("presignedUrl");
	String file_name = (String) session.getAttribute("file_name");
	session.removeAttribute("presignedUrl");
	session.removeAttribute("file_name");

	if (file_name == null) {
		response.sendRedirect(request.getContextPath() + "/pgp-upload.jsp");
		return;
	}

	if (presignedUrl != null) {
%>
	<div class="alert alert-success">
		<i class="fas fa-check-circle"></i> <strong>File Available:</strong> Your encrypted file is ready for download.
	</div>

	<div class="card file-card mb-4">
		<div class="card-header bg-success text-white">
			<h5 class="mb-0"><i class="fas fa-file-download"></i> File: <strong><%=file_name%></strong></h5>
		</div>
		<div class="card-body">
			<div class="alert alert-info">
				<i class="fas fa-info-circle"></i> <strong>Download Options:</strong> Download the encrypted .asc file directly, or decrypt it in your browser using your PGP private key.
			</div>

			<div class="btn-group btn-group-lg mb-3" role="group">
				<a id="downloadLink" href="<%= presignedUrl %>" download="<%=file_name%>" class="btn btn-primary">
					<i class="fas fa-download"></i> Download ASC File
				</a>
				<button type="button" id="showDecryptBtn" class="btn btn-success" onclick="showDecryptionFields()">
					<i class="fas fa-unlock"></i> Decrypt & Download
				</button>
			</div>

			<!-- Decryption Section -->
			<div id="decryptionFields" style="display: none;">
				<hr>
				<h5><i class="fas fa-key"></i> Decrypt File with Your Private Key</h5>
				<p class="text-muted">Decryption happens client-side in your browser. Your private key never leaves your device.</p>

				<form id="decryptForm">
					<div class="form-group">
						<label for="pgpKeyFile">
							<i class="fas fa-file-code text-primary"></i> <strong>PGP Private Key File</strong> <span class="text-danger">*</span>
							<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Upload your PGP private key file (.asc)"></i>
						</label>
						<div class="custom-file">
							<input type="file" class="custom-file-input" id="pgpKeyFile" accept=".asc" required>
							<label class="custom-file-label" for="pgpKeyFile">Choose your private key file (.asc)...</label>
						</div>
						<div id="keyFileFeedback" class="validation-feedback"></div>
						<small class="form-text text-muted">Your private key file (usually ends with .asc)</small>
					</div>

					<div class="form-group">
						<label for="pgpPassword">
							<i class="fas fa-lock text-warning"></i> <strong>Private Key Passphrase</strong> <span class="text-danger">*</span>
							<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Enter the passphrase for your private key"></i>
						</label>
						<input type="password" class="form-control" id="pgpPassword" placeholder="Enter your private key passphrase" required>
						<div id="passwordFeedback" class="validation-feedback"></div>
						<small class="form-text text-muted">The passphrase used when generating your key pair</small>
					</div>

					<button type="button" id="decryptButton" class="btn btn-success btn-lg" onclick="decryptFile('<%= presignedUrl %>', '<%=file_name%>')" disabled>
						<i class="fas fa-unlock-alt"></i> Decrypt & Download File
					</button>
				</form>

				<div class="mt-3" id="resultArea"></div>
			</div>
		</div>
	</div>

<%
	} else {
%>
	<div class="alert alert-danger">
		<i class="fas fa-exclamation-triangle"></i> <strong>File Not Found:</strong> The specified file <strong><%=file_name%></strong> doesn't exist or has expired.
	</div>

	<div class="card">
		<div class="card-body">
			<p>The file may have been downloaded already or the link has expired. Please request a new upload from the sender.</p>
			<a href="pgp-upload.jsp" class="btn btn-primary">
				<i class="fas fa-upload"></i> Upload New File
			</a>
		</div>
	</div>
<%
	}
%>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

<!-- Related Tools -->
<div class="card my-4">
	<div class="card-header bg-secondary text-white">
		<h3 class="mb-0"><i class="fas fa-tools"></i> Related PGP Tools</h3>
	</div>
	<div class="card-body">
		<div class="row">
			<div class="col-md-4">
				<div class="card mb-3">
					<div class="card-body">
						<h5 class="card-title"><i class="fas fa-upload text-primary"></i> PGP File Transfer</h5>
						<p class="card-text">Upload and encrypt files with PGP public key encryption.</p>
						<a href="pgp-upload.jsp" class="btn btn-sm btn-primary">Upload File</a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card mb-3">
					<div class="card-body">
						<h5 class="card-title"><i class="fas fa-unlock text-success"></i> PGP File Decrypt</h5>
						<p class="card-text">Decrypt PGP encrypted files with your private key.</p>
						<a href="pgpfileverify.jsp" class="btn btn-sm btn-success">Decrypt File</a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card mb-3">
					<div class="card-body">
						<h5 class="card-title"><i class="fas fa-key text-warning"></i> PGP Key Generator</h5>
						<p class="card-text">Generate PGP key pairs for encryption and signing.</p>
						<a href="pgpkeyfunctions.jsp" class="btn btn-sm btn-warning">Generate Keys</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
	<div class="card-header bg-info text-white">
		<h3 class="mb-0">PGP File Download & Decryption Explained</h3>
	</div>
	<div class="card-body">
		<h4>How PGP Encrypted File Download Works</h4>
		<p>This service allows you to download and decrypt PGP encrypted files that were shared with you. Files are encrypted with your PGP public key, ensuring only you can decrypt them with your private key.</p>

		<h5>Download Process</h5>
		<ol>
			<li><strong>Receive Link:</strong> You receive a secure download link via email</li>
			<li><strong>Access File:</strong> Click the link to access the encrypted file</li>
			<li><strong>Download Options:</strong> Choose to download the encrypted .asc file or decrypt it immediately</li>
			<li><strong>Client-Side Decryption:</strong> If decrypting, upload your private key and enter passphrase</li>
			<li><strong>Secure Download:</strong> Decrypted file is downloaded directly to your device</li>
		</ol>

		<h5>Security Features</h5>
		<ul>
			<li><strong>Client-Side Decryption:</strong> Files are decrypted in your browser using OpenPGP.js</li>
			<li><strong>Private Key Security:</strong> Your private key never leaves your device</li>
			<li><strong>End-to-End Encryption:</strong> Server never sees decrypted content</li>
			<li><strong>OpenPGP Standard:</strong> Uses RFC 4880 compliant OpenPGP format</li>
			<li><strong>Temporary Storage:</strong> Files are automatically deleted after download</li>
		</ul>

		<div class="alert alert-warning mt-3">
			<strong>Security Note:</strong> Always verify the sender's identity before decrypting files. Never share your private key or passphrase with anyone.
		</div>
	</div>
</div>

<div class="card my-4 border-success">
	<div class="card-header bg-success text-white">
		<h3 class="mb-0">Author Credentials & Expertise</h3>
	</div>
	<div class="card-body">
		<p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and secure file transfer systems.</p>
		<ul>
			<li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, and secure file transfer</li>
			<li><strong>Expertise:</strong> OpenPGP/GPG implementations, public key infrastructure, secure file sharing</li>
			<li><strong>Standards Knowledge:</strong> RFC 4880 (OpenPGP), secure communication protocols, encryption best practices</li>
			<li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">@anish2good on X (Twitter)</a></li>
		</ul>

		<div class="alert alert-info mt-3">
			<strong>Implementation Note:</strong> This tool uses OpenPGP.js for client-side decryption, ensuring your private key and decrypted files never leave your browser.
		</div>
	</div>
</div>

<div class="card my-4 border-primary">
	<div class="card-header bg-primary text-white">
		<h3 class="mb-0">Best Practices for PGP File Security</h3>
	</div>
	<div class="card-body">
		<h4>Private Key Management</h4>
		<ul>
			<li><strong>Secure Storage:</strong> Keep your private key file in a secure location with restricted access</li>
			<li><strong>Strong Passphrase:</strong> Use a strong, unique passphrase to protect your private key</li>
			<li><strong>Backup Keys:</strong> Maintain secure backups of your private key in case of device failure</li>
			<li><strong>Never Share:</strong> Never share your private key or passphrase with anyone</li>
			<li><strong>Key Revocation:</strong> Know how to revoke your key if it becomes compromised</li>
		</ul>

		<h4>File Download Security</h4>
		<ul>
			<li><strong>Verify Sender:</strong> Always verify the sender's identity before downloading files</li>
			<li><strong>Check Fingerprints:</strong> Verify public key fingerprints through trusted channels</li>
			<li><strong>Use HTTPS:</strong> Ensure you're using a secure HTTPS connection</li>
			<li><strong>Scan Decrypted Files:</strong> Run antivirus scans on decrypted files before opening</li>
			<li><strong>Prompt Download:</strong> Download files promptly as they may be automatically deleted</li>
		</ul>

		<h4>Authoritative Sources</h4>
		<ul>
			<li><a href="https://tools.ietf.org/html/rfc4880" target="_blank" rel="noopener">RFC 4880 - OpenPGP Message Format</a> (IETF Standard)</li>
			<li><a href="https://openpgpjs.org/" target="_blank" rel="noopener">OpenPGP.js Documentation</a> - Client-Side Encryption Library</li>
			<li><a href="https://www.gnupg.org/documentation/" target="_blank" rel="noopener">GnuPG Documentation</a> - GNU Privacy Guard Docs</li>
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
      "name": "How do I download a PGP encrypted file?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Click the 'Download ASC File' button to download the encrypted file to your device. The file will have a .asc extension and is encrypted with your PGP public key. You can then decrypt it using your private key with PGP software or our online decryption tool."
      }
    },
    {
      "@type": "Question",
      "name": "Can I decrypt the file in my browser?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, click 'Decrypt & Download' to decrypt the file client-side in your browser. You'll need to upload your PGP private key file (.asc) and enter your passphrase. The decryption happens entirely in your browser using OpenPGP.js - your private key never leaves your device."
      }
    },
    {
      "@type": "Question",
      "name": "What do I need to decrypt the file?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "You need two things: (1) Your PGP private key file (usually with .asc extension) that corresponds to the public key used for encryption, and (2) The passphrase that protects your private key. Without both, you cannot decrypt the file."
      }
    },
    {
      "@type": "Question",
      "name": "Is my private key safe when decrypting online?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, when using our in-browser decryption feature. The decryption happens entirely client-side in your browser using OpenPGP.js. Your private key file and passphrase are never uploaded to the server. They remain in your browser's memory only and are discarded when you close or refresh the page."
      }
    },
    {
      "@type": "Question",
      "name": "How long is the file available for download?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Encrypted files are stored temporarily for a limited period. After the first download or expiration period, files are automatically deleted from the server for security. Download your files promptly after receiving the notification email."
      }
    },
    {
      "@type": "Question",
      "name": "What if I lost my private key or passphrase?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Unfortunately, if you lose your private key or passphrase, the encrypted file cannot be decrypted. This is a fundamental security feature of PGP encryption - only the holder of the private key can decrypt files encrypted with the corresponding public key. Always maintain secure backups of your private keys."
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
    "https://github.com/anishnath"
  ],
  "founder": {
    "@type": "Person",
    "name": "Anish Nath",
    "jobTitle": "Security Engineer"
  }
}
</script>

<script>
	// Enable tooltips
	$(document).ready(function() {
		$('[data-toggle="tooltip"]').tooltip();

		// Update file input label
		$('#pgpKeyFile').on('change', function() {
			const fileName = $(this).val().split('\\').pop();
			$(this).next('.custom-file-label').html(fileName || 'Choose your private key file (.asc)...');

			if (fileName) {
				if (fileName.endsWith('.asc')) {
					$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
					$('#keyFileFeedback').html('<i class="fas fa-check-circle"></i> Private key file selected')
						.removeClass('invalid-feedback').addClass('valid-feedback');
				} else {
					$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
					$('#keyFileFeedback').html('<i class="fas fa-exclamation-triangle"></i> File should have .asc extension')
						.removeClass('valid-feedback').addClass('invalid-feedback');
				}
			}
			updateDecryptButtonState();
		});

		// Password validation
		$('#pgpPassword').on('input', function() {
			const password = $(this).val();

			if (password.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#passwordFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (password.length >= 8) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#passwordFeedback').html('<i class="fas fa-check-circle"></i> Passphrase entered')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#passwordFeedback').html('<i class="fas fa-info-circle"></i> Enter your passphrase')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
			updateDecryptButtonState();
		});
	});

	function showDecryptionFields() {
		document.getElementById('decryptionFields').style.display = 'block';
		document.getElementById('showDecryptBtn').disabled = true;
		document.getElementById('showDecryptBtn').innerHTML = '<i class="fas fa-check"></i> Decryption Form Opened';
	}

	function updateDecryptButtonState() {
		const password = document.getElementById('pgpPassword').value;
		const keyFile = document.getElementById('pgpKeyFile').files[0];
		const decryptButton = document.getElementById('decryptButton');
		decryptButton.disabled = !(password && keyFile);
	}

	function showError(message) {
		var resultArea = document.getElementById('resultArea');
		resultArea.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
			'<i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> ' + message +
			'<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
		resultArea.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
	}

	function showSuccess(message) {
		var resultArea = document.getElementById('resultArea');
		resultArea.innerHTML = '<div class="alert alert-success alert-dismissible fade show" role="alert">' +
			'<i class="fas fa-check-circle"></i> <strong>Success:</strong> ' + message +
			'<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
		resultArea.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
	}

	async function decryptFile(presignedUrl, file_name) {
		const password = document.getElementById('pgpPassword').value;
		const keyFile = document.getElementById('pgpKeyFile').files[0];
		const decryptButton = document.getElementById('decryptButton');
		const originalBtnHtml = decryptButton.innerHTML;

		if (!password || !keyFile) {
			showError('Please provide both private key file and passphrase.');
			return;
		}

		// Disable button and show processing state
		decryptButton.disabled = true;
		decryptButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Decrypting...';

		const reader = new FileReader();
		reader.onload = async function() {
			const privateKeyArmored = reader.result;
			const fileURL = presignedUrl;

			try {
				// Fetch the encrypted file content
				const response = await fetch(fileURL);
				const encryptedText = await response.text();

				// Validate PGP message format
				if (!encryptedText.includes('-----BEGIN PGP MESSAGE-----') || !encryptedText.includes('-----END PGP MESSAGE-----')) {
					showError('Invalid PGP message format. The file should contain PGP message delimiters.');
					decryptButton.disabled = false;
					decryptButton.innerHTML = originalBtnHtml;
					return;
				}

				// Read private key
				const privateKeyObj = (await openpgp.key.readArmored(privateKeyArmored)).keys[0];

				// Decrypt the private key with the passphrase
				try {
					await privateKeyObj.decrypt(password);
				} catch (error) {
					showError('Failed to decrypt private key. Please check your passphrase and try again.');
					decryptButton.disabled = false;
					decryptButton.innerHTML = originalBtnHtml;
					return;
				}

				// Decrypt the file
				const decrypted = await openpgp.decrypt({
					message: await openpgp.message.readArmored(encryptedText),
					privateKeys: [privateKeyObj],
				});

				// Create download link
				const decryptedBlob = new Blob([decrypted.data], { type: 'application/octet-stream' });
				const downloadLink = document.createElement('a');
				downloadLink.href = URL.createObjectURL(decryptedBlob);

				// Extract original filename
				const filenameWithoutPrefix = file_name.split('_').slice(1).join('_');
				const filenameWithoutExtension = filenameWithoutPrefix.replace(/\.asc$/, '');
				downloadLink.download = filenameWithoutExtension;

				// Trigger download
				document.body.appendChild(downloadLink);
				downloadLink.click();
				document.body.removeChild(downloadLink);

				// Show success message
				showSuccess('File "' + filenameWithoutExtension + '" decrypted and downloaded successfully!');

				// Re-enable button
				decryptButton.disabled = false;
				decryptButton.innerHTML = originalBtnHtml;

			} catch (error) {
				console.error('Decryption error:', error);
				showError('Failed to decrypt file: ' + error.message);
				decryptButton.disabled = false;
				decryptButton.innerHTML = originalBtnHtml;
			}
		};

		reader.onerror = function() {
			showError('Failed to read private key file.');
			decryptButton.disabled = false;
			decryptButton.innerHTML = originalBtnHtml;
		};

		reader.readAsText(keyFile);
	}
</script>

</div>

<%@ include file="body-close.jsp"%>
