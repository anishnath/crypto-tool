<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
        <title>Secure File Transfer | Send Encrypted Files Online (Free, E2EE) | 8gwifi.org</title>
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
        <meta property="og:image" content="https://8gwifi.org/images/site/share-file.png">
        <meta property="og:locale" content="en_US">

        <!-- Twitter Card -->
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:site" content="@anish2good">
        <meta name="twitter:title" content="Secure File Transfer | Encrypted Files Online (Free)">
        <meta name="twitter:description" content="Client‑side encryption and shareable download links.">
        <meta name="twitter:image" content="https://8gwifi.org/images/site/share-file.png">
    	   <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Secure File Transfer (Encrypted)",
            "description": "Free, browser‑only secure file transfer. Encrypt files with a password and share protected download links.",
            "url": "https://8gwifi.org/share-file.jsp",
			"image" : "https://8gwifi.org/images/site/share-file.png",
            "applicationCategory": "Encryption",
            "version": "1.0",
            "author": {
                "@type": "Person",
                "name": "Anish Nath"
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
        <h1 class="mb-3">Secure File Transfer</h1>
        <p class="lead mb-4">Encrypt files in your browser with a password, then email a protected download link. Free, no sign‑up.</p>

        <div class="row">
            <div class="col-lg-7 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">Send Encrypted File</h5>
                        <p class="text-muted mb-3">Passwords are never emailed. Share them separately for zero‑trust security.</p>
                        <div class="form-group">
                            <label for="txtEmail">Recipient Email</label>
                            <input type="email" class="form-control" id="txtEmail" aria-describedby="emailHelp" placeholder="name@example.com" oninput="updateSendButtonState()">
                            <small id="emailHelp" class="form-text text-muted">We only send the download link to this email.</small>
                        </div>
                        <div class="form-group">
                            <label for="txtEncpassphrase">Password</label>
                            <div class="input-group input-group-sm">
                                <input type="password" class="form-control" id="txtEncpassphrase" placeholder="Strong password" oninput="updateSendButtonState()">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-success" type="button" onclick="generateAndFillPassword(this)" data-toggle="tooltip" title="Generate a strong password">⚡ Generate</button>
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleReveal('txtEncpassphrase', this)" data-toggle="tooltip" title="Show or hide password">👁 Show</button>
                                </div>
                            </div>
                            <small class="form-text text-muted">Choose a strong password and share it separately.</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="encfileElem">File for Encryption</label>
                            <input type="file" class="form-control" id="encfileElem" onchange="onFileChange(); updateSendButtonState();" />
                            <small id="fileHelp" class="form-text text-muted">Max size: 500 MB. Selected: <span id="fileMeta">none</span></small>
                        </div>
                        <div class="d-flex align-items-center">
                            <button id="sendEncryptedFileButton" onclick="javascript:encryptfile();" class="btn btn-primary mr-2" disabled>Send Encrypted File</button>
                            <button id="btnRefresh" class="btn btn-outline-secondary" onClick="javascript:location.reload();">Reset</button>
                        </div>
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
                        <h5 class="card-title mb-3">Result</h5>
                        <div id="fileTableContainer" class="min-h-result"><!-- Table will be added dynamically here --></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- How It Works -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title mb-2">How It Works</h5>
                <ol class="mb-0">
                    <li>Enter recipient email and a strong password.</li>
                    <li>Select the file to encrypt (client‑side).</li>
                    <li>We upload the encrypted file and email the link.</li>
                    <li>Share the password separately for security.</li>
                    <li>The recipient uses the link and password to download/decrypt.</li>
                </ol>
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
                        <input type=hidden id="copyLink" value="`+shortenedUrl+`">
                        <div class="form-group">
                          <label class="font-weight-bold">File</label>
                          <div>`+fileName+`</div>
                        </div>
                        <div class="form-group">
                          <label for="resultLink" class="font-weight-bold">Download Link</label>
                          <div class="input-group input-group-sm">
                            <input id="resultLink" type="text" class="form-control" readonly value="`+shortenedUrl+`">
                            <div class="input-group-append">
                              <button class="btn btn-outline-secondary" type="button" onclick="copyById('resultLink', this)" data-toggle="tooltip" title="Copy link">📋 Copy</button>
                              <a class="btn btn-primary" target="_blank" rel="noopener" href="`+shortenedUrl+`" data-toggle="tooltip" title="Open in new tab">Open</a>
                            </div>
                          </div>
                          <small class="form-text text-muted">Share the password separately for security.</small>
                        </div>
                    `;

                    // Set the HTML content of the new div
                    newTableDiv.innerHTML = tableHtml;
                    alert('Email sent successfully.');
                    const sendButton = document.getElementById('sendEncryptedFileButton');
                    sendButton.disabled = true;
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
    {"@type": "Question", "name": "Is encryption client‑side?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. Files are encrypted locally in your browser before upload (E2EE)."}},
    {"@type": "Question", "name": "What gets emailed?", "acceptedAnswer": {"@type": "Answer", "text": "Only the download link. Passwords are never emailed and should be shared separately."}},
    {"@type": "Question", "name": "Is there a file size limit?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. The current limit is up to 500 MB per file."}}
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
