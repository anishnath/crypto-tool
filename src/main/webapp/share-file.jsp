<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
        <title>Secure File Transfer – Password Protected (Free) | 8gwifi.org</title>
        <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/share-file.jsp">
        <link rel="alternate" href="https://8gwifi.org/share-file.jsp" hreflang="en">
        <meta name="description" content="Free, browser‑only secure file transfer. Encrypt files with a password (E2EE) and send a protected download link via email. No sign‑up required.">

        <!-- Open Graph -->
        <meta property="og:type" content="website">
        <meta property="og:site_name" content="8gwifi.org">
        <meta property="og:title" content="Secure File Transfer | Send Encrypted Files Online (Free, E2EE)">
        <meta property="og:description" content="Encrypt files in your browser and share a protected download link. Free, no sign‑up.">
        <meta property="og:url" content="https://8gwifi.org/share-file.jsp">
        <meta property="og:image" content="https://8gwifi.org/images/site/file-encrypt.png">
        <meta property="og:locale" content="en_US">

        <!-- Twitter Card -->
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:site" content="@anish2good">
        <meta name="twitter:title" content="Secure File Transfer | Encrypted Files Online (Free)">
        <meta name="twitter:description" content="Client‑side encryption and shareable download links.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/file-encrypt.png">

  <style>
    .howto-steps .step {border:1px solid #eef0f3;border-radius:8px;padding:.75rem;margin-bottom:.5rem;background:#fafbfc}
    .howto-steps .step .num {display:inline-block;width:24px;height:24px;border-radius:999px;background:#3c5be8;color:#fff;text-align:center;line-height:24px;font-weight:700;margin-right:.5rem}
  </style>
    	   <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Secure File Transfer – End-to-End Encrypted File Sharing",
            "description": "Free, browser-only secure file transfer. Encrypt files with AES-256-CBC encryption and share protected download links. No registration required, 24-hour expiry, zero-knowledge architecture.",
            "url": "https://8gwifi.org/share-file.jsp",
			"image": "https://8gwifi.org/images/site/share-file.png",
            "applicationCategory": "UtilityApplication",
            "operatingSystem": "Any (Web-based)",
            "browserRequirements": "Requires JavaScript and Web Crypto API",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "featureList": [
                "AES-256-CBC client-side encryption",
                "PBKDF2 key derivation (10,000 iterations)",
                "Zero-knowledge architecture",
                "24-hour automatic expiry",
                "No registration or sign-up required",
                "Browser-only encryption and decryption",
                "Up to 500MB file size support",
                "Email notification with download link",
                "Password never transmitted or stored",
                "Secure file sharing for teams",
                "Real-time upload progress tracking",
                "Strong password generation"
            ],
            "author": {
                "@type": "Person",
                "name": "Anish Nath",
                "url": "https://8gwifi.org",
                "jobTitle": "Security Engineer & Cryptography Specialist",
                "sameAs": "https://twitter.com/anish2good",
                "knowsAbout": ["Cryptography", "Web Security", "AES Encryption", "Zero-Knowledge Architecture", "File Encryption"]
            },
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org",
                "logo": "https://8gwifi.org/images/logo.png",
                "description": "Free online cryptography, networking, and security tools for developers and security professionals.",
                "founder": {
                    "@type": "Person",
                    "name": "Anish Nath"
                },
                "contactPoint": {
                    "@type": "ContactPoint",
                    "contactType": "Technical Support",
                    "url": "https://8gwifi.org"
                }
            }
        }
    </script>
        <style>
            .min-h-result { min-height: 180px; }
            @media (min-width: 992px) { .min-h-result { min-height: 240px; } }
        </style>
            <%@ include file="header-script.jsp"%>
	</head>

	<%@ include file="body-script.jsp"%>

    <!-- Compact Cryptography Tools Navigation Bar -->
    <%@ include file="crypto-menu-nav.jsp"%>

    <div class="container mt-5">
        <div class="text-center mb-4">
            <h1 class="mb-2">Secure File Transfer</h1>
            <p class="lead text-muted mb-3">Encrypt files in your browser with a password, then email a protected download link. Free, no sign-up.</p>
            <div class="d-flex justify-content-center flex-wrap">
                <span class="badge badge-success badge-pill px-3 py-2 m-1"><i class="fas fa-shield-alt"></i> End-to-End Encrypted</span>
                <span class="badge badge-warning badge-pill px-3 py-2 m-1"><i class="fas fa-clock"></i> 24-Hour Expiry</span>
                <span class="badge badge-info badge-pill px-3 py-2 m-1"><i class="fas fa-user-secret"></i> No Registration</span>
                <span class="badge badge-primary badge-pill px-3 py-2 m-1"><i class="fas fa-lock"></i> AES-256-CBC</span>
            </div>
        </div>

        <!-- Trust Banner -->
        <div class="alert alert-light border mb-4">
            <div class="row text-center small">
                <div class="col-md-3 col-6 mb-2 mb-md-0">
                    <i class="fas fa-laptop-code text-primary"></i> <strong>Browser-Only:</strong> Client-side encryption
                </div>
                <div class="col-md-3 col-6 mb-2 mb-md-0">
                    <i class="fas fa-eye-slash text-success"></i> <strong>Zero-Knowledge:</strong> Server never sees files
                </div>
                <div class="col-md-3 col-6">
                    <i class="fas fa-file-archive text-info"></i> <strong>Up to 500MB:</strong> Large file support
                </div>
                <div class="col-md-3 col-6">
                    <i class="fas fa-trash-alt text-warning"></i> <strong>Auto-Delete:</strong> Removed after 24 hours
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-7 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-file-upload text-primary"></i> Send Encrypted File</h5>
                        <p class="text-muted mb-3">Passwords are never emailed. Share them separately for zero-trust security.</p>
                        <div class="form-group">
                            <label for="txtEmail"><i class="fas fa-envelope"></i> Recipient Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="txtEmail" aria-describedby="emailHelp" placeholder="name@example.com" oninput="updateSendButtonState()" style="border-radius: 8px;">
                            <small id="emailHelp" class="form-text text-muted">We only send the download link to this email.</small>
                        </div>
                        <div class="form-group">
                            <label for="txtEncpassphrase"><i class="fas fa-key"></i> Password <span class="text-danger">*</span></label>
                            <div class="input-group input-group-sm">
                                <input type="password" class="form-control" id="txtEncpassphrase" placeholder="Strong password" oninput="updateSendButtonState()" style="border-radius: 8px 0 0 8px;">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-success" type="button" onclick="generateAndFillPassword(this)" data-toggle="tooltip" title="Generate a strong password">⚡ Generate</button>
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleReveal('txtEncpassphrase', this)" data-toggle="tooltip" title="Show or hide password">👁 Show</button>
                                </div>
                            </div>
                            <small class="form-text text-muted">Choose a strong password (or generate one) and share it separately via secure channel.</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="encfileElem"><i class="fas fa-file"></i> File for Encryption <span class="text-danger">*</span></label>
                            <input type="file" class="form-control" id="encfileElem" onchange="onFileChange(); updateSendButtonState();" style="border-radius: 8px;" />
                            <small id="fileHelp" class="form-text text-muted">Max size: 500 MB. Selected: <span id="fileMeta" class="font-weight-bold text-primary">none</span></small>
                        </div>
                        <div class="d-flex align-items-center">
                            <button id="sendEncryptedFileButton" onclick="javascript:encryptfile();" class="btn btn-success btn-lg mr-2" disabled style="border-radius: 8px;">
                                <i class="fas fa-lock"></i> Encrypt & Send File
                            </button>
                            <button id="btnRefresh" class="btn btn-outline-secondary" onClick="javascript:location.reload();" style="border-radius: 8px;">
                                <i class="fas fa-redo"></i> Clear Form
                            </button>
                        </div>
                        <small id="validationError" class="text-danger mt-2" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i> <strong>Please fill in all required fields.</strong>
                        </small>
                    </div>
                    <div class="card-footer bg-white">
                        <div id="progressWrapper" class="progress" style="display:none; height: 0.75rem;">
                            <div id="uploadProgressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="card shadow-sm sticky-top" style="top: 80px;">
                    <div class="card-body">
                        <h5 class="card-title mb-3"><i class="fas fa-link text-success"></i> Download Link</h5>
                        <div id="fileTableContainer" class="min-h-result text-center text-muted">
                            <p class="mt-4"><i class="fas fa-arrow-left"></i> Encrypt and send a file to get a download link</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- How It Works & Security Features -->
        <div class="row mb-4">
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title mb-3"><i class="fas fa-question-circle text-primary"></i> How It Works</h5>
                        <ol class="mb-0 pl-3">
                            <li class="mb-2"><strong>Enter details:</strong> Recipient email and a strong password</li>
                            <li class="mb-2"><strong>Select file:</strong> Choose the file to encrypt (up to 500 MB)</li>
                            <li class="mb-2"><strong>Encrypt locally:</strong> File encrypted in your browser with AES-256-CBC</li>
                            <li class="mb-2"><strong>Upload securely:</strong> Encrypted file uploaded to secure storage</li>
                            <li class="mb-0"><strong>Share password:</strong> Send password separately via secure channel</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm h-100 border-success">
                    <div class="card-body">
                        <h5 class="card-title mb-3"><i class="fas fa-shield-alt text-success"></i> Security Features</h5>
                        <ul class="mb-0 list-unstyled">
                            <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>AES-256-CBC:</strong> Military-grade encryption standard</li>
                            <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>PBKDF2 Key Derivation:</strong> 10,000 iterations for security</li>
                            <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Zero-Knowledge:</strong> Server never sees plaintext or passwords</li>
                            <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>24-Hour Auto-Delete:</strong> Files removed automatically</li>
                            <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Multiple Downloads:</strong> Access anytime within 24 hours</li>
                            <li class="mb-0"><i class="fas fa-check text-success"></i> <strong>No Registration:</strong> Completely anonymous</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Common Use Cases -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title mb-3"><i class="fas fa-lightbulb text-warning"></i> Common Use Cases</h5>
                <div class="row">
                    <div class="col-md-6">
                        <ul class="mb-2">
                            <li class="mb-2"><strong>Confidential Documents:</strong> Share contracts, legal documents, or NDAs securely</li>
                            <li class="mb-2"><strong>Sensitive Files:</strong> Tax returns, medical records, or personal identification</li>
                            <li class="mb-2"><strong>Business Data:</strong> Financial reports, proprietary code, or client data</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="mb-0">
                            <li class="mb-2"><strong>Large Attachments:</strong> Videos, high-res images, or design files (up to 500MB)</li>
                            <li class="mb-2"><strong>Team Collaboration:</strong> Share project files with team members securely</li>
                            <li class="mb-2"><strong>Client Deliverables:</strong> Send completed work to clients with encryption</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Author/Expertise Section (E-E-A-T) -->
        <div class="card shadow-sm mb-4 border-primary">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h5 class="card-title mb-2"><i class="fas fa-user-shield text-primary"></i> About the Developer</h5>
                        <p class="mb-2">
                            <strong>Anish Nath</strong> – Security Engineer & Cryptography Specialist
                            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="ml-2" title="Follow on Twitter">
                                <i class="fab fa-twitter text-primary"></i> @anish2good
                            </a>
                        </p>
                        <p class="text-muted small mb-2">
                            Extensive experience in cryptography, web security, and file encryption systems.
                            Creator of 8gwifi.org, providing free online security tools used by developers and security professionals worldwide.
                        </p>
                        <div class="d-flex flex-wrap">
                            <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-shield-alt"></i> Cryptography</span>
                            <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-lock"></i> Web Security</span>
                            <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-key"></i> AES Encryption</span>
                            <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-user-secret"></i> Zero-Knowledge Systems</span>
                            <span class="badge badge-primary mb-2"><i class="fas fa-file-lock"></i> File Encryption</span>
                        </div>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="border rounded p-3 bg-light">
                            <div class="mb-2">
                                <i class="fas fa-tools fa-3x text-primary"></i>
                            </div>
                            <p class="small mb-1"><strong>8gwifi.org</strong></p>
                            <p class="small text-muted mb-0">Free Security Tools Since 2010</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Why Trust This Tool -->
        <div class="alert alert-light border mb-4">
            <div class="row text-center small">
                <div class="col-md-4 mb-2 mb-md-0">
                    <i class="fas fa-code text-primary fa-2x mb-2"></i>
                    <p class="mb-0"><strong>Standard Encryption:</strong> Uses Web Crypto API</p>
                </div>
                <div class="col-md-4 mb-2 mb-md-0">
                    <i class="fas fa-history text-success fa-2x mb-2"></i>
                    <p class="mb-0"><strong>Proven Track Record:</strong> Serving professionals since 2010</p>
                </div>
                <div class="col-md-4">
                    <i class="fas fa-users text-info fa-2x mb-2"></i>
                    <p class="mb-0"><strong>Trusted Worldwide:</strong> Used by security teams globally</p>
                </div>
            </div>
        </div>

    </div>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>



