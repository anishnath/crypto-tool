<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>View Secret | One-Time Encrypted Secret | 8gwifi.org</title>
    <meta name="robots" content="noindex, nofollow">
    <meta name="description" content="View your one-time encrypted secret. This secret will self-destruct after viewing.">

    <style>
        .min-h-decrypted { min-height: 240px; }
        @media (min-width: 992px) { .min-h-decrypted { min-height: 320px; } }
        .monospace { font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
        .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; }
        .warning-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        .pulse-warning {
            animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: .7; }
        }
        .secret-revealed {
            border: 2px solid #28a745;
            box-shadow: 0 0 20px rgba(40, 167, 69, 0.3);
        }
        #passwordModal .modal-content {
            border-radius: 12px;
            border: none;
        }
        #passwordModal .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }
        .loading-state {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 240px;
            flex-direction: column;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-5">
    <!-- Header with Trust Badges -->
    <div class="d-flex justify-content-between align-items-start flex-wrap mb-3">
        <div>
            <h1 class="mb-2"><i class="fas fa-eye"></i> View Shared Content</h1>
            <p class="lead text-muted mb-0">Secure content sharing - available for 24 hours</p>
        </div>
        <div class="mt-2">
            <span class="badge badge-warning badge-pill px-3 py-2"><i class="fas fa-clock"></i> 24-Hour Expiry</span>
            <span class="badge badge-info badge-pill px-3 py-2 ml-2"><i class="fas fa-shield-alt"></i> Secure Sharing</span>
        </div>
    </div>

    <%
        String shortcode = request.getParameter("q");
        if (shortcode != null && !shortcode.isEmpty()) {
    %>

    <!-- Info Banner -->
    <div class="alert alert-info border-info mb-4" id="infoBanner">
        <div class="d-flex align-items-start">
            <div class="mr-3" style="font-size: 2rem;">
                <i class="fas fa-info-circle"></i>
            </div>
            <div>
                <h5 class="mb-2"><strong><i class="fas fa-clock"></i> 24-Hour Access Period</strong></h5>
                <p class="mb-2">This content is available for <strong>24 hours</strong> and can be viewed multiple times within that period. It will automatically expire and be deleted after 24 hours.</p>
                <hr class="my-2" style="opacity: 0.3;">
                <div class="row small">
                    <div class="col-md-6">
                        <p class="mb-1"><i class="fas fa-shield-alt"></i> <strong>Secure:</strong> Content processed client-side when encrypted</p>
                        <p class="mb-0"><i class="fas fa-user-secret"></i> <strong>Private:</strong> No server-side logging of content</p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1"><i class="fas fa-redo"></i> <strong>Multiple Views:</strong> Access anytime within 24 hours</p>
                        <p class="mb-0"><i class="fas fa-key"></i> <strong>Password:</strong> Required for encrypted content only</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8 mb-4">
            <div class="card shadow-lg h-100" id="secretCard">
                <div class="card-header bg-white border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-file-alt text-primary"></i> <strong>Shared Content</strong></h5>
                        <span class="badge badge-secondary badge-pill">ID: <%= shortcode %></span>
                    </div>
                </div>
                <div class="card-body">
                    <div id="loadingState" class="loading-state" style="display: none;">
                        <div class="spinner-border text-primary mb-3" style="width: 3rem; height: 3rem;" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        <p class="text-muted"><strong id="loadingMessage">Fetching encrypted secret...</strong></p>
                    </div>

                    <textarea id="decryptedText" class="form-control monospace min-h-decrypted" readonly style="border-radius: 8px; border: 2px solid #dee2e6;"></textarea>

                    <div id="successBanner" class="alert alert-success mt-3" style="display: none;">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle fa-2x mr-3"></i>
                            <div>
                                <strong>Content Successfully Loaded!</strong>
                                <p class="mb-0 small">You can view this content multiple times within the 24-hour validity period. Copy or download if you need to save it permanently.</p>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div>
                            <button class="btn btn-success mr-2" type="button" onclick="copyById('decryptedText', this)" data-toggle="tooltip" title="Copy to clipboard">
                                <i class="fas fa-copy"></i> Copy Secret
                            </button>
                            <button class="btn btn-outline-secondary mr-2" type="button" onclick="toggleWrap('decryptedText', this)" data-toggle="tooltip" title="Toggle line wrap">
                                <i class="fas fa-align-left"></i> Wrap
                            </button>
                            <button class="btn btn-outline-primary" type="button" onclick="saveToFile()" data-toggle="tooltip" title="Download as text file">
                                <i class="fas fa-download"></i> Download
                            </button>
                        </div>
                        <div class="text-right">
                            <small class="text-muted d-block"><i class="fas fa-text-height"></i> <span id="charCountView" class="font-weight-bold">0</span> characters</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm sticky-side border-info mb-4">
                <div class="card-header bg-info text-white">
                    <h6 class="mb-0"><i class="fas fa-info-circle"></i> <strong>Security Tips</strong></h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0 pl-3 small">
                        <li class="mb-2"><strong>24-Hour Access:</strong> Content available for 24 hours, can be viewed multiple times.</li>
                        <li class="mb-2"><strong>Use Copy Button:</strong> Avoid taking screenshots - they can leak sensitive data.</li>
                        <li class="mb-2"><strong>Verify Sender:</strong> Make sure you trust who sent you this link.</li>
                        <li class="mb-2"><strong>Secure Device:</strong> Only decrypt on a trusted, private device.</li>
                        <li class="mb-2"><strong>Close Tab After:</strong> Clear browser history if viewing on shared device.</li>
                        <li class="mb-0"><strong>Rotate Credentials:</strong> Change passwords/keys after transfer if needed.</li>
                    </ul>
                </div>
            </div>

            <div class="card shadow-sm border-success">
                <div class="card-header bg-success text-white">
                    <h6 class="mb-0"><i class="fas fa-shield-alt"></i> <strong>How It Works</strong></h6>
                </div>
                <div class="card-body">
                    <ol class="mb-0 pl-3 small">
                        <li class="mb-2">Enter the password (sent separately by sender)</li>
                        <li class="mb-2">Content decrypts <strong>in your browser</strong> using AES-256-GCM</li>
                        <li class="mb-2">Server never sees your plaintext content</li>
                        <li class="mb-0">Content <strong>expires after 24 hours</strong> automatically</li>
                    </ol>
                    <hr class="my-2">
                    <p class="small mb-0 text-muted"><i class="fas fa-info-circle"></i> True end-to-end encryption with zero-knowledge architecture.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Password Modal -->
    <div class="modal fade" id="passwordModal" tabindex="-1" role="dialog" aria-labelledby="passwordModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="passwordModalLabel">
                        <i class="fas fa-key"></i> <strong>Password Required to Decrypt</strong>
                    </h5>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info py-2 px-3 mb-3">
                        <i class="fas fa-info-circle"></i> <strong>Security:</strong> The password was sent separately by the sender. Check your other communication channels (email, Slack, SMS, etc.).
                    </div>

                    <label for="passwordInput" class="font-weight-bold">
                        <i class="fas fa-lock"></i> Enter Decryption Password
                    </label>
                    <div class="input-group mb-3">
                        <input type="password" id="passwordInput" class="form-control form-control-lg" placeholder="Paste password here..." aria-label="Password" style="border-radius: 8px 0 0 8px; border: 2px solid #dee2e6;">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary btn-lg" type="button" onclick="toggleReveal('passwordInput', this)" data-toggle="tooltip" title="Show or hide password" style="border-radius: 0 8px 8px 0;">
                                <i class="fas fa-eye"></i> Show
                            </button>
                        </div>
                    </div>

                    <div id="passwordError" class="alert alert-danger" style="display: none;">
                        <i class="fas fa-exclamation-triangle"></i> <strong>Incorrect Password</strong> - Please try again or contact the sender.
                    </div>

                    <div class="alert alert-info py-2 px-3 mb-0 small">
                        <i class="fas fa-info-circle"></i> <strong>Note:</strong> You can view this content multiple times within the 24-hour validity period. Copy or download if needed.
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" onclick="window.location.href='securebin.jsp'">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="button" id="confirmPasswordBtn" class="btn btn-success btn-lg">
                        <i class="fas fa-unlock-alt"></i> Decrypt Secret
                    </button>
                </div>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        // Show loading state initially
        $("#loadingState").show();
        $("#decryptedText").hide();
        $("#loadingMessage").text('Fetching encrypted secret from secure storage...');

        // Use jQuery to make an AJAX request to the servlet
        $.ajax({
            type: "GET",
            url: "pastebin",
            data: {shortcode: '<%= shortcode %>'},
            success: function (response) {
                $("#loadingMessage").text('Validating secret...');
                try {
                    var jsonResponse = JSON.parse(response);
                } catch (e) {
                    $("#loadingState").hide();
                    $("#decryptedText").show();
                    $("#decryptedText").val('❌ Error: The given code is expired or invalid.\n\nThis secret may have already been viewed or has expired.\n\nPlease contact the sender for a new link.');
                    $("#decryptedText").addClass('border-danger');
                    return;
                }

                var presignedUrl = jsonResponse.presignedUrl;
                var fileName = presignedUrl.split('/').pop();

                if (fileName.includes('ENC')) {
                    // Show password modal for encrypted secrets
                    $("#loadingState").hide();
                    $('#passwordModal').modal('show');

                    // Handle password submission
                    $("#confirmPasswordBtn").off('click').on('click', function() {
                        var password = $("#passwordInput").val();
                        if (!password || password.trim() === '') {
                            $("#passwordError").show().html('<i class="fas fa-exclamation-triangle"></i> <strong>Password Required</strong> - Please enter the password to decrypt the secret.');
                            return;
                        }
                        $("#passwordError").hide();
                        $('#passwordModal').modal('hide');
                        $("#loadingState").show();
                        $("#loadingMessage").text('Decrypting secret with AES-256-GCM...');
                        fetchPresignedUrlContent(presignedUrl, password);
                    });

                    // Allow Enter key to submit
                    $("#passwordInput").off('keypress').on('keypress', function(e) {
                        if (e.which === 13) {
                            $("#confirmPasswordBtn").click();
                        }
                    });
                } else {
                    $("#loadingMessage").text('Loading secret content...');
                    fetchPresignedUrlContentNonEncrypted(presignedUrl);
                }
            },
            error: function (error) {
                console.error("Error:", error.responseText);
                $("#loadingState").hide();
                $("#decryptedText").show();
                $("#decryptedText").val('❌ Error: The given code is expired or invalid.\n\nThis secret may have already been viewed or has expired.\n\nPlease contact the sender for a new link.');
                $("#decryptedText").addClass('border-danger');
            }
        });


        function fetchPresignedUrlContentNonEncrypted(presignedUrl) {
            fetch(presignedUrl)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.arrayBuffer();
                })
                .then(function(buffer) {
                    // Convert ArrayBuffer to string
                    var text = new TextDecoder().decode(buffer);
                    var decryptedContent = atob(text);

                    // Hide loading, show success
                    $("#loadingState").hide();
                    $("#decryptedText").show().val(decryptedContent);
                    $("#decryptedText").addClass('secret-revealed');
                    $("#successBanner").slideDown();
                    $("#infoBanner").slideUp();
                    $("#secretCard").addClass('border-success');

                    // Auto-resize textarea
                    var lines = decryptedContent.split('\n').length;
                    $("#decryptedText").attr("rows", Math.max(10, Math.min(lines + 2, 25)));
                })
                .catch(function(error) {
                    console.error('Error fetching content:', error);
                    $("#loadingState").hide();
                    $("#decryptedText").show();
                    $("#decryptedText").val('❌ Error Loading Secret\n\nUnable to retrieve the secret from secure storage.\n\nPlease try again or contact the sender.');
                    $("#decryptedText").addClass('border-danger');
                });
        }

        function fetchPresignedUrlContent(presignedUrl, password) {
            fetch(presignedUrl)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.arrayBuffer();
                })
                .then(function(buffer) {
                    $("#loadingMessage").text('Decrypting with AES-256-GCM...');
                    var encryptedText = new TextDecoder().decode(buffer);
                    return decryptText(encryptedText, password);
                })
                .then(function(decryptedText) {
                    console.log("✅ Decryption successful");

                    // Hide loading, show success
                    $("#loadingState").hide();
                    $("#decryptedText").show().val(decryptedText);
                    $("#decryptedText").addClass('secret-revealed');
                    $("#successBanner").slideDown();
                    $("#infoBanner").slideUp();
                    $("#secretCard").addClass('border-success');

                    // Auto-resize textarea
                    var lines = decryptedText.split('\n').length;
                    $("#decryptedText").attr("rows", Math.max(10, Math.min(lines + 2, 25)));
                })
                .catch(function(error) {
                    console.error('Error decrypting content:', error);
                    $("#loadingState").hide();
                    $("#decryptedText").show();
                    $("#decryptedText").val('❌ Decryption Failed - Incorrect Password\n\nThe password you entered is incorrect.\n\nPlease check:\n• Password was copied correctly (watch for extra spaces)\n• You have the password from the sender\n• The secret has not expired\n\nContact the sender for the correct password or a new link.');
                    $("#decryptedText").addClass('border-danger');
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
            btn.innerHTML = success === false ? '<i class="fas fa-times"></i> Failed' : '<i class="fas fa-check"></i> Copied!';
            btn.classList.add(success === false ? 'btn-danger' : 'btn-success');
            btn.classList.remove('btn-outline-primary', 'btn-outline-secondary');
            setTimeout(function(){
                btn.disabled = false;
                btn.innerHTML = original;
                btn.classList.remove('btn-danger', 'btn-success');
                if (original.includes('Copy')) {
                    btn.classList.add('btn-success');
                } else {
                    btn.classList.add('btn-outline-secondary');
                }
            }, 1500);
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
            if (el.type === 'password') {
                el.type = 'text';
                if (btn) btn.innerHTML = '<i class="fas fa-eye-slash"></i> Hide';
            } else {
                el.type = 'password';
                if (btn) btn.innerHTML = '<i class="fas fa-eye"></i> Show';
            }
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
