<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"> -->
    <title>Download File</title>
    <%@ include file="header-script.jsp"%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.js"></script>
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
<h1 class="mt-4">Your Encrypted File Info</h1>
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
                    response.sendRedirect(request.getContextPath()+"/share-file.jsp");
                }

                if (presignedUrl != null) {
            %>
            <p class="text-success">File <strong><%=file_name %></strong>
            <div class="button-container">
                <button onclick="decryptFile('<%= presignedUrl %>', '<%= file_name %>' )">Decrypt and Download</button>
                <div id="loadingSpinner"></div>
            </div>
<%--                <button onclick="decryptFile('<%= presignedUrl %>', '<%= file_name %>' )">Decrypt and Download</button>--%>
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
    function wordArrayToUint8Array(wordArray) {
        var byteArray = new Uint8Array(wordArray.length);
        for (var i = 0; i < wordArray.length; i++) {
            byteArray[i] = (wordArray[i] & 0xff00) >> 8 | (wordArray[i] & 0x00ff) << 8;
        }
        return byteArray;
    }

    async function decryptFile(presignedUrl, file_name) {
        const password = prompt(`Enter password for decryption ${file_name}:`);

        if (password) {
            // Construct the URL for fetching the encrypted file
            const fileURL = presignedUrl;
            showLoadingSpinner();

            // Fetch the encrypted file content
            fetch(fileURL)
                .then(response => response.arrayBuffer())
                .then(async encryptedArrayBuffer => {
                    console.log(encryptedArrayBuffer)
                    var cipherbytes = new Uint8Array(encryptedArrayBuffer);
                    var pbkdf2iterations = 10000;
                    var passphrasebytes = new TextEncoder("utf-8").encode(password);
                    var pbkdf2salt = cipherbytes.slice(8, 16);

                    var passphrasekey = await window.crypto.subtle.importKey('raw', passphrasebytes, {name: 'PBKDF2'}, false, ['deriveBits'])
                        .catch(function (err) {
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
                    cipherbytes=cipherbytes.slice(16);

                    var key=await window.crypto.subtle.importKey('raw', keybytes, {name: 'AES-CBC', length: 256}, false, ['decrypt'])
                        .catch(function(err){
                            console.error(err);
                        });
                    console.log('key imported');

                    var plaintextbytes=await window.crypto.subtle.decrypt({name: "AES-CBC", iv: ivbytes}, key, cipherbytes)
                        .catch(function(err){
                            console.error(err);
                        });

                    if(!plaintextbytes) {
                        alert('Invalid password');
                        return;
                    }

                    var decryptedBlob = new Blob([plaintextbytes], {type: 'application/octet-stream'});
                    const downloadLink = document.createElement('a');
                    downloadLink.href = URL.createObjectURL(decryptedBlob);
                    downloadLink.download = file_name; // Set the appropriate filename

                    // Append the link to the document and trigger the download
                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
                    hideLoadingSpinner();


                    alert('File decrypted and downloaded successfully!');

                })
                .catch(error => {
                    console.error('Error fetching encrypted file:', error);
                    alert('Error fetching encrypted file.');
                    hideLoadingSpinner();

                });
        } else {
            alert('Password is required for decryption.');
        }
    }
</script>

<%@ include file="footer_adsense.jsp"%>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div class="row">

<%@ include file="body-close.jsp"%>

