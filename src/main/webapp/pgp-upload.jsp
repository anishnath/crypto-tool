<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>PGP Encrypted File Transfer (OpenPGP) – Free | 8gwifi.org</title>
    <link rel="canonical" href="https://8gwifi.org/pgp-upload.jsp" />
	<meta name="description" content="Free secure file sharing with PGP encryption. Upload and transfer files encrypted with OpenPGP. Share sensitive documents securely using public key cryptography. No storage, direct encrypted file transfer.">
	<meta name="keywords" content="pgp file transfer, encrypted file sharing, secure file upload, openpgp file encryption, pgp encrypted transfer, secure document sharing, encrypted file send">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgp-upload.jsp">
	<meta property="og:title" content="PGP Encrypted File Transfer Online – Free | 8gwifi.org">
	<meta property="og:description" content="Secure file sharing with PGP encryption. Upload and transfer files encrypted with OpenPGP. Share documents securely using public key cryptography.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgp-upload.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgp-upload.jsp">
	<meta name="twitter:title" content="PGP Encrypted File Transfer Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Secure PGP encrypted file sharing and transfer. Upload documents with OpenPGP encryption.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgp-upload.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

	<!-- Include OpenPGP.js -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/openpgp/4.10.10/openpgp.min.js"></script>
	<script src="js/pgp-upload.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.10/clipboard.min.js"></script>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Encrypted File Transfer Online – Free",
  "description" : "Secure file sharing and transfer service using OpenPGP encryption. Upload files, encrypt them with recipient's PGP public key, and share securely. Client-side encryption ensures privacy. No file storage - direct encrypted transfer.",
  "url" : "https://8gwifi.org/pgp-upload.jsp",
  "image" : "https://8gwifi.org/images/site/pgp-upload.png",
  "screenshot" : "https://8gwifi.org/images/site/pgp-upload.png",
  "applicationCategory" : ["SecurityApplication", "FileTransferApplication", "CryptographyApplication"],
  "applicationSubCategory" : "Encrypted File Transfer Service",
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
    "Client-side PGP encryption using OpenPGP.js",
    "Secure file transfer with public key cryptography",
    "No server-side file storage",
    "Encrypted file upload and sharing",
    "Email notification support",
    "Multiple recipient support"
  ]
}
	</script>

    <!-- How it works (visible) -->
    <style>
      .howto-steps .step {border:1px solid #eef0f3;border-radius:8px;padding:.75rem;margin-bottom:.5rem;background:#fafbfc}
      .howto-steps .step .num {display:inline-block;width:24px;height:24px;border-radius:999px;background:#3c5be8;color:#fff;text-align:center;line-height:24px;font-weight:700;margin-right:.5rem}
    </style>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Encrypted File Transfer Online – Free",
  "description": "Secure file sharing and transfer with PGP encryption online.",
  "url": "https://8gwifi.org/pgp-upload.jsp",
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
        "name": "PGP File Transfer",
        "item": "https://8gwifi.org/pgp-upload.jsp"
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
  "name": "How to Send Encrypted Files with PGP",
  "description": "Step-by-step guide to securely uploading and sharing files encrypted with PGP public key.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Select File to Upload",
      "text": "Choose the file you want to transfer securely. The file will be encrypted client-side using OpenPGP.js before upload.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Enter Recipient Email",
      "text": "Provide the recipient's email address. They will receive a notification with a link to download the encrypted file.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Paste PGP Public Key",
      "text": "Paste the recipient's PGP public key. The file will be encrypted with this key, ensuring only the recipient with the corresponding private key can decrypt it.",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Transfer Encrypted File",
      "text": "Click 'Transfer' to encrypt and upload the file. The file is encrypted client-side in your browser before transmission, ensuring end-to-end encryption.",
      "position": 4
    }
  ]
}
	</script>

	<style>
		/* Progress bar enhancement */
		.progress {
			height: 25px;
			display: none;
		}
		.progress.active {
			display: block;
		}
		.progress-bar {
			font-size: 14px;
			line-height: 25px;
		}

		/* File table styling */
		#fileTableContainer {
			margin-top: 20px;
		}

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

		/* Alert animations */
		.alert {
			animation: fadeIn 0.3s ease-in;
		}
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}
	</style>

</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">PGP Encrypted File Transfer</h1>
<p class="lead text-muted">Securely upload and share files with end-to-end PGP encryption</p>
<hr>

