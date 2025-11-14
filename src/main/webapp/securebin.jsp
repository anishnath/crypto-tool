<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>One‑Time Secret | Encrypted Pastebin & Secure Note (Free, E2EE) | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="https://8gwifi.org/securebin.jsp">
    <link rel="alternate" href="https://8gwifi.org/securebin.jsp" hreflang="en">

    <!-- Primary SEO -->
    <meta name="description" content="Share one‑time secrets with end‑to‑end encryption. Free online tool, no sign‑up, runs in your browser. Create a secure link and separate password to send passwords, API keys, and private data safely.">
    <meta name="keywords" content="one‑time secret, encrypted pastebin, secure note, password share, zero trust, end‑to‑end encryption, E2EE, secure link, share secret, private key share">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:title" content="One‑Time Secret | Encrypted Pastebin & Secure Note (Free, E2EE)">
    <meta property="og:description" content="Free online tool with client‑side encryption. Create a one‑time secret link and a separate password to share sensitive data safely.">
    <meta property="og:url" content="https://8gwifi.org/securebin.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/securebin.png">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@anish2good">
    <meta name="twitter:title" content="One‑Time Secret | Encrypted Pastebin (Free, E2EE)">
    <meta name="twitter:description" content="Free browser‑only secret sharing. Create a one‑time link + separate password.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/securebin.png">

    <!-- JSON-LD: WebApplication -->
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "WebApplication",
          "name": "One‑Time Secret – Encrypted Pastebin",
          "alternateName": "Secure Secret Sharing (E2EE)",
          "url": "https://8gwifi.org/securebin.jsp",
          "image": "https://8gwifi.org/images/site/securebin.png",
          "description": "Free online tool for one‑time secrets. End‑to‑end encryption in your browser. Create a secure view link and share the password separately.",
          "applicationCategory": "SecurityApplication",
          "operatingSystem": "All",
          "inLanguage": "en",
          "isAccessibleForFree": true,
          "version": "1.0",
          "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org"
          },
          "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org",
            "logo": {
              "@type": "ImageObject",
              "url": "https://8gwifi.org/images/site/4book.png"
            }
          }
        }
    </script>

    <!-- JSON-LD: WebPage + Breadcrumbs -->
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "WebPage",
          "name": "Secure Secret Sharing",
          "url": "https://8gwifi.org/securebin.jsp",
          "description": "One‑time, end‑to‑end encrypted secret sharing on 8gwifi.org.",
          "isPartOf": {"@id": "https://8gwifi.org#website"},
          "dateModified": "2025-01-01"
        }
    </script>
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
            {"@type": "ListItem", "position": 2, "name": "Secure Secret Sharing", "item": "https://8gwifi.org/securebin.jsp"}
          ]
        }
    </script>

    <!-- JSON-LD: FAQ -->
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "FAQPage",
          "mainEntity": [
            {
              "@type": "Question",
              "name": "How does the one‑time secret sharing work?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Your text is encrypted in your browser. You get a unique view link and a separate password. Share the link and password via different channels. The secret expires and cannot be viewed again."
              }
            },
            {
              "@type": "Question",
              "name": "Is it truly end‑to‑end encrypted?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes. Encryption and decryption happen client‑side using AES‑GCM. The server never sees your plaintext or password."
              }
            },
            {
              "@type": "Question",
              "name": "How long is the link valid?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "The link is intended for one‑time access and remains active only for a limited time as shown after upload."
              }
            }
          ]
        }
    </script>
    <!-- JSON-LD: HowTo (concise steps) -->
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "HowTo",
          "name": "Share a one‑time secret securely",
          "description": "Free browser‑only encrypted pastebin to share one‑time secrets.",
          "totalTime": "PT1M",
          "step": [
            {"@type": "HowToStep", "name": "Enter secret", "text": "Paste or type your sensitive text (email optional)."},
            {"@type": "HowToStep", "name": "Encrypt in browser", "text": "Your secret is encrypted locally using AES‑GCM."},
            {"@type": "HowToStep", "name": "Get URL + password", "text": "A one‑time view URL and separate password are generated."},
            {"@type": "HowToStep", "name": "Share separately", "text": "Share the URL and password via different channels."},
            {"@type": "HowToStep", "name": "Recipient views once", "text": "Recipient opens the URL and enters the password to view the secret."}
          ],
          "url": "https://8gwifi.org/securebin.jsp"
        }
    </script>

    <style>
        .min-h-result { min-height: 180px; }
        @media (min-width: 992px) { .min-h-result { min-height: 240px; } }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-5">
    <h1 class="mb-3">Secure Secret Sharing</h1>
    <p class="lead mb-4">Encrypt a secret in your browser, then share a one‑time view URL and a separate password.</p>

    <div class="row">
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h4 class="card-title">Create a New Secret</h4>
                    <p class="text-muted mb-3">Email is optional; it only sends the URL (not the password). Zero‑trust by design.</p>
                    <form id="uploadForm">
                        <div class="form-group">
                            <label for="email">Recipient Email (optional)</label>
                            <input type="email" class="form-control" id="email" placeholder="name@example.com" aria-describedby="emailHelp">
                            <small id="emailHelp" class="form-text text-muted">We email only the link. You must share the password separately.</small>
                        </div>

                        <div class="form-group mb-2">
                            <label for="textData">Secret Content</label>
                            <textarea class="form-control" id="textData" rows="5" placeholder="Paste or type your sensitive text here..."></textarea>
                            <small class="form-text text-muted"><span id="charCount">0</span> characters</small>
                        </div>

                        <div class="d-flex align-items-center">
                            <button type="button" class="btn btn-primary mr-2" onclick="createPresignedURL()">Share Secret</button>
                            <button type="reset" class="btn btn-outline-secondary" onclick="resetFormUI()">Reset</button>
                        </div>
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
                    <h5 class="card-title mb-3">Result</h5>
                    <div id="tableContainer" class="min-h-result"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- How It Works -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h5 class="card-title mb-2">How It Works</h5>
            <ol class="mb-0">
                <li>Enter your secret text (email optional).</li>
                <li>We encrypt it in your browser (E2EE).</li>
                <li>You get a one‑time view URL and a password.</li>
                <li>Share the URL and password via different channels.</li>
                <li>The recipient opens the URL and enters the password.</li>
            </ol>
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
                                    // Build a pretty card with copy buttons for URL and Password
                                    var viewUrl = window.location.origin + "/securebind.jsp?q=" + shortCode;

                                    var cardHtml = ''+
                                      '<div class="card shadow-sm">' +
                                      '  <div class="card-body">' +
                                      '    <h5 class="card-title mb-3">Secret Created</h5>' +
                                      '    <div class="form-group">' +
                                      '      <label for="secretUrlInput" class="font-weight-bold">Secret View URL</label>' +
                                      '      <div class="input-group input-group-sm">' +
                                      '        <input id="secretUrlInput" type="text" class="form-control" readonly value="' + viewUrl + '">' +
                                      '        <div class="input-group-append">' +
                                      '          <button class="btn btn-outline-secondary" type="button" onclick="copyById(\'secretUrlInput\', this)" data-toggle="tooltip" title="Copy URL" aria-label="Copy URL">📋 Copy</button>' +
                                      '          <a class="btn btn-primary" target="_blank" rel="noopener" href="' + viewUrl + '" data-toggle="tooltip" title="Open in new tab" aria-label="Open URL">Open</a>' +
                                      '        </div>' +
                                      '      </div>' +
                                      '    </div>' +
                                      '    <div class="form-group mt-3">' +
                                      '      <label for="secretPasswordInput" class="font-weight-bold">Password</label>' +
                                      '      <div class="input-group input-group-sm">' +
                                      '        <input id="secretPasswordInput" type="password" class="form-control" readonly value="' + password + '">' +
                                      '        <div class="input-group-append">' +
                                      '          <button class="btn btn-outline-secondary" type="button" onclick="copyById(\'secretPasswordInput\', this)" data-toggle="tooltip" title="Copy password" aria-label="Copy Password">📋 Copy</button>' +
                                      '          <button class="btn btn-outline-secondary" type="button" onclick="toggleReveal(\'secretPasswordInput\', this)" data-toggle="tooltip" title="Show or hide password" aria-label="Show or hide password">👁 Show</button>' +
                                      '        </div>' +
                                      '      </div>' +
                                      '      <small class="form-text text-muted">Share the URL and password via different channels for better security.</small>' +
                                      '    </div>' +
                                      '    <div class="d-flex mb-3">' +
                                      '      <button class="btn btn-success btn-sm mr-2" type="button" onclick="copyBoth()" data-toggle="tooltip" title="Copy URL and password together">Copy Both</button>' +
                                      '      <button class="btn btn-outline-secondary btn-sm" type="button" onclick="resetFormUI()" data-toggle="tooltip" title="Create another secret">Create Another</button>' +
                                      '    </div>' +
                                      '    <div class="alert alert-info mt-3 mb-0" role="alert">This link remains active only for a limited time and requires the password to view.</div>' +
                                      '  </div>' +
                                      '</div>';

                                    var tableContainer = document.getElementById("tableContainer");
                                    tableContainer.innerHTML = cardHtml;

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

    // Utilities: copy helpers and password reveal
    function copyText(text) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            return navigator.clipboard.writeText(text);
        }
        // Fallback
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

