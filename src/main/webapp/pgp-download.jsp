<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://unpkg.com/openpgp@4.10.10/dist/openpgp.min.js"></script>
    <title>Download File</title>
    <%@ include file="header-script.jsp"%>

    <style>
        .button-container {
            position: relative;
            display: inline-block;
        }

        #loadingSpinner {
            display: none;
            position: absolute;
            top: 50%;
            right: -20px; /* Adjust the distance from the button */
            transform: translateY(-50%);
            border: 6px solid #f3f3f3;
            border-top: 6px solid #3498db;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

</head>
<%@ include file="body-script.jsp"%>
<h1 class="mt-4">PGP ASC File Info</h1>
    <div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <%-- Access the presigned URL from the request attribute --%>
                <%
                    String presignedUrl = (String) session.getAttribute("presignedUrl");
                    String file_name = (String) session.getAttribute("file_name");
                    session.removeAttribute("presignedUrl");
                    session.removeAttribute("file_name");

                    if (file_name==null) {
                    	response.sendRedirect(request.getContextPath()+"/pgp-upload.jsp");
                    }

                    if (presignedUrl != null) {
                        %>
<%--                        <p class="text-success">File <strong><%=file_name %></strong> <a id="downloadLink" href="<%= presignedUrl %>"  download> Click for Download</a></p>--%>
                    <p class="text-success">File <strong><%=file_name %></strong>
                    <div class="button-container">
                        <button onclick="showDecryptionFields()">Decrypt ASC File</button>
                        <button><a id="downloadLink" href="<%= presignedUrl %>" download>Download ASC File</a></button>
                        <div id="loadingSpinner"></div>
                    </div>

                    <div id="decryptionFields" style="display: none;">
                        <div>
                        <label for="pgpPassword">PGP Password:</label>
                        <input type="password" id="pgpPassword" value="anish" placeholder="Enter PGP Password">
                        </div>
                        <div>
                        <label for="pgpKeyFile">PGP Key File (*.asc extension):</label>
                        <input type="file" id="pgpKeyFile" accept=".asc">
                        </div>
                        <div>
                        <button onclick="decryptFile('<%= presignedUrl %>', '<%= file_name %>')" id="decryptButton"
                                disabled>Decrypt File & Download
                        </button>
                        </>
                    </div>
                    <div class="mt-4" id="resultArea"></div>


                    </p>

                        <%
                    } else {
                        %>
                        <p class="text-danger">The specified file <strong><%=file_name %></strong> doesn't exist.</p>
                        <%
                    }
                %>
            </div>
        </div>
    </div>

     <script>
                            // Simulate a click on the hidden link
                            document.getElementById('downloadLink').click();
                            alert("File '" + <%= file_name %> + "' downloaded successfully!");
    </script>

<%@ include file="footer_adsense.jsp"%>

<hr>
<h2 class="mt-4">Other File sharing Service</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="pgp-upload.jsp">Send Encrypted file using PGP</a></li>
            <li><a href="pgp-file-decrypt.jsp">PGP File decryption</a></li>
            <li><a href="share-file.jsp">Send Encrypted files</a></li>
        </ul>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div class="row">

<script>

    function updateDecryptButtonState() {
        // Enable the button only if both password and key file are provided
        const password = document.getElementById('pgpPassword').value;
        const keyFile = document.getElementById('pgpKeyFile').files[0];

        const decryptButton = document.getElementById('decryptButton');
        decryptButton.disabled = !(password && keyFile);
    }

    document.getElementById('pgpPassword').addEventListener('input', updateDecryptButtonState);
    document.getElementById('pgpKeyFile').addEventListener('change', updateDecryptButtonState);

    function showDecryptionFields() {
        // Show the decryption fields
        document.getElementById('decryptionFields').style.display = 'block';
    }

    function showLoadingSpinner() {
        // Show the loading spinner
        document.getElementById('loadingSpinner').style.display = 'block';
    }

    function hideLoadingSpinner() {
        // Hide the loading spinner
        document.getElementById('loadingSpinner').style.display = 'none';
    }

    // ... (Rest of your existing JavaScript code)
</script>

<script>
    // Simulate a click on the hidden link
    document.getElementById('downloadLink').click();
    alert("File '" + <%= file_name %> + "' downloaded successfully!");
</script>

<script>


    async function decryptFile(presignedUrl, file_name) {
        const password = document.getElementById('pgpPassword').value;
        const keyFile = document.getElementById('pgpKeyFile').files[0];
        var resultArea = document.getElementById('resultArea');
        if (password && keyFile ) {
            const reader = new FileReader();
            reader.onload = async function() {
                const privateKeyArmored = reader.result;
                const fileURL = presignedUrl;
                showLoadingSpinner();
                // Fetch the encrypted file content
                fetch(fileURL)
                    .then(response => response.text())
                    .then(async encryptedText => {
                        console.log(encryptedText)
                        if (!encryptedText.includes('-----BEGIN PGP MESSAGE-----') || !encryptedText.includes('-----END PGP MESSAGE-----')) {
                            resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error: Misformed armored text. The file should contain PGP message delimiters.</div>';
                            return;
                        }
                        const privateKeyObj = (await openpgp.key.readArmored(privateKeyArmored)).keys[0];
                        // Decrypt the private key with the passphrase
                        try {
                            await privateKeyObj.decrypt(password);
                        } catch (error) {
                            resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error decrypting the private key: ' + error.message + '</div>';
                            return;
                        }

                        // Decrypt the data
                        openpgp.decrypt({
                            message: await openpgp.message.readArmored(encryptedText),
                            privateKeys: [privateKeyObj],
                        }).then(function (decrypted) {
                            console.log(decrypted.data);
                            const decryptedBlob = new Blob([decrypted.data], { type: 'application/octet-stream' });
                            const downloadLink = document.createElement('a');
                            downloadLink.href = URL.createObjectURL(decryptedBlob);
                            const filenameWithoutPrefix = file_name.split('_')[1];
                            const filenameWithoutExtension = filenameWithoutPrefix.replace(/\.asc$/, '');
                            downloadLink.download = filenameWithoutExtension; // Set the appropriate filename
                            document.body.appendChild(downloadLink);
                            downloadLink.click();
                            document.body.removeChild(downloadLink);
                            hideLoadingSpinner()
                            alert('File '+ filenameWithoutExtension + ' decrypted and downloaded successfully!');
                        }).catch(function (error) {
                            hideLoadingSpinner()
                            resultArea.innerHTML = '<div class="alert alert-danger" role="alert">Error decrypting the file: ' + error.message + '</div>';
                        });

                    })
                    .catch(error => {
                        console.error('Error fetching encrypted file:', error);
                        alert('Error fetching encrypted file.');
                        hideLoadingSpinner();

                    });
            };
            reader.readAsText(keyFile);
        } else {
            alert('Password is required for decryption.');
        }
    }
</script>

<%@ include file="body-close.jsp"%>

