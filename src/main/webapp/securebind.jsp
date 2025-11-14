<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Your Content</title>
    <style>
        .min-h-decrypted { min-height: 240px; }
        @media (min-width: 992px) { .min-h-decrypted { min-height: 320px; } }
        .monospace { font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
        .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-5">
    <h1 class="mb-4">View Secret</h1>

    <%
        String shortcode = request.getParameter("q");
        if (shortcode != null && !shortcode.isEmpty()) {
    %>

    <div class="row">
        <div class="col-lg-8 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="card-title mb-0">Decrypted Content</h5>
                        <span class="badge badge-secondary">Code: <%= shortcode %></span>
                    </div>
                    <div id="spinner" class="spinner-border text-primary mb-3" role="status" style="display: none;">
                        <span class="sr-only">Loading...</span>
                    </div>
                    <textarea id="decryptedText" class="form-control monospace min-h-decrypted" readonly></textarea>
                    <div class="d-flex justify-content-between align-items-center mt-2">
                        <div>
                            <button class="btn btn-sm btn-outline-primary mr-2" type="button" onclick="copyById('decryptedText', this)" data-toggle="tooltip" title="Copy content">📋 Copy</button>
                            <button class="btn btn-sm btn-outline-secondary mr-2" type="button" onclick="toggleWrap('decryptedText', this)" data-toggle="tooltip" title="Toggle line wrap">↩ Wrap</button>
                            <button class="btn btn-sm btn-outline-secondary" type="button" onclick="saveToFile()" data-toggle="tooltip" title="Download as file">⬇ Download</button>
                        </div>
                        <small class="text-muted"><span id="charCountView">0</span> chars</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow-sm sticky-side">
                <div class="card-body">
                    <h6 class="card-title">Tips</h6>
                    <ul class="mb-0 pl-3">
                        <li>Keep the password separate from this link.</li>
                        <li>Content is read‑only and stays local once decrypted.</li>
                        <li>Use Copy to share safely; avoid screenshots.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

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
                    <div class="input-group input-group-sm">
                        <input type="password" id="passwordInput" class="form-control" placeholder="Enter password" aria-label="Password">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" onclick="toggleReveal('passwordInput', this)" data-toggle="tooltip" title="Show or hide password">👁 Show</button>
                        </div>
                    </div>
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
    <script>
        // UI helpers (no changes to decrypt/fetch logic)
        (function(){
            if (window.jQuery && typeof $ === 'function') {
                $(function(){
                    $('[data-toggle="tooltip"]').tooltip();
                    // live char counter; handles programmatic updates
                    setInterval(function(){
                        var ta = document.getElementById('decryptedText');
                        var cc = document.getElementById('charCountView');
                        if (ta && cc) cc.textContent = (ta.value || '').length;
                    }, 600);
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

        function toggleWrap(id, btn) {
            var el = document.getElementById(id);
            if (!el) return;
            var current = el.style.whiteSpace;
            if (current === 'pre-wrap' || current === '') {
                el.style.whiteSpace = 'pre';
                if (btn) btn.innerHTML = '↩ Wrap';
            } else {
                el.style.whiteSpace = 'pre-wrap';
                if (btn) btn.innerHTML = '⤶ No Wrap';
            }
        }

        function toggleReveal(id, btn) {
            var el = document.getElementById(id);
            if (!el) return;
            if (el.type === 'password') { el.type = 'text'; if (btn) btn.innerHTML = '🙈 Hide'; }
            else { el.type = 'password'; if (btn) btn.innerHTML = '👁 Show'; }
        }

        function saveToFile() {
            var el = document.getElementById('decryptedText');
            var text = el ? (el.value || '') : '';
            var blob = new Blob([text], { type: 'text/plain;charset=utf-8' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = 'secret.txt';
            document.body.appendChild(a);
            a.click();
            setTimeout(function(){ document.body.removeChild(a); URL.revokeObjectURL(url); }, 0);
        }
    </script>
    <%
    } else {
    %>
    <div class="alert alert-warning">Invalid shortcode</div>
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
