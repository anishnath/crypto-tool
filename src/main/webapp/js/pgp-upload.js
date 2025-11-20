// Assuming you have included OpenPGP.js in your HTML file

async function uploadFile() {
	// Get the upload button and disable it
	var uploadBtn = document.getElementById('uploadBtn');
	if (!uploadBtn) {
		console.error('Upload button not found');
		return;
	}
	var originalBtnHtml = uploadBtn.innerHTML;

	// Disable button and show processing state
	uploadBtn.disabled = true;
	uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

	// Show progress bar
	var progressContainer = document.getElementById('progressContainer');
	if (progressContainer) {
		progressContainer.classList.add('active');
	}

	var fileInput = document.getElementById('file');
	var pgpKeys = document.getElementById('pgpKeys').value;
	var email = document.getElementById('email').value;


	// Helper function to re-enable button
	function enableButton() {
		uploadBtn.disabled = false;
		uploadBtn.innerHTML = originalBtnHtml;
		if (progressContainer) {
			progressContainer.classList.remove('active');
		}
	}

	// Helper function to show error message
	function showError(message) {
		var container = document.getElementById('fileTableContainer');
		container.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> ' + message + '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
		container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
		enableButton();
	}

	if (!pgpKeys || pgpKeys.trim() === '') {
		showError('Please enter valid PGP Keys.');
		return false;
	}

	// Validate email
	if (!isValidEmail(email)) {
		showError('Please enter a valid email address.');
		return false;
	}

	// Validate file
	if (fileInput.files.length === 0) {
		showError('Please choose a file to upload.');
		return false;
	}

	// Validate PGPKeys
	if (!isValidPgpKeys(pgpKeys)) {
		showError('Please enter valid PGP Public Keys.');
		return;
	}

	// Validation
	var file = fileInput.files[0];

	// Check file size
    var maxSizeInBytes = 100 * 1024 * 1024; // 100MB
    if (file.size > maxSizeInBytes) {
        showError('File size exceeds the maximum allowed size of 100MB.');
        return false;
    }


	var fileName = file.name + ".asc";
	var contentType = file.type;

	// Override content Type
	contentType = "application/octet-stream"


	const currentUnixTimestamp = Math.floor(Date.now() / 1000);
	fileName = currentUnixTimestamp + '_' + fileName
	if (pgpKeys && file) {
		var reader = new FileReader();

		reader.onload = async function(e) {
			var plainData = new Uint8Array(e.target.result);
			const publicKey = (await openpgp.key.readArmored(pgpKeys)).keys[0];

			openpgp.encrypt({
				message: openpgp.message.fromBinary(plainData),
				publicKeys: publicKey,
			}).then(function(ciphertext) {

				//updateProgressBar('10')

				// Create a Blob from the encrypted data
				var blob = new Blob([ciphertext.data], { type: contentType });


				// Make a request to the servlet to get the presigned URL with filename and content type
				var xhr = new XMLHttpRequest();
				var servletUrl = 'presign?fileName=' + encodeURIComponent(fileName) + '&file_size=' + encodeURIComponent(file.size) + '&contentType=' + encodeURIComponent(contentType) + '&type=upload';
				xhr.open('GET', servletUrl, true);

				xhr.onreadystatechange = function() {
					if (xhr.readyState === 4 && xhr.status === 200) {
						var presignedUrl = JSON.parse(xhr.responseText).presignedUrl;

						// Use the presigned URL to upload the encrypted file to S3
						var uploadXhr = new XMLHttpRequest();
						uploadXhr.open('PUT', presignedUrl, true);
						uploadXhr.setRequestHeader('Content-Type', contentType);

						// Track progress
						uploadXhr.upload.onprogress = function(e) {
							if (e.lengthComputable) {
								var percentComplete = (e.loaded / e.total) * 100;
								// Update your progress bar here
								updateProgressBar(percentComplete);
							}
						};

						uploadXhr.onreadystatechange = function() {
							if (uploadXhr.readyState === 4) {
								if (uploadXhr.status === 200) {
									sendEmail(email, fileName, enableButton);
								} else {
									var container = document.getElementById('fileTableContainer');
									container.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="fas fa-exclamation-circle"></i> <strong>Upload Failed:</strong> Unable to upload file. Please try again.<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
									container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
									enableButton();
								}
							}
						};

						uploadXhr.send(blob);
					}
				};

				xhr.send();
			}).catch(function(error) {
				console.error('Encryption failed:', error);
				var container = document.getElementById('fileTableContainer');
				container.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="fas fa-exclamation-circle"></i> <strong>Encryption Failed:</strong> Unable to encrypt file. Please verify the PGP public key is correct.<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
				container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
				enableButton();
			});
		};

		reader.readAsArrayBuffer(file);
	}
}

