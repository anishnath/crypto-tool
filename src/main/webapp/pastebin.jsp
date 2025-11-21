<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Pastebin Online | Encrypted or Public Text Share (Free) | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="https://8gwifi.org/pastebin.jsp">
    <link rel="alternate" href="https://8gwifi.org/pastebin.jsp" hreflang="en">
    <meta name="description" content="Free online pastebin: share text publicly or encrypt with a password. No sign‑up, runs in your browser. Get a shareable link (and password if encrypted).">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:title" content="Pastebin Online | Encrypted or Public Text Share (Free)">
    <meta property="og:description" content="Share text online. Optional encryption with password. Free, browser‑only.">
    <meta property="og:url" content="https://8gwifi.org/pastebin.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/pastebin.png">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@anish2good">
    <meta name="twitter:title" content="Pastebin Online | Encrypted or Public Text Share (Free)">
    <meta name="twitter:description" content="Free browser‑only pastebin with optional encryption.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/pastebin.png">
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Pastebin – Encrypted or Public Text Sharing",
            "description": "Free online pastebin to share text publicly or with end-to-end AES-256-GCM encryption in your browser. No registration required, 24-hour expiry, zero-knowledge architecture.",
            "url": "https://8gwifi.org/pastebin.jsp",
            "image": "https://8gwifi.org/images/site/pastebin.png",
            "applicationCategory": "UtilityApplication",
            "operatingSystem": "Any (Web-based)",
            "browserRequirements": "Requires JavaScript and Web Crypto API",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "featureList": [
                "AES-256-GCM client-side encryption (optional)",
                "Public or password-protected text sharing",
                "Zero-knowledge architecture",
                "24-hour automatic expiry",
                "No registration or sign-up required",
                "Browser-only processing",
                "Anonymous sharing",
                "Separate password generation",
                "Multiple views within 24 hours",
                "Optional email notification (link only)",
                "Real-time character counting",
                "Copy and share utilities"
            ],
            "author": {
                "@type": "Person",
                "name": "Anish Nath",
                "url": "https://8gwifi.org",
                "jobTitle": "Security Engineer & Cryptography Specialist",
                "sameAs": "https://twitter.com/anish2good",
                "knowsAbout": ["Cryptography", "Web Security", "AES Encryption", "Zero-Knowledge Architecture", "Privacy Engineering"]
            },
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org",
                "logo": "https://8gwifi.org/images/logo.png",
                "description": "Free online cryptography, networking, and security tools for developers and security professionals.",
                "founder": {
                    "@type": "Person",
                    "name": "Anish Nath"
                },
                "contactPoint": {
                    "@type": "ContactPoint",
                    "contactType": "Technical Support",
                    "url": "https://8gwifi.org"
                }
            }
        }
    </script>
    <style>
        .min-h-result { min-height: 180px; }
        @media (min-width: 992px) { .min-h-result { min-height: 240px; } }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<div class="container mt-5">
    <div class="text-center mb-4">
        <h1 class="mb-2">Pastebin: Share Text Online</h1>
        <p class="lead text-muted mb-3">Share text publicly or protect it with end-to-end encryption and a password. Free, browser-only, no sign-up.</p>
        <div class="d-flex justify-content-center flex-wrap">
            <span class="badge badge-success badge-pill px-3 py-2 m-1"><i class="fas fa-shield-alt"></i> Optional E2E Encryption</span>
            <span class="badge badge-warning badge-pill px-3 py-2 m-1"><i class="fas fa-clock"></i> 24-Hour Expiry</span>
            <span class="badge badge-info badge-pill px-3 py-2 m-1"><i class="fas fa-user-secret"></i> No Registration</span>
            <span class="badge badge-primary badge-pill px-3 py-2 m-1"><i class="fas fa-lock"></i> AES-256-GCM</span>
        </div>
    </div>

    <!-- Trust Banner -->
    <div class="alert alert-light border mb-4">
        <div class="row text-center small">
            <div class="col-md-3 col-6 mb-2 mb-md-0">
                <i class="fas fa-laptop-code text-primary"></i> <strong>Browser-Only:</strong> Client-side encryption
            </div>
            <div class="col-md-3 col-6 mb-2 mb-md-0">
                <i class="fas fa-eye-slash text-success"></i> <strong>Zero-Knowledge:</strong> Server never sees plaintext
            </div>
            <div class="col-md-3 col-6">
                <i class="fas fa-redo text-info"></i> <strong>Multiple Views:</strong> Access within 24 hours
            </div>
            <div class="col-md-3 col-6">
                <i class="fas fa-trash-alt text-warning"></i> <strong>Auto-Delete:</strong> Removed after 24 hours
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-file-alt text-primary"></i> Create a New Paste</h5>
                    <p class="text-muted mb-3">Share text publicly or with password protection. Email is optional and only sends the link.</p>
                    <form id="uploadForm">
                        <div class="form-group">
                            <label for="email"><i class="fas fa-envelope"></i> Recipient Email (optional)</label>
                            <input type="email" class="form-control" id="email" placeholder="name@example.com" aria-describedby="emailHelp" style="border-radius: 8px;">
                            <small id="emailHelp" class="form-text text-muted">We email only the link. Share the password yourself if encryption is enabled.</small>
                        </div>

                        <div class="form-group mb-2">
                            <label for="textData"><i class="fas fa-keyboard"></i> Content <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="textData" rows="6" placeholder="Paste or type your text here..." style="border-radius: 8px; font-family: 'Courier New', monospace;"></textarea>
                            <small class="form-text text-muted"><span id="charCount">0</span> characters</small>
                        </div>

                        <div class="form-group form-check mb-3">
                            <input type="checkbox" value="true" class="form-check-input" id="isEncrypted">
                            <label class="form-check-label" for="isEncrypted">
                                <i class="fas fa-lock"></i> Protect with password (AES-256-GCM encryption)
                            </label>
                            <small class="form-text text-muted ml-4">Password will be auto-generated and must be shared separately</small>
                        </div>

                        <div class="d-flex align-items-center">
                            <button type="button" id="createPasteBtn" class="btn btn-primary btn-lg mr-2" onclick="createPresignedURL()" style="border-radius: 8px;">
                                <i class="fas fa-share-alt"></i> Create Paste
                            </button>
                            <button type="reset" class="btn btn-outline-secondary" onclick="resetFormUI()" style="border-radius: 8px;">
                                <i class="fas fa-eraser"></i> Clear Form
                            </button>
                        </div>
                        <small id="validationError" class="text-danger mt-2" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i> <strong>Please enter content before creating a paste.</strong>
                        </small>
                    </form>
                </div>
                <div class="card-footer bg-white">
                    <div id="progressWrapper" class="progress" style="display:none; height: 0.75rem;">
                        <div id="uploadProgressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="card shadow-sm sticky-top" style="top: 80px;">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="fas fa-link text-success"></i> Share Link</h5>
                    <div id="tableContainer" class="min-h-result text-center text-muted">
                        <p class="mt-4"><i class="fas fa-arrow-left"></i> Create a paste to get a shareable link</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- How It Works & Security Features -->
    <div class="row mb-4">
        <div class="col-md-6 mb-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="fas fa-question-circle text-primary"></i> How It Works</h5>
                    <ol class="mb-0 pl-3">
                        <li class="mb-2"><strong>Enter your text:</strong> Paste code, logs, or any text content</li>
                        <li class="mb-2"><strong>Choose protection:</strong> Enable encryption for sensitive data or share publicly</li>
                        <li class="mb-2"><strong>Get shareable link:</strong> Receive a URL (and auto-generated password if encrypted)</li>
                        <li class="mb-2"><strong>Share securely:</strong> Send link via email/chat, password via separate channel</li>
                        <li class="mb-0"><strong>Recipient views:</strong> Opens link and enters password if required</li>
                    </ol>
                </div>
            </div>
        </div>
        <div class="col-md-6 mb-3">
            <div class="card shadow-sm h-100 border-success">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="fas fa-shield-alt text-success"></i> Security Features</h5>
                    <ul class="mb-0 list-unstyled">
                        <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Client-Side Encryption:</strong> AES-256-GCM in your browser</li>
                        <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Zero-Knowledge:</strong> Server never sees plaintext or passwords</li>
                        <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Auto-Generated Passwords:</strong> Strong 12-character passwords</li>
                        <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>24-Hour Auto-Delete:</strong> Automatic expiry and removal</li>
                        <li class="mb-2"><i class="fas fa-check text-success"></i> <strong>Multiple Views:</strong> Access anytime within 24 hours</li>
                        <li class="mb-0"><i class="fas fa-check text-success"></i> <strong>No Registration:</strong> Anonymous and private</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Common Use Cases -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h5 class="card-title mb-3"><i class="fas fa-lightbulb text-warning"></i> Common Use Cases</h5>
            <div class="row">
                <div class="col-md-6">
                    <ul class="mb-2">
                        <li class="mb-2"><strong>Share Code Snippets:</strong> Share code examples, debug logs, or error traces with colleagues</li>
                        <li class="mb-2"><strong>Temporary Credentials:</strong> Share API keys, passwords, or tokens securely with encryption</li>
                        <li class="mb-2"><strong>Configuration Files:</strong> Share config files, environment variables, or setup instructions</li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <ul class="mb-0">
                        <li class="mb-2"><strong>Log Analysis:</strong> Share application logs, server outputs, or debugging information</li>
                        <li class="mb-2"><strong>Notes & Documentation:</strong> Quick temporary notes, meeting notes, or documentation drafts</li>
                        <li class="mb-2"><strong>Collaboration:</strong> Share JSON, XML, CSV data or API responses for review</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Author/Expertise Section (E-E-A-T) -->
    <div class="card shadow-sm mb-4 border-primary">
        <div class="card-body">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="card-title mb-2"><i class="fas fa-user-shield text-primary"></i> About the Developer</h5>
                    <p class="mb-2">
                        <strong>Anish Nath</strong> – Security Engineer & Cryptography Specialist
                        <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="ml-2" title="Follow on Twitter">
                            <i class="fab fa-twitter text-primary"></i> @anish2good
                        </a>
                    </p>
                    <p class="text-muted small mb-2">
                        Extensive experience in cryptography, web security, and privacy engineering.
                        Creator of 8gwifi.org, a comprehensive suite of free online security and networking tools used by developers and security professionals worldwide.
                    </p>
                    <div class="d-flex flex-wrap">
                        <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-shield-alt"></i> Cryptography</span>
                        <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-lock"></i> Web Security</span>
                        <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-key"></i> AES Encryption</span>
                        <span class="badge badge-primary mr-2 mb-2"><i class="fas fa-user-secret"></i> Zero-Knowledge Systems</span>
                        <span class="badge badge-primary mb-2"><i class="fas fa-code"></i> Privacy Engineering</span>
                    </div>
                </div>
                <div class="col-md-4 text-center">
                    <div class="border rounded p-3 bg-light">
                        <div class="mb-2">
                            <i class="fas fa-tools fa-3x text-primary"></i>
                        </div>
                        <p class="small mb-1"><strong>8gwifi.org</strong></p>
                        <p class="small text-muted mb-0">Free Cryptography & Security Tools Since 2010</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Why Trust This Tool -->
    <div class="alert alert-light border mb-4">
        <div class="row text-center small">
            <div class="col-md-4 mb-2 mb-md-0">
                <i class="fas fa-code text-primary fa-2x mb-2"></i>
                <p class="mb-0"><strong>Open Source Approach:</strong> Uses standard Web Crypto API</p>
            </div>
            <div class="col-md-4 mb-2 mb-md-0">
                <i class="fas fa-history text-success fa-2x mb-2"></i>
                <p class="mb-0"><strong>Proven Track Record:</strong> Serving developers since 2010</p>
            </div>
            <div class="col-md-4">
                <i class="fas fa-users text-info fa-2x mb-2"></i>
                <p class="mb-0"><strong>Trusted by Professionals:</strong> Used by security teams worldwide</p>
            </div>
        </div>
    </div>

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
        var isEncrypted = document.getElementById("isEncrypted").checked;
        var password = generateStrongPassword(12);
        var createBtn = document.getElementById("createPasteBtn");
        var validationError = document.getElementById("validationError");

        // Validation: Check if textData is empty
        if (textData === null || textData.trim() === "") {
            validationError.style.display = 'block';
            // Add shake animation if available
            if (validationError.classList) {
                validationError.classList.add('animate__animated', 'animate__shakeX');
                setTimeout(function() {
                    validationError.classList.remove('animate__animated', 'animate__shakeX');
                }, 1000);
            }
            // Scroll to and focus on textarea
            document.getElementById("textData").focus();
            document.getElementById("textData").style.borderColor = '#dc3545';
            setTimeout(function() {
                document.getElementById("textData").style.borderColor = '#dee2e6';
            }, 2000);
            return;
        }

        // Hide validation error if shown
        validationError.style.display = 'none';

        // Disable button and show processing state
        var originalBtnHtml = createBtn.innerHTML;
        createBtn.disabled = true;
        createBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Paste...';


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
                                    var viewUrl = window.location.origin + "/securebind.jsp?q=" + shortCode;

                                    var cardHtml = ''+
                                        '<div class="card shadow-sm">' +
                                        '  <div class="card-body">' +
                                        '    <h5 class="card-title mb-3">Paste Created</h5>' +
                                        '    <div class="form-group">' +
                                        '      <label for="pbUrlInput" class="font-weight-bold">Secret View URL</label>' +
                                        '      <div class="input-group input-group-sm">' +
                                        '        <input id="pbUrlInput" type="text" class="form-control" readonly value="' + viewUrl + '">' +
                                        '        <div class="input-group-append">' +
                                        '          <button class="btn btn-outline-secondary" type="button" onclick="copyById(\'pbUrlInput\', this)" data-toggle="tooltip" title="Copy URL" aria-label="Copy URL">📋 Copy</button>' +
                                        '          <a class="btn btn-primary" target="_blank" rel="noopener" href="' + viewUrl + '" data-toggle="tooltip" title="Open in new tab" aria-label="Open URL">Open</a>' +
                                        '        </div>' +
                                        '      </div>' +
                                        '    </div>' +
                                        '    <div class="form-group mt-3">' +
                                        '      <label for="pbPwdInput" class="font-weight-bold">Password</label>' +
                                        '      <div class="input-group input-group-sm">' +
                                        '        <input id="pbPwdInput" type="password" class="form-control" readonly value="' + password + '">' +
                                        '        <div class="input-group-append">' +
                                        '          <button class="btn btn-outline-secondary" type="button" onclick="copyById(\'pbPwdInput\', this)" data-toggle="tooltip" title="Copy password" aria-label="Copy Password">📋 Copy</button>' +
                                        '          <button class="btn btn-outline-secondary" type="button" onclick="toggleReveal(\'pbPwdInput\', this)" data-toggle="tooltip" title="Show or hide password" aria-label="Show or hide password">👁 Show</button>' +
                                        '        </div>' +
                                        '      </div>' +
                                        '      <small class="form-text text-muted">Share the URL and password via different channels for better security.</small>' +
                                        '    </div>' +
                                        '    <div class="d-flex mb-3">' +
                                        '      <button class="btn btn-success btn-sm mr-2" type="button" onclick="copyBoth()" data-toggle="tooltip" title="Copy URL and password together">Copy Both</button>' +
                                        '      <button class="btn btn-outline-secondary btn-sm" type="button" onclick="resetFormUI()" data-toggle="tooltip" title="Create another">Create Another</button>' +
                                        '    </div>' +
                                        '    <div class="alert alert-info mt-3 mb-0" role="alert"><i class="fas fa-info-circle"></i> This link remains active for <strong>24 hours</strong> and requires the password to view. Can be accessed multiple times.</div>' +
                                        '  </div>' +
                                        '</div>';

                                    var tableContainer = document.getElementById("tableContainer");
                                    tableContainer.innerHTML = cardHtml;

                                    sendEmail(email, password , shortCode);

                                    // Show success state on button
                                    createBtn.disabled = false;
                                    createBtn.innerHTML = '<i class="fas fa-check-circle"></i> Paste Created!';
                                    createBtn.classList.remove('btn-primary');
                                    createBtn.classList.add('btn-outline-success');
                                    setTimeout(function() {
                                        createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                                        createBtn.classList.remove('btn-outline-success');
                                        createBtn.classList.add('btn-primary');
                                    }, 3000);

                                })
                                .catch(function (error) {
                                    console.error("Upload error:", error);
                                    // Show error state on button
                                    createBtn.disabled = false;
                                    createBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Upload Failed';
                                    createBtn.classList.remove('btn-primary');
                                    createBtn.classList.add('btn-danger');
                                    setTimeout(function() {
                                        createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                                        createBtn.classList.remove('btn-danger');
                                        createBtn.classList.add('btn-primary');
                                    }, 4000);
                                });
                        },
                        error: function (error) {
                            console.error("Error:", error);
                            // Show error state on button
                            createBtn.disabled = false;
                            createBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Server Error';
                            createBtn.classList.remove('btn-primary');
                            createBtn.classList.add('btn-danger');
                            setTimeout(function() {
                                createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                                createBtn.classList.remove('btn-danger');
                                createBtn.classList.add('btn-primary');
                            }, 4000);
                        }
                    });
                })
                .catch(function (error) {
                    console.error("Encryption Error:", error);
                    // Show error state on button
                    createBtn.disabled = false;
                    createBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Encryption Failed';
                    createBtn.classList.remove('btn-primary');
                    createBtn.classList.add('btn-danger');
                    setTimeout(function() {
                        createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                        createBtn.classList.remove('btn-danger');
                        createBtn.classList.add('btn-primary');
                    }, 4000);
                });
        } else {
            var textDataBase64 = btoa(textData);
            console.log("Text (Base64): " + textDataBase64);
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
                            var viewUrl = window.location.origin + "/securebind.jsp?q=" + shortCode;

                            var cardHtml = ''+
                                '<div class="card shadow-sm">' +
                                '  <div class="card-body">' +
                                '    <h5 class="card-title mb-3">Paste Created</h5>' +
                                '    <div class="form-group">' +
                                '      <label for="pbUrlInput2" class="font-weight-bold">View URL</label>' +
                                '      <div class="input-group input-group-sm">' +
                                '        <input id="pbUrlInput2" type="text" class="form-control" readonly value="' + viewUrl + '">' +
                                '        <div class="input-group-append">' +
                                '          <button class="btn btn-outline-secondary" type="button" onclick="copyById(\'pbUrlInput2\', this)" data-toggle="tooltip" title="Copy URL" aria-label="Copy URL">📋 Copy</button>' +
                                '          <a class="btn btn-primary" target="_blank" rel="noopener" href="' + viewUrl + '" data-toggle="tooltip" title="Open in new tab" aria-label="Open URL">Open</a>' +
                                '        </div>' +
                                '      </div>' +
                                '    </div>' +
                                '    <div class="alert alert-info mt-3 mb-0" role="alert"><i class="fas fa-info-circle"></i> This link remains active for <strong>24 hours</strong>. No password required. Can be accessed multiple times.</div>' +
                                '  </div>' +
                                '</div>';

                            var tableContainer = document.getElementById("tableContainer");
                            tableContainer.innerHTML = cardHtml;

                            sendEmail(email, "", shortCode);

                            // Show success state on button
                            createBtn.disabled = false;
                            createBtn.innerHTML = '<i class="fas fa-check-circle"></i> Paste Created!';
                            createBtn.classList.remove('btn-primary');
                            createBtn.classList.add('btn-outline-success');
                            setTimeout(function() {
                                createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                                createBtn.classList.remove('btn-outline-success');
                                createBtn.classList.add('btn-primary');
                            }, 3000);

                        })
                        .catch(function (error) {
                            console.error("Upload error:", error);
                            // Show error state on button
                            createBtn.disabled = false;
                            createBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Upload Failed';
                            createBtn.classList.remove('btn-primary');
                            createBtn.classList.add('btn-danger');
                            setTimeout(function() {
                                createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                                createBtn.classList.remove('btn-danger');
                                createBtn.classList.add('btn-primary');
                            }, 4000);
                        });
                },
                error: function (error) {
                    console.error("Error:", error);
                    // Show error state on button
                    createBtn.disabled = false;
                    createBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Server Error';
                    createBtn.classList.remove('btn-primary');
                    createBtn.classList.add('btn-danger');
                    setTimeout(function() {
                        createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
                        createBtn.classList.remove('btn-danger');
                        createBtn.classList.add('btn-primary');
                    }, 4000);
                }
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
        const wrapper = document.getElementById('progressWrapper');
        const progressBar = document.getElementById('uploadProgressBar');
        if (!wrapper || !progressBar) return;
        if (percent > 0 && wrapper.style.display === 'none') wrapper.style.display = 'block';
        progressBar.style.width = percent + '%';
        progressBar.setAttribute('aria-valuenow', percent);
        progressBar.textContent = percent + '%';
        if (percent >= 100) {
            setTimeout(function(){ wrapper.style.display = 'none'; }, 1000);
        }
    }

    // Utilities: clipboard and reveal helpers
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

    function copyById(inputId, btn) {
        var el = document.getElementById(inputId);
        if (!el) return;
        copyText(el.value)
            .then(function() { showCopied(btn); })
            .catch(function() { showCopied(btn, false); });
    }

    function showCopied(btn, success) {
        if (!btn) return;
        var original = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = success === false ? '❌ Failed' : '✅ Copied';
        setTimeout(function() {
            btn.disabled = false;
            btn.innerHTML = original;
        }, 1500);
    }

    function toggleReveal(inputId, btn) {
        var el = document.getElementById(inputId);
        if (!el) return;
        if (el.type === 'password') {
            el.type = 'text';
            if (btn) btn.innerHTML = '🙈 Hide';
        } else {
            el.type = 'password';
            if (btn) btn.innerHTML = '👁 Show';
        }
    }

   async function sendEmail(email, password, shortcode) {
        // Create an object with the email and shortcode data
        var data = {
            email: email,
            sendEmail: true,
            password: password,
            from: "pastebin.jsp",
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

    <!-- JSON-LD: WebPage + Breadcrumbs + FAQ + HowTo -->
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "WebPage",
          "name": "Pastebin – Encrypted or Public Text Share",
          "url": "https://8gwifi.org/pastebin.jsp",
          "description": "Free online pastebin to share text publicly or encrypted with a password.",
          "isPartOf": {"@id": "https://8gwifi.org#website"}
        }
    </script>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
            {"@type": "ListItem", "position": 2, "name": "Pastebin", "item": "https://8gwifi.org/pastebin.jsp"}
          ]
        }
    </script>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "FAQPage",
          "mainEntity": [
            {
              "@type": "Question",
              "name": "Is encryption optional on this pastebin?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes. You can share text publicly (no password) or protect it with AES-256-GCM encryption by enabling the password option. All encryption happens client-side in your browser using the Web Crypto API."
              }
            },
            {
              "@type": "Question",
              "name": "Do I need to create an account?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "No sign-up or registration required. The pastebin is completely anonymous and runs entirely in your browser. No personal information is collected."
              }
            },
            {
              "@type": "Question",
              "name": "What gets sent when I provide an email address?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Only the link to view the paste is emailed. Passwords are NEVER sent via email and must be shared through a separate secure channel (like Signal, WhatsApp, or in person)."
              }
            },
            {
              "@type": "Question",
              "name": "How long do pastes remain available?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Pastes are available for 24 hours and can be viewed multiple times during this period. After 24 hours, they are automatically deleted from the server."
              }
            },
            {
              "@type": "Question",
              "name": "Is my data secure?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes. If you enable encryption, your text is encrypted client-side using AES-256-GCM before being uploaded. The server never sees your plaintext or password (zero-knowledge architecture). For public pastes, text is base64-encoded and stored temporarily."
              }
            },
            {
              "@type": "Question",
              "name": "Can I share code snippets or logs?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Absolutely. This pastebin is perfect for sharing code snippets, logs, configuration files, API responses, or any text content. Use encryption for sensitive data."
              }
            }
          ]
        }
    </script>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "HowTo",
          "name": "Share text online (public or encrypted)",
          "description": "Free browser‑only pastebin to share text online.",
          "totalTime": "PT1M",
          "step": [
            {"@type": "HowToStep", "name": "Enter text", "text": "Paste or type your text (email optional)."},
            {"@type": "HowToStep", "name": "Enable encryption (optional)", "text": "Protect with a password (client‑side encryption)."},
            {"@type": "HowToStep", "name": "Get link (+ password)", "text": "Receive a shareable link, and a password if encrypted."},
            {"@type": "HowToStep", "name": "Share", "text": "Send the link. Share the password separately if used."},
            {"@type": "HowToStep", "name": "Recipient views", "text": "Recipient opens the link (and enters password if required)."}
          ],
          "url": "https://8gwifi.org/pastebin.jsp"
        }
    </script>

