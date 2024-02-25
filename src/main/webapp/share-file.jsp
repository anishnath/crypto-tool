<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
        <title>Transfer file </title>
        <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="keywords" content="send encrypted file, secure file sharing, end-2-end encryption, Send and receive any type of file over the internet securely">
        <meta name="description" content="send encrypted file, secure file sharing, end-2-end encryption, ">
    	   <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Share/Send encrypted file online",
            "description": "transfer share send file securely online, end-2-end encryption, Send and receive any type of file over the internet securely",
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
		 <%@ include file="header-script.jsp"%>
	</head>

	<%@ include file="body-script.jsp"%>

    <div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>Share/Send encrypted file</h1>
        </div>
    </div>
    <p>Share and send any type of file over the internet securely using our online encryption service.To ensure the highest level of security, our platform employs end-to-end encryption with a zero-trust approach. All encryption and decryption processes take place exclusively at the client's end, providing you with complete control over your sensitive data. Your files remain private</p>
            <div class="form-group">
                <label for="txtEmail">Email address</label>
                <input type="email" class="form-control" id="txtEmail" aria-describedby="emailHelp" placeholder="Enter email" oninput="updateSendButtonState()">
            </div>
            <div class="form-group">
                <label for="txtEncpassphrase">Password</label>
                <input type="password" class="form-control" id="txtEncpassphrase" placeholder="Password" oninput="updateSendButtonState()">
            </div>
        <div class="form-group">
        <label class="form-label" for="encfileElem">File for Encryption</label>
        <input type="file" class="form-control" id="encfileElem" onchange="updateSendButtonState();" />
        </div>

        <div class="progress">
            <div id="uploadProgressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
        </div>

        <div id="fileTableContainer">
            <!-- Table will be added dynamically here -->
        </div>

        <button id="sendEncryptedFileButton" onclick="javascript:encryptfile();" class="btn btn-primary" disabled>Send Encrypted File</button>
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
        var servletUrl = 'presign?fileName=' + encodeURIComponent(fileName) +
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
                    var shortenedUrl = currentUrl.replace("share-file.jsp", "e/"+JSON.parse(emailXhr.responseText).status );
                    console.log(emailXhr.responseText)
                    console.log(shortenedUrl)

                    // Create the table inside the new div
                    var tableHtml = `
				<input type=hidden id="copyLink" value="`+shortenedUrl+`">
        <table class="table mt-3">
            <thead>
                <tr>
                    <th scope="col">File Name</th>
                    <th scope="col">Download Link</th>
                </tr>
            </thead>
            <tbody id="fileTableBody">
                <tr>
                    <td>`+fileName+`</td>
                    <td><a href=`+shortenedUrl+` target="_blank">`+shortenedUrl+`</a></td>                </tr>
            </tbody>
        </table>
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