function sendEmail(email, fileName, enableButton) {
	var emailXhr = new XMLHttpRequest();
	var emailEndpoint = 'presign';  // Replace with your actual email sending endpoint

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
            	var shortenedUrl = currentUrl.replace("pgp-upload.jsp", "d/"+JSON.parse(emailXhr.responseText).status );

                // Build a compact result with copy/open actions
                var tableHtml = `
                    <input type="hidden" id="copyLink" value="${shortenedUrl}">
                    <div class="form-group">
                      <label class="font-weight-bold">File</label>
                      <div>${fileName}</div>
                    </div>
                    <div class="form-group">
                      <label for="pgpResultLink" class="font-weight-bold">Download Link</label>
                      <div class="input-group input-group-sm">
                        <input id="pgpResultLink" type="text" class="form-control" readonly value="${shortenedUrl}">
                        <div class="input-group-append">
                          <button class="btn btn-outline-secondary copy-button" data-clipboard-target="#pgpResultLink" type="button" title="Copy link">📋 Copy</button>
                          <a class="btn btn-primary" target="_blank" rel="noopener" href="${shortenedUrl}" title="Open in new tab">Open</a>
                        </div>
                      </div>
                      <small class="form-text text-muted">Only the link is emailed. Keep your private key safe.</small>
                    </div>
                `;

				// Set the HTML content of the new div
				newTableDiv.innerHTML = tableHtml;

				// Initialize Clipboard.js
                new ClipboardJS('.copy-button');

                // Add success message at the top with highlight
                var successMsg = document.createElement('div');
                successMsg.className = 'alert alert-success alert-dismissible fade show mb-3';
                successMsg.setAttribute('role', 'alert');
                successMsg.innerHTML = '<i class="fas fa-check-circle"></i> <strong>Success!</strong> File encrypted and uploaded. Download link sent to <strong>' + email + '</strong><button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>';
                tableContainer.insertBefore(successMsg, newTableDiv);

                // Highlight and scroll to result
                newTableDiv.className = 'card border-success';
                newTableDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });

                // Re-enable the upload button
                if (enableButton) enableButton();
			} else {
				// Show error message
				tableContainer.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="fas fa-exclamation-circle"></i> <strong>Email Failed:</strong> Unable to send notification email. Please try again.<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
				tableContainer.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

				// Re-enable the upload button
				if (enableButton) enableButton();
			}
		}
	};

	// Prepare the data to send in the request body
	var emailData = {
		email: email,
		fileName: fileName
	};

	emailXhr.send(JSON.stringify(emailData));
}



function updateProgressBar(percent) {
    var wrapper = document.getElementById('progressWrapper');
    var progressBar = document.getElementById('progressBar');
    if (!progressBar) return;
    if (wrapper && percent > 0 && wrapper.style.display === 'none') wrapper.style.display = 'block';
    progressBar.style.width = percent + '%';
    progressBar.innerText = percent.toFixed(2) + '%';
    if (wrapper && percent >= 100) setTimeout(function(){ wrapper.style.display = 'none'; }, 1000);
}

async function isValidPgpKeys(pgpKeys) {
	try {
		// Attempt to parse the PGP public key
		const key = await openpgp.key.readArmored(pgpKeys)
		// Check if the key is successfully parsed
		if (key && key.keys && key.keys.length > 0) {
			return true; // Valid PGP public key
		} else {
			return false; // Invalid PGP public key
		}
	} catch (error) {
		return false; // Error during parsing, consider it invalid
	}
}

function isValidEmail(email) {
	var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	return emailRegex.test(email);
}
