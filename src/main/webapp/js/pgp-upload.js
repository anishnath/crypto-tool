// Assuming you have included OpenPGP.js in your HTML file

async function uploadFile() {

	var fileInput = document.getElementById('file');
	var pgpKeys = document.getElementById('pgpKeys').value;
	var email = document.getElementById('email').value;


	if (!pgpKeys || pgpKeys.trim() === '') {
		alert('Please enter a valid PGP Keys .');
		return false; // Empty or null PGP public key
	}



	// Validate email
	if (!isValidEmail(email)) {
		alert('Please enter a valid email address.');
		return false;
	}


	// Validate file
	if (fileInput.files.length === 0) {
		alert('Please choose a file to upload.');
		return false;
	}



	// Validate PGPKeys
	if (!isValidPgpKeys(pgpKeys)) {
		alert('Please enter valid PGP Public Keys.');
		return;
	}

	// Validation
	var file = fileInput.files[0];

	// Check file size
    var maxSizeInBytes = 100 * 1024 * 1024; // 100MB
    if (file.size > maxSizeInBytes) {
        alert('File size exceeds the maximum allowed size of 100MB.');
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
									sendEmail(email, fileName);
								} else {
									alert('File upload failed. Please try again.');
								}
							}
						};

						uploadXhr.send(blob);
					}
				};

				xhr.send();
			}).catch(function(error) {
				console.error('Encryption failed:', error);

				alert("Failed to Encrypted File possible reason wrong pgp file ....", error)
			});
		};

		reader.readAsArrayBuffer(file);
	}
}

function sendEmail(email, fileName) {
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

				// Create the table inside the new div
				var tableHtml = `
				<input type=hidden id="copyLink" value=${shortenedUrl}>
        <table class="table mt-3">
            <thead>
                <tr>
                    <th scope="col">File Name</th>
                    <th scope="col">Download Link</th>
                    <th scope="col">Copy</th>
                </tr>
            </thead>
            <tbody id="fileTableBody">
                <tr>
                    <td>${fileName}</td>
                    <td><a href="${shortenedUrl}" target="_blank">${shortenedUrl}</a></td>
                    <td><button class="btn btn-secondary copy-button" data-clipboard-target="#copyLink"><i class="fas fa-copy"></i></button></td>
                </tr>
            </tbody>
        </table>
    `;

				// Set the HTML content of the new div
				newTableDiv.innerHTML = tableHtml;

				// Initialize Clipboard.js
                new ClipboardJS('.copy-button');
                alert('Email sent successfully.');
			} else {
				alert('Failed to send email. Please try again.');
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
	// Assuming you have a progress bar element with id "progressBar"
	var progressBar = document.getElementById('progressBar');
	progressBar.style.width = percent + '%';
	progressBar.innerText = percent.toFixed(2) + '%';
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
