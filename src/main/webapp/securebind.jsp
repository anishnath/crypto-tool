<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Your Content</title>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-5">
    <h2>Your Content</h2>

    <%
        String shortcode = request.getParameter("q");
        if (shortcode != null && !shortcode.isEmpty()) {
    %>
    <p>Access Code: <%= shortcode %></p>

    <div id="spinner" class="spinner-border text-primary" role="status" style="display: none;">
        <span class="sr-only">Loading...</span>
    </div>

    <textarea id="decryptedText" class="form-control mt-3" readonly></textarea>
    <div class="modal fade" id="passwordModal" tabindex="-1" role="dialog" aria-labelledby="passwordModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="passwordModalLabel">Enter Password</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="password" id="passwordInput" class="form-control" placeholder="Enter password">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" id="confirmPasswordBtn" class="btn btn-primary">Confirm</button>
                </div>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>

        $("#decryptedText").val('Loading..');
        // Use jQuery to make an AJAX request to the servlet
        $.ajax({
            type: "GET",
            url: "pastebin", // Adjust the servlet URL accordingly
            data: {shortcode: '<%= shortcode %>'},
            success: function (response) {
                $("#decryptedText").val('Loading....');
                try {
                    var jsonResponse = JSON.parse(response);
                } catch (e) {
                    $("#decryptedText").val('The given code is expired or invalid');
                    throw new Error('Invalid response');
                }
                var jsonResponse = JSON.parse(response);
                var presignedUrl = jsonResponse.presignedUrl;
                // Check if the filename contains 'ENC'
                var fileName = presignedUrl.split('/').pop();
                if (fileName.includes('ENC')) {
                    // Open password modal
                    $('#passwordModal').modal('show');
                    $("#confirmPasswordBtn").click(function() {
                        var password = $("#passwordInput").val();
                        if (password === null || password === '') {
                            $("#decryptedText").val('Password not provided');
                            throw new Error('Password not provided');
                        }
                        // Hide the modal
                        $('#passwordModal').modal('hide');
                        fetchPresignedUrlContent(presignedUrl, password);
                    });// fetchPresignedUrlContent( presignedUrl, password);
                } else {
                    fetchPresignedUrlContentNonEncrypted(presignedUrl)
                }
            },
            error: function (error) {
                console.error("Error:", error.responseText);
                $("#decryptedText").val('The given code is expired or invalid');
            }
        });


        function fetchPresignedUrlContentNonEncrypted(presignedUrl) {
            fetch(presignedUrl)
                .then(function(response) {
                    $("#decryptedText").val('Loading......');
                    if (!response.ok) {
                        $("#decryptedText").val('Network response was not ok');
                        $("#spinner").hide();
                        throw new Error('Network response was not ok');
                    }
                    return response.arrayBuffer();
                })
                .then(function(buffer) {
                    $("#decryptedText").val('Loading........');
                    // Convert ArrayBuffer to string
                    var text = new TextDecoder().decode(buffer);
                    $("#decryptedText").val('Loading..........');
                    console.log(text)
                    $("#decryptedText").val(atob(text));
                    $("#decryptedText").prop("readonly", true);
                    // $("#decryptedText").attr("cols", decryptedText.length);
                    $("#decryptedText").attr("rows", Math.max(5, decryptedText.length / 50));
                })
                .catch(function(error) {
                    console.error('Error fetching content:', error);
                    $("#decryptedText").val('Error Loading Text');
                });
        }

        function fetchPresignedUrlContent(presignedUrl, password) {
            fetch(presignedUrl)
                .then(function(response) {
                    $("#decryptedText").val('Loading......');
                    if (!response.ok) {
                        $("#decryptedText").val('Network response was not ok');
                        $("#spinner").hide();
                        throw new Error('Network response was not ok');
                    }
                    return response.arrayBuffer();
                })
                .then(function(buffer) {
                    $("#decryptedText").val('Loading........');
                    // Convert ArrayBuffer to string
                    var encryptedText = new TextDecoder().decode(buffer);

                    // Decrypt the encrypted text
                    return decryptText(encryptedText, password);
                })
                .then(function(decryptedText) {
                    // Display the decrypted content
                    console.log("Decrypted Content:", decryptedText);
                    $("#decryptedText").val('Loading..........');
                    $("#decryptedText").val(decryptedText);
                    $("#decryptedText").prop("readonly", true);
                    // $("#decryptedText").attr("cols", decryptedText.length);
                    $("#decryptedText").attr("rows", Math.max(5, decryptedText.length / 50));
                })
                .catch(function(error) {
                    console.error('Error fetching and decrypting content:', error);
                    $("#decryptedText").val('Error decrypting content wrong password');
                });
        }

        function decryptText(encryptedText, password) {
            // Decode the base64-encoded encrypted text
            console.log(typeof (encryptedText) )
            var uint8Array = new Uint8Array(atob(encryptedText).split(',').map(Number));
            return crypto.subtle.digest('SHA-256', new TextEncoder().encode(password))
                .then(function (keyBuffer) {
                    return window.crypto.subtle.importKey(
                        'raw',
                        keyBuffer,
                        'AES-GCM',
                        true,
                        ['decrypt']
                    );
                })
                .then(function (key) {
                    // Perform decryption
                    return crypto.subtle.decrypt(
                        {name: 'AES-GCM', iv: uint8Array.slice(0,12)},
                        key,
                        uint8Array.slice(12) // Exclude the IV from the encrypted buffer
                    );
                })
                .then(function (decryptedBuffer) {
                    // Convert the decrypted ArrayBuffer to string
                    return new TextDecoder().decode(decryptedBuffer);
                })
                .catch(function (error) {
                    $("#decryptedText").val('Error decrypting text Wrong Password');
                });
        }

    </script>
    <%
    } else {
    %>
    <p>Invalid shortcode</p>
    <%
        }
    %>

</div>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

