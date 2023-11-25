<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Decrypt PGP files and verify signatures using openpgp.js. A web-based tool for PGP encryption and decryption.">
    <title>Decrypt PGP filesn</title>
    <!-- Include Bootstrap CSS -->
    
    
      <!-- JSON-LD Script for Metadata -->
    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebPage",
            "name": "PGP Decryption",
            "description": "A web page for decrypting PGP files using openpgp.js",
            "keywords": "PGP, encryption, decryption, openpgp.js, signature verification",
            "url": "https://yourwebsite.com/pgp-decryption-verification",
			"image": "https://8gwifi.org/images/pgp-file-decrypt.png",
            "inLanguage": "en",
            "mainEntity": {
                "@type": "SoftwareApplication",
                "name": "PGP Tool",
                "applicationCategory": "Security",
                "operatingSystem": "Cross-platform",
                "description": "A web-based tool for PGP encryption, decryption, and signature verification.",
                "version": "1.0.0",
                "downloadUrl": "https://8gwifi.org/pgp-file-decrypt.jsp"
            },
            "author": {
                "@type": "Person",
                "name": "Anish Nath",
                "url": "pgp-file-decrypt.jsp"
            }
        }
    </script>
    <%@ include file="header-script.jsp"%>
    <script src="https://unpkg.com/openpgp@4.10.10/dist/openpgp.min.js"></script>

    <script>
        async function decryptFile() {
            var fileInput = document.getElementById('fileInput');
            var privateKeyInput = document.getElementById('privateKeyInput');
            var publicKeyInput = document.getElementById('publicKeyInput');
            var resultArea = document.getElementById('resultArea');

            // Check if all fields are filled
            if (
                fileInput.files.length === 0 ||
                privateKeyInput.value.trim() === ''
            ) {
                alert('All fields are required.');
                return;
            }

            // Get the passphrase for the private key
            var passphrase = prompt('Enter the passphrase for the private key');

            // Read the file
            var file = fileInput.files[0];
            var reader = new FileReader();
            reader.onload = async function (event) {
                // Get the encrypted data from the file
                var encryptedData = event.target.result;
                
             // Check if the data contains PGP message delimiters
                if (!encryptedData.includes('-----BEGIN PGP MESSAGE-----') || !encryptedData.includes('-----END PGP MESSAGE-----')) {
                    resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error: Misformed armored text. The file should contain PGP message delimiters.</div>';
                    return;
                }

             // Parse the private key
                const privateKeyObj = (await openpgp.key.readArmored(privateKeyInput.value)).keys[0];

                // Decrypt the private key with the passphrase
                try {
                	
                    await privateKeyObj.decrypt(passphrase);
                } catch (error) {
                    resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error decrypting the private key: ' + error.message + '</div>';
                    return;
                }

                // Decrypt the data
                openpgp.decrypt({
                    message: await openpgp.message.readArmored(encryptedData),
                    privateKeys: [privateKeyObj],
                }).then(function (decrypted) {
                    resultArea.innerHTML = '<div class="alert alert-success" role="alert">Decrypted Data: <br>' + decrypted.data + '</div>';
                    toggleDownloadButton();
                }).catch(function (error) {
                    resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error decrypting the file: ' + error.message + '</div>';
                });
            };

            reader.readAsText(file);
        }

        
        function toggleDownloadButton() {
            var resultArea = document.getElementById('resultArea');
            var downloadButton = document.getElementById('downloadButton');

            // Check if resultArea contains any text
            if (resultArea.innerText.trim() !== '') {
                downloadButton.style.display = 'block';
            } else {
                downloadButton.style.display = 'none';
            }
        }
        
        function downloadResult() {
            var resultArea = document.getElementById('resultArea');
            var resultData = resultArea.innerText;
            // Get the original file name
            var fileInput = document.getElementById('fileInput');
            var originalFileName = fileInput.files[0].name;
            originalFileName =  originalFileName.replace(/\.asc$/, '');

            // Create a Blob with the result data
            var blob = new Blob([resultData], { type: '"application/octet-stream' });

            // Create a link element and trigger a click to download the result
            var link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = originalFileName;
            link.click();
        }
        
    </script>
        
</head>
<%@ include file="body-script.jsp"%>
    <div class="container mt-5">
        <h2 class="mb-4">PGP file Decryption</h2>

        <form id="pgpForm">
            <div class="form-group">
                <label for="fileInput">Select PGP Encrypted File</label>
                <input type="file" class="form-control-file" id="fileInput" required>
            </div>

            <div class="form-group">
                <label for="privateKeyInput">PGP Private Key</label>
                <textarea class="form-control" id="privateKeyInput" rows="5" required>-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: Keybase OpenPGP v2.0.76
Comment: https://keybase.io/crypto

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
=aq/f
-----END PGP PRIVATE KEY BLOCK-----
                </textarea>
            </div>

            <button type="button" class="btn btn-primary" onclick="decryptFile()">Decrypt File</button>
        </form>

        <div class="mt-4" id="resultArea"></div>
        
        <button type="button" class="btn btn-success mt-3" id="downloadButton" style="display: none;" onclick="downloadResult()">Download File</button>
    </div>
    
     <!-- Add download button only when file is present -->
    

    <!-- Include openpgp.js -->

<hr>

<div id="fileTableContainer">
        <!-- Table will be added dynamically here -->
    </div>

 <div class="card my-4">
     <h5 class="card-header">Other PGP Tools</h5>
     <ul>
	     <li><a href="pgpencdec.jsp">PGP Encryption/Decryption  </a></li>
	     <li><a href="pgpkeyfunction.jsp">PGP Key Generation  </a></li>
	     <li><a href="PGPFunctionality?invalidate=yes">PGP Signature Verifier  </a></li>
	     <li><a href="pgpdump.jsp">PGP KeyDumper</a></li>
	     <li><a href="pgp-upload.jsp">PGP Encrypt files</a></li>
	     <li><a href="pgp-file-decrypt.jsp">PGP Decrypt files</a></li>
     </ul>
 </div>

<%@ include file="footer_adsense.jsp"%>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div class="row">

<%@ include file="body-close.jsp"%>