<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.10/clipboard.min.js"></script>
<script type="text/javascript">

    function isFileValid(fileInput) {
        if (fileInput.files.length > 0) {
            const maxFileSize = 500 * 1024 * 1024; // 200 MB in bytes
            const fileSize = fileInput.files[0].size;
            return fileSize <= maxFileSize;
        }
        return false;
    }

    function updateSendButtonState() {
        const email = document.getElementById('txtEmail').value.trim();
        const password = document.getElementById('txtEncpassphrase').value.trim();
        const fileInput = document.getElementById('encfileElem');
        const sendButton = document.getElementById('sendEncryptedFileButton');

        // Enable the button only if email, password, and a file are provided
        sendButton.disabled = !(isValidEmail(email) && password !== '' && fileInput.files.length > 0);
    }

	function readfile(file){
		return new Promise((resolve, reject) => {
			var fr = new FileReader();
			fr.onload = () => {
				resolve(fr.result )
			};
			fr.readAsArrayBuffer(file);
		});
	}

	async function encryptfile() {

        const email = document.getElementById('txtEmail').value.trim();
        if (!isValidEmail(email)) {
            alert('Please enter a valid email address.');
            return;
        }

        // Validate password
        const password = document.getElementById('txtEncpassphrase').value.trim();
        if (password === '') {
            alert('Please enter a password.');
            return;
        }

        const fileInput = document.getElementById('encfileElem');
        if (fileInput.files.length === 0) {
            alert('Please select a file for encryption.');
            return;
        }

        if (!isFileValid(fileInput)) {
            alert('Maximum File size Reached sorry dont have budget for this now . Reach out to us if you need to send larger files.');
            return;
        }

        const selectedFile = fileInput.files[0];
        const fileContent = await readfile(selectedFile);

        const currentUnixTimestamp = Math.floor(Date.now() / 1000);
        var fileName = currentUnixTimestamp + '_' + selectedFile.name

		var plaintextbytes=new Uint8Array(fileContent);

		var pbkdf2iterations=10000;
		var passphrasebytes=new TextEncoder("utf-8").encode(txtEncpassphrase.value);
		var pbkdf2salt=window.crypto.getRandomValues(new Uint8Array(8));

		var passphrasekey=await window.crypto.subtle.importKey('raw', passphrasebytes, {name: 'PBKDF2'}, false, ['deriveBits'])
		.catch(function(err){
			console.error(err);
		});
		console.log('passphrasekey imported');

		var pbkdf2bytes=await window.crypto.subtle.deriveBits({"name": 'PBKDF2', "salt": pbkdf2salt, "iterations": pbkdf2iterations, "hash": 'SHA-256'}, passphrasekey, 384)
		.catch(function(err){
			console.error(err);
		});
		console.log('pbkdf2bytes derived');
		pbkdf2bytes=new Uint8Array(pbkdf2bytes);

		keybytes=pbkdf2bytes.slice(0,32);
		ivbytes=pbkdf2bytes.slice(32);

		var key=await window.crypto.subtle.importKey('raw', keybytes, {name: 'AES-CBC', length: 256}, false, ['encrypt'])
		.catch(function(err){
			console.error(err);
		});
		console.log('key imported');

		var cipherbytes=await window.crypto.subtle.encrypt({name: "AES-CBC", iv: ivbytes}, key, plaintextbytes)
		.catch(function(err){
			console.error(err);
		});

		if(!cipherbytes) {
		 	spnEncstatus.classList.add("redspan");
			spnEncstatus.innerHTML='<p>Error encrypting file.  See console log.</p>';
			return;
		}

		console.log('plaintext encrypted');
		cipherbytes=new Uint8Array(cipherbytes);

		var resultbytes=new Uint8Array(cipherbytes.length+16)
		resultbytes.set(new TextEncoder("utf-8").encode('Salted__'));
		resultbytes.set(pbkdf2salt, 8);
		resultbytes.set(cipherbytes, 16);

		var encryptedBlob=new Blob([resultbytes], {type: 'application/octet-stream'});
        handleFileUpload(fileName, encryptedBlob);
	}

    async function handleFileUpload(fileName,file) {
        try {
            let presignedUrl = await getPresignedUrl(fileName, file);
            await uploadToS3(presignedUrl, file);

            // After upload, call the email sending function
            let email = document.getElementById('txtEmail').value;
            await sendEmail(email, fileName); // Implement this function
        } catch (err) {
            console.error(err);
            alert('Error during file upload or email sending.', err);
        }
    }

    async function getPresignedUrl(fileName, file) {
        var contentType = file.type;
        var servletUrl = 'presign2?fileName=' + encodeURIComponent(fileName) +
            '&file_size=' + encodeURIComponent(file.size) +
            '&contentType=' + encodeURIComponent(contentType) +
            '&type=upload';

        try {
            let response = await fetch(servletUrl);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            let data = await response.json();
            console.log('Got presigned URL: ' +  data.presignedUrl)
            return data.presignedUrl;
        } catch (error) {
            console.error('Error getting presigned URL:', error);
            throw error; // Rethrow the error to be handled by the caller
        }
    }

    function uploadToS3(presignedUrl, file) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open("PUT", presignedUrl);

            xhr.upload.onprogress = function(event) {
                if (event.lengthComputable) {
                    const percentComplete = Math.round((event.loaded / event.total) * 100);
                    updateProgressBar(percentComplete);
                }
            };

            xhr.onload = function() {
                if (xhr.status === 200) {
                    console.log('Upload complete');
                    resolve();
                } else {
                    reject(`Upload failed: ${xhr.status}`);
                }
            };

            xhr.onerror = function() {
                reject('XMLHttpRequest error');
            };

            xhr.setRequestHeader('Content-Type', file.type);
            xhr.send(file);
        });
    }

    function isValidEmail(email) {
        // Use a regular expression or a more sophisticated email validation logic
        // This is a basic example, and you may want to use a more comprehensive approach
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function updateProgressBar(percent) {
        const progressBar = document.getElementById('uploadProgressBar');
        progressBar.style.width = percent + '%';
        progressBar.setAttribute('aria-valuenow', percent);
        progressBar.textContent = percent + '%';
    }

    function sendEmail(email, fileName) {
        var emailXhr = new XMLHttpRequest();
        var emailEndpoint = 'presign2';  // Replace with your actual email sending endpoint

        emailXhr.open('POST', emailEndpoint, true);
        emailXhr.setRequestHeader('Content-Type', 'application/json');

        emailXhr.onreadystatechange = function() {
            if (emailXhr.readyState === 4) {
                if (emailXhr.status === 200) {
                    // Create a new div for the table
                    var tableContainer = document.getElementById('fileTableContainer');
                    var newTableDiv = document.createElement('div');
                    newTableDiv.id = 'fileTableDiv';

                    // Append the new div to the container
                    tableContainer.appendChild(newTableDiv);

                    var currentUrl = window.location.href.split('#')[0];
                    var shortenedUrl = currentUrl.replace("share-file.jsp", "e/"+JSON.parse(emailXhr.responseText).status );
                    console.log(emailXhr.responseText)
                    console.log(shortenedUrl)

                    // Build a clean result form group with copy/open actions
                    var tableHtml = `
                        <div class="alert alert-success mb-3">
                          <i class="fas fa-check-circle"></i> <strong>File Encrypted & Uploaded!</strong>
                          <p class="mb-0 small">Download link sent to recipient's email.</p>
                        </div>
                        <input type=hidden id="copyLink" value="`+shortenedUrl+`">
                        <div class="form-group">
                          <label class="font-weight-bold"><i class="fas fa-file"></i> File</label>
                          <div class="text-break">`+fileName+`</div>
                        </div>
                        <div class="form-group">
                          <label for="resultLink" class="font-weight-bold"><i class="fas fa-link"></i> Download Link</label>
                          <div class="input-group input-group-sm">
                            <input id="resultLink" type="text" class="form-control" readonly value="`+shortenedUrl+`">
                            <div class="input-group-append">
                              <button class="btn btn-outline-secondary" type="button" onclick="copyById('resultLink', this)" data-toggle="tooltip" title="Copy link">📋 Copy</button>
                              <a class="btn btn-primary" target="_blank" rel="noopener" href="`+shortenedUrl+`" data-toggle="tooltip" title="Open in new tab">Open</a>
                            </div>
                          </div>
                          <small class="form-text text-muted"><i class="fas fa-info-circle"></i> Share the password separately for security.</small>
                        </div>
                        <div class="alert alert-info mb-0 small">
                          <i class="fas fa-clock"></i> Available for <strong>24 hours</strong>. Can be downloaded multiple times. Auto-deleted after expiry.
                        </div>
                    `;

                    // Set the HTML content of the new div
                    newTableDiv.innerHTML = tableHtml;

                    // Update button state
                    const sendButton = document.getElementById('sendEncryptedFileButton');
                    sendButton.disabled = false;
                    sendButton.innerHTML = '<i class="fas fa-check-circle"></i> File Sent!';
                    sendButton.classList.remove('btn-success');
                    sendButton.classList.add('btn-outline-success');
                    setTimeout(function() {
                        sendButton.innerHTML = '<i class="fas fa-lock"></i> Encrypt & Send File';
                        sendButton.classList.remove('btn-outline-success');
                        sendButton.classList.add('btn-success');
                        sendButton.disabled = true;
                    }, 3000);
                } else {
                    alert('Failed to send email. Please try again.');
                }
            }
        };

        // Prepare the data to send in the request body
        var emailData = {
            email: email,
            fileName: fileName,
            cameFrom: window.location.href
        };

        emailXhr.send(JSON.stringify(emailData));
    }



</script>
<script>
    // UI helpers: tooltips, copy, reveal, file meta
    (function(){
        if (window.jQuery && typeof $ === 'function') {
            $(function(){
                $('[data-toggle="tooltip"]').tooltip();
            });
        }
    })();

    function copyText(text) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            return navigator.clipboard.writeText(text);
        }
        return new Promise(function(resolve, reject) {
            try {
                var ta = document.createElement('textarea');
                ta.value = text;
                ta.style.position = 'fixed';
                ta.style.opacity = '0';
                document.body.appendChild(ta);
                ta.focus();
                ta.select();
                var ok = document.execCommand('copy');
                document.body.removeChild(ta);
                ok ? resolve() : reject(new Error('copy failed'));
            } catch (e) { reject(e); }
        });
    }

    function copyById(id, btn) {
        var el = document.getElementById(id);
        if (!el) return;
        copyText(el.value || '')
            .then(function(){ showCopied(btn); })
            .catch(function(){ showCopied(btn, false); });
    }

    function showCopied(btn, success) {
        if (!btn) return;
        var original = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = success === false ? '❌ Failed' : '✅ Copied';
        setTimeout(function(){ btn.disabled = false; btn.innerHTML = original; }, 1300);
    }

    function toggleReveal(id, btn) {
        var el = document.getElementById(id);
        if (!el) return;
        if (el.type === 'password') { el.type = 'text'; if (btn) btn.innerHTML = '🙈 Hide'; }
        else { el.type = 'password'; if (btn) btn.innerHTML = '👁 Show'; }
    }

    function onFileChange() {
        var fi = document.getElementById('encfileElem');
        var meta = document.getElementById('fileMeta');
        if (!fi || !meta || fi.files.length === 0) { meta.textContent = 'none'; return; }
        var f = fi.files[0];
        var sizeMB = (f.size / (1024*1024)).toFixed(1);
        meta.textContent = f.name + ' (' + sizeMB + ' MB)';
    }

    function generateStrongPassword(length) {
        var charset = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%^&*()-_=+[]{}~';
        var pwd = '';
        var bytes = new Uint32Array(length);
        (window.crypto || window.msCrypto).getRandomValues(bytes);
        for (var i = 0; i < length; i++) {
            pwd += charset[bytes[i] % charset.length];
        }
        return pwd;
    }

    function generateAndFillPassword(btn) {
        var pwd = generateStrongPassword(16);
        var input = document.getElementById('txtEncpassphrase');
        if (input) {
            input.value = pwd;
            updateSendButtonState();
        }
        // Copy to clipboard for convenience
        copyText(pwd).then(function(){ showCopied(btn); }).catch(function(){ showCopied(btn, false); });
    }
  </script>

  <!-- Visible: How it works & FAQs -->
  <div class="container mt-4">
    <h2 class="mt-4">How It Works</h2>
    <div class="howto-steps">
      <div class="step"><span class="num">1</span><strong>Upload file</strong>: Select a file to encrypt client‑side in your browser.</div>
      <div class="step"><span class="num">2</span><strong>Set password</strong>: Choose a strong password; we encrypt locally before transfer.</div>
      <div class="step"><span class="num">3</span><strong>Share link</strong>: Send the protected download link to the recipient. Share the password via a separate channel.</div>
    </div>

    <hr>
    <h2 class="mt-4" id="faqs">FAQs</h2>
    <div class="accordion" id="sftFaqs">
      <div class="card"><div class="card-header"><h6 class="mb-0">Are files stored on the server?</h6></div><div class="card-body small text-muted">Encryption occurs in your browser; we do not permanently store your files. Use the link promptly and avoid sharing sensitive data over insecure channels.</div></div>
      <div class="card"><div class="card-header"><h6 class="mb-0">How should I share the password?</h6></div><div class="card-body small text-muted">Share the password separately (e.g., messaging app) and avoid including it in the same email as the link.</div></div>
      <div class="card"><div class="card-header"><h6 class="mb-0">Any file size limits?</h6></div><div class="card-body small text-muted">Browser‑based encryption works best with moderate file sizes. For very large files, compress or split before encrypting.</div></div>
    </div>
  </div>