<div class="alert alert-info">
	<i class="fas fa-shield-alt"></i> <strong>Secure Transfer:</strong> Files are encrypted client-side in your browser using OpenPGP.js before upload. Only the recipient with the corresponding private key can decrypt the file.
</div>

<form id="uploadForm" enctype="multipart/form-data">
	<div class="form-group">
		<label for="file">
			<i class="fas fa-file text-primary"></i> <strong>Select File</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Choose a file to encrypt and transfer securely"></i>
		</label>
		<div class="custom-file">
			<input type="file" class="custom-file-input" id="file" name="file" required>
			<label class="custom-file-label" for="file">Choose file to encrypt and transfer...</label>
		</div>
		<div id="fileFeedback" class="validation-feedback"></div>
		<small class="form-text text-muted">File will be encrypted client-side before upload</small>
	</div>

	<div class="form-group">
		<label for="email">
			<i class="fas fa-envelope text-success"></i> <strong>Recipient Email</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Email address to send the encrypted file link"></i>
		</label>
		<input type="email" class="form-control" id="email" name="email"
			placeholder="recipient@example.com" required>
		<div id="emailFeedback" class="validation-feedback"></div>
		<small class="form-text text-muted">Recipient will receive a link to download the encrypted file</small>
	</div>

	<div class="form-group">
		<label for="pgpKeys">
			<i class="fas fa-key text-warning"></i> <strong>Recipient's PGP Public Key</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Paste the recipient's PGP public key to encrypt the file"></i>
		</label>
		<textarea class="form-control" id="pgpKeys" name="pgpKeys" rows="8"
			style="font-family: 'Courier New', monospace; font-size: 12px;"
			placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

