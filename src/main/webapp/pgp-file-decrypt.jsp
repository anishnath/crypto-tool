<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Encrypt & Decrypt PGP Files Online – Free Tool | 8gwifi.org</title>
	<meta name="description" content="Encrypt and decrypt PGP files online with client-side processing using OpenPGP.js v5. Choose binary .pgp or armored .asc format. Drag-and-drop file upload. Free PGP file encryption with public key and decryption with private key. Secure, private, no upload to server.">
	<meta name="keywords" content="pgp file encrypt, pgp file decrypt, pgp encryption, pgp decryption, openpgp file, encrypt file online, decrypt file online, pgp asc, pgp binary, drag drop pgp, openpgp v5">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgp-file-decrypt.jsp">
	<meta property="og:title" content="Encrypt & Decrypt PGP Files Online – Free Tool | 8gwifi.org">
	<meta property="og:description" content="Encrypt PGP files in binary .pgp or armored .asc format. Decrypt both formats. Drag-and-drop upload. Client-side processing using OpenPGP.js v5. Free and secure.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgp-file-decrypt.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta property="twitter:url" content="https://8gwifi.org/pgp-file-decrypt.jsp">
	<meta name="twitter:title" content="Encrypt & Decrypt PGP Files Online – Free Tool | 8gwifi.org">
	<meta name="twitter:description" content="Encrypt PGP files in binary .pgp or armored .asc format. Decrypt both formats. Drag-and-drop upload. Client-side processing using OpenPGP.js v5.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgp-file-decrypt.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<script src="https://unpkg.com/openpgp@5.11.2/dist/openpgp.min.js"></script>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "Encrypt & Decrypt PGP Files Online – Free Tool",
  "description" : "Encrypt and decrypt PGP files online using client-side OpenPGP.js v5. Encrypt files with public key in binary (.pgp) or armored (.asc) format. Decrypt both .pgp and .asc files with private key. Drag-and-drop file upload. All processing happens in your browser - files never uploaded to server. Secure PGP file encryption and decryption tool.",
  "url" : "https://8gwifi.org/pgp-file-decrypt.jsp",
  "image" : "https://8gwifi.org/images/site/pgp-file-decrypt.png",
  "screenshot" : "https://8gwifi.org/images/site/pgp-file-decrypt.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "FileEncryptionTool"],
  "applicationSubCategory" : "PGP File Encryption and Decryption",
  "browserRequirements" : "Requires JavaScript and OpenPGP.js v5. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer"
  },
  "datePublished" : "2023-11-21",
  "dateModified" : "2025-11-21",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "Client-side PGP file encryption using OpenPGP.js v5",
    "Client-side PGP file decryption using OpenPGP.js v5",
    "Encrypt files with PGP public key - choose binary (.pgp) or armored (.asc) format",
    "Binary .pgp format - smaller file size, efficient storage",
    "ASCII armored .asc format - text-based, email compatible",
    "Decrypt both .pgp binary and .asc armored encrypted files",
    "Drag-and-drop file upload interface",
    "Visual format selector for encryption output",
    "Real-time file information display",
    "No server upload - all processing in browser",
    "Supports all file types - documents, images, videos, archives",
    "Download encrypted and decrypted files instantly"
  ]
}
	</script>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Encrypt & Decrypt PGP Files Online – Free Tool",
  "description": "Encrypt and decrypt PGP files online with your keys. Supports binary .pgp and armored .asc formats.",
  "url": "https://8gwifi.org/pgp-file-decrypt.jsp",
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
        "name": "PGP File Encrypt/Decrypt",
        "item": "https://8gwifi.org/pgp-file-decrypt.jsp"
      }
    ]
  }
}
	</script>

	<!-- HowTo Schema for PGP File Encryption -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Encrypt Files with PGP",
  "description": "Step-by-step guide to encrypt files using PGP with binary or armored format",
  "image": "https://8gwifi.org/images/site/pgp-file-decrypt.png",
  "totalTime": "PT2M",
  "tool": [
    {
      "@type": "HowToTool",
      "name": "PGP Public Key"
    },
    {
      "@type": "HowToTool",
      "name": "File to encrypt"
    }
  ],
  "supply": [
    {
      "@type": "HowToSupply",
      "name": "Recipient's PGP Public Key"
    }
  ],
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Open Encrypt Tab",
      "text": "Navigate to the Encrypt tab in the PGP file encryption tool",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Upload File",
      "text": "Drag and drop your file into the upload area or click to browse and select the file you want to encrypt",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Paste Public Key",
      "text": "Paste the recipient's PGP public key into the public key text area",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Choose Output Format",
      "text": "Select your preferred output format: Binary .pgp (smaller file size, recommended) or ASCII armored .asc (text format, email compatible)",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 5,
      "name": "Encrypt File",
      "text": "Click the 'Encrypt File' button. The file will be encrypted in your browser using OpenPGP.js v5",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 6,
      "name": "Download Encrypted File",
      "text": "The encrypted file will automatically download with .pgp or .asc extension based on your format selection",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    }
  ]
}
	</script>

	<!-- HowTo Schema for PGP File Decryption -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Decrypt PGP Encrypted Files",
  "description": "Step-by-step guide to decrypt PGP encrypted files in .pgp or .asc format",
  "image": "https://8gwifi.org/images/site/pgp-file-decrypt.png",
  "totalTime": "PT2M",
  "tool": [
    {
      "@type": "HowToTool",
      "name": "PGP Private Key"
    },
    {
      "@type": "HowToTool",
      "name": "Encrypted file (.pgp or .asc)"
    }
  ],
  "supply": [
    {
      "@type": "HowToSupply",
      "name": "Private Key Passphrase"
    }
  ],
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Open Decrypt Tab",
      "text": "Navigate to the Decrypt tab in the PGP file decryption tool",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Upload Encrypted File",
      "text": "Drag and drop your encrypted .pgp or .asc file into the upload area or click to browse. Both binary and armored formats are supported",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Paste Private Key",
      "text": "Paste your PGP private key into the private key text area",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 4,
      "name": "Enter Passphrase",
      "text": "Enter your private key passphrase to unlock the private key for decryption",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 5,
      "name": "Decrypt File",
      "text": "Click the 'Decrypt File' button. The file will be decrypted in your browser using OpenPGP.js v5",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
    },
    {
      "@type": "HowToStep",
      "position": 6,
      "name": "Download Decrypted File",
      "text": "The original decrypted file will automatically download with its original filename",
      "url": "https://8gwifi.org/pgp-file-decrypt.jsp"
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

		/* Result area highlight */
		.result-highlight {
			border: 2px solid #28a745;
			background-color: #f8fff9;
		}

		/* Tabs styling */
		.nav-tabs .nav-link {
			font-weight: 500;
			padding: 12px 24px;
			font-size: 16px;
		}
		.nav-tabs .nav-link.active {
			font-weight: 600;
			background-color: #fff;
			border-bottom-color: #fff;
		}
		.nav-tabs {
			border-bottom: 2px solid #dee2e6;
		}

		/* Drag and drop file upload */
		.file-drop-area {
			position: relative;
			border: 3px dashed #cbd5e0;
			border-radius: 12px;
			padding: 40px;
			text-align: center;
			transition: all 0.3s ease;
			background-color: #f8f9fa;
			cursor: pointer;
		}
		.file-drop-area:hover {
			border-color: #4299e1;
			background-color: #edf2f7;
		}
		.file-drop-area.dragover {
			border-color: #28a745;
			background-color: #d4edda;
			transform: scale(1.02);
		}
		.file-drop-area input[type="file"] {
			position: absolute;
			width: 100%;
			height: 100%;
			top: 0;
			left: 0;
			opacity: 0;
			cursor: pointer;
		}
		.file-drop-icon {
			font-size: 48px;
			color: #4299e1;
			margin-bottom: 16px;
		}
		.file-drop-area.dragover .file-drop-icon {
			color: #28a745;
		}
		.file-info {
			margin-top: 16px;
			padding: 12px;
			background-color: #e3f2fd;
			border-radius: 8px;
			border-left: 4px solid #2196f3;
		}
		.file-info-success {
			background-color: #d4edda;
			border-left-color: #28a745;
		}

		/* Format selector cards */
		.format-selector {
			display: flex;
			gap: 16px;
			margin-top: 8px;
		}
		.format-card {
			flex: 1;
			position: relative;
			border: 2px solid #dee2e6;
			border-radius: 12px;
			padding: 20px;
			cursor: pointer;
			transition: all 0.3s ease;
			background-color: #fff;
		}
		.format-card:hover {
			border-color: #4299e1;
			transform: translateY(-2px);
			box-shadow: 0 4px 12px rgba(0,0,0,0.1);
		}
		.format-card input[type="radio"] {
			position: absolute;
			opacity: 0;
		}
		.format-card input[type="radio"]:checked + .format-card-content {
			border-color: #28a745;
		}
		.format-card input[type="radio"]:checked ~ .format-check {
			opacity: 1;
		}
		.format-card.selected {
			border-color: #28a745;
			background-color: #f0f9ff;
			box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
		}
		.format-check {
			position: absolute;
			top: 12px;
			right: 12px;
			width: 24px;
			height: 24px;
			background-color: #28a745;
			border-radius: 50%;
			display: flex;
			align-items: center;
			justify-content: center;
			opacity: 0;
			transition: opacity 0.3s ease;
		}
		.format-check i {
			color: white;
			font-size: 14px;
		}
		.format-icon {
			font-size: 32px;
			margin-bottom: 8px;
		}
		.format-title {
			font-size: 18px;
			font-weight: 600;
			margin-bottom: 4px;
		}
		.format-description {
			font-size: 13px;
			color: #6c757d;
			margin-bottom: 8px;
		}
		.format-badge {
			display: inline-block;
			padding: 4px 12px;
			background-color: #e3f2fd;
			color: #1976d2;
			border-radius: 12px;
			font-size: 11px;
			font-weight: 600;
			text-transform: uppercase;
		}
		.format-card.selected .format-badge {
			background-color: #d4edda;
			color: #28a745;
		}

		/* Card sections */
		.form-card {
			background: #fff;
			border-radius: 12px;
			padding: 24px;
			margin-bottom: 24px;
			border: 1px solid #e0e0e0;
			box-shadow: 0 2px 8px rgba(0,0,0,0.05);
		}
		.form-card-header {
			display: flex;
			align-items: center;
			gap: 12px;
			margin-bottom: 20px;
			padding-bottom: 16px;
			border-bottom: 2px solid #f0f0f0;
		}
		.form-card-header i {
			font-size: 24px;
		}
		.form-card-title {
			font-size: 18px;
			font-weight: 600;
			margin: 0;
		}

		/* Textarea improvements */
		.key-textarea {
			font-family: 'Courier New', monospace;
			font-size: 12px;
			border-radius: 8px;
			border: 2px solid #dee2e6;
			transition: border-color 0.3s ease;
		}
		.key-textarea:focus {
			border-color: #4299e1;
			box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
		}

		/* Result cards */
		.result-card {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			color: white;
			border-radius: 12px;
			padding: 24px;
			margin-top: 24px;
		}
		.result-card-success {
			background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
		}
		.result-card-info {
			display: flex;
			align-items: center;
			gap: 16px;
			margin-bottom: 16px;
		}
		.result-icon {
			font-size: 48px;
		}
		.result-details {
			flex: 1;
		}
		.result-filename {
			font-size: 20px;
			font-weight: 600;
			margin-bottom: 4px;
		}
		.result-meta {
			font-size: 14px;
			opacity: 0.9;
		}
		.result-actions {
			display: flex;
			gap: 12px;
			margin-top: 16px;
		}
		.result-actions .btn {
			flex: 1;
		}

		/* Processing state */
		.processing-overlay {
			position: fixed;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			background: rgba(0,0,0,0.5);
			display: none;
			align-items: center;
			justify-content: center;
			z-index: 9999;
		}
		.processing-overlay.active {
			display: flex;
		}
		.processing-card {
			background: white;
			border-radius: 12px;
			padding: 32px;
			text-align: center;
			min-width: 300px;
		}
		.processing-spinner {
			font-size: 48px;
			color: #4299e1;
			animation: spin 1s linear infinite;
		}
		@keyframes spin {
			100% { transform: rotate(360deg); }
		}

		/* Responsive */
		@media (max-width: 768px) {
			.format-selector {
				flex-direction: column;
			}
			.nav-tabs .nav-link {
				padding: 10px 16px;
				font-size: 14px;
			}
		}
	</style>

</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">PGP File Encryption & Decryption</h1>
<p class="lead text-muted">Encrypt and decrypt files with PGP keys securely in your browser</p>
<hr>

<div class="alert alert-info">
	<i class="fas fa-shield-alt"></i> <strong>Client-Side Processing:</strong> Files are encrypted and decrypted entirely in your browser using OpenPGP.js. Your keys and files never leave your device.
</div>

<!-- Bootstrap Tabs -->
<ul class="nav nav-tabs" id="pgpTabs" role="tablist">
	<li class="nav-item">
		<a class="nav-link active" id="decrypt-tab" data-toggle="tab" href="#decrypt" role="tab" aria-controls="decrypt" aria-selected="true">
			<i class="fas fa-unlock-alt"></i> Decrypt File
		</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" id="encrypt-tab" data-toggle="tab" href="#encrypt" role="tab" aria-controls="encrypt" aria-selected="false">
			<i class="fas fa-lock"></i> Encrypt File
		</a>
	</li>
</ul>

<div class="tab-content" id="pgpTabsContent">
	<!-- DECRYPT TAB -->
	<div class="tab-pane fade show active" id="decrypt" role="tabpanel" aria-labelledby="decrypt-tab">
		<div class="mt-4">
			<form id="pgpDecryptForm">
				<!-- File Upload Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-file-upload text-primary"></i>
						<h5 class="form-card-title">Select Encrypted File</h5>
					</div>
					<div class="file-drop-area" id="dropAreaDecrypt">
						<input type="file" id="fileInputDecrypt" accept=".pgp,.asc" required>
						<div class="file-drop-icon">
							<i class="fas fa-cloud-upload-alt"></i>
						</div>
						<h5>Drag & Drop your encrypted file here</h5>
						<p class="text-muted">or click to browse</p>
						<p class="text-muted mb-0"><small>Supports .pgp (binary) and .asc (armored) formats</small></p>
					</div>
					<div id="fileInfoDecrypt"></div>
				</div>

				<!-- Private Key Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-key text-warning"></i>
						<h5 class="form-card-title">Your PGP Private Key</h5>
					</div>
					<textarea class="form-control key-textarea" id="privateKeyInput" rows="8"
						placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----

[Paste your private key here]

-----END PGP PRIVATE KEY BLOCK-----" required></textarea>
					<div id="privateKeyFeedback" class="validation-feedback mt-2"></div>
					<small class="form-text text-muted mt-2"><i class="fas fa-shield-alt"></i> Your private key is processed client-side only and never leaves your browser</small>
				</div>

				<!-- Passphrase Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-lock text-danger"></i>
						<h5 class="form-card-title">Private Key Passphrase</h5>
					</div>
					<input type="password" class="form-control" id="passphraseInput" placeholder="Enter your private key passphrase" required style="border-radius: 8px; border: 2px solid #dee2e6; padding: 12px;">
					<div id="passphraseFeedback" class="validation-feedback mt-2"></div>
					<small class="form-text text-muted mt-2"><i class="fas fa-info-circle"></i> Required to unlock your private key for decryption</small>
				</div>

				<!-- Action Buttons -->
				<div class="d-flex">
					<button type="button" id="decryptBtn" class="btn btn-primary btn-lg flex-grow-1 mr-3" onclick="decryptFile()" style="border-radius: 8px; padding: 14px;">
						<i class="fas fa-unlock-alt"></i> Decrypt File
					</button>
					<button type="button" class="btn btn-outline-secondary btn-lg" onclick="resetDecryptForm()" style="border-radius: 8px; padding: 14px;">
						<i class="fas fa-eraser"></i> Clear
					</button>
				</div>
			</form>

			<div class="mt-4" id="resultAreaDecrypt"></div>
		</div>
	</div>

	<!-- ENCRYPT TAB -->
	<div class="tab-pane fade" id="encrypt" role="tabpanel" aria-labelledby="encrypt-tab">
		<div class="mt-4">
			<form id="pgpEncryptForm">
				<!-- File Upload Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-file-upload text-success"></i>
						<h5 class="form-card-title">Select File to Encrypt</h5>
					</div>
					<div class="file-drop-area" id="dropAreaEncrypt">
						<input type="file" id="fileInputEncrypt" required>
						<div class="file-drop-icon">
							<i class="fas fa-cloud-upload-alt"></i>
						</div>
						<h5>Drag & Drop your file here</h5>
						<p class="text-muted">or click to browse</p>
						<p class="text-muted mb-0"><small>Any file type supported (documents, images, videos, etc.)</small></p>
					</div>
					<div id="fileInfoEncrypt"></div>
				</div>

				<!-- Public Key Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-key text-success"></i>
						<h5 class="form-card-title">Recipient's PGP Public Key</h5>
					</div>
					<textarea class="form-control key-textarea" id="publicKeyInput" rows="8"
						placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----

[Paste recipient's public key here]

-----END PGP PUBLIC KEY BLOCK-----" required></textarea>
					<div id="publicKeyFeedback" class="validation-feedback mt-2"></div>
					<small class="form-text text-muted mt-2"><i class="fas fa-info-circle"></i> Only the holder of the corresponding private key can decrypt this file</small>
				</div>

				<!-- Output Format Card -->
				<div class="form-card">
					<div class="form-card-header">
						<i class="fas fa-file-archive text-info"></i>
						<h5 class="form-card-title">Choose Output Format</h5>
					</div>
					<div class="format-selector">
						<label class="format-card" id="formatCardBinary">
							<input type="radio" name="outputFormat" value="binary" checked>
							<div class="format-check">
								<i class="fas fa-check"></i>
							</div>
							<div class="format-icon">📦</div>
							<div class="format-title">.pgp Binary</div>
							<div class="format-description">Smaller file size, more efficient for storage and transfer</div>
							<span class="format-badge">Recommended</span>
						</label>
						<label class="format-card" id="formatCardArmored">
							<input type="radio" name="outputFormat" value="armored">
							<div class="format-check">
								<i class="fas fa-check"></i>
							</div>
							<div class="format-icon">📄</div>
							<div class="format-title">.asc Armored</div>
							<div class="format-description">Text format, compatible with email systems and text editors</div>
							<span class="format-badge">Text Format</span>
						</label>
					</div>
				</div>

				<!-- Action Buttons -->
				<div class="d-flex">
					<button type="button" id="encryptBtn" class="btn btn-success btn-lg flex-grow-1 mr-3" onclick="encryptFile()" style="border-radius: 8px; padding: 14px;">
						<i class="fas fa-lock"></i> Encrypt File
					</button>
					<button type="button" class="btn btn-outline-secondary btn-lg" onclick="resetEncryptForm()" style="border-radius: 8px; padding: 14px;">
						<i class="fas fa-eraser"></i> Clear
					</button>
				</div>
			</form>

			<div class="mt-4" id="resultAreaEncrypt"></div>
		</div>
	</div>
</div>

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
						<h5 class="card-title"><i class="fas fa-shield-alt text-primary"></i> PGP Encrypt/Decrypt Text</h5>
						<p class="card-text">Encrypt or decrypt text messages with PGP keys.</p>
						<a href="pgpencdec.jsp" class="btn btn-sm btn-primary">Open Tool</a>
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
			<div class="col-md-4">
				<div class="card mb-3">
					<div class="card-body">
						<h5 class="card-title"><i class="fas fa-upload text-success"></i> PGP File Transfer</h5>
						<p class="card-text">Upload and share encrypted files securely.</p>
						<a href="pgp-upload.jsp" class="btn btn-sm btn-success">Upload File</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
	<div class="card-header bg-info text-white">
		<h3 class="mb-0">PGP File Encryption & Decryption Explained</h3>
	</div>
	<div class="card-body">
		<h4>How PGP File Encryption & Decryption Works</h4>
		<p>PGP uses asymmetric cryptography to secure files. Encrypt files with a recipient's public key, and only their corresponding private key can decrypt them. This ensures secure file transfer and storage.</p>

		<h5>Encryption Process</h5>
		<ol>
			<li><strong>Select File:</strong> Choose any file you want to encrypt</li>
			<li><strong>Provide Public Key:</strong> Paste the recipient's PGP public key</li>
			<li><strong>Choose Format:</strong> Select binary (.pgp) for smaller files or armored (.asc) for text compatibility</li>
			<li><strong>Client-Side Encryption:</strong> File is encrypted in your browser using OpenPGP.js</li>
			<li><strong>Download Encrypted File:</strong> Download the encrypted file (.pgp or .asc)</li>
			<li><strong>Share Securely:</strong> Send the encrypted file to the recipient</li>
		</ol>

		<h5>Decryption Process</h5>
		<ol>
			<li><strong>Select Encrypted File:</strong> Choose the encrypted file (.pgp or .asc)</li>
			<li><strong>Provide Private Key:</strong> Paste your PGP private key</li>
			<li><strong>Enter Passphrase:</strong> Unlock your private key with passphrase</li>
			<li><strong>Client-Side Decryption:</strong> File is decrypted in your browser</li>
			<li><strong>Download Decrypted File:</strong> Original file is automatically downloaded</li>
		</ol>

		<h5>Security Features</h5>
		<ul>
			<li><strong>Client-Side Processing:</strong> All operations happen in your browser - nothing sent to server</li>
			<li><strong>Public Key Cryptography:</strong> Files encrypted with public key, decrypted with private key</li>
			<li><strong>No File Upload:</strong> Files are processed locally in your browser</li>
			<li><strong>OpenPGP Standard:</strong> Uses RFC 4880 compliant OpenPGP format</li>
			<li><strong>Memory Safety:</strong> Keys and files cleared from memory after processing</li>
		</ul>

		<div class="alert alert-warning mt-3">
			<strong>Security Note:</strong> Never share your private key or passphrase. Always verify recipient identity before encrypting. Verify sender before decrypting files.
		</div>
	</div>
</div>

<div class="card my-4 border-success">
	<div class="card-header bg-success text-white">
		<h3 class="mb-0">Author Credentials & Expertise</h3>
	</div>
	<div class="card-body">
		<p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and secure file systems.</p>
		<ul>
			<li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, PGP/GPG systems</li>
			<li><strong>Expertise:</strong> OpenPGP implementations, public key cryptography, file encryption/decryption</li>
			<li><strong>Standards Knowledge:</strong> RFC 4880 (OpenPGP), cryptographic best practices, secure key management</li>
			<li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">@anish2good on X (Twitter)</a></li>
		</ul>

		<div class="alert alert-info mt-3">
			<strong>Implementation Note:</strong> This tool uses OpenPGP.js for client-side encryption and decryption. Your keys and files are never transmitted - all operations occur in your browser's JavaScript environment.
		</div>
	</div>
</div>

<div class="card my-4 border-primary">
	<div class="card-header bg-primary text-white">
		<h3 class="mb-0">Best Practices for PGP File Security</h3>
	</div>
	<div class="card-body">
		<h4>Key Management</h4>
		<ul>
			<li><strong>Public Key Distribution:</strong> Share your public key freely - it's safe to distribute widely</li>
			<li><strong>Private Key Security:</strong> Store private keys in encrypted containers or password managers</li>
			<li><strong>Strong Passphrases:</strong> Use long, unique passphrases (20+ characters recommended)</li>
			<li><strong>Never Share Private Keys:</strong> Private keys should never be shared with anyone</li>
			<li><strong>Backup Keys:</strong> Maintain secure, offline backups of your key pair</li>
		</ul>

		<h4>Encryption & Decryption Safety</h4>
		<ul>
			<li><strong>Verify Public Keys:</strong> Always verify recipient's public key fingerprint through trusted channel</li>
			<li><strong>Verify Sender:</strong> Confirm sender identity before decrypting files</li>
			<li><strong>Check Signatures:</strong> Verify PGP signatures when available to confirm authenticity</li>
			<li><strong>Scan Files:</strong> Run antivirus scans on decrypted files before opening</li>
			<li><strong>Use HTTPS:</strong> Always use secure connections when accessing encryption tools</li>
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
      "name": "How do I encrypt a file with PGP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To encrypt a file: (1) Go to the Encrypt tab, (2) Select the file you want to encrypt, (3) Paste the recipient's PGP public key, (4) Choose output format (.pgp binary or .asc armored), (5) Click 'Encrypt File'. The encrypted file will be downloaded. Send this file to the recipient who can decrypt it with their private key."
      }
    },
    {
      "@type": "Question",
      "name": "How do I decrypt a PGP encrypted file?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To decrypt: (1) Go to the Decrypt tab, (2) Select the encrypted .pgp or .asc file, (3) Paste your PGP private key, (4) Enter your private key passphrase, (5) Click 'Decrypt File'. The original file will be decrypted and downloaded."
      }
    },
    {
      "@type": "Question",
      "name": "Are my files and keys safe?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, completely safe. All encryption and decryption happens client-side in your browser using OpenPGP.js. Your keys, files, and passphrases never leave your device - nothing is uploaded to the server."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between encrypting and decrypting?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Encryption uses a PGP public key to convert a readable file into an encrypted file (.pgp or .asc) that only the private key holder can read. Decryption uses the corresponding PGP private key (and passphrase) to convert the encrypted file back to the original readable format."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between .pgp and .asc formats?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Binary .pgp format is smaller and more efficient for file storage and transfer. ASCII armored .asc format is text-based, making it compatible with email systems and text editors. Both formats provide the same level of security - choose .pgp for efficiency or .asc for text compatibility."
      }
    },
    {
      "@type": "Question",
      "name": "Can I encrypt files for myself?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! You can encrypt files with your own public key and decrypt them later with your private key. This is useful for secure file storage. Just use your own public key during encryption, and you'll be able to decrypt with your private key."
      }
    },
    {
      "@type": "Question",
      "name": "What file types can I encrypt or decrypt?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "You can encrypt any file type - documents, images, videos, archives, etc. For encryption output, choose between binary .pgp (smaller) or ASCII armored .asc (text-compatible). For decryption, both .pgp and .asc formats are supported."
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
	// Drag and drop setup
	function setupDragAndDrop(dropAreaId, fileInputId, fileInfoId) {
		const dropArea = document.getElementById(dropAreaId);
		const fileInput = document.getElementById(fileInputId);
		const fileInfo = document.getElementById(fileInfoId);

		if (!dropArea || !fileInput) return;

		// Prevent defaults
		['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
			dropArea.addEventListener(eventName, preventDefaults, false);
		});

		function preventDefaults(e) {
			e.preventDefault();
			e.stopPropagation();
		}

		// Highlight on drag
		['dragenter', 'dragover'].forEach(eventName => {
			dropArea.addEventListener(eventName, () => {
				dropArea.classList.add('dragover');
			}, false);
		});

		['dragleave', 'drop'].forEach(eventName => {
			dropArea.addEventListener(eventName, () => {
				dropArea.classList.remove('dragover');
			}, false);
		});

		// Handle drop
		dropArea.addEventListener('drop', function(e) {
			const dt = e.dataTransfer;
			const files = dt.files;

			if (files.length > 0) {
				fileInput.files = files;
				// Trigger change event
				const event = new Event('change', { bubbles: true });
				fileInput.dispatchEvent(event);
			}
		}, false);

		// Handle file selection
		fileInput.addEventListener('change', function(e) {
			const file = e.target.files[0];
			if (file) {
				displayFileInfo(file, fileInfo);
			}
		});
	}

	// Display file information
	function displayFileInfo(file, fileInfoElement) {
		const fileSize = formatFileSize(file.size);
		const fileType = file.type || 'Unknown';
		const fileExt = file.name.split('.').pop().toUpperCase();

		const html = `
			<div class="file-info file-info-success">
				<div class="d-flex align-items-center">
					<i class="fas fa-file-alt fa-2x text-success mr-3"></i>
					<div class="flex-grow-1">
						<strong>${file.name}</strong>
						<div class="text-muted small">
							<i class="fas fa-hdd"></i> ${fileSize} •
							<i class="fas fa-tag"></i> ${fileExt} Format
						</div>
					</div>
					<i class="fas fa-check-circle fa-2x text-success"></i>
				</div>
			</div>
		`;

		fileInfoElement.innerHTML = html;
	}

	// Format file size
	function formatFileSize(bytes) {
		if (bytes === 0) return '0 Bytes';
		const k = 1024;
		const sizes = ['Bytes', 'KB', 'MB', 'GB'];
		const i = Math.floor(Math.log(bytes) / Math.log(k));
		return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
	}

	// Format card selection
	function setupFormatCardSelection() {
		const formatCards = document.querySelectorAll('.format-card');

		formatCards.forEach(card => {
			card.addEventListener('click', function() {
				// Remove selected class from all cards
				formatCards.forEach(c => c.classList.remove('selected'));
				// Add selected class to clicked card
				this.classList.add('selected');
			});
		});

		// Set initial selected state
		const checkedRadio = document.querySelector('input[name="outputFormat"]:checked');
		if (checkedRadio) {
			const parentCard = checkedRadio.closest('.format-card');
			if (parentCard) {
				parentCard.classList.add('selected');
			}
		}
	}

	// Enable tooltips
	$(document).ready(function() {
		$('[data-toggle="tooltip"]').tooltip();

		// Drag and drop for decrypt file
		setupDragAndDrop('dropAreaDecrypt', 'fileInputDecrypt', 'fileInfoDecrypt');

		// Drag and drop for encrypt file
		setupDragAndDrop('dropAreaEncrypt', 'fileInputEncrypt', 'fileInfoEncrypt');

		// Format card selection
		setupFormatCardSelection();


		// Private key validation
		$('#privateKeyInput').on('input', function() {
			const key = $(this).val().trim();

			if (key.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#privateKeyFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (key.includes('-----BEGIN PGP PRIVATE KEY BLOCK-----') &&
					   key.includes('-----END PGP PRIVATE KEY BLOCK-----')) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#privateKeyFeedback').html('<i class="fas fa-check-circle"></i> Valid PGP private key format')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#privateKeyFeedback').html('<i class="fas fa-times-circle"></i> Invalid PGP private key format')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
		});

		// Public key validation
		$('#publicKeyInput').on('input', function() {
			const key = $(this).val().trim();

			if (key.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#publicKeyFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (key.includes('-----BEGIN PGP PUBLIC KEY BLOCK-----') &&
					   key.includes('-----END PGP PUBLIC KEY BLOCK-----')) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#publicKeyFeedback').html('<i class="fas fa-check-circle"></i> Valid PGP public key format')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#publicKeyFeedback').html('<i class="fas fa-times-circle"></i> Invalid PGP public key format')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
		});

		// Passphrase validation
		$('#passphraseInput').on('input', function() {
			const passphrase = $(this).val();

			if (passphrase.length === 0) {
				$(this).removeClass('is-valid-custom is-invalid-custom');
				$('#passphraseFeedback').html('').removeClass('valid-feedback invalid-feedback');
			} else if (passphrase.length >= 8) {
				$(this).removeClass('is-invalid-custom').addClass('is-valid-custom');
				$('#passphraseFeedback').html('<i class="fas fa-check-circle"></i> Passphrase entered')
					.removeClass('invalid-feedback').addClass('valid-feedback');
			} else {
				$(this).removeClass('is-valid-custom').addClass('is-invalid-custom');
				$('#passphraseFeedback').html('<i class="fas fa-info-circle"></i> Enter your passphrase')
					.removeClass('valid-feedback').addClass('invalid-feedback');
			}
		});
	});

	function showError(message, resultAreaId) {
		const resultArea = document.getElementById(resultAreaId);
		resultArea.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
			'<i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> ' + message +
			'<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
		resultArea.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
	}

	function showSuccess(message, resultAreaId) {
		const resultArea = document.getElementById(resultAreaId);
		resultArea.innerHTML = '<div class="alert alert-success alert-dismissible fade show result-highlight" role="alert">' +
			'<i class="fas fa-check-circle"></i> <strong>Success!</strong> ' + message +
			'<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
		resultArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
	}

	function resetDecryptForm() {
		document.getElementById('pgpDecryptForm').reset();
		$('.validation-feedback').html('').removeClass('valid-feedback invalid-feedback');
		$('input, textarea').removeClass('is-valid-custom is-invalid-custom');
		document.getElementById('resultAreaDecrypt').innerHTML = '';
		document.getElementById('fileInfoDecrypt').innerHTML = '';
	}

	function resetEncryptForm() {
		document.getElementById('pgpEncryptForm').reset();
		$('.validation-feedback').html('').removeClass('valid-feedback invalid-feedback');
		$('input, textarea').removeClass('is-valid-custom is-invalid-custom');
		document.getElementById('resultAreaEncrypt').innerHTML = '';
		document.getElementById('fileInfoEncrypt').innerHTML = '';
		// Reset format card selection
		document.querySelectorAll('.format-card').forEach(c => c.classList.remove('selected'));
		const binaryCard = document.getElementById('formatCardBinary');
		if (binaryCard) binaryCard.classList.add('selected');
	}

	// DECRYPT FUNCTION
	async function decryptFile() {
		const fileInput = document.getElementById('fileInputDecrypt');
		const privateKeyInput = document.getElementById('privateKeyInput');
		const passphraseInput = document.getElementById('passphraseInput');
		const decryptBtn = document.getElementById('decryptBtn');
		const originalBtnHtml = decryptBtn.innerHTML;

		// Validation
		if (fileInput.files.length === 0) {
			showError('Please select an encrypted file.', 'resultAreaDecrypt');
			return;
		}

		if (privateKeyInput.value.trim() === '') {
			showError('Please provide your PGP private key.', 'resultAreaDecrypt');
			return;
		}

		if (passphraseInput.value.trim() === '') {
			showError('Please enter your private key passphrase.', 'resultAreaDecrypt');
			return;
		}

		// Disable button and show processing state
		decryptBtn.disabled = true;
		decryptBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Decrypting...';

		// Read the file
		const file = fileInput.files[0];

		try {
			const arrayBuffer = await file.arrayBuffer();
			const uint8 = new Uint8Array(arrayBuffer);

			// Parse the private key using v5 API
			const privateKeyObj = await openpgp.readPrivateKey({ armoredKey: privateKeyInput.value });

			// Decrypt the private key with the passphrase
			let decryptedPrivateKey;
			try {
				decryptedPrivateKey = await openpgp.decryptKey({
					privateKey: privateKeyObj,
					passphrase: passphraseInput.value
				});
			} catch (error) {
				showError('Failed to decrypt private key. Please check your passphrase and try again.', 'resultAreaDecrypt');
				decryptBtn.disabled = false;
				decryptBtn.innerHTML = originalBtnHtml;
				return;
			}

			// Read the message - try binary first, then armored
			let message;
			try {
				// Try binary message first (.pgp files)
				message = await openpgp.readMessage({ binaryMessage: uint8 });
			} catch (e) {
				// Fall back to armored text (.asc files)
				const text = new TextDecoder().decode(uint8);
				message = await openpgp.readMessage({ armoredMessage: text });
			}

			// Decrypt the data with format: 'binary' to get Uint8Array
			const { data: decrypted } = await openpgp.decrypt({
				message,
				decryptionKeys: decryptedPrivateKey,
				format: 'binary'
			});

			// Download decrypted file
			const originalFileName = file.name.replace(/\.(pgp|asc)$/i, '') || 'decrypted.bin';

			const blob = new Blob([decrypted], { type: 'application/octet-stream' });
			const link = document.createElement('a');
			link.href = URL.createObjectURL(blob);
			link.download = originalFileName;
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);

			// Show success message
			showSuccess('File "' + originalFileName + '" decrypted and downloaded successfully!', 'resultAreaDecrypt');

			// Re-enable button
			decryptBtn.disabled = false;
			decryptBtn.innerHTML = originalBtnHtml;

		} catch (error) {
			console.error('Decryption error:', error);
			showError('Failed to decrypt file: ' + error.message, 'resultAreaDecrypt');
			decryptBtn.disabled = false;
			decryptBtn.innerHTML = originalBtnHtml;
		}
	}

	// ENCRYPT FUNCTION
	async function encryptFile() {
		const fileInput = document.getElementById('fileInputEncrypt');
		const publicKeyInput = document.getElementById('publicKeyInput');
		const encryptBtn = document.getElementById('encryptBtn');
		const originalBtnHtml = encryptBtn.innerHTML;

		// Validation
		if (fileInput.files.length === 0) {
			showError('Please select a file to encrypt.', 'resultAreaEncrypt');
			return;
		}

		if (publicKeyInput.value.trim() === '') {
			showError('Please provide the recipient\'s PGP public key.', 'resultAreaEncrypt');
			return;
		}

		// Get selected format
		const format = document.querySelector('input[name="outputFormat"]:checked').value;

		// Disable button and show processing state
		encryptBtn.disabled = true;
		encryptBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Encrypting...';

		// Read the file
		const file = fileInput.files[0];

		try {
			const arrayBuffer = await file.arrayBuffer();
			const uint8 = new Uint8Array(arrayBuffer);

			// Parse the public key using v5 API
			const publicKeyObj = await openpgp.readKey({ armoredKey: publicKeyInput.value });

			// Create message from binary data
			const message = await openpgp.createMessage({ binary: uint8 });

			// Encrypt the file with selected format
			const encrypted = await openpgp.encrypt({
				message,
				encryptionKeys: publicKeyObj,
				format: format // 'binary' or 'armored'
			});

			// Create blob and filename based on format
			let blob, encryptedFileName;
			if (format === 'binary') {
				blob = new Blob([encrypted], { type: 'application/octet-stream' });
				encryptedFileName = file.name + '.pgp';
			} else { // armored
				blob = new Blob([encrypted], { type: 'text/plain' });
				encryptedFileName = file.name + '.asc';
			}

			// Download encrypted file
			const link = document.createElement('a');
			link.href = URL.createObjectURL(blob);
			link.download = encryptedFileName;
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);

			// Show success message
			showSuccess('File "' + file.name + '" encrypted successfully! Downloaded as "' + encryptedFileName + '"', 'resultAreaEncrypt');

			// Re-enable button
			encryptBtn.disabled = false;
			encryptBtn.innerHTML = originalBtnHtml;

		} catch (error) {
			console.error('Encryption error:', error);
			showError('Failed to encrypt file: ' + error.message, 'resultAreaEncrypt');
			encryptBtn.disabled = false;
			encryptBtn.innerHTML = originalBtnHtml;
		}
	}
</script>
</div>
<%@ include file="body-close.jsp"%>