<!-- JSON-LD: WebPage + Breadcrumbs + FAQ + HowTo -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Secure File Transfer (Encrypted)",
  "url": "https://8gwifi.org/share-file.jsp",
  "description": "Encrypt files in your browser and share a protected download link. Free, no sign‑up.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Secure File Transfer", "item": "https://8gwifi.org/share-file.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Is encryption client-side?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Files are encrypted locally in your browser using AES-256-CBC with PBKDF2 key derivation (10,000 iterations) before upload. This is true end-to-end encryption (E2EE) – the server never sees your plaintext files or passwords."
      }
    },
    {
      "@type": "Question",
      "name": "What gets emailed?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Only the download link is emailed to the recipient. Passwords are NEVER sent via email and must be shared through a separate secure channel (like Signal, WhatsApp, phone call, or in person) for zero-trust security."
      }
    },
    {
      "@type": "Question",
      "name": "Is there a file size limit?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. The current limit is up to 500 MB per file. This covers most documents, images, videos, and archives."
      }
    },
    {
      "@type": "Question",
      "name": "How long are files available?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Encrypted files are available for 24 hours and can be downloaded multiple times during this period. After 24 hours, files are automatically deleted from the server."
      }
    },
    {
      "@type": "Question",
      "name": "What encryption algorithm is used?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Files are encrypted using AES-256-CBC (Advanced Encryption Standard with 256-bit key in Cipher Block Chaining mode) with PBKDF2 key derivation. This is industry-standard encryption used by governments and enterprises worldwide."
      }
    },
    {
      "@type": "Question",
      "name": "Do I need to create an account?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No sign-up or registration required. The service is completely anonymous and runs entirely in your browser using the Web Crypto API."
      }
    }
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Send an encrypted file securely",
  "description": "Free browser‑only encrypted file transfer.",
  "totalTime": "PT2M",
  "step": [
    {"@type": "HowToStep", "name": "Enter email", "text": "Type the recipient's email address (we email only the link)."},
    {"@type": "HowToStep", "name": "Set password", "text": "Choose a strong password for encryption."},
    {"@type": "HowToStep", "name": "Select file", "text": "Choose the file to encrypt (max 500 MB)."},
    {"@type": "HowToStep", "name": "Encrypt and upload", "text": "The file is encrypted in your browser and uploaded securely."},
    {"@type": "HowToStep", "name": "Share password separately", "text": "Share the password via a different channel."}
  ],
  "url": "https://8gwifi.org/share-file.jsp"
}
</script>
