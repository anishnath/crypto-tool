<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Share secrets with zero Trust</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="keywords" content="Share a one-time secret. With this tool you can transmit passwords, credit card information, private keys or other sensitive data in a secure way: End-to-end encrypted">
    <meta property="description" content="Share a one-time secret. With this tool you can transmit passwords, credit card information, private keys or other sensitive data in a secure way: End-to-end encrypted">
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Share secrets with zero Trust",
            "description": "transfer share send file securely online, end-2-end encryption, Send and receive any type of file over the internet securely",
            "url": "https://8gwifi.org/securebin.jsp",
            "image" : "https://8gwifi.org/images/site/securebin.png",
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

<div class="container mt-5">
    <h4>Share Encrypted text</h4>
    <p>Welcome to our secure sharing platform! With our tool, you can securely share sensitive information with others.Your secret will be encrypted for added security. Once created, you'll receive a unique URL and password. Share this URL with your intended recipient, who can then access the secret securely. With end-to-end encryption and a user-friendly interface, sharing secrets has never been easier!</p>
    <form id="uploadForm">
        <div class="form-group">
            <label for="email">Email:</label>
            <textarea class="form-control"  id="email" rows="1" placeholder="Enter email"></textarea>
            <small>Will Email the link to the recipient Note: password will not email as this is End-2-End Encryption Complete Zero trust</small>
        </div>

        <div class="form-group">
            <label for="textData">Secret Content:</label>
            <textarea class="form-control" id="textData" rows="4" placeholder="Enter text content"></textarea>
        </div>
        <button type="button" class="btn btn-primary" onclick="createPresignedURL()">Share It!!</button>
    </form>

    <br>

    <div class="progress">
        <div id="uploadProgressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
    </div>


    <!-- Table container -->
    <div id="tableContainer"></div>

</div>