[Paste recipient's public key here]

-----END PGP PUBLIC KEY BLOCK-----" required>-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EZe2QiQEEAKiZnLZkugOZhU7Lw5K7ZezGVeGAV4rO/RdxE0eruHOm6g87V2pQ
+1zA6CPojk3yyaHabjUNvtYWqD9g2Vk595v2iG/OxZ5/6qzpXUDIeS2z/etT3k8i
dzZH01/K21JW3NIpSrVBB3m7osfAT/VTi7PISf05ZhgQ1wHAnCIuAEIFABEBAAG0
BWFuaXNoiJwEEAECAAYFAmXtkIkACgkQlusdronXgTRWSgP+Ju4B0XJUR3yVUMsj
utiHUBgzAcfdHBjcmQgBxGjpWwPCx8PzIem11OrDfzDmDynetTzyOLgZOmpEsgdY
mnvy6YZuJS2ukOPgmYH+AlhIKR3DyYtNXK7W/Jw1L7da4vq+4BzyRrMOEGeCqdlF
9zztSwQCfIL1UvpHoPMPP+5pR8c=
=ku/w
-----END PGP PUBLIC KEY BLOCK-----</textarea>
		<div id="pgpKeysFeedback" class="validation-feedback"></div>
		<small class="form-text text-muted">File will be encrypted with this public key</small>
	</div>

	<div class="form-group">
		<button type="button" id="uploadBtn" class="btn btn-primary btn-lg" onclick="uploadFile()">
			<i class="fas fa-upload"></i> Encrypt & Transfer
		</button>
		<button type="button" class="btn btn-outline-secondary btn-lg ml-2" onclick="resetForm()">
			<i class="fas fa-eraser"></i> Clear
		</button>
	</div>

	<!-- Progress Bar -->
	<div class="progress mt-3" id="progressContainer">
		<div id="progressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success"
			role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
			0%
		</div>
	</div>
</form>

<hr>

<div id="fileTableContainer">
	<!-- Uploaded files table will be displayed here -->
</div>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
	<div class="card-header bg-info text-white">
		<h3 class="mb-0">PGP Encrypted File Transfer Explained</h3>
	</div>
	<div class="card-body">
		<h4>How PGP Encrypted File Transfer Works</h4>
		<p>This service provides end-to-end encrypted file transfer using OpenPGP public key cryptography. Your files are encrypted in your browser before transmission, ensuring maximum security.</p>

		<h5>Security Features</h5>
		<ul>
			<li><strong>Client-Side Encryption:</strong> Files are encrypted in your browser using OpenPGP.js before upload</li>
			<li><strong>Public Key Cryptography:</strong> Files are encrypted with recipient's public key - only their private key can decrypt</li>
			<li><strong>End-to-End Security:</strong> Server never sees unencrypted file content</li>
			<li><strong>No Long-Term Storage:</strong> Files are transferred and removed after download</li>
			<li><strong>OpenPGP Standard:</strong> Uses RFC 4880 compliant OpenPGP encryption</li>
		</ul>

		<h5>Transfer Process</h5>
		<ol>
			<li><strong>Select File:</strong> Choose the file you want to send securely</li>
			<li><strong>Provide Details:</strong> Enter recipient's email and PGP public key</li>
			<li><strong>Client-Side Encryption:</strong> File is encrypted in your browser using OpenPGP.js</li>
			<li><strong>Upload:</strong> Encrypted file is uploaded to temporary storage</li>
			<li><strong>Notification:</strong> Recipient receives email with secure download link</li>
			<li><strong>Decryption:</strong> Recipient uses their private key to decrypt the file</li>
		</ol>

		<div class="alert alert-warning mt-3">
			<strong>Important:</strong> The recipient must have the PGP private key corresponding to the public key used for encryption. Without the correct private key, the file cannot be decrypted.
		</div>
	</div>
</div>

<div class="card my-4 border-success">
	<div class="card-header bg-success text-white">
		<h3 class="mb-0">Author Credentials & Expertise</h3>
	</div>
	<div class="card-body">
		<p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and secure systems.</p>
		<ul>
			<li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, and secure file transfer systems</li>
			<li><strong>Expertise:</strong> OpenPGP/GPG implementations, public key infrastructure, secure file sharing</li>
			<li><strong>Standards Knowledge:</strong> RFC 4880 (OpenPGP), secure communication protocols, encryption best practices</li>
			<li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank">@anish2good on X (Twitter)</a></li>
		</ul>

		<div class="alert alert-info mt-3">
			<strong>Implementation Note:</strong> This tool uses OpenPGP.js library for client-side encryption, ensuring your files are encrypted before leaving your device. The encryption happens entirely in your browser.
		</div>
	</div>
</div>

<div class="card my-4 border-primary">
	<div class="card-header bg-primary text-white">
		<h3 class="mb-0">Best Practices for Secure File Transfer</h3>
	</div>
	<div class="card-body">
		<h4>Key Management</h4>
		<ul>
			<li><strong>Verify Public Keys:</strong> Always verify recipient's public key fingerprint through a trusted channel</li>
			<li><strong>Key Authenticity:</strong> Ensure the public key belongs to the intended recipient</li>
			<li><strong>Key Size:</strong> Use at least 2048-bit RSA keys (4096-bit recommended for high security)</li>
			<li><strong>Key Rotation:</strong> Regularly update PGP keys and revoke compromised keys</li>
		</ul>

		<h4>File Transfer Security</h4>
		<ul>
			<li><strong>HTTPS Connection:</strong> Always use HTTPS to prevent man-in-the-middle attacks</li>
			<li><strong>File Size Limits:</strong> Be aware of practical limits for encrypted file transfers</li>
			<li><strong>Temporary Storage:</strong> Files are automatically deleted after a set period</li>
			<li><strong>Metadata Privacy:</strong> File names and metadata are also protected</li>
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
      "name": "How does PGP encrypted file transfer work?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "PGP encrypted file transfer uses public key cryptography. You select a file, provide the recipient's PGP public key, and the file is encrypted client-side in your browser using OpenPGP.js. The encrypted file is then uploaded and the recipient receives a download link. Only the recipient with the corresponding private key can decrypt the file."
      }
    },
    {
      "@type": "Question",
      "name": "Is my file encrypted before upload?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, files are encrypted entirely client-side in your browser using OpenPGP.js before being uploaded. This means the file is already encrypted when it leaves your device, ensuring end-to-end encryption. The server never sees the unencrypted file content."
      }
    },
    {
      "@type": "Question",
      "name": "How do I get the recipient's PGP public key?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The recipient must share their PGP public key with you through a trusted channel. They can generate a key pair using our PGP Key Generation tool, export their public key, and send it to you via email or other communication method. Always verify the key fingerprint to ensure authenticity."
      }
    },
    {
      "@type": "Question",
      "name": "Can the recipient decrypt the file without special software?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The recipient needs PGP/GPG software or our PGP File Decryption tool along with their private key to decrypt the file. Common options include GnuPG (GPG), Kleopatra, or web-based tools like our pgp-file-decrypt.jsp page. They must have the private key corresponding to the public key used for encryption."
      }
    },
    {
      "@type": "Question",
      "name": "How long are uploaded files stored?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Encrypted files are stored temporarily for a limited period to allow the recipient to download them. Files are automatically deleted after download or after the expiration period. We recommend recipients download files promptly for security."
      }
    },
    {
      "@type": "Question",
      "name": "Is PGP encrypted file transfer secure?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, when used correctly. PGP encryption is military-grade security using public key cryptography. Files are encrypted client-side before upload, providing end-to-end encryption. However, security also depends on: (1) verifying recipient's public key authenticity, (2) recipient protecting their private key, (3) using strong encryption keys (2048-bit or higher), and (4) using HTTPS connections."
      }
    }
  ]
}
	</script>

    <!-- Visible: How it works & FAQs -->
    <div class="container mt-4">
      <h2 class="mt-4">How It Works</h2>
      <div class="howto-steps">
        <div class="step"><span class="num">1</span><strong>Upload file</strong>: Choose a file to send. Processing is client‑side in your browser.</div>
        <div class="step"><span class="num">2</span><strong>Encrypt with public key</strong>: Paste the recipient’s PGP public key. The file is encrypted locally (no server storage).</div>
        <div class="step"><span class="num">3</span><strong>Share securely</strong>: Send the download link to the recipient. Only their private key can decrypt.</div>
      </div>

      <hr>
      <h2 class="mt-4" id="faqs">FAQs</h2>
      <div class="accordion" id="pgpUploadFaqs">
        <div class="card"><div class="card-header"><h6 class="mb-0">Do you store any files or keys?</h6></div><div class="card-body small text-muted">No. Encryption happens in your browser (client‑side) and files are not stored on the server.</div></div>
        <div class="card"><div class="card-header"><h6 class="mb-0">Which keys are supported?</h6></div><div class="card-body small text-muted">OpenPGP public keys. The recipient decrypts using their private key.</div></div>
        <div class="card"><div class="card-header"><h6 class="mb-0">How big can files be?</h6></div><div class="card-body small text-muted">Use reasonable sizes for browser‑based encryption. For very large files, consider chunking before encrypting.</div></div>
      </div>
    </div>

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
		$('#file').on('change', function() {
			const fileName = $(this).val().split('\\').pop();
			$(this).next('.custom-file-label').html(fileName || 'Choose file to encrypt and transfer...');

			if (fileName) {
				$('#fileFeedback').html('<i class="fas fa-check-circle"></i> File selected: ' + fileName)
					.removeClass('invalid-feedback').addClass('valid-feedback');
			}
		});

		// Email validation
		$('#email').on('input', function() {
			const email = $(this).val().trim();
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

			if (email.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#emailFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (emailRegex.test(email)) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#emailFeedback').html('<i class="fas fa-check-circle"></i> Valid email address')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#emailFeedback').html('<i class="fas fa-times-circle"></i> Invalid email format')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
		});

		// PGP key validation
		$('#pgpKeys').on('input', function() {
			const key = $(this).val().trim();

			if (key.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#pgpKeysFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (key.includes('-----BEGIN PGP PUBLIC KEY BLOCK-----') &&
					   key.includes('-----END PGP PUBLIC KEY BLOCK-----')) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#pgpKeysFeedback').html('<i class="fas fa-check-circle"></i> Valid PGP public key format')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#pgpKeysFeedback').html('<i class="fas fa-times-circle"></i> Invalid PGP public key format')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
		});

		// Trigger validation on load
		$('#pgpKeys').trigger('input');
	});

	// Reset form function
	function resetForm() {
		document.getElementById('uploadForm').reset();
		$('#file').next('.custom-file-label').html('Choose file to encrypt and transfer...');
		$('.validation-feedback').html('').removeClass('valid-feedback invalid-feedback');
		$('input, textarea').removeClass('is-valid-custom is-invalid-custom');
		$('#progressContainer').removeClass('active');
		$('#progressBar').css('width', '0%').attr('aria-valuenow', 0).text('0%');
	}
</script>

</div>

<%@ include file="body-close.jsp"%>