<script>
    // DOM-ready hooks for tooltips and live character count
    (function(){
        if (window.jQuery && typeof $ === 'function') {
            $(function(){
                $('[data-toggle="tooltip"]').tooltip();
                $('#textData').on('input', function(){
                    var len = (this.value || '').length;
                    var cc = document.getElementById('charCount');
                    if (cc) cc.textContent = len;
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
    }

    function copyBoth() {
        var urlEl = document.getElementById('secretUrlInput');
        var pwdEl = document.getElementById('secretPasswordInput');
        var text = '';
        if (urlEl) text += 'URL: ' + urlEl.value + '\n';
        if (pwdEl) text += 'Password: ' + pwdEl.value + '\n';
        if (text) {
            copyText(text);
        }
    }
</script>

<!-- Visible FAQ matching the FAQPage schema for eligibility -->
<section class="container mb-4">
    <h2 class="h4">Secure Secret Sharing FAQ</h2>
    <details class="mb-2">
        <summary><strong>How does the one‑time secret sharing work?</strong></summary>
        <p>Your text is encrypted locally in your browser. You receive a view link and a separate password. Share them separately. The secret expires after it’s viewed or after a limited time.</p>
    </details>
    <details class="mb-2">
        <summary><strong>Is it truly end‑to‑end encrypted?</strong></summary>
        <p>Yes. Encryption and decryption happen client‑side using AES‑GCM. The server never sees your plaintext or your password.</p>
    </details>
    <details>
        <summary><strong>What kind of data can I share?</strong></summary>
        <p>Passwords, API keys, private keys, credit card info, or any sensitive text. Avoid sharing secrets you are not authorized to transmit.</p>
    </details>
    <hr>
</section>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