<script>

    function encryptText(text, password) {
        var iv = crypto.getRandomValues(new Uint8Array(12));
        return crypto.subtle.digest('SHA-256', new TextEncoder().encode(password))
            .then(function (keyBuffer) {
                return window.crypto.subtle.importKey(
                    'raw',
                    keyBuffer,
                    'AES-GCM',
                    true,
                    ['encrypt' , 'decrypt']
                );
            })
            .then(function (key) {
                console.log("Key: ", key);
                return crypto.subtle.encrypt(
                    {name: 'AES-GCM', iv: iv},
                    key,
                    new TextEncoder().encode(text)
                );
            })
            .then(function (encryptedBuffer) {
                var combinedBuffer = new Uint8Array(iv.length + encryptedBuffer.byteLength);
                combinedBuffer.set(iv, 0); // Set IV at the beginning
                combinedBuffer.set(new Uint8Array(encryptedBuffer), iv.length); // Set encrypted text after IV
                return combinedBuffer;
            });
    }

    function generateStrongPassword(length) {
        var charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+";
        var password = "";
        for (var i = 0; i < length; i++) {
            var randomIndex = Math.floor(Math.random() * charset.length);
            password += charset[randomIndex];
        }
        return password;
    }

    function createPresignedURL() {
        // Get values from the form
        var email = document.getElementById("email").value;
        var textData = document.getElementById("textData").value;
        var isEncrypted = true
        var password = generateStrongPassword(12)
        // Convert textData to Base58 format

        // Encrypt textDataBase58 using AES encryption
        if (isEncrypted) {
            encryptText(textData, password)
                .then(function (encryptedText) {
                    // Make AJAX call to the servlet using jQuery
                    console.log("Encrypted Text: " + encryptedText);
                    var textDataBase64 = btoa(encryptedText);
                    console.log("Encrypted Text (Base64): " + textDataBase64);
                    var myblob = new Blob([textDataBase64], {
                        type: 'text/plain'
                    });
                    $.ajax({
                        type: "POST",
                        url: "pastebin", // Replace with the actual servlet URL
                        data: {email: email,  isEncrypted: isEncrypted},
                        success: function (response) {
                            // Handle the response here
                            var jsonResponse = JSON.parse(response);
                            var presignedUrl = jsonResponse.presignedUrl;
                            var fileName = jsonResponse.fileName;
                            var shortCode = jsonResponse.shortCode;

                            // Use presignedUrl and fileName to upload the file to S3
                            // You can implement the file upload logic here
                            myblob.name = fileName;

                            // Upload to S3
                            uploadToS3(presignedUrl, myblob)
                                .then(function () {


                                    var table = document.createElement("table");
                                    table.classList.add("table", "table-bordered");

                                    // Create table body
                                    var tbody = document.createElement("tbody");

                                    // Create table row for URL
                                    var urlRow = document.createElement("tr");
                                    var urlCell1 = document.createElement("th");
                                    urlCell1.scope = "row";
                                    urlCell1.textContent = "Secret View URL:";
                                    var urlCell2 = document.createElement("td");
                                    var urlLink = document.createElement("a");
                                    // urlLink.href = "securebind.jsp?q=" + shortCode;
                                    urlLink.href = window.location.origin + "/securebind.jsp?q=" + shortCode;
                                    urlLink.target = "_blank";
                                    // urlLink.textContent = "securebind.jsp?q=" + shortCode;
                                    urlLink.textContent = window.location.origin + "/securebind.jsp?q=" + shortCode;
                                    urlCell2.appendChild(urlLink);
                                    urlRow.appendChild(urlCell1);
                                    urlRow.appendChild(urlCell2);
                                    tbody.appendChild(urlRow);


                                    var passwordRow = document.createElement("tr");
                                    var passwordCell1 = document.createElement("th");
                                    passwordCell1.scope = "row";
                                    passwordCell1.textContent = "Password:";
                                    var passwordCell2 = document.createElement("td");
                                    var codeElement = document.createElement("code");
                                    codeElement.textContent = password;
                                    passwordCell2.appendChild(codeElement);
                                    passwordRow.appendChild(passwordCell1);
                                    passwordRow.appendChild(passwordCell2);
                                    tbody.appendChild(passwordRow);

                                    // Create table row for additional information
                                    var infoRow = document.createElement("tr");
                                    var infoCell1 = document.createElement("th");
                                    infoCell1.scope = "row";
                                    infoCell1.textContent = "Information:";
                                    var infoCell2 = document.createElement("td");
                                    infoCell2.textContent = "This link will remain active for a limited time and can only be accessed with the provided password."; // Additional information
                                    infoRow.appendChild(infoCell1);
                                    infoRow.appendChild(infoCell2);
                                    tbody.appendChild(infoRow);

                                    // Append table body to table
                                    table.appendChild(tbody);

                                    // Append table to the tableContainer
                                    var tableContainer = document.getElementById("tableContainer");
                                    tableContainer.innerHTML = ""; // Clear previous content
                                    tableContainer.appendChild(table);

                                    sendEmail(email, shortCode);

                                })
                                .catch(function (error) {
                                    console.error("Upload error:", error);
                                });
                        },
                        error: function (error) {
                            console.error("Error:", error);
                        }
                    });
                })
                .catch(function (error) {
                    console.error("Encryption Error:", error);
                });
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


    function updateProgressBar(percent) {
        const progressBar = document.getElementById('uploadProgressBar');
        progressBar.style.width = percent + '%';
        progressBar.setAttribute('aria-valuenow', percent);
        progressBar.textContent = percent + '%';
    }

   async function sendEmail(email, shortcode) {
        // Create an object with the email and shortcode data
        var data = {
            email: email,
            sendEmail: true,
            shortcode: shortcode
        };

        // Make an AJAX POST request to the server-side script that handles email sending
        $.ajax({
            type: "POST",
            url: "pastebin",
            data: data,
            success: function(response) {
                // Handle success response
                console.log("Email sent successfully");
            },
            error: function(xhr, status, error) {
                // Handle error response
                console.error("Error sending email:", status, error);
            }
        });
    }

</script>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