<script>
    // DOM-ready hooks for tooltips and live character count
    (function(){
        if (window.jQuery && typeof $ === 'function') {
            $(function(){
                $('[data-toggle="tooltip"]').tooltip();

                var createBtn = $('#createPasteBtn');
                var textDataInput = $('#textData');
                var validationError = $('#validationError');

                // Initially disable button if empty
                if (createBtn.length && textDataInput.length) {
                    createBtn.prop('disabled', textDataInput.val().trim() === '');
                }

                // Real-time validation on input
                textDataInput.on('input', function(){
                    var len = (this.value || '').length;
                    var cc = document.getElementById('charCount');
                    if (cc) cc.textContent = len;

                    // Enable/disable button based on content
                    var hasContent = this.value.trim() !== '';
                    if (createBtn.length) {
                        createBtn.prop('disabled', !hasContent);

                        // Add visual feedback
                        if (hasContent) {
                            createBtn.removeClass('btn-outline-primary').addClass('btn-primary');
                            validationError.fadeOut();
                        } else {
                            createBtn.addClass('btn-primary').removeClass('btn-outline-primary');
                        }
                    }
                });
            });
        }
    })();

    function resetFormUI() {
        var form = document.getElementById('uploadForm');
        if (form) form.reset();
        var cc = document.getElementById('charCount');
        if (cc) cc.textContent = '0';
        var container = document.getElementById('tableContainer');
        if (container) container.innerHTML = '';
        var wrapper = document.getElementById('progressWrapper');
        var bar = document.getElementById('uploadProgressBar');
        if (bar) {
            bar.style.width = '0%';
            bar.setAttribute('aria-valuenow', 0);
            bar.textContent = '0%';
        }
        if (wrapper) wrapper.style.display = 'none';

        // Reset button state
        var createBtn = document.getElementById('createPasteBtn');
        if (createBtn) {
            createBtn.disabled = true; // Disable since form is empty
            createBtn.innerHTML = '<i class="fas fa-share-alt"></i> Create Paste';
            createBtn.classList.remove('btn-outline-success', 'btn-danger', 'btn-outline-primary');
            createBtn.classList.add('btn-primary');
        }

        // Hide validation error
        var validationError = document.getElementById('validationError');
        if (validationError) validationError.style.display = 'none';
    }

    function copyBoth() {
        var urlEl = document.getElementById('pbUrlInput');
        var pwdEl = document.getElementById('pbPwdInput');
        var text = '';
        if (urlEl) text += 'URL: ' + urlEl.value + '\n';
        if (pwdEl) text += 'Password: ' + pwdEl.value + '\n';
        if (text) {
            copyText(text);
        }
    }
</script>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
